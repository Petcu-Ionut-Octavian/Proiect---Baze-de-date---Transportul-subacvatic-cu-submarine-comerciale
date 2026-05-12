/* ============================================================
   UPDATE 1 – CORELATĂ
   Crește prețul itinerariilor dacă total_price este mai mic
   decât media itinerariilor pasagerului respectiv.
   (subcerere corelată: folosește i.passenger_id)
   ============================================================ */
UPDATE Itinerary i
SET i.total_price = i.total_price * 1.15
WHERE i.total_price < (
    SELECT AVG(i2.total_price)
    FROM Itinerary i2
    WHERE i2.passenger_id = i.passenger_id
);

/* ============================================================
   UPDATE 2 – NECORELATĂ
   Setează available_seats = 0 pentru scufundările
   care apar în itinerarii sub media globală.
   (subcerere necorelată: nu folosește aliasuri din UPDATE)
   ============================================================ */
UPDATE Scheduled_Dive d
SET d.available_seats = 0
WHERE d.dive_id IN (
    SELECT s.dive_id
    FROM Itinerary_Segment s
    JOIN Itinerary i ON i.itinerary_id = s.itinerary_id
    WHERE i.total_price < (SELECT AVG(total_price) FROM Itinerary)
);

/* ============================================================
   UPDATE 3 – CORELATĂ
   Setează medical_clearance = 'LIMITED' pentru pasagerii
   care au itinerarii create înainte de media datelor lor proprii.
   (subcerere corelată: folosește p.passenger_id)
   ============================================================ */
UPDATE Passenger p
SET p.medical_clearance = 'LIMITED'
WHERE p.passenger_id IN (
    SELECT i.passenger_id
    FROM Itinerary i
    WHERE i.passenger_id = p.passenger_id
      AND i.created_at < (
          SELECT AVG(i2.created_at)
          FROM Itinerary i2
          WHERE i2.passenger_id = p.passenger_id
      )
);

/* ============================================================
   DELETE 1 – NECORELATĂ
   Șterge itinerariile fără segmente.
   (subcerere necorelată: nu folosește aliasuri din DELETE)
   ============================================================ */
DELETE FROM Itinerary i
WHERE i.itinerary_id NOT IN (
    SELECT itinerary_id
    FROM Itinerary_Segment
);

/* ============================================================
   DELETE 2 – CORELATĂ
   Șterge segmentele itinerariilor care au prețul total
   mai mic decât media segmentelor acelui itinerariu.
   (subcerere corelată: folosește s.itinerary_id)
   ============================================================ */
DELETE FROM Itinerary_Segment s
WHERE s.segment_id IN (
    SELECT s2.segment_id
    FROM Itinerary_Segment s2
    WHERE s2.itinerary_id = s.itinerary_id
      AND s2.segment_order < (
          SELECT AVG(s3.segment_order)
          FROM Itinerary_Segment s3
          WHERE s3.itinerary_id = s.itinerary_id
      )
);

/* ============================================================
   DELETE 3 – NECORELATĂ
   Șterge pasagerii care nu au niciun itinerariu.
   (subcerere necorelată)
   ============================================================ */
DELETE FROM Passenger p
WHERE p.passenger_id NOT IN (
    SELECT passenger_id
    FROM Itinerary
);

/* ============================================================
   ✔ 3 UPDATE-uri
   ✔ 3 DELETE-uri
   ✔ subcereri corelate și necorelate
   ✔ subcereri cu 2–3 tabele în JOIN
   ============================================================ */
