DROP TABLE "workers";
CREATE TABLE "workers"(
    "id" serial PRIMARY KEY,
    "name" varchar(64) NOT NULL, 
    "birthday" date, 
    "salary" int CHECK ("salary" > 0)
);

--Задачи на INSERT--
--1--
INSERT INTO "workers" ("name", "birthday", "salary") VALUES
('Олег', '1990/01/01', 300);
--2--
INSERT INTO "workers" ("name", "salary") VALUES 
('Ярослава', 1200);
--3--
INSERT INTO "workers" ("name", "birthday", "salary") 
VALUES 
('Саша', '1985/01/05', 300),
('Маша', '1995/01/01', 900);

--Задачи на UPDATE--
--1--
UPDATE "workers"
SET "salary" = 500
WHERE "name" = 'Олег';
--2--
UPDATE "workers"
SET "birthday" = '1987/01/01'
WHERE "id" = 4;
--3--
UPDATE "workers"
SET "salary" = 700
WHERE "salary" > 500;
--4--
UPDATE "workers"
SET "birthday" = '1999/01/01'
WHERE "id" BETWEEN 2 AND 5;
--5--
UPDATE "workers"
SET "name" = 'Женя' , "salary" = 900
WHERE "name" = 'Саша';

--Задачи на SELECT --
--1--
SELECT * 
FROM "workers" WHERE "id" = 3;
--2--
SELECT * 
FROM "workers" WHERE "salary" > 400;
--3--
SELECT "salary", EXTRACT('year' FROM age("birthday")) 
FROM "workers" 
WHERE "name"= 'Женя';
--4--
SELECT * FROM "workers"
WHERE "name"= 'Петя';
--5--
SELECT * FROM "workers"
WHERE age("birthday") = make_interval(27) OR "salary" = 1000;
--6--
SELECT * FROM "workers"
WHERE age("birthday") > make_interval(25) AND age("birthday") < make_interval(28);
--7--
SELECT * FROM "workers"
WHERE "id" IN (1, 3, 5);

--Задачи на DELETE--
--1--
DELETE FROM "workers"
WHERE "id" = 4;
--2--
DELETE FROM "workers"
WHERE "name" = 'Петя';
--3--
DELETE FROM "workers"
WHERE age("birthday") > make_interval(30);
