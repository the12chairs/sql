CREATE DATABASE instaclone;
USE instaclone;

CREATE TABLE users (
        id_user INT(255) AUTO_INCREMENT PRIMARY KEY,
        login VARCHAR(50) NOT NULL,
        email VARCHAR(50) NOT NULL,
        password VARCHAR(255) NOT NULL
        ) ENGINE=InnoDB;

CREATE TABLE friends (
        id_friend INT(255) NOT NULL, -- Aim
        id_user INT(255) NOT NULL, -- We
        accepted BOOLEAN DEFAULT false, -- Is accepted
        FOREIGN KEY (id_friend) REFERENCES users(id_user),
        FOREIGN KEY (id_user) REFERENCES users(id_user)
        ) ENGINE=InnoDB;

CREATE TABLE albums (
        id_album INT(255) AUTO_INCREMENT PRIMARY KEY,
        id_user INT(255) NOT NULL,
        name_album VARCHAR(255) NOT NULL DEFAULT 'New album',
        created TIMESTAMP DEFAULT 0,
        updated TIMESTAMP DEFAULT 0 ON UPDATE now(),
        FOREIGN KEY (id_user) REFERENCES users(id_user)
        ) ENGINE=InnoDB;

CREATE TABLE photos (
        id_photo INT(255) AUTO_INCREMENT PRIMARY KEY,
        picture VARCHAR(255) NOT NULL,
        id_user INT(255) NOT NULL,
        created TIMESTAMP DEFAULT 0,
        updated TIMESTAMP DEFAULT 0 ON UPDATE now(),
        private BOOLEAN DEFAULT true NOT NULL,
        FOREIGN KEY (id_user) REFERENCES users(id_user)
        ) ENGINE=InnoDB;

CREATE TABLE album_link (
        id_album INT(255) NOT NULL,
        id_photo INT(255) NOT NULL,
        FOREIGN KEY (id_album) REFERENCES albums(id_album),
        FOREIGN KEY (id_photo) REFERENCES photos(id_photo)
        ) ENGINE=InnoDB;




MariaDB [instaclone]> INSERT INTO users (login, email, password) VALUES ("vasya", "vasya@vasya.vasya", "11111");
Query OK, 1 row affected (0.00 sec)

MariaDB [instaclone]> INSERT INTO users (login, email, password) VALUES ("petya", "vasya@vasya.vasya", "11111");
Query OK, 1 row affected (0.01 sec)

MariaDB [instaclone]> INSERT INTO users (login, email, password) VALUES ("Boka", "vasya@vasya.vasya", "11111");
Query OK, 1 row affected (0.01 sec)

MariaDB [instaclone]> INSERT INTO users (login, email, password) VALUES ("Joka", "vasya@vasya.vasya", "11111");
Query OK, 1 row affected (0.01 sec)

MariaDB [instaclone]> INSERT INTO albums (id_user, name_album) VALUES (1, "Ya i moya sranaya koshka");
Query OK, 1 row affected (0.02 sec)

MariaDB [instaclone]> INSERT INTO albums (id_user, name_album) VALUES (1, "Ya bez koshki");
Query OK, 1 row affected (0.00 sec)

MariaDB [instaclone]> INSERT INTO albums (id_user, name_album) VALUES (2, "S morya");
Query OK, 1 row affected (0.01 sec)

MariaDB [instaclone]> INSERT INTO albums (id_user, name_album) VALUES (2, "Svad''ba");
Query OK, 1 row affected (0.01 sec)



MariaDB [instaclone]>  INSERT INTO photos (picture, id_album, id_user, private) VALUES ("1.jpg", 1, 1, false);
ERROR 1054 (42S22): Unknown column 'id_album' in 'field list'
MariaDB [instaclone]>  INSERT INTO photos (picture, id_user, private) VALUES ("1.jpg", 1, false);
Query OK, 1 row affected (0.01 sec)

MariaDB [instaclone]>  INSERT INTO photos (picture, id_user, private) VALUES ("2.jpg", 1, false);
Query OK, 1 row affected (0.01 sec)

MariaDB [instaclone]>  INSERT INTO photos (picture, id_user, private) VALUES ("2.jpg", 1, true);
Query OK, 1 row affected (0.00 sec)

MariaDB [instaclone]>  INSERT INTO photos (picture, id_user, private) VALUES ("xxx.jpg", 2, true);
Query OK, 1 row affected (0.00 sec)



-- ДрУзЯфФкИ ^________^
INSERT INTO friends (id_friend, id_user) VALUES (2, 1);
UPDATE friends SET accepted = true WHERE accepted =false AND id_friend = 2;


-- Случайный альбом конкретного юзера с id_user = 1
SELECT * FROM photos WHERE id_user = 1 AND id_album = (SELECT id_album FROM albums ORDER BY rand() LIMIT 1) LIMIT 10 OFFSET 40;

UPDATE users SET login = "Pwned" WHERE id_user = 1;


UPDATE albums SET name_album = "Pwned" WHERE id_album = 1;

UPDATE photos SET private = true WHERE id_photo = 1;


-- Проверка на непринадлежность фото к альбому пользователя и к самому пользователю, проверка привата. Совпала - удаление
DELETE * FROM album_link WHERE id_album NOT IN (SELECT id_album FROM albums WHERE id_user = 2) AND id_photo IN (SELECT id_photo FROM photos WHERE id_user = 2 AND private = true); 

-- 8
DELETE * FROM photos WHERE id_photo NOT IN (SELECT id_photo FROM album_link);



SELECT * FROM albums WHERE id_user IN (SELECT id_friend FROM friends WHERE id_user = 2 AND accepted = true);

-- Выводит фото и пользователя, который может ее посмотреть. Логика такая: Если фото не приват, то видят все. Приватные фото может видеть только владелец фото
SELECT picture, users.login FROM photos INNER JOIN users WHERE private = false OR users.id_user = photos.id_photo;



-- Index

CREATE INDEX part_pic ON photos (picture (20));

CREATE INDEX user_name ON users (login (20));

CREATE INDEX user_name ON users (login (20));

CREATE INDEX ind ON photos (id_user);

CREATE INDEX usr_alb ON albums (id_user);


-- Hometask

-- 3
SELECT picture FROM photos WHERE id_photo IN (SELECT id_photo FROM album_link WHERE id_album = (SELECT id_album FROM albums WHERE id_user = 1 ORDER BY rand() LIMIT 1));
-- 4 
SELECT picture FROM photos WHERE id_photo IN (SELECT id_photo FROM album_link WHERE id_album IN (SELECT id_album FROM albums WHERE id_user = 1));

-- 5 Hardcore mod = on


SELECT DISTINCT id_photo, picture FROM photos WHERE id_photo IN (SELECT id_photo FROM album_link WHERE id_album IN (SELECT id_album FROM albums WHERE id_user IN (SELECT id_friend FROM friends WHERE id_user = 2 AND accepted = true))) AND NOT IN (SELECT id_photo FROM photos WHERE id_photo IN (SELECT id_photo FROM album_link WHERE id_album IN (SELECT id_album FROM albums WHERE id_user = 2)));


-- or

SELECT DISTINCT photos.id_photo, picture FROM photos INNER JOIN album_link ON album_link.id_photo = photos.id_photo INNER JOIN albums ON albums.id_album = album_link.id_album INNER JOIN users ON users.id_user = albums.id_user INNER JOIN friends ON friends.id_user = 2 AND accepted = true WHERE albums.id_user != 1;

-- Первый мне нравится больше, там лучше ясна логика запроса. Но по какой-то причине ошибка синтаксиса в конъюнкции подзапросов

-- hardcore mod = off
