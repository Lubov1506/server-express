DROP TABLE users;

CREATE TABLE users(
    id serial PRIMARY KEY,
    first_name varchar(64) NOT NULL CHECK (first_name != ''),
    last_name varchar(64) NOT NULL CHECK (last_name != ''),
    email varchar(256) NOT NULL UNIQUE CHECK (email != ''),
    gender varchar(64) NOT NULL,
    is_subscribe boolean NOT NULL,
    birthday date NOT NULL CHECK (birthday < current_date AND birthday > '1900/1/1'),
    height numeric(3,2) NOT NULL CHECK (height > 0.20 AND height < 3.0)
);

INSERT INTO users (first_name, last_name, email, gender, is_subscribe, birthday, height)
VALUES ('First NAme', 'hello', 'test@test.com', 'male', true, '1999-05-10', 1.90),
('world', 'Testovich', 'tes1t@test.com', 'female', true, '1999-05-10', 1.50),
('Test', 'Testovic1h', 'hw@com', 'binary', false, '1999-05-10', 1.90);

--------



DROP TABLE products;

CREATE TABLE products (
    id serial PRIMARY KEY,
    name varchar(64),
    category varchar(128),
    price decimal(16,2),
    quantity int,
    UNIQUE(name, category),
    CHECK (quantity > 0),
    CHECK (price > 0)
);

INSERT INTO products (name, category, price, quantity) VALUES
('samsung s', 'phone', 123.10, 5),
('iphone', 'phone', 2000, 6),
('dell', 'computer', 200.5, 1),
('lenovo', 'computer', 150.2, 3),
('realme 6', 'phone', 150.1, 1);

----

/* Связь 1:m
users - главная,
orders - подчиненная таблица
*/


DROP TABLE orders;

CREATE TABLE orders(
id serial PRIMARY KEY,
created_at timestamp DEFAULT current_timestamp,
customer_id int REFERENCES users(id)
);

INSERT INTO orders (customer_id) VALUES 
(1),
(2),
(2),
(3);

/* 
Связь многие ко многим
m:m
имяТаблицы1_to_имяТаблицы2
*/

DROP TABLE products_to_orders;

CREATE TABLE products_to_orders(
    product_id int REFERENCES products(id),
    order_id int REFERENCES orders(id),
    quantity int,
    PRIMARY KEY(product_id, order_id)
);

INSERT INTO products_to_orders (product_id, order_id, quantity) VALUES
(2, 1, 3),
(3, 1, 1),
(1, 2, 1),
(3, 3, 1),
(5, 4, 2);



CREATE TABLE chats(
    id serial PRIMARY KEY,
    name varchar(64) CHECK (name != ''),
    owner_id int REFERENCES users(id),
    create_at timestamp DEFAULT current_timestamp
);


INSERT INTO chat (name, owner_id) VALUES ();

CREATE TABLE user_to_chat (
    user_id int REFERENCES users(id),
    chat_id int REFERENCES chats(id),
    join_at timestamp DEFAULT current_timestamp,
    PRIMARY KEY(user_id, chat_id)
);

CREATE TABLE messages(
    id serial PRIMARY KEY,
    body text CHECK (body != ''),
    created_at timestamp DEFAULT current_timestamp,
    author_id int,
    chat_id int,
    FOREIGN KEY (chat_id, author_id) REFERENCES user_to_chat (chat_id, user_id)
);

/*
Сущность Контент
- имя
- описание
- дата создания
Сущность реакции
- like
- dislike
- null или можем удалить кортеж из таблицы
Контент --->Реакции <----Пользователь
*/

DROP TABLE content;

CREATE TABLE content(
    id serial PRIMARY KEY,
    name varchar(64),
    description text,
    author_id int REFERENCES users(id)
);


CREATE TABLE reactions(
users_id int REFERENCES users(id),
content_id int REFERENCES content(id),
is_liked boolean
);

/* 
CASE 
    WHEN
    THEN
END */

SELECT users.id, users.email, (
    CASE
    WHEN is_subscribe = true THEN 'subscribed'
    ELSE 'not subscribed'
    END
) AS "is_subscribe"
FROM users;

/* 
CASE expression
    WHEN case1 THEN result1
    WHEN case2 THEN result2
END
 */
