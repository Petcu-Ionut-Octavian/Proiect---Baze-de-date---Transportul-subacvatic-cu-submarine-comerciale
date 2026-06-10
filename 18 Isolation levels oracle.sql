/* ============================================================
   EXEMPLIFICARE COMPLETĂ ISOLATION LEVELS ÎN ORACLE
   Adaptat pentru baza ta de date cu scufundări
   ============================================================ */


/* ============================================================
   1. READ COMMITTED (default în Oracle)
   Permite:
     - NON-REPEATABLE READS
     - PHANTOM READS
   Previne:
     - DIRTY READS (Oracle NU permite dirty reads)
   ============================================================ */

/* --- T1: Pasager verifică locurile disponibile --- */
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT available_seats
FROM Scheduled_Dive
WHERE dive_id = 10;
/* → primește 20 locuri */

/* T1 finalizează tranzacția */
COMMIT;


/* --- T2: Operator modifică locurile --- */
UPDATE Scheduled_Dive
SET available_seats = 18
WHERE dive_id = 10;

COMMIT;
/* → modificarea devine vizibilă */


/* --- T1 citește din nou --- */
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT available_seats
FROM Scheduled_Dive
WHERE dive_id = 10;
/*
   → primește 18 locuri
   → NON-REPEATABLE READ
*/

COMMIT;




/* ============================================================
   2. PHANTOM READS în READ COMMITTED
   Oracle permite phantom reads în READ COMMITTED
   ============================================================ */

/* --- T1: Pasager vede segmentele itinerariului --- */
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT *
FROM Itinerary_Segment
WHERE itinerary_id = 5;
/* → primește 2 segmente */
/* nu dam comit */


/* --- T2: Sistemul adaugă un segment nou --- */
INSERT INTO Itinerary_Segment(segment_id, itinerary_id, dive_id, segment_order, seat_number)
VALUES (300, 5, 12, 3, 'A3');

COMMIT;
/* → un rând nou apare în tabel */


/* --- T1 citește din nou --- */
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT *
FROM Itinerary_Segment
WHERE itinerary_id = 5;
COMMIT;
/*
   → primește 3 segmente
   → PHANTOM READ
*/




/* ============================================================
   3. SERIALIZABLE în Oracle
   Previne:
     - NON-REPEATABLE READS
     - PHANTOM READS
   Dar poate produce:
     - ORA-08177 (update conflict)
   ============================================================ */

/* --- T1: Operator 1 citește scufundările unei rute --- */
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT *
FROM Scheduled_Dive
WHERE route_id = 3;
/* → primește 4 scufundări */

COMMIT;


/* --- T2: Operator 2 inserează o scufundare nouă --- */
INSERT INTO Scheduled_Dive(dive_id, route_id, departure_time, arrival_time, available_seats, pressure_level)
VALUES (200, 3, SYSTIMESTAMP+1, SYSTIMESTAMP+2, 15, 5);

COMMIT;
/*
   → Inserarea reușește.
   → Dacă T1 ar încerca UPDATE pe același set:
       ORA-08177: can't serialize access for this transaction
*/


/* --- T1 finalizează --- */
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT *
FROM Scheduled_Dive
WHERE route_id = 3;

COMMIT;




/* ============================================================
   4. MVCC în Oracle (citiri consistente)
   Oracle păstrează versiuni vechi ale rândurilor.
   Citirile NU sunt afectate de UPDATE-urile altor tranzacții.
   ============================================================ */

/* --- T1: Pasager verifică prețul itinerariului --- */
SELECT total_price
FROM Itinerary
WHERE itinerary_id = 10;
/* → primește 350.00 (versiune consistentă) */

COMMIT;


/* --- T2: Operator modifică prețul --- */
UPDATE Itinerary
SET total_price = 400.00
WHERE itinerary_id = 10;

COMMIT;
/* → modificarea devine vizibilă pentru alții */


/* --- T1 citește din nou --- */
SELECT total_price
FROM Itinerary
WHERE itinerary_id = 10;
/*
   → primește tot 350.00
   → Oracle MVCC păstrează versiunea consistentă
*/

COMMIT;


/* --- Dacă T1 încearcă UPDATE pe același rând --- */
/*
UPDATE Itinerary
SET total_price = 360.00
WHERE itinerary_id = 10;

→ ORA-08177: can't serialize access for this transaction
*/





/* ============================================================
   5. RESET — readuce baza la valorile inițiale
   ============================================================ */

/* Reset Scheduled_Dive */
UPDATE Scheduled_Dive
SET available_seats = 6
WHERE dive_id = 10;

/* Șterge segmentul adăugat în exemplu */
DELETE FROM Itinerary_Segment
WHERE segment_id = 300;

/* Reset Itinerary price */
UPDATE Itinerary
SET total_price = 350.00
WHERE itinerary_id = 10;

/* Șterge scufundarea inserată în exemplul SERIALIZABLE */
DELETE FROM Scheduled_Dive
WHERE dive_id = 200;

COMMIT;