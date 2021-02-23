-- Insert data into each table

-- (director_id, director_name)
INSERT INTO Director VALUES (001, 'Ridley Scott');
INSERT INTO Director VALUES (002, 'Steven Spielberg');
INSERT INTO Director VALUES (003, 'George Lucas');
INSERT INTO Director VALUES (004, 'Martin Scorsese');
INSERT INTO Director VALUES (005, 'James Cameron');

-- (award_id, award_name)
INSERT INTO Award VALUES (001, 'Academy Award');
INSERT INTO Award VALUES (002, 'Golden Globe');
INSERT INTO Award VALUES (003, 'Best Picture');
INSERT INTO Award VALUES (004, 'Oscar');
INSERT INTO Award VALUES (005, 'Two thumbs up');

-- (actor_id, actor_name)
INSERT INTO Actor VALUES (001, 'Russell Crowe');
INSERT INTO Actor VALUES (002, 'Harrison Ford');
INSERT INTO Actor VALUES (003, 'Natalie Portman');
INSERT INTO Actor VALUES (004, 'Leonardo DiCaprio');
INSERT INTO Actor VALUES (005, 'Linda Hamilton');
INSERT INTO Actor VALUES (006, 'Arnold Schwarzenegger');
INSERT INTO Actor VALUES (007, 'Mark Hamill');

-- (cast_id, actor_id)
INSERT INTO MovieCast VALUES (001, 001);
INSERT INTO MovieCast VALUES (002, 007);
INSERT INTO MovieCast VALUES (003, 002);
INSERT INTO MovieCast VALUES (004, 005);
INSERT INTO MovieCast VALUES (005, 006);
INSERT INTO MovieCast VALUES (006, 003);
INSERT INTO MovieCast VALUES (007, 004);

-- (movie_id, movie_title, running_length, rating, release_date, director_id, award_id, cast_id, DVD_orVHS)
INSERT INTO Movie VALUES (001, 'Gladiator', 110, 9.5, '5 Jun 2000', 001, 003, 001, 'VHS');
INSERT INTO Movie VALUES (002, 'Star Wars: A New Hope', 138, 9.9, '6 Sep 1977', 003, 004, 002, 'VHS');
INSERT INTO Movie VALUES (003, 'The Terminator', 99, 9.1, '1 Dec 1984', 005, 002, 005, 'VHS');
INSERT INTO Movie VALUES (004, 'Star Wars: The Phantom Menace', 106, 8.5, '8 Aug 2000', 003, NULL, 006, 'DVD');
INSERT INTO Movie VALUES (005, 'The Departed', 165, 9.7, '16 Jun 2005', 004, 004, 007, 'DVD');

-- (cust_id, last_name, first_name, address, phone_num)
INSERT INTO Customer VALUES (001, 'Smith', 'John', '123 Main st St Louis, MO', 1231112222);
INSERT INTO Customer VALUES (002, 'Doe', 'Jane', '44 Second st Memphis, TN', 2237414455);
INSERT INTO Customer VALUES (003, 'McDonald', 'Ronald', '1 First st Tampa, FL', 1205554721);
INSERT INTO Customer VALUES (004, 'Bones', 'Billy', '335 Salty Port ave Greenville, SC', 1325557420);
INSERT INTO Customer VALUES (005, 'Cash', 'Johnny', '412 Willis Cir Philadelphia, PA', 9695227834);

-- (dist_id, dist_name, genre, purchase_price, movie_id)
INSERT INTO Distributor VALUES (001, 'America shipping Co', 'Horror', 19.99, 003);
INSERT INTO Distributor VALUES (002, 'Shippers Ltd.', 'Sci Fi', 16.99, 002);
INSERT INTO Distributor VALUES (003, 'Crazy Distro Co.', 'Action', 28.99, 001);
INSERT INTO Distributor VALUES (004, 'Generic Distribution LLC', 'Sci Fi', 18.99, 004);
INSERT INTO Distributor VALUES (005, 'Super Distro Inc.', 'Action', 24.99, 005);

-- (inventory_id, rented, dist_id, movie_id)
INSERT INTO Inventory VALUES (001, 0, 003, 005);
INSERT INTO Inventory VALUES (002, 1, 005, 002);
INSERT INTO Inventory VALUES (003, 1, 001, 001);
INSERT INTO Inventory VALUES (004, 0, 002, 004);
INSERT INTO Inventory VALUES (005, 1, 003, 003);

-- (rental_id, discounted, rent_date, tax, rent_price, rewind_fee, late_or_damage_fee, cust_id, inventory_id)
INSERT INTO Rental VALUES (001, 0, '16 Feb 2021', 2.43, 8.99, 0.99, NULL, 002, 001);
INSERT INTO Rental VALUES (002, 0, '28 Jan 2021', 1.23, 1.99, 0.99, NULL, 001, 002);
INSERT INTO Rental VALUES (003, 0, '2 Feb 2021', 1.20, 2.99, 0.99, NULL, 002, 005);
INSERT INTO Rental VALUES (004, 0, '1 Apr 2020', 0.89, 2.99, NULL, 2.99, 005, 003);
INSERT INTO Rental VALUES (005, 0, '14 Jul 2019', 2.13, 3.00, NULL, 2.99, 003, 004);

/*
SELECT * FROM Director;
SELECT * FROM Award;
SELECT * FROM Actor;
SELECT * FROM MovieCast;
SELECT * FROM Movie;
SELECT * FROM Customer;
SELECT * FROM Distributor;
SELECT * FROM Inventory;
SELECT * FROM Rental;
*/