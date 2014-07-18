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
        id_album INT(255) NOT NULL,
        id_user INT(255) NOT NULL,
        created TIMESTAMP DEFAULT 0,
        updated TIMESTAMP DEFAULT 0 ON UPDATE now(),
        private BOOLEAN DEFAULT true NOT NULL,
        FOREIGN KEY (id_user) REFERENCES users(id_user),
        FOREIGN KEY (id_album) REFERENCES albums(id_album)
        ) ENGINE=InnoDB;

CREATE TABLE album_link (
        id_album INT(255) NOT NULL,
        id_photo INT(255) NOT NULL,
        FOREIGN KEY (id_album) REFERENCES albums(id_album),
        FOREIGN KEY (id_photo) REFERENCES photos(id_photo)
        ) ENGINE=InnoDB;



-- ДрУзЯфФкИ ^________^
INSERT INTO friends (id_friend, id_user) VALUES (2, 1);
UPDATE friends SET accepted = true WHERE accepted =false AND id_friend = 2;

