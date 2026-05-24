--a) subcereri sincronizate în care intervin cel puțin 3 tabele 

--b) subcereri nesincronizate în clauza FROM 

--c) grupări de date, funcții grup, filtrare la nivel de grupuri cu subcereri nesincronizate (în clauza de HAVING) 

--d) ordonări și utilizarea funcțiilor NVL și DECODE (în cadrul aceleiași cereri) 

--e) utilizarea a cel puțin 2 funcții pe șiruri de caractere, 2 funcții pe date calendaristice,  a cel puțin unei expresii CASE 

--f) utilizarea a cel puțin 1 bloc de cerere (clauza WITH) 




--1.
--b), c)

--sa se afiseze obiectivele care au media ratingurilor 
--mai mare decat media tuturor ratingurilor.
--pentru fiecare obiectiv se va afisa si numarul de 
--turisti pentru care obiectivul este favorit
--si media ratingurilor.

SELECT r.id_obiectiv, COUNT(*), AVG(rating), f.nr_fav
FROM rating r JOIN (SELECT id_obiectiv, COUNT(*) nr_fav
                 FROM favorite
                 GROUP BY id_obiectiv) f 
ON r.id_obiectiv = f.id_obiectiv
GROUP BY r.id_obiectiv, nr_fav
HAVING AVG(rating) > (SELECT AVG(rating)
                      FROM rating);

--2.
--a, f

--se se afiseze pentru fiecare utilizator 
--obiectivul care are ratingul maxim 
--dat de utilizatori pe care ii urmareste 
--si pe care nu l-a adaugat inca in lista sa de favorite.

--angajatii cu sal max in departament
--SELECT last_name, department_id, salary
--from employees e
--where salary = (select max(salary) from employees 
--                where department_id = e.department_id)
--order by department_id
--;




WITH rating_firends as (SELECT u.id_utilizator, 
                         u.nume_user, 
                         o.id_obiectiv, f.id_followed, 
                         r.rating
                  FROM utilizator u, obiectiv_turistic o, 
                       urmareste f,
                       rating r 
                  WHERE u.id_utilizator = f.id_utilizator
                  AND r.id_utilizator = f.id_followed
                  AND r.id_obiectiv = o.id_obiectiv
                  AND o.id_obiectiv NOT IN (SELECT o.id_obiectiv = favorite.ID_OBIECTIV
                   FROM favorite 
                   WHERE id_utilizator = u.id_utilizator
                  )
   )
SELECT id_utilizator, nume_user, id_obiectiv, rating 
FROM rating_firends r
WHERE rating = (SELECT MAX(rating) 
                FROM rating_firends 
                WHERE id_utilizator = r.id_utilizator);

--3.
--d) e)

SELECT NVL(comentariu, 'N/A') comentariu,
  CASE 
    WHEN data_rating > to_date('01-01-2024', 'dd-mm-yyyy')
    THEN 'recent'
    WHEN data_rating < to_date ('20-02-2023', 'dd-mm-yyyy')
    THEN 'neactualizat'
    ELSE 'actual' 
   END relevanta,
   s.status_user
FROM rating r JOIN 
    (SELECT id_utilizator, 
     decode ( COUNT(distinct id_obiectiv), nrmax, 'activ',
              nrmax-1 , 'activ', 
              'N/A') status_user
    FROM rating  , (SELECT MAX(COUNT(distinct id_obiectiv)) nrmax
                    FROM rating 
                    GROUP BY id_utilizator)
    GROUP BY id_utilizator, nrmax) s
on r.id_utilizator = s.id_utilizator;
    




