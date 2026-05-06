/*test pentru baza de date*/
SELECT * FROM dual;
SELECT 1;

/*crearea tabelelor*/
CREATE TABLE Submarine_Type (
    type_id           NUMBER PRIMARY KEY CHECK (type_id > 0),
    name              VARCHAR2(100) NOT NULL,
    max_depth_meters  NUMBER CHECK (max_depth_meters > 0),
    capacity          NUMBER CHECK (capacity > 0)
);

CREATE TABLE Station (
    station_id     NUMBER PRIMARY KEY,
    name           VARCHAR2(100) NOT NULL,
    region         VARCHAR2(100) NOT NULL,
    depth_meters   NUMBER CHECK (depth_meters >= 0)
);

CREATE TABLE Route (
    route_id               NUMBER PRIMARY KEY,
    type_id                NUMBER NOT NULL,
    origin_station_id      NUMBER NOT NULL,
    destination_station_id NUMBER NOT NULL,
    distance_km            NUMBER(10,2) CHECK (distance_km > 0),
    base_price             NUMBER(10,2) CHECK (base_price >= 0),
    FOREIGN KEY (type_id) REFERENCES Submarine_Type(type_id),
    FOREIGN KEY (origin_station_id) REFERENCES Station(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES Station(station_id),
    CONSTRAINT chk_diff_stations CHECK (origin_station_id <> destination_station_id)
);

CREATE TABLE Scheduled_Dive (
    dive_id          NUMBER PRIMARY KEY,
    route_id         NUMBER NOT NULL,
    departure_time   TIMESTAMP NOT NULL,
    arrival_time     TIMESTAMP NOT NULL,
    available_seats  NUMBER CHECK (available_seats >= 0),
    pressure_level   NUMBER CHECK (pressure_level >= 0),
    FOREIGN KEY (route_id) REFERENCES Route(route_id),
    CONSTRAINT chk_time_order CHECK (arrival_time > departure_time)
);

CREATE TABLE Passenger (
    passenger_id       NUMBER PRIMARY KEY,
    first_name         VARCHAR2(100) NOT NULL,
    last_name          VARCHAR2(100) NOT NULL,
    email              VARCHAR2(150) UNIQUE,
    medical_clearance  VARCHAR2(10) CHECK (medical_clearance IN ('OK','LIMITED','DENIED'))
);

CREATE TABLE Itinerary (
    itinerary_id   NUMBER PRIMARY KEY,
    passenger_id   NUMBER NOT NULL,
    created_at     TIMESTAMP NOT NULL,
    total_price    NUMBER(10,2) CHECK (total_price >= 0),
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id)
);

CREATE TABLE Itinerary_Segment (
    segment_id     NUMBER PRIMARY KEY,
    itinerary_id   NUMBER NOT NULL,
    dive_id        NUMBER NOT NULL,
    segment_order  NUMBER CHECK (segment_order > 0),
    seat_number    VARCHAR2(10) NOT NULL,
    FOREIGN KEY (itinerary_id) REFERENCES Itinerary(itinerary_id),
    FOREIGN KEY (dive_id) REFERENCES Scheduled_Dive(dive_id),
    CONSTRAINT uniq_segment_order UNIQUE (itinerary_id, segment_order)
);

CREATE TABLE Crew_Member (
    crew_id             NUMBER PRIMARY KEY,
    first_name          VARCHAR2(100) NOT NULL,
    last_name           VARCHAR2(100) NOT NULL,
    certification_level VARCHAR2(100) NOT NULL,
    experience_years    NUMBER CHECK (experience_years >= 0)
);

CREATE TABLE Captain (
    crew_id        NUMBER PRIMARY KEY,
    command_level  VARCHAR2(50) NOT NULL,
    FOREIGN KEY (crew_id) REFERENCES Crew_Member(crew_id)
);

