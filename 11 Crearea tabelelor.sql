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