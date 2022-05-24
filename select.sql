SELECT * 
FROM "users"
WHERE ("id" % 2) = 0;

SELECT * 
FROM "users"
WHERE "height" > 1.5;

SELECT * 
FROM "users"
WHERE "gender" = 'female'
ORDER BY "last_name";

SELECT * 
FROM "users"
WHERE ("is_subscribe" = true AND "gender"= 'male' AND "height" > 1.8);

SELECT * 
FROM "users"
WHERE "first_name" IN ('John', 'Jary', 'William');

SELECT *
FROM "users" 
WHERE "height" >1.5 AND "height" < 1.9;

SELECT *
FROM "users" 
WHERE "height" BETWEEN 1.5 AND  1.9;

SELECT *
FROM "users" 
WHERE "id" BETWEEN 105 AND 130;

SELECT *
FROM "users" 
WHERE "first_name" LIKE 'L%';

SELECT *
FROM "users" 
WHERE "first_name" LIKE '___';

SELECT *
FROM "users" 
WHERE "first_name" LIKE 'L%';



SELECT *
FROM "users"
ORDER BY "id" ;

ALTER TABLE "users"
ADD COLUMN "weight" int CHECK ("weight" != 0);

UPDATE "users"
SET "weight" = 60;

UPDATE "users"
SET "weight" = 65
WHERE "id"=25;

UPDATE "users"
SET "weight" = 80
WHERE "height" > 1.8;

UPDATE "users"
SET "weight" = 85
WHERE "id" = 12
RETURNING *;

DELETE FROM "users"
WHERE "id" = 13
RETURNING *;

SELECT *
FROM "users"
WHERE "first_name" LIKE 'A%' AND "gender" = 'female';

SELECT *
FROM "users"
WHERE age("birthday") > make_interval(18);

SELECT *
FROM "users"
WHERE EXTRACT ('month' FROM "birthday") = 9; 

SELECT *
FROM "users"
WHERE age("birthday") > make_interval(20) AND age("birthday") < make_interval(60)
ORDER BY "birthday"; 

SELECT *
FROM "users"
WHERE EXTRACT ('month' FROM "birthday") = 9 AND EXTRACT ('day' FROM "birthday") = 10;

SELECT "id" AS "Порядковый номер", 
"first_name" AS "Имя", 
"last_name" AS "Фамилия", 
"email" AS "Электронная почта"
FROM "users";

SELECT * FROM "users" AS "u"
WHERE "u"."id" = 99;

--PAGINATION--

SELECT * FROM "users"
ORDER BY "id"
LIMIT 15;

SELECT * FROM "users"
ORDER BY "id"
LIMIT 15
OFFSET 15;

SELECT "id",
"first_name"|| ' ' ||"last_name" AS "Fullname"
FROM "users";

SELECT "id",
concat("first_name", ' ',"last_name") AS "Fullname"
FROM "users";


SELECT "id",
concat("first_name", ' ',"last_name") AS "Fullname"
FROM "users"
WHERE char_length(concat("first_name","last_name")) > 15;

SELECT "id",
concat("first_name", ' ',"last_name") AS "Fullname"
FROM "users"
WHERE length(concat("first_name","last_name")) <8;

SELECT * FROM
    (SELECT "id",
    concat("first_name", ' ',"last_name") AS "Fullname"
    FROM "users") AS "FN"
WHERE length("fn". "Fullname") <8;

/* 
avg - среднее
max -найбольшее
min - найменьшее
sum - сумма
count -количество
 */

SELECT max("height")
FROM "users";

SELECT min("height")
FROM "users";
--количество--
SELECT count("height")
FROM "users";
--средний вес--
SELECT avg("weight")
FROM "users";

SELECT avg("weight"), "gender"
FROM "users"
GROUP BY "gender";


SELECT * FROM "users";

SELECT max("weight")
FROM "users"
WHERE "gender" = 'female' AND EXTRACT('year' from age("birthday"))>18;

SELECT max("weight"), "gender"
FROM "users"
WHERE EXTRACT('year' from age("birthday"))>18
GROUP BY "gender";

SELECT count(*), "gender"
FROM "users"
WHERE EXTRACT('year' from age("birthday"))>18
GROUP BY "gender"
ORDER BY count;

--PRACTYISE--
--1--
SELECT avg(EXTRACT('year' from age("birthday")))
FROM "users";
--2--
SELECT avg(EXTRACT('year' from age("birthday"))), "gender"
FROM "users"
GROUP BY "gender";
--3--
SELECT min("height"), max("height"), "gender"
FROM "users"
GROUP BY "gender";
--4--
SELECT count(*)
FROM "users"
WHERE EXTRACT('year' from "birthday")>1995;
--5--
SELECT count(*)
FROM "users"
WHERE "first_name" = 'Jary';
--6--
SELECT count(*),  EXTRACT('year' from age("birthday"))
FROM "users"
WHERE EXTRACT('year' from age("birthday")) BETWEEN 20 AND 30
GROUP BY EXTRACT('year' from age("birthday"));