CREATE TABLE Engineer (
    crew_id     NUMBER PRIMARY KEY,
    specialty   VARCHAR2(100) NOT NULL,
    FOREIGN KEY (crew_id) REFERENCES Crew_Member(crew_id)
);

CREATE TABLE Medic (
    crew_id                    NUMBER PRIMARY KEY,
    medical_specialization      VARCHAR2(100) NOT NULL,
    emergency_training_level    VARCHAR2(50) NOT NULL,
    FOREIGN KEY (crew_id) REFERENCES Crew_Member(crew_id)
);

CREATE TABLE Dive_Crew (
    dive_id  NUMBER NOT NULL,
    crew_id  NUMBER NOT NULL,
    duty     VARCHAR2(100) NOT NULL,
    PRIMARY KEY (dive_id, crew_id),
    FOREIGN KEY (dive_id) REFERENCES Scheduled_Dive(dive_id),
    FOREIGN KEY (crew_id) REFERENCES Crew_Member(crew_id)
);

CREATE TABLE Internship (
    passenger_id   NUMBER NOT NULL,
    crew_id        NUMBER NOT NULL,
    dive_id        NUMBER NOT NULL,
    training_level VARCHAR2(100) NOT NULL,
    feedback       NUMBER CHECK (feedback BETWEEN 1 AND 10),
    PRIMARY KEY (passenger_id, crew_id, dive_id),
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (crew_id) REFERENCES Crew_Member(crew_id),
    FOREIGN KEY (dive_id) REFERENCES Scheduled_Dive(dive_id)
);


/*test pentru tabele*/
SELECT table_name 
FROM user_tables
ORDER BY table_name;


/*inserturi*/
INSERT INTO Submarine_Type VALUES (1, 'AquaSwift', 800, 20);
INSERT INTO Submarine_Type VALUES (2, 'DeepRunner', 1200, 15);
INSERT INTO Submarine_Type VALUES (3, 'BlueRay', 600, 10);
INSERT INTO Submarine_Type VALUES (4, 'TitanX', 1500, 25);
INSERT INTO Submarine_Type VALUES (5, 'SeaFox', 900, 18);
INSERT INTO Submarine_Type VALUES (6, 'Nautilus', 1100, 22);
INSERT INTO Submarine_Type VALUES (7, 'Hydra', 700, 12);
INSERT INTO Submarine_Type VALUES (8, 'Poseidon', 1600, 30);
INSERT INTO Submarine_Type VALUES (9, 'AbyssOne', 2000, 8);
INSERT INTO Submarine_Type VALUES (10, 'CoralJet', 500, 6);

INSERT INTO Station VALUES (1, 'Coral Bay', 'Atlantic', 50);
INSERT INTO Station VALUES (2, 'Deep Haven', 'Pacific', 120);
INSERT INTO Station VALUES (3, 'Blue Ridge', 'Indian', 80);
INSERT INTO Station VALUES (4, 'Abyss Gate', 'Arctic', 300);
INSERT INTO Station VALUES (5, 'Sunken Port', 'Mediterranean', 40);
INSERT INTO Station VALUES (6, 'Crystal Reef', 'Atlantic', 20);
INSERT INTO Station VALUES (7, 'Shadow Trench', 'Pacific', 500);
INSERT INTO Station VALUES (8, 'Emerald Dome', 'Indian', 60);
INSERT INTO Station VALUES (9, 'Silent Depths', 'Arctic', 250);
INSERT INTO Station VALUES (10, 'Golden Shoal', 'Mediterranean', 30);

INSERT INTO Route VALUES (1, 1, 1, 2, 12.5, 100);
INSERT INTO Route VALUES (2, 2, 2, 3, 20.0, 150);
INSERT INTO Route VALUES (3, 3, 3, 4, 35.0, 200);
INSERT INTO Route VALUES (4, 4, 4, 5, 50.0, 300);
INSERT INTO Route VALUES (5, 5, 5, 6, 10.0, 80);
INSERT INTO Route VALUES (6, 6, 6, 7, 60.0, 350);
INSERT INTO Route VALUES (7, 7, 7, 8, 25.0, 180);
INSERT INTO Route VALUES (8, 8, 8, 9, 40.0, 250);
INSERT INTO Route VALUES (9, 9, 9, 10, 55.0, 320);
INSERT INTO Route VALUES (10, 10, 10, 1, 15.0, 120);