SELECT *, (
    CASE extract('month' from "birthday")
    WHEN 1 THEN 'winter'
    WHEN 2 THEN 'winter'
    WHEN 3 THEN 'spring'
    WHEN 4 THEN 'spring'
    WHEN 5 THEN 'spring'
    WHEN 6 THEN 'summer'
    WHEN 7 THEN 'summer'
    WHEN 8 THEN 'summer'
    WHEN 9 THEN 'autumn'
    WHEN 10 THEN 'autumn'
    WHEN 11 THEN 'autumn'
    WHEN 12 THEN 'winter'
END
) AS "seasons"
FROM users;

---

SELECT *, (
CASE
    WHEN extract('year' from age("birthday")) <= 30 THEN 'not adult'
    ELSE 'adult'
END
) AS "age status"
FROM users;

SELECT *, (
CASE
    WHEN brand ILIKE 'iphone' THEN 'IPhone'
    ELSE 'Other'
END
)
AS "manufacture"
FROM phones;

SELECT *, (
    CASE
    WHEN price < 5000 THEN 'cheap' 
    WHEN price > 8000 THEN 'flagman' 
    ELSE'middle' 
    END
) AS "price class"
FROM phones;

SELECT *, (
    CASE 
    WHEN price > avg(price) THEN 'expensive'
    ELSE 'cheap'
    END
) AS "avg"
FROM phones
GROUP BY id;

SELECT *, (
    CASE 
    WHEN price > 
    "avg price"
    THEN 'expensive'
    ELSE 'cheap'
    END
) AS "avg"
FROM 
(SELECT avg(price)AS "avg price"
FROM phones  ) AS "avg price count";

WITH "avg_price" AS (
    SELECT avg(price) FROM phones
)
SELECT *, "avg_price", (
    CASE 
    WHEN price > "avg_price" THEN 'expensive'
    ELSE 'cheap'
    END
) AS "price status"
FROM phones;

SELECT *, (
    CASE 
    WHEN price > (
        SELECT avg(price) FROM phones
    ) THEN 'expensive'
    ELSE 'cheap'
    END
) AS "price status"
FROM phones;


SELECT *, (
    CASE 
    WHEN 
    (SELECT sum(o.id) FROM orders GROUP BY o.user_id) > 3 THEN 'постоянный покупатель'
    WHEN 
    (SELECT sum(o.id) FROM orders GROUP BY o.user_id)> 2 THEN 'активный покупатель'
    ELSE 'покупатель'
    END
) AS "buying active"
FROM users AS u
JOIN orders AS o
ON u.id = o.user_id
GROUP BY o.user_id;

SELECT u.id, u.email, (
    CASE 
    WHEN count(o.id) > 3 THEN 'постоянный покупатель'
    WHEN count(o.id) > 2 THEN 'активный покупатель'
    ELSE 'покупатель'
    END
) AS "buying active"
FROM users AS u
LEFT JOIN orders AS o
ON u.id = o.user_id
GROUP BY o.user_id, u.id
ORDER BY u.id;
-- COALESCE - вернет первый не NULLI
SELECT COALESCE (NULL, 12,24);
SELECT COALESCE (NULL, NULL,NULL);

ALTER TABLE phones
ADD COLUMN "decsr" text;

SELECT model, price, COALESCE(decsr, 'not available') AS "description"
FROM phones;

/* 
NULLIF (12, 12) - NULL;
NULLIF (12, NULL) - 12;
NULLIF (15, 24) - 15;
NULLIF (NULL, NULL) - NULL;
 */

 /* GREATEST, LEAST
 GREATEST (1,2,3,4,5,6) - 6
 LEAST (1,2,3,4,5,6) - 1 */


/*  ________ выражения ПОДЗАПРОСОВ ________    */

/* 
IN - NOT IN
SOME, ANY
EXCISTS */

--Выбрать всех пользователей, которые не делали заказы
SELECT * 
FROM users AS u
WHERE u.id NOT IN (SELECT user_id FROM orders);

SELECT *
FROM phones AS p
WHERE p.id NOT IN (
    SELECT phone_id FROM orders_to_phones
);

SELECT EXISTS(
    SELECT * FROM users
    WHERE users.id= 20
);

--Делал ли пользователь заказ
SELECT * FROM users AS u
WHERE EXISTS(
    SELECT * FROM orders
    WHERE u.id=orders.user_id
);

--ALL - true, если условие истина для всех, false - наоборот
SELECT *
FROM phones AS p
WHERE p.id != ALL (SELECT "phone_id"
FROM orders_to_phones);