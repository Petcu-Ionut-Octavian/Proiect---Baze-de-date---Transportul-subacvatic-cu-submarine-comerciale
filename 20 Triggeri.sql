/* Trigger 1: Verifica ca available_seats ≤ capacity pentru submarinul rutei */
CREATE OR REPLACE TRIGGER trg_check_capacity
BEFORE INSERT OR UPDATE ON Scheduled_Dive
FOR EACH ROW
DECLARE
    v_capacity Submarine_Type.capacity%TYPE;
BEGIN
    SELECT st.capacity INTO v_capacity
    FROM Route r
    JOIN Submarine_Type st ON r.type_id = st.type_id
    WHERE r.route_id = :NEW.route_id;

    IF :NEW.available_seats > v_capacity THEN
        RAISE_APPLICATION_ERROR(-20001, 'available_seats depaseste capacitatea submarinului.');
    END IF;
END;
/

/* Trigger 2: Impiedica un Captain sa fie si Engineer sau Medic */
CREATE OR REPLACE TRIGGER trg_exclusive_captain
BEFORE INSERT ON Captain
FOR EACH ROW
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM Engineer WHERE crew_id = :NEW.crew_id;
    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Crew member este deja Engineer.');
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM Medic WHERE crew_id = :NEW.crew_id;
    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Crew member este deja Medic.');
    END IF;
END;
/

/* Trigger 3: Impiedica un Engineer sa fie si Captain sau Medic */
CREATE OR REPLACE TRIGGER trg_exclusive_engineer
BEFORE INSERT ON Engineer
FOR EACH ROW
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM Captain WHERE crew_id = :NEW.crew_id;
    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Crew member este deja Captain.');
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM Medic WHERE crew_id = :NEW.crew_id;
    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Crew member este deja Medic.');
    END IF;
END;
/

/* Trigger 4: Impiedica un Medic sa fie si Captain sau Engineer */
CREATE OR REPLACE TRIGGER trg_exclusive_medic
BEFORE INSERT ON Medic
FOR EACH ROW
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM Captain WHERE crew_id = :NEW.crew_id;
    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Crew member este deja Captain.');
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM Engineer WHERE crew_id = :NEW.crew_id;
    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Crew member este deja Engineer.');
    END IF;
END;
/
