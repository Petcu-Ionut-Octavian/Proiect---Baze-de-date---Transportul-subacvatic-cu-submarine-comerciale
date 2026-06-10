// View-uri

// Lista tuturor scufundărilor programate cu detalii despre rută și stații
CREATE OR REPLACE VIEW Dive_Details AS
SELECT 
    d.dive_id,
    d.departure_time,
    d.arrival_time,
    d.available_seats,
    d.pressure_level,
    r.route_id,
    r.distance_km,
    r.base_price,
    st1.name AS origin_station,
    st2.name AS destination_station,
    t.name AS submarine_type,
    t.capacity AS submarine_capacity
FROM Scheduled_Dive d
JOIN Route r ON d.route_id = r.route_id
JOIN Station st1 ON r.origin_station_id = st1.station_id
JOIN Station st2 ON r.destination_station_id = st2.station_id
JOIN Submarine_Type t ON r.type_id = t.type_id;


// Itinerarii complete ale pasagerilor
CREATE OR REPLACE VIEW Passenger_Itineraries AS
SELECT 
    p.passenger_id,
    p.first_name,
    p.last_name,
    i.itinerary_id,
    i.created_at,
    i.total_price,
    s.segment_id,
    s.segment_order,
    s.seat_number,
    d.dive_id,
    d.departure_time,
    d.arrival_time
FROM Passenger p
JOIN Itinerary i ON p.passenger_id = i.passenger_id
JOIN Itinerary_Segment s ON i.itinerary_id = s.itinerary_id
JOIN Scheduled_Dive d ON s.dive_id = d.dive_id;


// Echipajul fiecărei scufundări
CREATE OR REPLACE VIEW Dive_Crew_View AS
SELECT 
    d.dive_id,
    c.crew_id,
    c.first_name,
    c.last_name,
    c.certification_level,
    c.experience_years,
    dc.duty
FROM Dive_Crew dc
JOIN Crew_Member c ON dc.crew_id = c.crew_id
JOIN Scheduled_Dive d ON dc.dive_id = d.dive_id;


// Internships (stagii) cu detalii despre pasager, echipaj și scufundare
CREATE OR REPLACE VIEW Internship_Details AS
SELECT 
    i.passenger_id,
    p.first_name AS passenger_first_name,
    p.last_name AS passenger_last_name,
    i.crew_id,
    c.first_name AS crew_first_name,
    c.last_name AS crew_last_name,
    i.dive_id,
    i.training_level,
    i.feedback
FROM Internship i
JOIN Passenger p ON i.passenger_id = p.passenger_id
JOIN Crew_Member c ON i.crew_id = c.crew_id;



// View cu o coloană calculată: durata scufundării + prețul pe minut
CREATE OR REPLACE VIEW Dive_Calculated_Info AS
SELECT
    d.dive_id,
    d.route_id,
    d.departure_time,
    d.arrival_time,
    r.distance_km,
    r.base_price,

    /* Durata scufundării în minute */
    EXTRACT(HOUR FROM (d.arrival_time - d.departure_time)) * 60 +
    EXTRACT(MINUTE FROM (d.arrival_time - d.departure_time)) +
    EXTRACT(SECOND FROM (d.arrival_time - d.departure_time)) / 60
        AS dive_duration_minutes,

    /* Preț pe minut */
    CASE 
        WHEN (EXTRACT(HOUR FROM (d.arrival_time - d.departure_time)) * 60 +
              EXTRACT(MINUTE FROM (d.arrival_time - d.departure_time)) +
              EXTRACT(SECOND FROM (d.arrival_time - d.departure_time)) / 60) > 0
        THEN ROUND(
            r.base_price /
            (
                EXTRACT(HOUR FROM (d.arrival_time - d.departure_time)) * 60 +
                EXTRACT(MINUTE FROM (d.arrival_time - d.departure_time)) +
                EXTRACT(SECOND FROM (d.arrival_time - d.departure_time)) / 60
            ), 2
        )
        ELSE NULL
    END AS price_per_minute

