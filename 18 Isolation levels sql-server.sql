/* ============================================================
   EXEMPLIFICARE COMPLETĂ ISOLATION LEVELS
   ADAPTATĂ PENTRU BAZA TA DE DATE SUBMARINE
   FIECARE SCENARIU ARE EXPLICAȚII CA ȘI COMENTARII
   ============================================================ */


/* ============================================================
   1. READ UNCOMMITTED — permite DIRTY READS
   Scenariu: Operatorul 1 modifică available_seats la o scufundare,
   dar nu face COMMIT. Operatorul 2 citește valoarea "murdară".
   ============================================================ */

/* --- T1: Operator 1 --- */
BEGIN TRAN;
UPDATE Scheduled_Dive
SET available_seats = available_seats - 2
WHERE dive_id = 10;
/* T1 NU face COMMIT → valoarea este NEconfirmată */


/* --- T2: Operator 2 (READ UNCOMMITTED) --- */
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT available_seats
FROM Scheduled_Dive
WHERE dive_id = 10;
/*
   → T2 poate vedea valoarea modificată de T1,
     chiar dacă T1 NU a făcut COMMIT.
   → Aceasta este o DIRTY READ.
*/


/* --- T1 decide să anuleze --- */
ROLLBACK;
/*
   → Valoarea citită de T2 nu a existat niciodată în baza de date.
*/



/* ============================================================
   2. READ COMMITTED — previne dirty reads,
      dar permite NON-REPEATABLE READS
   Scenariu: Pasagerul verifică locurile disponibile,
   apoi alt operator modifică scufundarea.
   ============================================================ */

/* --- T1: Pasager --- */
BEGIN TRAN;
SELECT available_seats
FROM Scheduled_Dive
WHERE dive_id = 10;
/* → primește 20 locuri */


/* --- T2: Operator modifică --- */
BEGIN TRAN;
UPDATE Scheduled_Dive
SET available_seats = 18
WHERE dive_id = 10;
COMMIT;
/* → modificarea devine vizibilă */


/* --- T1 citește din nou --- */
SELECT available_seats
FROM Scheduled_Dive
WHERE dive_id = 10;
/*
   → primește 18 locuri
   → NON-REPEATABLE READ: aceeași interogare, rezultate diferite
*/
COMMIT;



/* ============================================================
   3. REPEATABLE READ — previne non-repeatable reads,
      dar permite PHANTOM READS
   Scenariu: Pasagerul își verifică segmentele itinerariului.
   Între timp, sistemul adaugă un segment nou.
   ============================================================ */

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

/* --- T1: Pasager --- */
BEGIN TRAN;
SELECT *
FROM Itinerary_Segment
WHERE itinerary_id = 5;
/* → primește 2 segmente */


/* --- T2: Sistem adaugă un segment nou --- */
BEGIN TRAN;
INSERT INTO Itinerary_Segment(segment_id, itinerary_id, dive_id, segment_order, seat_number)
VALUES (300, 5, 12, 3, 'A3');
COMMIT;
/* → un rând nou apare în tabel */


/* --- T1 citește din nou --- */
SELECT *
FROM Itinerary_Segment
WHERE itinerary_id = 5;
/*
   → primește 3 segmente
   → PHANTOM READ: apar rânduri noi în aceeași tranzacție
*/
COMMIT;



/* ============================================================
   4. SERIALIZABLE — previne toate anomaliile,
      dar blochează concurența
   Scenariu: Operatorul 1 verifică scufundările unei rute.
   Operatorul 2 încearcă să adauge o scufundare pe aceeași rută.
   ============================================================ */

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

/* --- T1: Operator 1 --- */
BEGIN TRAN;
SELECT *
FROM Scheduled_Dive
WHERE route_id = 3;
/* → primește 4 scufundări */


/* --- T2: Operator 2 încearcă să insereze --- */
BEGIN TRAN;
INSERT INTO Scheduled_Dive(dive_id, route_id, departure_time, arrival_time, available_seats, pressure_level)
VALUES (200, 3, SYSTIMESTAMP+1, SYSTIMESTAMP+2, 15, 5);
/*
   → BLOCARE: SERIALIZABLE nu permite inserări
     care ar modifica setul de rânduri vizualizat de T1
*/


/* --- T1 finalizează --- */
COMMIT;

/* --- T2 se deblochează și rulează --- */
COMMIT;
/*
   → ZERO anomalii, dar concurență foarte redusă
*/



/* ============================================================
   5. SNAPSHOT — citiri consistente fără blocări
   Scenariu: Pasagerul își verifică prețul itinerariului.
   Alt operator îl modifică între timp.
   ============================================================ */

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

/* --- T1: Pasager --- */
BEGIN TRAN;
SELECT total_price
FROM Itinerary
WHERE itinerary_id = 10;
/* → primește 350.00 (versiunea snapshot) */


/* --- T2: Operator modifică prețul --- */
BEGIN TRAN;
UPDATE Itinerary
SET total_price = 400.00
WHERE itinerary_id = 10;
COMMIT;
/* → modificarea devine vizibilă pentru alții, dar NU pentru T1 */


/* --- T1 citește din nou --- */
SELECT total_price
FROM Itinerary
WHERE itinerary_id = 10;
/*
   → primește tot 350.00
   → SNAPSHOT păstrează versiunea consistentă
*/
COMMIT;
/*
   → Dacă T1 ar încerca UPDATE pe același rând:
     ar apărea UPDATE CONFLICT.
*/