INSERT INTO Scheduled_Dive VALUES (1, 1, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '1' HOUR, 20, 5);
INSERT INTO Scheduled_Dive VALUES (2, 2, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '2' HOUR, 15, 6);
INSERT INTO Scheduled_Dive VALUES (3, 3, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '3' HOUR, 10, 7);
INSERT INTO Scheduled_Dive VALUES (4, 4, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '4' HOUR, 25, 8);
INSERT INTO Scheduled_Dive VALUES (5, 5, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '1' HOUR, 18, 4);
INSERT INTO Scheduled_Dive VALUES (6, 6, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '2' HOUR, 22, 9);
INSERT INTO Scheduled_Dive VALUES (7, 7, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '3' HOUR, 12, 3);
INSERT INTO Scheduled_Dive VALUES (8, 8, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '4' HOUR, 30, 10);
INSERT INTO Scheduled_Dive VALUES (9, 9, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '2' HOUR, 8, 2);
INSERT INTO Scheduled_Dive VALUES (10, 10, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '1' HOUR, 6, 1);

INSERT INTO Passenger VALUES (1, 'Alex', 'Popescu', 'alex1@mail.com', 'OK');
INSERT INTO Passenger VALUES (2, 'Maria', 'Ionescu', 'maria2@mail.com', 'OK');
INSERT INTO Passenger VALUES (3, 'Andrei', 'Georgescu', 'andrei3@mail.com', 'LIMITED');
INSERT INTO Passenger VALUES (4, 'Ioana', 'Dumitru', 'ioana4@mail.com', 'OK');
INSERT INTO Passenger VALUES (5, 'Vlad', 'Stan', 'vlad5@mail.com', 'DENIED');
INSERT INTO Passenger VALUES (6, 'Elena', 'Matei', 'elena6@mail.com', 'OK');
INSERT INTO Passenger VALUES (7, 'Radu', 'Serban', 'radu7@mail.com', 'OK');
INSERT INTO Passenger VALUES (8, 'Cristina', 'Toma', 'cristina8@mail.com', 'LIMITED');
INSERT INTO Passenger VALUES (9, 'Mihai', 'Enache', 'mihai9@mail.com', 'OK');
INSERT INTO Passenger VALUES (10, 'Daria', 'Ilie', 'daria10@mail.com', 'OK');


INSERT INTO Itinerary VALUES (1, 1, SYSTIMESTAMP, 100);
INSERT INTO Itinerary VALUES (2, 2, SYSTIMESTAMP, 150);
INSERT INTO Itinerary VALUES (3, 3, SYSTIMESTAMP, 200);
INSERT INTO Itinerary VALUES (4, 4, SYSTIMESTAMP, 300);
INSERT INTO Itinerary VALUES (5, 5, SYSTIMESTAMP, 80);
INSERT INTO Itinerary VALUES (6, 6, SYSTIMESTAMP, 350);
INSERT INTO Itinerary VALUES (7, 7, SYSTIMESTAMP, 180);
INSERT INTO Itinerary VALUES (8, 8, SYSTIMESTAMP, 250);
INSERT INTO Itinerary VALUES (9, 9, SYSTIMESTAMP, 320);
INSERT INTO Itinerary VALUES (10, 10, SYSTIMESTAMP, 120);