FROM Scheduled_Dive d
JOIN Route r ON d.route_id = r.route_id;



// Select din views
SELECT * FROM Dive_Details;
SELECT * FROM Passenger_Itineraries;
SELECT * FROM Dive_Crew_View;
SELECT * FROM Internship_Details;
SELECT * FROM Dive_Calculated_Info;

// Select din views mai complex
// Scufundările ordonate după durata calculată
SELECT 
    dive_id,
    dive_duration_minutes,
    price_per_minute
FROM Dive_Calculated_Info
ORDER BY dive_duration_minutes DESC;

// Cele mai scumpe scufundări (preț pe minut)
SELECT 
    dive_id,
    base_price,
    dive_duration_minutes,
    price_per_minute
FROM Dive_Calculated_Info
WHERE price_per_minute IS NOT NULL
ORDER BY price_per_minute DESC;

// Pasagerii care au mai multe segmente în itinerariu
SELECT 
    passenger_id,
    first_name,
    last_name,
    COUNT(segment_id) AS number_of_segments
FROM Passenger_Itineraries
GROUP BY passenger_id, first_name, last_name
HAVING COUNT(segment_id) > 1;

// Echipajele cu roluri specifice (din view-ul Dive_Crew_View)
SELECT 
    dive_id,
    first_name,
    last_name,
    duty
FROM Dive_Crew_View
WHERE duty LIKE '%Captain%';

// Stagiile (internships) cu feedback mare
SELECT 
    passenger_first_name,
    passenger_last_name,
    crew_first_name,
    crew_last_name,
    training_level,
    feedback
FROM Internship_Details
WHERE feedback >= 8
ORDER BY feedback DESC;

// Rute lungi cu detalii despre stații (din Dive_Details)
SELECT 
    dive_id,
    origin_station,
    destination_station,
    distance_km,
    submarine_type
FROM Dive_Details
WHERE distance_km > 50
ORDER BY distance_km DESC;

// Verificare - ce e modificabil in viewuri
SELECT 
    column_name,
    updatable,
    insertable,
    deletable
FROM user_updatable_columns
WHERE table_name = 'DIVE_DETAILS';

// Materialised view
// Statistici pe rute (număr scufundări, durată medie, locuri libere medii)
CREATE MATERIALIZED VIEW mv_route_statistics
REFRESH COMPLETE ON DEMAND
AS
SELECT
    r.route_id,
    r.distance_km,
    r.base_price,

    COUNT(d.dive_id) AS total_dives,

    /* Durata medie a scufundărilor în minute */
    AVG(  /* Ex de operatie nepermisa: insert, update, delete (deoarece am date calculate) */
        EXTRACT(HOUR FROM (d.arrival_time - d.departure_time)) * 60 +
        EXTRACT(MINUTE FROM (d.arrival_time - d.departure_time)) +
        EXTRACT(SECOND FROM (d.arrival_time - d.departure_time)) / 60
    ) AS avg_dive_duration_minutes,

    /* Locuri libere medii */
    AVG(d.available_seats) AS avg_available_seats

FROM Route r
LEFT JOIN Scheduled_Dive d ON r.route_id = d.route_id
GROUP BY r.route_id, r.distance_km, r.base_price;

// Select din viwe-ul materializat
SELECT * FROM mv_route_statistics;

// Scor de eficienta(viteză) + clasificare rute
SELECT
    route_id,
    distance_km,
    base_price,
    total_dives,
    ROUND(avg_dive_duration_minutes, 2) AS avg_duration,
    ROUND(avg_available_seats, 2) AS avg_free_seats,

    /* Clasificare după durata medie */
    CASE
        WHEN avg_dive_duration_minutes < 30 THEN 'SCURTĂ'
        WHEN avg_dive_duration_minutes < 90 THEN 'MEDIE'
        ELSE 'LUNGĂ'
    END AS duration_category,

    /* Scor de eficiență: distanță / durată */
    CASE
        WHEN avg_dive_duration_minutes > 0
        THEN ROUND(distance_km / avg_dive_duration_minutes, 3)
        ELSE NULL
    END AS efficiency_score

