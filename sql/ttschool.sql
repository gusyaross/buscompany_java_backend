DROP DATABASE IF EXISTS buscompany;
CREATE DATABASE buscompany;
USE buscompany;

CREATE TABLE user (
	id INT NOT NULL AUTO_INCREMENT,
    login VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    user_type ENUM('ADMIN', 'CLIENT'),
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50),
    PRIMARY KEY (id),
    UNIQUE(login)
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE session (
	uuid VARCHAR(50) NOT NULL,
	id_user INT NOT NULL,
    last_action_time TIME NOT NULL,
    FOREIGN KEY (id_user) REFERENCES user (id) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE admin (
	id_user INT NOT NULL,
    position VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_user),
    FOREIGN KEY (id_user) REFERENCES user (id) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE client (
	id_user INT NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    PRIMARY KEY (id_user),
    FOREIGN KEY (id_user) REFERENCES user (id) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE bus (
	id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR (50) NOT NULL UNIQUE,
    place_count INT NOT NULL,
    PRIMARY KEY (id)
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE trip (
	id INT NOT NULL AUTO_INCREMENT,
    id_bus INT NOT NULL,
    from_station VARCHAR(50) NOT NULL,
    to_station VARCHAR(50) NOT NULL,
    start_time TIME NOT NULL,
    duration_in_minutes INT NOT NULL,
    price INT NOT NULL,
    approved BOOL NOT NULL DEFAULT FALSE,
    PRIMARY KEY (id),
    FOREIGN KEY (id_bus) REFERENCES bus (id)
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE schedule (
	id_trip INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    period VARCHAR(50) NOT NULL,
	FOREIGN KEY (id_trip) REFERENCES trip (id) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE assigned_trip (
	id INT NOT NULL AUTO_INCREMENT,
    id_trip INT NOT NULL,
    date_trip DATE NOT NULL,
    free_places INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_trip) REFERENCES trip (id) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE `order` (
	id INT NOT NULL AUTO_INCREMENT,
    id_client INT NOT NULL,
    id_assigned_trip INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_client) REFERENCES client (id_user) ON DELETE CASCADE,
    FOREIGN KEY(id_assigned_trip) REFERENCES assigned_trip (id) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE passenger (
	id INT NOT NULL AUTO_INCREMENT, 
    id_order INT NOT NULL,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    passport VARCHAR(50) NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(id_order) REFERENCES `order`(id) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

CREATE TABLE place (
	place_number INT NOT NULL,
    id_assigned_trip INT NOT NULL,
    id_passenger INT,
    PRIMARY KEY(place_number, id_assigned_trip),
    FOREIGN KEY (id_assigned_trip) REFERENCES assigned_trip (id) ON DELETE CASCADE,
    FOREIGN KEY (id_passenger) REFERENCES passenger (id) ON DELETE SET NULL
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;