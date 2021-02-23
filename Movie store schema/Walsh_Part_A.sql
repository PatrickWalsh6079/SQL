-- Create all tables

-- Create Movie table
CREATE TABLE Movie (
    movie_id INT PRIMARY KEY,
    movie_title VARCHAR(30) NOT NULL,
    running_length INT,
    rating FLOAT,
    release_date DATE NOT NULL,
    director_id INT NOT NULL, -- FK to Director table
    award_id INT, -- FK to Award table
    cast_id INT NOT NULL, -- FK to MovieCast table
    DVD_or_VHS VARCHAR(3) NOT NULL
);
-- Check to see table
--DESCRIBE Movie;

-- Create Inventory table
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY,
    rented NUMBER NOT NULL, -- BOOLEAN. Enter as (1) for True and (0) for False
    dist_id INT NOT NULL, -- FK to Distributor table
    movie_id INT  NOT NULL -- FK to Movie table
);
-- Check to see table
--DESCRIBE Inventory;

-- Create Distributor table
CREATE TABLE Distributor (
    dist_id INT PRIMARY KEY,
    dist_name VARCHAR(30) NOT NULL,
    genre VARCHAR(20),
    purchase_price FLOAT NOT NULL,
    movie_id INT NOT NULL-- FK to Movie table
);
-- Check to see table
--DESCRIBE Distributor;

-- Create Award table
CREATE TABLE Award (
    award_id INT PRIMARY KEY,
    award_name VARCHAR(30) NOT NULL
);
-- Check to see table
--DESCRIBE Award;

-- Create Director table
CREATE TABLE Director (
    director_id INT PRIMARY KEY,
    director_name VARCHAR(30) NOT NULL
);
-- Check to see table
--DESCRIBE Director;

-- Create Actor table
CREATE TABLE Actor (
    actor_id INT PRIMARY KEY,
    actor_name VARCHAR(30) NOT NULL
);
-- Check to see table
--DESCRIBE Actor;

-- Create MovieCast table
CREATE TABLE MovieCast (
    cast_id INT PRIMARY KEY,
    actor_id INT NOT NULL -- FK to Actor table
);
-- Check to see table
--DESCRIBE MovieCast;

-- Create Customer table
CREATE TABLE Customer (
    cust_id INT PRIMARY KEY,
    last_name VARCHAR(30) NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    address VARCHAR(50) NOT NULL,
    phone_num INT NOT NULL
);
-- Check to see table
--DESCRIBE Customer;

-- Create Rental table
CREATE TABLE Rental (
    rental_id INT PRIMARY KEY,
    discounted NUMBER NOT NULL, -- BOOLEAN. Enter as (1) for True and (0) for False
    rent_date DATE NOT NULL,
    tax FLOAT NOT NULL,
    rent_price FLOAT NOT NULL,
    rewind_fee FLOAT,
    late_or_damage_fee FLOAT,
    cust_id INT NOT NULL,  -- FK to Customer table
    movie_id INT NOT NULL  -- FK to Movie table
    --inventory_id INT NOT NULL  -- FK to Inventory table
);
-- Check to see table
--DESCRIBE Rental;




-- Add Foreign Key constraints

-- Movie table
ALTER TABLE Movie
ADD CONSTRAINT movie_director FOREIGN KEY(director_id)
REFERENCES Director(director_id)
ON DELETE SET NULL;

ALTER TABLE Movie
ADD CONSTRAINT movie_award FOREIGN KEY(award_id)
REFERENCES Award(award_id)
ON DELETE SET NULL;

-- MovieCast table
ALTER TABLE MovieCast
ADD CONSTRAINT actor_cast FOREIGN KEY(actor_id)
REFERENCES Actor(actor_id)
ON DELETE SET NULL;

-- Inventory table
ALTER TABLE Inventory
ADD CONSTRAINT inventory_movie FOREIGN KEY(movie_id)
REFERENCES Movie(movie_id)
ON DELETE SET NULL;

ALTER TABLE Inventory
ADD CONSTRAINT inventory_dist FOREIGN KEY(dist_id)
REFERENCES Distributor(dist_id)
ON DELETE SET NULL;

-- Distributor table
ALTER TABLE Distributor
ADD CONSTRAINT movie_dist FOREIGN KEY(movie_id)
REFERENCES Movie(movie_id)
ON DELETE SET NULL;

-- Rental table
ALTER TABLE Rental
ADD CONSTRAINT cust_rental FOREIGN KEY(cust_id)
REFERENCES Customer(cust_id)
ON DELETE SET NULL;

ALTER TABLE Rental
ADD CONSTRAINT movie_rental FOREIGN KEY(movie_id)
REFERENCES Movie(movie_id)
ON DELETE SET NULL;

