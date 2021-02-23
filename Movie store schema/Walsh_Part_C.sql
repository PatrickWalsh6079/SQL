-- Performs a number of queries to SELECT, UPDATE, or DELETE info in tables.

-- 1. Retrieve all of your customers' names, account numbers, and addresses (street and zip code only), sorted by account number.
SELECT Customer.cust_id AS Account_Number, Customer.last_name, Customer.first_name, Customer.address
FROM Customer
ORDER BY Customer.cust_id;

-- 2. Retrieve all of the videos rented in the last 30 days and sort in chronological rental date order.
SELECT Movie.movie_title, Rental.rent_date  
FROM Movie, Rental
WHERE Rental.rent_date > sysdate-30 AND Movie.movie_id = Rental.movie_id
ORDER BY Rental.rent_date;

-- 3. Produce a list of your distributors and all their information sorted in order by company name.
SELECT * 
FROM Distributor
ORDER BY dist_name;

-- 4. Update a customer name to change their maiden name to a married name. You can choose which row to update. Make sure that 
-- you use the primary key column in your WHERE clause to affect only a specific row. You may want to include a ROLLBACK 
-- statement to undo your data update.
SELECT * FROM Customer;

UPDATE Customer
SET last_name = 'Smith'
WHERE cust_id = 2;

SELECT * FROM Customer;

-- 5. Delete a customer from the database. You can choose which row to delete. Make sure that you use the primary key column in 
-- your WHERE clause to affect only a specific row. You may want to include a ROLLBACK statement to undo your data deletion.
DELETE FROM Customer
WHERE cust_id = 4;

SELECT * FROM Customer;
