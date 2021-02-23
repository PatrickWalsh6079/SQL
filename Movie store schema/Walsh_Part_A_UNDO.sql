-- Remove all FOREIGN KEY constraints
ALTER TABLE Movie DROP CONSTRAINT movie_director;
ALTER TABLE Movie DROP CONSTRAINT movie_award;
ALTER TABLE Inventory DROP CONSTRAINT inventory_movie;
ALTER TABLE Inventory DROP CONSTRAINT inventory_dist;
ALTER TABLE Distributor DROP CONSTRAINT movie_dist;
ALTER TABLE MovieCast DROP CONSTRAINT actor_cast;
ALTER TABLE Rental DROP CONSTRAINT movie_rental;
ALTER TABLE Rental DROP CONSTRAINT cust_rental;

-- Drop all tables
DROP TABLE Movie;
DROP TABLE Award;
DROP TABLE Director;
DROP TABLE Actor;
DROP TABLE MovieCast;
DROP TABLE Inventory;
DROP TABLE Distributor;
DROP TABLE Customer;
DROP TABLE Rental;

