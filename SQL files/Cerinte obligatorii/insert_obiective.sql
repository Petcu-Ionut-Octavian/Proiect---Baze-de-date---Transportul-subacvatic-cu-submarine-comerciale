-- Insert data into obiectiv_turistic
INSERT INTO obiectiv_turistic (nume, descriere, adresa, oras, tip_obiectiv) VALUES
('Parcul Herăstrău', 'Un parc mare cu lac și multe facilități.', 'Șoseaua Kiseleff, nr. 32', 'București', 'Parc'),
('Muzeul Național de Artă', 'Muzeu cu colecții de artă românească și europeană.', 'Calea Victoriei, nr. 49-53', 'București', 'Muzeu'),
('Ateneul Român', 'Clădire emblematică pentru concerte și evenimente culturale.', 'Strada Benjamin Franklin, nr. 1-3', 'București', 'Monument'),
('Parcul Cișmigiu', 'Parc istoric cu grădini și lac.', 'Bulevardul Regina Elisabeta', 'București', 'Parc'),
('Arcul de Triumf', 'Monument istoric dedicat eroilor români.', 'Piața Arcul de Triumf', 'București', 'Monument');

-- Insert data into parc
INSERT INTO parc (id_obiectiv, suprafata, tip_vegetatie, facilitati) VALUES
(1, 187, 'Diversă', 'Locuri de joacă, piste de alergare, lacuri'),
(4, 160, 'Diversă', 'Grădini, lacuri, locuri de joacă');

-- Insert data into monument
INSERT INTO monument (id_obiectiv, data_constructie, stil_architectural, istorie) VALUES
(3, TO_DATE('1888-02-14', 'YYYY-MM-DD'), 'Neoclasic', 'Construit în 1888, Ateneul Român este un simbol cultural al României.'),
(5, TO_DATE('1936-12-01', 'YYYY-MM-DD'), 'Neoclasic', 'Arcul de Triumf a fost construit pentru a comemora participarea României în Primul Război Mondial.');

-- Insert data into fotografii_obiectiv
INSERT INTO fotografii_obiectiv (id_obiectiv, url_fotografie, descriere_fotografie, data_incarcare) VALUES
(1, 'https://example.com/herastrau1.jpg', 'Vedere aeriană a Parcului Herăstrău.', TO_DATE('2023-01-15', 'YYYY-MM-DD')),
(1, 'https://example.com/herastrau2.jpg', 'Lacul din Parcul Herăstrău.', TO_DATE('2023-02-20', 'YYYY-MM-DD')),
(2, 'https://example.com/muzeu1.jpg', 'Intrarea principală a Muzeului Național de Artă.', TO_DATE('2023-03-10', 'YYYY-MM-DD')),
(3, 'https://example.com/ateneu1.jpg', 'Fațada Ateneului Român.', TO_DATE('2023-04-05', 'YYYY-MM-DD')),
(4, 'https://example.com/cismigiu1.jpg', 'Grădinile din Parcul Cișmigiu.', TO_DATE('2023-05-01', 'YYYY-MM-DD'));

-- Insert data into utilizator
INSERT INTO utilizator (nume_user, email, parola, data_inregistrare) VALUES
('maria.popescu', 'maria.popescu@example.com', 'parola123', TO_DATE('2023-01-01', 'YYYY-MM-DD')),
('ion.ionescu', 'ion.ionescu@example.com', 'parola456', TO_DATE('2023-02-15', 'YYYY-MM-DD')),
('ana.marin', 'ana.marin@example.com', 'parola789', TO_DATE('2023-03-20', 'YYYY-MM-DD')),
('george.vasilescu', 'george.vasilescu@example.com', 'parola321', TO_DATE('2023-04-10', 'YYYY-MM-DD')),
('elena.dumitrescu', 'elena.dumitrescu@example.com', 'parola654', TO_DATE('2023-05-05', 'YYYY-MM-DD'));

-- Insert data into rating
INSERT INTO rating (id_utilizator, id_obiectiv, rating, comentariu, data_rating) VALUES
(1, 1, 3, 'Parc foarte frumos și bine întreținut.', TO_DATE('2023-01-20', 'YYYY-MM-DD')),
(2, 2, 4, 'Muzeu interesant, dar aglomerat.', TO_DATE('2023-02-25', 'YYYY-MM-DD')),
(3, 3, 5, 'Ateneul Român este impresionant.', TO_DATE('2023-03-30', 'YYYY-MM-DD')),
(4, 4, 3, 'Parc liniștit și plăcut.', TO_DATE('2023-04-15', 'YYYY-MM-DD')),
(5, 5, 5, 'Monument impresionant.', TO_DATE('2023-05-10', 'YYYY-MM-DD')),
(2, 1, 5, null, TO_DATE('2024-01-20', 'YYYY-MM-DD')),
(1, 2, 4, 'Muzeu interesant.', TO_DATE('2024-02-25', 'YYYY-MM-DD')),
(5, 3, 5, 'impresionant.', TO_DATE('2024-10-30', 'YYYY-MM-DD')),
(3, 4, 4, null, TO_DATE('2023-04-15', 'YYYY-MM-DD')),
(4, 5, 5, 'Monument impresionant.', TO_DATE('2023-05-10', 'YYYY-MM-DD')),
(1,3,3, null, null),
(1,5,4, null, null),
(2,3,2, null, null);

-- Insert data into program
INSERT INTO program (id_program, id_obiectiv,  zi, ora_deschidere, ora_inchidere, tarif) VALUES
(program_seq.NEXTVAL, 1, 'Luni', '08:00', '10:00', 50);

INSERT INTO program (id_program, id_obiectiv,  zi, ora_deschidere, ora_inchidere, tarif) VALUES
(program_seq.NEXTVAL, 2, 'Marți', '10:00', '14:00', 40);


INSERT INTO favorite (id_utilizator, id_obiectiv) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 1);


INSERT INTO urmareste (id_utilizator, id_followed) VALUES
( 1, 2);
INSERT INTO urmareste (id_utilizator, id_followed) VALUES
( 2, 3);
INSERT INTO urmareste ( id_utilizator, id_followed) VALUES
( 3, 4);
INSERT INTO urmareste ( id_utilizator, id_followed) VALUES
(4, 5);
INSERT INTO urmareste ( id_utilizator, id_followed) VALUES
(5, 1);
INSERT INTO urmareste ( id_utilizator, id_followed) VALUES
( 1, 3);
INSERT INTO urmareste (id_utilizator, id_followed) VALUES
( 2, 4);
INSERT INTO urmareste (id_utilizator, id_followed) VALUES
( 3, 5);
INSERT INTO urmareste ( id_utilizator, id_followed) VALUES
( 4, 1);
INSERT INTO urmareste (id_utilizator, id_followed) VALUES
( 5, 2);

INSERT INTO favorite VALUES (1, 3);
INSERT INTO favorite VALUES (1, 4);
COMMIT;


commit;