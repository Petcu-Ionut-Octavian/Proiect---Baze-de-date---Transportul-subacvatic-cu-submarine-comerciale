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