INSERT INTO Itinerary_Segment VALUES (1, 1, 1, 1, 'A1');
INSERT INTO Itinerary_Segment VALUES (2, 2, 2, 1, 'B1');
INSERT INTO Itinerary_Segment VALUES (3, 3, 3, 1, 'C1');
INSERT INTO Itinerary_Segment VALUES (4, 4, 4, 1, 'D1');
INSERT INTO Itinerary_Segment VALUES (5, 5, 5, 1, 'E1');
INSERT INTO Itinerary_Segment VALUES (6, 6, 6, 1, 'F1');
INSERT INTO Itinerary_Segment VALUES (7, 7, 7, 1, 'G1');
INSERT INTO Itinerary_Segment VALUES (8, 8, 8, 1, 'H1');
INSERT INTO Itinerary_Segment VALUES (9, 9, 9, 1, 'I1');
INSERT INTO Itinerary_Segment VALUES (10, 10, 10, 1, 'J1');

INSERT INTO Crew_Member VALUES (1, 'John', 'Smith', 'Advanced', 5);
INSERT INTO Crew_Member VALUES (2, 'Laura', 'Brown', 'Expert', 8);
INSERT INTO Crew_Member VALUES (3, 'Mark', 'Davis', 'Intermediate', 3);
INSERT INTO Crew_Member VALUES (4, 'Anna', 'Wilson', 'Advanced', 6);
INSERT INTO Crew_Member VALUES (5, 'Paul', 'Taylor', 'Expert', 10);
INSERT INTO Crew_Member VALUES (6, 'Emma', 'Moore', 'Intermediate', 2);
INSERT INTO Crew_Member VALUES (7, 'Chris', 'Hall', 'Advanced', 4);
INSERT INTO Crew_Member VALUES (8, 'Sophie', 'Clark', 'Expert', 12);
INSERT INTO Crew_Member VALUES (9, 'Daniel', 'Lewis', 'Intermediate', 1);
INSERT INTO Crew_Member VALUES (10, 'Olivia', 'Young', 'Advanced', 7);

INSERT INTO Captain VALUES (1, 'Senior');
INSERT INTO Captain VALUES (4, 'Junior');
INSERT INTO Captain VALUES (7, 'Senior');

INSERT INTO Engineer VALUES (2, 'Propulsion');
INSERT INTO Engineer VALUES (5, 'Navigation');
INSERT INTO Engineer VALUES (8, 'Systems');

INSERT INTO Medic VALUES (3, 'General', 'Level 2');
INSERT INTO Medic VALUES (6, 'Trauma', 'Level 3');
INSERT INTO Medic VALUES (9, 'Hyperbaric', 'Level 1');

INSERT INTO Dive_Crew VALUES (1, 1, 'Pilot');
INSERT INTO Dive_Crew VALUES (2, 2, 'Engineer');
INSERT INTO Dive_Crew VALUES (3, 3, 'Medic');
INSERT INTO Dive_Crew VALUES (4, 4, 'Pilot');
INSERT INTO Dive_Crew VALUES (5, 5, 'Engineer');
INSERT INTO Dive_Crew VALUES (6, 6, 'Medic');
INSERT INTO Dive_Crew VALUES (7, 7, 'Pilot');
INSERT INTO Dive_Crew VALUES (8, 8, 'Engineer');
INSERT INTO Dive_Crew VALUES (9, 9, 'Medic');
INSERT INTO Dive_Crew VALUES (10, 10, 'Pilot');

INSERT INTO Internship VALUES (1, 1, 1, 'Beginner', 8);
INSERT INTO Internship VALUES (2, 2, 2, 'Intermediate', 9);
INSERT INTO Internship VALUES (3, 3, 3, 'Beginner', 7);
INSERT INTO Internship VALUES (4, 4, 4, 'Advanced', 10);
INSERT INTO Internship VALUES (5, 5, 5, 'Beginner', 6);
INSERT INTO Internship VALUES (6, 6, 6, 'Intermediate', 9);
INSERT INTO Internship VALUES (7, 7, 7, 'Advanced', 10);
INSERT INTO Internship VALUES (8, 8, 8, 'Beginner', 7);
INSERT INTO Internship VALUES (9, 9, 9, 'Intermediate', 8);
INSERT INTO Internship VALUES (10, 10, 10, 'Advanced', 9);

