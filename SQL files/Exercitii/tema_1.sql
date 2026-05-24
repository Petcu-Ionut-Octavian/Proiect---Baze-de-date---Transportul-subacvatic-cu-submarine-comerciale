-- COMPETITIE(id_competitie, denumire, data_competitie, id_castigator) 

-- PROBA(id_proba, id_competitie, descriere, punctaj_maxim, data_proba) 

-- CONCURENT_PROBA(id_concurent, id_proba, punctaj) 

-- CONCURENT(id_concurent, nume, prenume, data_nasterii) 

 

-- Pentru fiecare concurent afișați numele, prenumele și media diferenței dintre punctajul maxim posibil și punctajul obținut la probele la care a participat în anii 2021 și 2022. 

-- Pentru competițiile la care au participat mai puțin de 3 candidați (0, 1 sau 2 candidați), să se afișeze suma punctajelor tuturor probelor. 

-- Pentru fiecare concurent să se afișeze numărul competițiilor la care a participat în anii 2021, 2022 și 2023. Rezultatul va conține 4 coloane: nume_concurent, nr_com_21, nr_com_22, nr_com_23. 

-- Pentru competițiile care conțin în denumire ‘fmi’ să se afișeze denumirea, numărul de zile pe durata cărora s-au desfășurat probe. 

-- Pentru fiecare competiție să se afișeze câștigătorii (primii 3 concurenți în ordinea sumelor punctajelor obținute la toate probele). 

-- Să se afișeze concurenții care au participat la toate probele date în cadrul competiției ‘fmi no stress 8’. 

-- Să se afișeze concurenții care au o medie a punctajelor obținute peste media tuturor punctajelor. 

-- Să se afișeze pentru fiecare probă concurenții care au obținut punctaj maxim. 

-- Pentru probele la care cel mai mare punctaj a fost obținut de mai mulți concurenți să se afișeze denumirea și denumirea competiției în cadrul cărora au fost organizate. 

 
DROP TABLE CONCURENT_PROBA;
DROP TABLE PROBA;
DROP TABLE CONCURENT;
DROP TABLE COMPETITIE;








/*==========================================================
=                     CREATE TABLES                        =
==========================================================*/

CREATE TABLE COMPETITIE (
    id_competitie     NUMBER PRIMARY KEY,
    denumire          VARCHAR2(200) NOT NULL,
    data_competitie   DATE NOT NULL,
    id_castigator     NUMBER
);

CREATE TABLE PROBA (
    id_proba         NUMBER PRIMARY KEY,
    id_competitie    NUMBER NOT NULL,
    descriere        VARCHAR2(200),
    punctaj_maxim    NUMBER NOT NULL,
    data_proba       DATE NOT NULL,
    FOREIGN KEY (id_competitie) REFERENCES COMPETITIE(id_competitie)
);

CREATE TABLE CONCURENT (
    id_concurent    NUMBER PRIMARY KEY,
    nume            VARCHAR2(100),
    prenume         VARCHAR2(100),
    data_nasterii   DATE
);

CREATE TABLE CONCURENT_PROBA (
    id_concurent   NUMBER NOT NULL,
    id_proba       NUMBER NOT NULL,
    punctaj        NUMBER,
    PRIMARY KEY (id_concurent, id_proba),
    FOREIGN KEY (id_concurent) REFERENCES CONCURENT(id_concurent),
    FOREIGN KEY (id_proba) REFERENCES PROBA(id_proba)
);

/*==========================================================
=                     INSERT TEST DATA                     =
==========================================================*/

-- Competitii
INSERT INTO COMPETITIE VALUES (1, 'FMI No Stress 8', DATE '2021-05-10', NULL);
INSERT INTO COMPETITIE VALUES (2, 'FMI Challenge 2022', DATE '2022-04-15', NULL);
INSERT INTO COMPETITIE VALUES (3, 'Olimpiada Informatica 2023', DATE '2023-03-20', NULL);

