CREATE TABLE user_tasks(
    id serial PRIMARY KEY,
    user_id int REFERENCES users(id),
    body text NOT NULL,
    is_done boolean DEFAULT false,
    deadline timestamp NOT NULL DEFAULT current_timestamp
);

INSERT INTO user_tasks(user_id, body, is_done) VALUES 
(1, 'test', false),
(2, 'hello', true),
(8, 'world', false),
(9, 'bye', true);

--Добавить столбцы
ALTER TABLE user_tasks
ADD COLUMN created_at timestamp NOT NULL DEFAULT current_timestamp;

ALTER TABLE user_tasks
ADD COLUMN test int;

--Удалить столбцы
ALTER TABLE user_tasks
DROP COLUMN test;

--Добавить ограничения
ALTER TABLE user_tasks
ADD CONSTRAINT check_created_time CHECK(created_at <= current_timestamp);

--Удалить ограничения
ALTER TABLE user_tasks
DROP CONSTRAINT check_created_time;

-- NOT NULL CONSTRAINT
ALTER TABLE user_tasks
ALTER COLUMN is_done SET NOT NULL;
ALTER TABLE user_tasks
ALTER COLUMN is_done DROP NOT NULL;

--Изменить значения по умолчанию
--добавить, изменить, удалить default
ALTER TABLE user_tasks
ALTER COLUMN is_done
DROP DEFAULT;

ALTER TABLE user_tasks
ALTER COLUMN is_done SET DEFAULT true;
--Изменить типы столбцов
ALTER TABLE user_tasks
ALTER COLUMN body TYPE varchar(512);

--Переименовать столбцы
ALTER TABLE user_tasks
RENAME COLUMN is_done TO status;
--Переименовать таблицы
ALTER TABLE user_tasks
RENAME TO tasks;


/* ---- */

CREATE TYPE tasks_status AS ENUM ('new', 'procedding', 'done', 'overdue');

ALTER TABLE tasks
ALTER COLUMN status
TYPE tasks_status;

ALTER TABLE tasks
ALTER COLUMN status
DROP DEFAULT;

ALTER TABLE tasks
ALTER COLUMN status
TYPE tasks_status USING (
    CASE status
    WHEN false THEN 'new'
    WHEN true THEN 'done'
    ELSE 'processing'
    END
)::tasks_status;

INSERT INTO tasks(user_id, body, status) VALUES
(9, 'hello', 'procesing'), (28, 'world', 'overdue');

CREATE SCHEMA task_users;

ALTER SCHEMA task_users RENAME TO TU;
DROP TABLE tu.employees;
CREATE TABLE tu.users(
    id serial PRIMARY KEY,
    login varchar(32) NOT NULL CHECK (login != ''),
    password varchar(16) NOT NULL,
    email varchar(64) NOT NULL CHECK (email != '')
);
CREATE TABLE tu.employees(
    id serial PRIMARY KEY,
    name varchar(64) NOT NULL CHECK (name != ''),
    salary numeric(10, 2),
    department varchar(32) NOT NULL CHECK (department != ''),
    position varchar(32) NOT NULL CHECK (position != ''),
    hire_date date NOT NULL CHECK (hire_date <= current_date)
);

INSERT INTO tu.employees(
    name, salary, department, position, hire_date, user_id
) VALUES
('Jane', 1000, 'sales', 'sale', '2021/04/06', 3),
('Tom', 12000, 'HR', 'manager', '2021/03/06', 4),
('Pit', 2000, 'sales', 'top-manager', '2021/02/06', 7),
('Lorens', 500, 'develop', 'dev', '2021/01/06', 8);

INSERT INTO tu.users (login, password_hash, email) VALUES
('logindfg1', 'd164b97dfd2ba92bb67a40b7ad3dc1a2a4f', 'email1@tsdse'),
('logewrgin2', 'd164b972ba92bb67a40b7ad3dc1a2a4fdfhhj', 'email2@dgfte');


ALTER TABLE tu.users
ADD UNIQUE (login);

ALTER TABLE tu.users
ADD UNIQUE (email);
--
ALTER TABLE tu.users
DROP COLUMN password;

ALTER TABLE tu.users
ADD COLUMN password_hash text;
--
ALTER TABLE tu.employees
DROP COLUMN user_id;

ALTER TABLE tu.employees
ADD COLUMN user_id int PRIMARY KEY REFERENCES tu.users;

--вытащить пользователей и их зарплату, у которых нет - 0
SELECT tuu.* , COALESCE(te.salary, 0) AS "salary"
from tu.users AS tuu
LEFT JOIN tu.employees AS te
ON tuu.id = te.user_id;

-- вытащить всех юзеров, которые не сотрудники
SELECT * 
FROM tu.users AS u
WHERE u.id NOT IN (SELECT user_id FROM tu.employees);

CREATE SCHEMA wf;
CREATE TABLE wf.department(
    id serial PRIMARY KEY,
    name varchar(64) NOT NULL
);
INSERT INTO wf.department (name) VALUES ('HR'),  ('sales'), ('development'), ('drivers');

CREATE TABLE wf.employees (
    id serial PRIMARY KEY,
    department_id int REFERENCES wf.department,
    name varchar(64) NOT NULL,
    salary numeric(10, 2) NOT NULL CHECK (salary >= 0)
);
INSERT INTO wf.employees (department_id, name, salary) VALUES 
(1, 'John', 5000),
(1, 'Jane', 7000),
(2, 'Joon', 10000),
(2, 'Olen', 8000),
(2, 'Kol', 7500),
(3, 'Petr', 6000),
(2, 'Rob', 11000),
(3, 'Garry', 5500),
(3, 'Terry', 9500);


SELECT d.name, count(e.id) AS "employees count"
FROM wf.department AS d
JOIN wf.employees AS e
ON e.department_id = d.id
GROUP BY d.id;

-- сотрудник и название его отдела
SELECT e.*, d.name
FROM wf.department AS d
JOIN wf.employees AS e
ON e.department_id = d.id;

--Средняя зп по каждому отделу
SELECT avg(e.salary), d.name
FROM wf.department AS d
JOIN wf.employees AS e
ON e.department_id = d.id
GROUP BY d.id;

--Вся информация о сотрудниках, департаменте и средняя зп департамента
SELECT e.*, d.*, "avg salary"
FROM wf.department AS d
JOIN wf.employees AS e
ON e.department_id = d.id
JOIN (
    SELECT avg(e.salary) AS "avg salary", d.name, d.id
    FROM wf.department AS d
    JOIN wf.employees AS e
    ON e.department_id = d.id
    GROUP BY d.id
) AS "das"
ON das.id = d.id;

-- оконные функции

SELECT e.*, d.*, avg(e.salary) OVER(PARTITION BY d.id) AS "avg salary"
FROM wf.department AS d
JOIN wf.employees AS e
ON e.department_id = d.id;

SELECT e.*, d.*, 
avg(e.salary) OVER() AS "summary salary",
avg(e.salary) OVER(PARTITION BY d.id) AS "avg salary"
FROM wf.department AS d
JOIN wf.employees AS e
ON e.department_id = d.id;