/*itinerariu cu mai multe segmente*/
INSERT INTO Passenger (passenger_id, first_name, last_name, email, medical_clearance)
VALUES (101, 'Alex', 'Popescu', 'alex.popescu@example.com', 'OK');

INSERT INTO Itinerary (itinerary_id, passenger_id, created_at, total_price)
VALUES (201, 101, SYSTIMESTAMP, 999.99);

INSERT INTO Submarine_Type (type_id, name, max_depth_meters, capacity)
VALUES (21, 'Explorer-Class', 3000, 40);

INSERT INTO Station (station_id, name, region, depth_meters)
VALUES (31, 'Coral Gate', 'North Reef', 120);

INSERT INTO Station (station_id, name, region, depth_meters)
VALUES (32, 'Deep Haven', 'Abyssal Zone', 900);

INSERT INTO Station (station_id, name, region, depth_meters)
VALUES (33, 'Trench Point', 'Mariana Sector', 1500);

INSERT INTO Route (route_id, type_id, origin_station_id, destination_station_id, distance_km, base_price)
VALUES (41, 21, 31, 32, 12.5, 150);

INSERT INTO Route (route_id, type_id, origin_station_id, destination_station_id, distance_km, base_price)
VALUES (42, 21, 32, 33, 18.0, 200);

INSERT INTO Route (route_id, type_id, origin_station_id, destination_station_id, distance_km, base_price)
VALUES (43, 21, 33, 31, 25.0, 250);

INSERT INTO Scheduled_Dive (dive_id, route_id, departure_time, arrival_time, available_seats, pressure_level)
VALUES (51, 41, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '2' HOUR, 30, 5);

INSERT INTO Scheduled_Dive (dive_id, route_id, departure_time, arrival_time, available_seats, pressure_level)
VALUES (52, 42, SYSTIMESTAMP + INTERVAL '3' HOUR, SYSTIMESTAMP + INTERVAL '5' HOUR, 28, 6);

INSERT INTO Scheduled_Dive (dive_id, route_id, departure_time, arrival_time, available_seats, pressure_level)
VALUES (53, 43, SYSTIMESTAMP + INTERVAL '6' HOUR, SYSTIMESTAMP + INTERVAL '8' HOUR, 25, 7);

INSERT INTO Itinerary_Segment (segment_id, itinerary_id, dive_id, segment_order, seat_number)
VALUES (61, 201, 51, 1, 'A21');

INSERT INTO Itinerary_Segment (segment_id, itinerary_id, dive_id, segment_order, seat_number)
VALUES (62, 201, 52, 2, 'A22');

INSERT INTO Itinerary_Segment (segment_id, itinerary_id, dive_id, segment_order, seat_number)
VALUES (63, 201, 53, 3, 'A23');


/*selecturi*/
SELECT * FROM Submarine_Type;
SELECT * FROM Station;
SELECT * FROM Route;
SELECT * FROM Scheduled_Dive;
SELECT * FROM Passenger;
SELECT * FROM Itinerary;
SELECT * FROM Itinerary_Segment;
SELECT * FROM Crew_Member;
SELECT * FROM Captain;
SELECT * FROM Engineer;
SELECT * FROM Medic;
SELECT * FROM Dive_Crew;
SELECT * FROM Internship;

/*Pentru delete*/
DELETE FROM Internship;
DELETE FROM Dive_Crew;
DELETE FROM Itinerary_Segment;

DELETE FROM Scheduled_Dive;
DELETE FROM Route;

DELETE FROM Itinerary;
DELETE FROM Passenger;

DELETE FROM Medic;
DELETE FROM Engineer;
DELETE FROM Captain;
DELETE FROM Crew_Member;

DELETE FROM Station;
DELETE FROM Submarine_Type;

COMMIT;







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
    AVG(
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
