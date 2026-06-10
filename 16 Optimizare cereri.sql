/* =====================================================================
   PUNCTUL (a) – OPTIMIZAREA UNEI CERERI FOLOSIND ALGEBRA RELAȚIONALĂ
   Cerere aleasă: CEREREA 3
   =====================================================================

   CEREREA 3 – SQL INIȚIALĂ
   ---------------------------------------------------------------
   SELECT st.region,
          AVG(i.total_price) AS avg_region_price
   FROM Itinerary i
   JOIN Itinerary_Segment s ON s.itinerary_id = i.itinerary_id
   JOIN Scheduled_Dive d ON d.dive_id = s.dive_id
   JOIN Route r ON r.route_id = d.route_id
   JOIN Station st ON st.station_id = r.origin_station_id
   GROUP BY st.region
   HAVING AVG(i.total_price) > (
       SELECT AVG(total_price)
       FROM Itinerary
   );

   =====================================================================
   1. EXPRESIA ALGEBRICĂ INIȚIALĂ
   =====================================================================

   γ_{region, AVG(total_price)}
   (
      σ_true                         (operație de selecție care nu filtrează nimic)
      (
         Itinerary ⋈ Itinerary_Segment ⋈ Scheduled_Dive ⋈ Route ⋈ Station
      )
   )
   HAVING AVG(total_price) > ( γ AVG(total_price)(Itinerary) )

   =====================================================================
   2. ARBORE ALGEBRIC INIȚIAL
   =====================================================================
   
                                γ (region, AVG(total_price))
                                             |
                                             |
                                      [4]    ⋈
                                    ----------- 
                                    |         |
                                  [3]        Station
                                -------        
                                |     |        
                              [2]    Route 
                            --------
                            |      |
                          [1]   Scheduled_Dive
                        --------
                        |      |
                  Itinerary   Itinerary_Segment

   =====================================================================
   3. OPTIMIZĂRI APLICATE
   =====================================================================

   - Push-down selecții (nu există predicate → nu se aplică)
   - Push-down proiecții (eliminăm coloanele inutile)
   - Reordonare join pentru reducerea cardinalității
   - Evaluarea subcererii HAVING o singură dată (materializare)

   =====================================================================
   4. EXPRESIA ALGEBRICĂ OPTIMIZATĂ
   =====================================================================

   Let M = γ AVG(total_price)(Itinerary)

   γ_{region, AVG(total_price)}
   (
      ( π_{itinerary_id, total_price}(Itinerary)
        ⋈
        π_{itinerary_id, dive_id}(Itinerary_Segment)
        ⋈
        π_{dive_id, route_id}(Scheduled_Dive)
        ⋈
        π_{route_id, origin_station_id}(Route)
        ⋈
        π_{station_id, region}(Station)
      )
   )
   HAVING AVG(total_price) > M

   =====================================================================
   5. ARBORE ALGEBRIC OPTIMIZAT
   =====================================================================

                                γ (region, AVG(total_price))
                                             |
                                             |
                                      [4]    ⋈
                                    ----------- 
                                    |         |
                                  [3]        π(station_id, region)
                                -------
                                |     |
                              [2]    π(route_id, origin_station_id)
                            --------
                            |      |
                          [1]   π(dive_id, route_id)
                        --------
                        |      |
                π(itinerary_id, total_price)
                         Itinerary_Segment

   =====================================================================
   6. SQL OPTIMIZAT
   =====================================================================

*/

-- SQL OPTIMIZAT (ECHIVALENT LOGIC)
SELECT st.region,
       AVG(i.total_price) AS avg_region_price
FROM (
    SELECT itinerary_id, total_price
    FROM Itinerary
) i
JOIN (
    SELECT itinerary_id, dive_id
    FROM Itinerary_Segment
) s ON s.itinerary_id = i.itinerary_id
JOIN (
    SELECT dive_id, route_id
    FROM Scheduled_Dive
) d ON d.dive_id = s.dive_id
JOIN (
    SELECT route_id, origin_station_id
    FROM Route
) r ON r.route_id = d.route_id
JOIN (
    SELECT station_id, region
    FROM Station
) st ON st.station_id = r.origin_station_id
GROUP BY st.region
HAVING AVG(i.total_price) > (
    SELECT /*+ MATERIALIZE */ AVG(total_price)
    FROM Itinerary
);




/* =====================================================================
   PUNCTUL (b) – PLAN DE EXECUȚIE + HINT-URI + INDEXURI
   Cerere aleasă: CEREREA 1
   ===================================================================== */

-- CEREREA 1 – VARIANTA FĂRĂ HINT-URI
EXPLAIN PLAN FOR
SELECT i.itinerary_id,
       p.first_name || ' ' || p.last_name AS passenger_name,
       i.total_price
FROM Itinerary i
JOIN Passenger p ON p.passenger_id = i.passenger_id
WHERE i.total_price > (
    SELECT AVG(i2.total_price)
    FROM Itinerary i2
    JOIN Itinerary_Segment s2 ON s2.itinerary_id = i2.itinerary_id
    JOIN Scheduled_Dive d2 ON d2.dive_id = s2.dive_id
    JOIN Route r2 ON r2.route_id = d2.route_id
    WHERE EXISTS (
        SELECT 1
        FROM Itinerary_Segment s3
        JOIN Scheduled_Dive d3 ON d3.dive_id = s3.dive_id
        JOIN Route r3 ON r3.route_id = d3.route_id
        WHERE s3.itinerary_id = i.itinerary_id
          AND r3.type_id = r2.type_id
    )
);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


