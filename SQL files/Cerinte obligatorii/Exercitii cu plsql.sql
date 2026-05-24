SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_users IS
        SELECT u.id_utilizator,
               u.nume_user,
               COUNT(f.id_obiectiv) AS nr_fav
        FROM   utilizator u
        JOIN   favorite f
        ON     u.id_utilizator = f.id_utilizator
        GROUP  BY u.id_utilizator, u.nume_user
        HAVING COUNT(f.id_obiectiv) >= 3
        ORDER  BY nr_fav DESC;

    v_rec c_users%ROWTYPE;
BEGIN
    OPEN c_users;
    LOOP
        FETCH c_users INTO v_rec;
        EXIT WHEN c_users%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Utilizator: ' || v_rec.nume_user ||
            ' | Favorite: ' || v_rec.nr_fav
        );
    END LOOP;
    CLOSE c_users;
END;
/



CREATE OR REPLACE PROCEDURE adauga_fotografie (
    p_id_obiectiv IN NUMBER,
    p_url         IN VARCHAR2,
    p_descriere   IN VARCHAR2
) AS
    v_exists NUMBER;
BEGIN
    -- verificăm dacă obiectivul există
    SELECT COUNT(*)
    INTO   v_exists
    FROM   obiectiv_turistic
    WHERE  id_obiectiv = p_id_obiectiv;

    IF v_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Obiectivul cu ID ' || p_id_obiectiv || ' nu există.');
    END IF;

    -- inserăm fotografia (IDENTITY generează id_fotografie)
    INSERT INTO fotografii_obiectiv (
        id_obiectiv,
        url_fotografie,
        descriere_fotografie,
        data_incarcare
    ) VALUES (
        p_id_obiectiv,
        p_url,
        p_descriere,
        SYSDATE
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Fotografie adăugată cu succes.');
END adauga_fotografie;
/




CREATE OR REPLACE FUNCTION tarif_mediu (
    p_id_obiectiv IN NUMBER
) RETURN NUMBER AS
    v_medie NUMBER;
BEGIN
    SELECT AVG(tarif)
    INTO   v_medie
    FROM   program
    WHERE  id_obiectiv = p_id_obiectiv;

    RETURN NVL(v_medie, 0);
END tarif_mediu;
/





CREATE OR REPLACE TRIGGER trg_no_self_follow
BEFORE INSERT ON urmareste
FOR EACH ROW
BEGIN
    IF :NEW.id_utilizator = :NEW.id_followed THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Un utilizator nu se poate urmări pe el însuși.'
        );
    END IF;
END trg_no_self_follow;
/



--teste

EXEC adauga_fotografie(1, 'https://test.ro/poza_noua.jpg', 'Poză test');
SELECT * FROM fotografii_obiectiv WHERE id_obiectiv = 1 ORDER BY id_fotografie DESC;


SELECT tarif_mediu(1) FROM dual;   --40
SELECT tarif_mediu(2) FROM dual;   --50
SELECT tarif_mediu(3) FROM dual;   --0



--nu este permis self follow
INSERT INTO urmareste (id_utilizator, id_followed)
VALUES (1, 1);