-- Probe
INSERT INTO PROBA VALUES (101, 1, 'Algoritmica', 100, DATE '2021-05-10');
INSERT INTO PROBA VALUES (102, 1, 'Matematica', 100, DATE '2021-05-11');
INSERT INTO PROBA VALUES (103, 2, 'Programare C++', 120, DATE '2022-04-15');
INSERT INTO PROBA VALUES (104, 3, 'Structuri de date', 150, DATE '2023-03-20');

-- Concurenti
INSERT INTO CONCURENT VALUES (10, 'Popescu', 'Andrei', DATE '2000-01-01');
INSERT INTO CONCURENT VALUES (11, 'Ionescu', 'Maria', DATE '2001-02-02');
INSERT INTO CONCURENT VALUES (12, 'Georgescu', 'Radu', DATE '1999-03-03');

-- Concurent-Proba
INSERT INTO CONCURENT_PROBA VALUES (10, 101, 90);
INSERT INTO CONCURENT_PROBA VALUES (10, 102, 80);
INSERT INTO CONCURENT_PROBA VALUES (11, 101, 95);
INSERT INTO CONCURENT_PROBA VALUES (11, 102, 100);
INSERT INTO CONCURENT_PROBA VALUES (11, 103, 110);
INSERT INTO CONCURENT_PROBA VALUES (12, 103, 120);
INSERT INTO CONCURENT_PROBA VALUES (12, 104, 140);
INSERT INTO CONCURENT_PROBA VALUES (12, 101, 95);
INSERT INTO CONCURENT_PROBA VALUES (10, 103, 120);

/*==========================================================
=                     SELECTURI CERUTE                     =
==========================================================*/

------------------------------------------------------------
-- 1. Media diferenței dintre punctaj maxim și punctaj obținut (2021–2022)
------------------------------------------------------------
SELECT c.nume, c.prenume,
       AVG(p.punctaj_maxim - cp.punctaj) AS media_diferentei
FROM CONCURENT c
JOIN CONCURENT_PROBA cp ON c.id_concurent = cp.id_concurent
JOIN PROBA p ON cp.id_proba = p.id_proba
WHERE EXTRACT(YEAR FROM p.data_proba) IN (2021, 2022)
GROUP BY c.nume, c.prenume;

------------------------------------------------------------
-- 2. Competitii cu < 3 concurenti → suma punctajelor
------------------------------------------------------------
SELECT comp.denumire,
       SUM(cp.punctaj) AS suma_punctaje
FROM COMPETITIE comp
JOIN PROBA p ON comp.id_competitie = p.id_competitie
JOIN CONCURENT_PROBA cp ON p.id_proba = cp.id_proba
GROUP BY comp.denumire
HAVING COUNT(DISTINCT cp.id_concurent) < 3;

------------------------------------------------------------
-- 3. Nr competiții per concurent în 2021, 2022, 2023
------------------------------------------------------------
SELECT c.nume, c.prenume,
       SUM(CASE WHEN EXTRACT(YEAR FROM p.data_proba) = 2021 THEN 1 ELSE 0 END) AS nr_com_21,
       SUM(CASE WHEN EXTRACT(YEAR FROM p.data_proba) = 2022 THEN 1 ELSE 0 END) AS nr_com_22,
       SUM(CASE WHEN EXTRACT(YEAR FROM p.data_proba) = 2023 THEN 1 ELSE 0 END) AS nr_com_23
FROM CONCURENT c
LEFT JOIN CONCURENT_PROBA cp ON c.id_concurent = cp.id_concurent
LEFT JOIN PROBA p ON cp.id_proba = p.id_proba
GROUP BY c.nume, c.prenume;

------------------------------------------------------------
-- 4. Competitii cu 'fmi' → număr de zile
------------------------------------------------------------
SELECT comp.denumire,
       (MAX(p.data_proba) - MIN(p.data_proba)) + 1 AS numar_zile
