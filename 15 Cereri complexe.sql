-- Afișează toate scufundările programate, chiar și cele care nu au echipaj asignat, împreună cu informații despre rută, stația de origine și membrii echipajului (dacă există).
-- Se folosesc LEFT JOIN-uri pe 4 tabele: Scheduled_Dive, Route, Station, Dive_Crew, Crew_Member.
SELECT d.dive_id,
       r.route_id,
       st.name AS origin_station,
       c.crew_id,
       c.first_name || ' ' || c.last_name AS a_crew_member,
       dc.duty
FROM Scheduled_Dive d
LEFT JOIN Route r ON r.route_id = d.route_id
LEFT JOIN Station st ON st.station_id = r.origin_station_id
LEFT JOIN Dive_Crew dc ON dc.dive_id = d.dive_id
LEFT JOIN Crew_Member c ON c.crew_id = dc.crew_id
ORDER BY d.dive_id, c.last_name;

-- Găsește pasagerii care au efectuat un internship cu toți membrii echipajului care sunt medici.
-- Cu alte cuvinte: pasagerii care au internship pentru fiecare medic existent în tabelul Medic.
SELECT p.passenger_id,
       p.first_name || ' ' || p.last_name AS passenger_name
FROM Passenger p
WHERE NOT EXISTS (
    SELECT m.crew_id
    FROM Medic m
    WHERE NOT EXISTS (
        SELECT 1
        FROM Internship i
        WHERE i.passenger_id = p.passenger_id
          AND i.crew_id = m.crew_id
    )
);

-- Afișează primele 3 rute care au cele mai multe scufundări programate, ordonate descrescător după numărul de scufundări.
-- Se folosește ROW_NUMBER() sau FETCH FIRST N ROWS ONLY.
SELECT route_id, dive_count
FROM (
    SELECT d.route_id,
           COUNT(*) AS dive_count,
           ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn
    FROM Scheduled_Dive d
    GROUP BY d.route_id
)
WHERE rn <= 3
ORDER BY dive_count DESC;

SELECT route_id,
       COUNT(*) AS dive_count
FROM Scheduled_Dive
GROUP BY route_id
ORDER BY dive_count DESC
FETCH FIRST 3 ROWS ONLY;


