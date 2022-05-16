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