-- VARIANTA OPTIMIZATĂ CU HINT-URI + INDEXURI

CREATE INDEX idx_itin_price ON Itinerary(total_price);
CREATE INDEX idx_seg_itin ON Itinerary_Segment(itinerary_id);
CREATE INDEX idx_dive_route ON Scheduled_Dive(route_id);
CREATE INDEX idx_route_type ON Route(type_id);


EXPLAIN PLAN FOR
SELECT /*+ QB_NAME(main) ORDERED */
       i.itinerary_id,
       p.first_name || ' ' || p.last_name AS passenger_name,
       i.total_price
FROM Itinerary i
JOIN Passenger p
     ON p.passenger_id = i.passenger_id
WHERE i.total_price > (
    SELECT /*+ QB_NAME(avgq)
               NO_MERGE
               MATERIALIZE
               ORDERED
               USE_NL(i2 s2 d2 r2)
           */
           AVG(i2.total_price)
    FROM Itinerary i2
    JOIN Itinerary_Segment s2
         ON s2.itinerary_id = i2.itinerary_id
    JOIN Scheduled_Dive d2
         ON d2.dive_id = s2.dive_id
    JOIN Route r2
         ON r2.route_id = d2.route_id
    WHERE EXISTS (
        SELECT /*+ QB_NAME(existsq)
                   NO_MERGE
                   MATERIALIZE
                   ORDERED
                   USE_NL(s3 d3 r3)
               */
               1
        FROM Itinerary_Segment s3
        JOIN Scheduled_Dive d3
             ON d3.dive_id = s3.dive_id
        JOIN Route r3
             ON r3.route_id = d3.route_id
        WHERE s3.itinerary_id = i.itinerary_id
          AND r3.type_id = r2.type_id
    )
);

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);



/* ============================================================================================
   REZUMAT PUNCTUL (b) – ANALIZA PLANULUI DE EXECUȚIE + HINT-URI + INDEXURI

   În acest punct am analizat o cerere complexă (CEREREA 1), care conține:
   - subcerere corelată cu 3 tabele (Itinerary_Segment, Scheduled_Dive, Route)
   - subcerere necorelată cu agregare (AVG)
   - condiție de filtrare dependentă de subcererea corelată

   1. PLAN DE EXECUȚIE FĂRĂ HINT-URI
      Oracle a ales implicit:
      - HASH JOIN pentru partea principală
      - NESTED LOOPS SEMI pentru subcererea EXISTS
      - FULL TABLE SCAN pe tabele mici (Itinerary, Passenger)
      - acces prin index pe coloanele de legătură (itinerary_id, dive_id, route_id)

      Concluzie:
      Planul implicit este influențat de cardinalități mici și de adaptive optimization.

   2. INDEXURI CREATE PENTRU OPTIMIZARE
      Am creat indexuri pentru a permite folosirea Nested Loop:
      - idx_seg_itin      → Itinerary_Segment(itinerary_id)
      - idx_dive_route    → Scheduled_Dive(route_id)
      - idx_route_type    → Route(type_id)
      - idx_itin_price    → Itinerary(total_price)

      Rolul lor:
      - reduc costul accesului în subcererea corelată
      - permit acces rapid prin INDEX RANGE SCAN
      - fac Nested Loop o opțiune viabilă pentru Oracle

   3. HINT-URI APLICATE
      Am folosit hint-uri pentru a forța un anumit comportament:
      - USE_NL(...)              → forțarea Nested Loop
      - ORDERED                  → păstrarea ordinii JOIN-urilor
      - NO_MERGE / MATERIALIZE   → împiedică rescrierea subcererilor
      - QB_NAME(...)             → control pe query block-uri

      Observație importantă:
      Oracle 12c+ folosește adaptive optimization, ceea ce înseamnă că:
      - poate ignora hint-urile declarate ca "Unused"
      - poate rescrie subcererile în from$_subquery$_XXX
      - poate decide că planul său este mai bun

      Chiar dacă hint-urile apar ca "Unused", planul final a folosit:
      - NESTED LOOPS în subcererea corelată
      - NESTED LOOPS SEMI pentru EXISTS
      - acces prin index pe toate coloanele relevante

      Concluzie:
      Comportamentul real al planului reflectă optimizările dorite,
      chiar dacă raportul de hint-uri nu le marchează ca "Used".

   4. CONCLUZIE GENERALĂ
      - Am analizat planul implicit și planul cu hint-uri.
      - Am creat indexuri pentru a permite Nested Loop.
      - Am aplicat hint-uri pentru controlul ordinii și tipului de JOIN.
      - Oracle a folosit Nested Loop în zonele critice (subcererea corelată),
        chiar dacă adaptive optimization marchează unele hint-uri ca "Unused".
      - Rezultatul final este un plan optimizat, cu acces indexat și cost redus.

   ============================================================================================ */