FROM mv_route_statistics
WHERE total_dives >= 1
ORDER BY efficiency_score DESC NULLS LAST, total_dives DESC;



-- Exemple de operatii permise in view-uri:
-- -- Select 



/* ============================================================
   DEMONSTRAȚIE ÎN ALGEBRĂ RELAȚIONALĂ:
   DE CE NU PUTEM FACE INSERT ÎN ACEST MATERIALIZED VIEW
   ============================================================

   View-ul este definit ca o agregare peste un JOIN:

       MV = γ_{route_id, distance_km, base_price;
               total_dives := COUNT(dive_id),
               avg_dur := AVG(durata),
               avg_seats := AVG(available_seats)}
            (Route ⟕ Scheduled_Dive)

   Notăm:
       R = Route
       D = Scheduled_Dive
       J = R ⟕_{R.route_id = D.route_id} D

       MV = γ_{grup, agregate}(J)

   ------------------------------------------------------------
   IDEEA CHEIE:
   Operatorul γ (GROUP BY + agregări) NU este invertibil.
   ------------------------------------------------------------

   Un INSERT în view ar însemna:

       "Adaug un tuplu t_nou în MV și baza trebuie să deducă
        ce tupluri noi trebuie inserate în R și/sau D astfel
        încât după aplicarea expresiei MV = γ(J) să apară exact
        t_nou în rezultat."

   Formal:

       MV = f(R, D)
       INSERT în MV ar cere aplicarea lui f^{-1}:

           (R', D') = f^{-1}(MV ∪ {t_nou})

       Problema: γ NU are inversă funcțională → f^{-1} nu există.

   ------------------------------------------------------------
   MOTIVUL FORMAL: agregarea pierde informație
   ------------------------------------------------------------

   Pentru un route_id = r0, în J există un set de tupluri:

       S = { t1, t2, ..., tn }

   Agregarea produce un singur tuplu:

       g(S) = ( route_id = r0,
                total_dives = n,
                avg_seats = (Σ seats_i) / n,
                ... )

   Observații:

   • Din g(S) NU poți reconstrui unic mulțimea S.
   • Există infinit de mulțimi S diferite care au același COUNT
     și același AVG.
   • Deci g^{-1}(t_agg) NU este o funcție.

   Consecință:

       Nu există o transformare deterministă care,
       dat fiind un tuplu agregat t_nou,
       să spună exact ce tupluri trebuie inserate în J
       (și implicit în R sau D).

   ------------------------------------------------------------
   EXEMPLU CONCRET (ilustrează ne-determinismul)
   ------------------------------------------------------------

   Presupunem că pentru route_id = 3 avem în Scheduled_Dive:

       d1: available_seats = 10
       d2: available_seats = 20

   Atunci în MV apare:

       total_dives = 2
       avg_available_seats = 15

   Dacă utilizatorul ar face INSERT în MV:

       total_dives = 3
       avg_available_seats = 18

   Baza ar trebui să "ghicească" un nou tuplu d3 astfel încât:

       AVG(10, 20, seats_3) = 18

   seats_3 = 24 este o soluție,
   dar există infinite combinații posibile dacă includem și durata,
   presiunea, orele etc.

   Deci INSERT nu este bine definit:
   nu există o singură soluție corectă pentru ce trebuie inserat
   în Scheduled_Dive.

   ------------------------------------------------------------
   CONCLUZIE:
   Pentru view-uri cu agregări (γ), operațiile de tip INSERT,
   UPDATE și DELETE NU sunt bine definite în algebră relațională,
   deoarece agregarea este o funcție many-to-one și nu poate fi
   inversată în mod unic.
   ============================================================ */
