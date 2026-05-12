/* ============================================================
   CEREREA 1
   - Subcerere sincronizată (corelată) cu 3+ tabele
   - Folosește Itinerary, Itinerary_Segment, Scheduled_Dive, Route
   - Afișează itinerariile cu preț mai mare decât media itinerariilor
     care folosesc același tip de submarin
   ============================================================ */
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

/* ============================================================
   CEREREA 2
   - Subcerere nesincronizată în FROM (inline view)
   - Afișează rutele cu mai mult de 3 scufundări programate
   ============================================================ */
SELECT r.route_id,
       r.distance_km,
       x.dive_count,
       x.avg_available_seats
FROM Route r
JOIN (
    SELECT route_id,
           COUNT(*) AS dive_count,
           AVG(available_seats) AS avg_available_seats
    FROM Scheduled_Dive
    GROUP BY route_id
) x ON x.route_id = r.route_id
WHERE x.dive_count > 3;

/* ============================================================
   CEREREA 3
   - GROUP BY + funcții grup
   - HAVING cu subcerere nesincronizată
   - Afișează regiunile cu media prețurilor > media globală
   ============================================================ */
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

/* ============================================================
   CEREREA 4
   - Ordonare + NVL + DECODE în aceeași cerere
   - Afișează membrii echipajului și rolul lor
   ============================================================ */
SELECT c.crew_id,
       c.first_name || ' ' || c.last_name AS crew_name,
       NVL(cap.command_level, 'N/A') AS command_level,
       NVL(eng.specialty, 'N/A') AS engineer_specialty,
       NVL(med.medical_specialization, 'N/A') AS medic_specialization,
       CASE
           WHEN cap.crew_id IS NOT NULL THEN 'CAPTAIN'
           WHEN eng.crew_id IS NOT NULL THEN 'ENGINEER'
           WHEN med.crew_id IS NOT NULL THEN 'MEDIC'
           ELSE 'OTHER'
       END AS role_label
FROM Crew_Member c
LEFT JOIN Captain cap ON cap.crew_id = c.crew_id
LEFT JOIN Engineer eng ON eng.crew_id = c.crew_id
LEFT JOIN Medic med ON med.crew_id = c.crew_id
ORDER BY DECODE(
           CASE
               WHEN cap.crew_id IS NOT NULL THEN 'CAPTAIN'
               WHEN eng.crew_id IS NOT NULL THEN 'ENGINEER'
               WHEN med.crew_id IS NOT NULL THEN 'MEDIC'
               ELSE 'OTHER'
           END,
           'CAPTAIN', 1,
           'ENGINEER', 2,
           'MEDIC', 3,
           4
         ),
         c.last_name,
         c.first_name;

/* ============================================================
   CEREREA 5
   - WITH (bloc de cerere)
   - 2 funcții pe șiruri: INITCAP, LOWER, LENGTH
   - 2 funcții pe date: TRUNC, ADD_MONTHS
   - Expresie CASE
   ============================================================ */
WITH recent_itineraries AS (
    SELECT i.itinerary_id,
           i.passenger_id,
           i.created_at,
           i.total_price
    FROM Itinerary i
    WHERE i.created_at >= ADD_MONTHS(TRUNC(SYSTIMESTAMP), -1)
)
SELECT ri.itinerary_id,
       INITCAP(LOWER(p.first_name || ' ' || p.last_name)) AS formatted_name,
       TRUNC(ri.created_at) AS created_day,
       TRUNC(SYSTIMESTAMP) - TRUNC(ri.created_at) AS days_since_creation,
       LENGTH(p.email) AS email_length,
       CASE p.medical_clearance
           WHEN 'OK' THEN 'LOW RISK'
           WHEN 'LIMITED' THEN 'MEDIUM RISK'
           WHEN 'DENIED' THEN 'HIGH RISK'
           ELSE 'UNKNOWN'
       END AS risk_level
FROM recent_itineraries ri
JOIN Passenger p ON p.passenger_id = ri.passenger_id
ORDER BY TRUNC(ri.created_at) DESC,
         INITCAP(LOWER(p.last_name));

/* ============================================================
   CERINȚE BIFATE
   a) Subcereri sincronizate cu 3 tabele → Cererea 1
   b) Subcereri nesincronizate în FROM → Cererea 2
   c) GROUP BY + HAVING cu subcerere → Cererea 3
   d) Ordonare + NVL + DECODE → Cererea 4
   e) 2 funcții string + 2 funcții date + CASE → Cererea 5
   f) Bloc WITH → Cererea 5
   ============================================================ */