FROM COMPETITIE comp
JOIN PROBA p ON comp.id_competitie = p.id_competitie
WHERE LOWER(comp.denumire) LIKE '%fmi%'
GROUP BY comp.denumire;

------------------------------------------------------------
-- 5. Top 3 concurenti per competitie
------------------------------------------------------------
SELECT *
FROM (
    SELECT comp.denumire,
           c.nume, c.prenume,
           SUM(cp.punctaj) AS total_puncte,
           ROW_NUMBER() OVER (PARTITION BY comp.id_competitie ORDER BY SUM(cp.punctaj) DESC) AS rn
    FROM COMPETITIE comp
    JOIN PROBA p ON comp.id_competitie = p.id_competitie
    JOIN CONCURENT_PROBA cp ON p.id_proba = cp.id_proba
    JOIN CONCURENT c ON cp.id_concurent = c.id_concurent
    GROUP BY comp.denumire, comp.id_competitie, c.nume, c.prenume
)
WHERE rn <= 3;

------------------------------------------------------------
-- 6. Concurenți care au participat la toate probele din 'fmi no stress 8'
------------------------------------------------------------
WITH toate AS (
    SELECT id_proba
    FROM PROBA p
    JOIN COMPETITIE c ON p.id_competitie = c.id_competitie
    WHERE LOWER(c.denumire) = 'fmi no stress 8'
),
nr AS (
    SELECT COUNT(*) AS total FROM toate
)
SELECT con.nume, con.prenume
FROM CONCURENT con
JOIN CONCURENT_PROBA cp ON con.id_concurent = cp.id_concurent
WHERE cp.id_proba IN (SELECT id_proba FROM toate)
GROUP BY con.nume, con.prenume
HAVING COUNT(*) = (SELECT total FROM nr);

------------------------------------------------------------
-- 7. Concurenți cu media punctajelor > media globală
------------------------------------------------------------
WITH mg AS (
    SELECT AVG(punctaj) AS medie_globala FROM CONCURENT_PROBA
)
SELECT c.nume, c.prenume, AVG(cp.punctaj) AS media_concurent
FROM CONCURENT c
JOIN CONCURENT_PROBA cp ON c.id_concurent = cp.id_concurent
GROUP BY c.nume, c.prenume
HAVING AVG(cp.punctaj) > (SELECT medie_globala FROM mg);

------------------------------------------------------------
-- 8. Concurenții cu punctaj maxim pe fiecare probă
------------------------------------------------------------
WITH maxp AS (
    SELECT id_proba, MAX(punctaj) AS maxp
    FROM CONCURENT_PROBA
    GROUP BY id_proba
)
SELECT p.id_proba, p.descriere, c.nume, c.prenume, cp.punctaj
FROM CONCURENT_PROBA cp
JOIN maxp m ON cp.id_proba = m.id_proba AND cp.punctaj = m.maxp
JOIN CONCURENT c ON cp.id_concurent = c.id_concurent
JOIN PROBA p ON cp.id_proba = p.id_proba;

------------------------------------------------------------
-- 9. Probe unde punctajul maxim a fost obținut de mai mulți concurenți
------------------------------------------------------------
WITH maxp AS (
    SELECT id_proba, MAX(punctaj) AS maxp
    FROM CONCURENT_PROBA
    GROUP BY id_proba
),
multi AS (
    SELECT cp.id_proba
    FROM CONCURENT_PROBA cp
    JOIN maxp m ON cp.id_proba = m.id_proba AND cp.punctaj = m.maxp
    GROUP BY cp.id_proba
    HAVING COUNT(*) > 1
)
SELECT p.id_proba, p.descriere, c.denumire
FROM PROBA p
JOIN COMPETITIE c ON p.id_competitie = c.id_competitie
WHERE p.id_proba IN (SELECT id_proba FROM multi);
