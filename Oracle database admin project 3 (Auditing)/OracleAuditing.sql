-- Create tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerLastName VARCHAR2(40) NOT NULL,
    CustomerFirstName VARCHAR2(40) NOT NULL,
    CustomerEmail VARCHAR2(80) NOT NULL,
    CustomerPhone VARCHAR2(12),
    CustomerCellPhone VARCHAR2(12)
);
CREATE TABLE Projections2020 (
    CustomerID INT NOT NULL,
    QuarterlyPurchaseAmount NUMBER(10, 2) NOT NULL,
    QuarterlyProfitAmount NUMBER(10, 2) NOT NULL,
    Confidence NUMBER(4, 2) NOT NULL,  -- The confidence (range 0.00 –1.00) of this projection.
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE Sales2019 (
    CustomerID INT NOT NULL,
    TransactionDate DATE NOT NULL,
    SalesAmount NUMBER(10, 2) NOT NULL,
    ProfitAmount NUMBER(10, 2) NOT NULL,
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    PRIMARY KEY(CustomerID, TransactionDate)
);

-- delete tables CAUTION!
DROP TABLE Customers CASCADE CONSTRAINTS;
DROP TABLE Projections2020 CASCADE CONSTRAINTS;
DROP TABLE Sales2019 CASCADE CONSTRAINTS;

-- insert data into Customers table
CREATE SEQUENCE seq_cust;  -- allows PK to be auto-incremented
INSERT INTO Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(seq_cust.NEXTVAL, 'Halpert', 'Jim', 'jhalpert@test.com', '111-222-3333', '101-202-3030');
INSERT INTO Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(seq_cust.NEXTVAL, 'Beesley', 'Pam', 'pbeesley@test.com', '232-343-4343', '555-423-1253');
INSERT INTO Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(seq_cust.NEXTVAL, 'Scott', 'Michael', 'mscott@test.com', '767-876-2341', '455-555-6132');
INSERT INTO Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(seq_cust.NEXTVAL, 'Shrute', 'Dwight', 'dshrute@test.com', '911-919-5542', '434-523-1233');
INSERT INTO Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(seq_cust.NEXTVAL, 'Bernard', 'Andy', 'narddog@test.com', '445-342-6678', '656-223-7836');

-- insert data into Projections2020 table
CREATE SEQUENCE seq_proj;  -- allows PK to be auto-incremented
INSERT INTO Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(seq_proj.NEXTVAL, 35623, 56743, 0.74);
INSERT INTO Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(seq_proj.NEXTVAL, 34765, 64334, 0.55);
INSERT INTO Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(seq_proj.NEXTVAL, 25674, 17786, 0.98);
INSERT INTO Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(seq_proj.NEXTVAL, 31567, 34455, 0.87);
INSERT INTO Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(seq_proj.NEXTVAL, 28900, 6673, 0.92);

-- insert data into Sales2019 table
CREATE SEQUENCE seq_sales;  -- allows PK to be auto-incremented
INSERT INTO Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(seq_sales.NEXTVAL, '20 Mar 2019', 789, 223);
INSERT INTO Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(seq_sales.NEXTVAL, '2 Apr 2019', 1433, 571);
INSERT INTO Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(seq_sales.NEXTVAL, '5 Jun 2019', 1677, 680);
INSERT INTO Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(seq_sales.NEXTVAL, '10 Aug 2019', 1087, 572);
INSERT INTO Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(seq_sales.NEXTVAL, '14 Sep 2019', 2565, 643);



-- query to see all data in tables
SELECT * FROM Customers;
SELECT * FROM Projections2020;
SELECT * FROM Sales2019;


-- create role to assign to users with read, update, insert, and delete privileges
CREATE ROLE R5PatrickWalsh;
GRANT CREATE SESSION TO R5PatrickWalsh;  --Role allows user to connect to database
GRANT SELECT, UPDATE, INSERT, DELETE ON admin.Customers TO R5PatrickWalsh;  --read, write, insert, and delete provileges on Customers table
GRANT SELECT, UPDATE, INSERT, DELETE ON admin.Projections2020 TO R5PatrickWalsh;  --read, write, insert, and delete provileges on Projections2020 table
GRANT SELECT, UPDATE, INSERT, DELETE ON admin.Sales2019 TO R5PatrickWalsh;  --read, write, insert, and delete provileges on Sales2019 table
--DROP ROLE R5PatrickWalsh;  --delete role



-- create users
CREATE USER Lab5_1PatrickWalsh  --username
IDENTIFIED BY "TestPass123!"   --password
DEFAULT TABLESPACE Users  --tablespace user is assigned to
QUOTA 30M on Users  --max space on tablespace user is allowed to use
PASSWORD EXPIRE  --requires user to reset password upon login
TEMPORARY TABLESPACE temp;  --temporary tablespace for user to use

SELECT USERNAME, ROLES, LAST_LOGIN, EXPIRY_DATE FROM DBA_USERS WHERE USERNAME = 'LAB5_1PATRICKWALSH';
--DROP USER Lab5_1PatrickWalsh CASCADE;  --delete user

CREATE USER Lab5_2PatrickWalsh  --username
IDENTIFIED BY "TestPass123!"   --password
DEFAULT TABLESPACE Users  --tablespace user is assigned to
QUOTA 30M on Users  --max space on tablespace user is allowed to use
PASSWORD EXPIRE  --requires user to reset password upon login
TEMPORARY TABLESPACE temp;  --temporary tablespace for user to use

SELECT USERNAME, LAST_LOGIN, EXPIRY_DATE FROM DBA_USERS WHERE USERNAME = 'LAB5_2PATRICKWALSH';
--DROP USER Lab5_2PatrickWalsh CASCADE;  --delete user

CREATE USER Lab5_3PatrickWalsh  --username
IDENTIFIED BY "TestPass123!"   --password
DEFAULT TABLESPACE Users  --tablespace user is assigned to
QUOTA 30M on Users  --max space on tablespace user is allowed to use
PASSWORD EXPIRE  --requires user to reset password upon login
TEMPORARY TABLESPACE temp;  --temporary tablespace for user to use

SELECT USERNAME, LAST_LOGIN, EXPIRY_DATE FROM DBA_USERS WHERE USERNAME = 'LAB5_3PATRICKWALSH';
--DROP USER Lab5_3PatrickWalsh CASCADE;  --delete user


-- assign role to users
GRANT R5PatrickWalsh TO Lab5_1PatrickWalsh;  --assigns R5PatrickWalsh role to user Lab5_1PatrickWalsh
GRANT R5PatrickWalsh TO Lab5_2PatrickWalsh;  --assigns R5PatrickWalsh role to user Lab5_2PatrickWalsh
GRANT R5PatrickWalsh TO Lab5_3PatrickWalsh;  --assigns R5PatrickWalsh role to user Lab5_3PatrickWalsh


-- Auditing the database 
SHOW PARAMETER audit_trail;  -- ensure auditing is allowed: should see DB,EXTENDED in VALUE field

-- Enable auditing of SELECT, UPDATE, INSERT, and DELETE statements for each table:
AUDIT SELECT, UPDATE, INSERT, DELETE ON Customers;
AUDIT SELECT, UPDATE, INSERT, DELETE ON Projections2020;
AUDIT SELECT, UPDATE, INSERT, DELETE ON Sales2019;

-- Disable auditing:
--NOAUDIT SELECT, UPDATE, INSERT, DELETE ON Customers;
--NOAUDIT SELECT, UPDATE, INSERT, DELETE ON Projections2020;
--NOAUDIT SELECT, UPDATE, INSERT, DELETE ON Sales2019;

-------------------------------------------------------------------------
-- LOGIN AS Lab5_1PatrickWalsh user and perform the following queries:
-------------------------------------------------------------------------
-- see which user is logged in
SHOW USER;
SELECT * FROM USER_ROLE_PRIVS;  --see which roles have been granted to the user
SELECT * FROM admin.Customers;
-- insert new data as Lab5_1PatrickWalsh
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(6, 'Hudson', 'Stanley', 'hstanley@test.com', '112-523-6678', '879-562-3411');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(7, 'Kapoor', 'Kelly', 'kkapoor@test.com', '554-342-6756', '232-442-5576');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(8, 'Martinez', 'Oscar', 'omartinez@test.com', '667-342-8099', '443-223-2572');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(9, 'Kinsley', 'Angela', 'amartin@test.com', '313-342-9000', '436-709-7836');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(10, 'Angela', 'Angela', 'amartin@test.com', '313-342-9000', '436-709-7836');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(11, 'Martin', 'Angela', 'amartin@test.com', '313-342-9000', '436-709-7836');
-- update records as Lab5_1PatrickWalsh
UPDATE admin.Customers SET CustomerLastName='Halpert' WHERE CustomerID=2;
UPDATE admin.Customers SET CustomerPhone='202-342-4577' WHERE CustomerID=3;
UPDATE admin.Customers SET CustomerPhone='212-563-3507' WHERE CustomerID=5;
UPDATE admin.Customers SET CustomerCellPhone='504-221-0086' WHERE CustomerID=1;
UPDATE admin.Customers SET CustomerCellPhone='645-434-1764' WHERE CustomerID=2;
UPDATE admin.Customers SET CustomerCellPhone='227-715-8946' WHERE CustomerID=5;
-- delete records as Lab5_1PatrickWalsh
DELETE FROM admin.Customers WHERE CustomerLastName='Kinsley';
DELETE FROM admin.Customers WHERE CustomerLastName='Angela';


SELECT * FROM admin.Sales2019;
-- insert new data as Lab5_1PatrickWalsh
INSERT INTO admin.Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(6, '18 Jan 2019', 675, 345);
INSERT INTO admin.Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(7, '19 Jan 2019', 809, 453);

-- update records as Lab5_1PatrickWalsh
UPDATE admin.Sales2019 SET SalesAmount=887 WHERE CustomerID=1;
UPDATE admin.Sales2019 SET SalesAmount=6098 WHERE CustomerID=2;
UPDATE admin.Sales2019 SET SalesAmount=1454 WHERE CustomerID=3;
UPDATE admin.Sales2019 SET SalesAmount=7089 WHERE CustomerID=4;

-- delete records as Lab5_1PatrickWalsh
DELETE FROM admin.Sales2019 WHERE ProfitAmount < 500;
DELETE FROM admin.Sales2019 WHERE SalesAmount < 1000;

COMMIT;  --run to ensure SQL statements are completed

-------------------------------------------------------------------------
-- LOGIN AS Lab5_2PatrickWalsh user and perform the following queries:
-------------------------------------------------------------------------
-- see which user is logged in
SHOW USER;
SELECT * FROM admin.Customers;
-- insert new data as Lab5_2PatrickWalsh
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(12, 'Levinson', 'Jan', 'hstanley@test.com', '423-889-2432', '554-562-453');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(13, 'Packer', 'Todd', 'kkapoor@test.com', '687-342-6756', '556-465-5576');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(14, 'Malone', 'Kevin', 'omartinez@test.com', '512-342-8099', '899-223-3546');

-- update records as Lab5_2PatrickWalsh
UPDATE admin.Customers SET CustomerEmail='jlevinson@test.com' WHERE CustomerLastName='Levinson';
UPDATE admin.Customers SET CustomerEmail='tpacker@test.com' WHERE CustomerLastName='Packer';
UPDATE admin.Customers SET CustomerEmail='kmalone@test.com' WHERE CustomerLastName='Malone';
UPDATE admin.Customers SET CustomerPhone='332-563-4573' WHERE CustomerID=8;
UPDATE admin.Customers SET CustomerCellPhone='410-221-4475' WHERE CustomerID=6;
UPDATE admin.Customers SET CustomerCellPhone='240-434-0425' WHERE CustomerID=7;
UPDATE admin.Customers SET CustomerCellPhone='443-715-1274' WHERE CustomerID=8;

SELECT * FROM admin.Sales2019;
-- insert new data as Lab5_2PatrickWalsh
INSERT INTO admin.Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(6, '1 Feb 2019', 576, 489);
INSERT INTO admin.Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(7, '7 May 2019', 7809, 609);
INSERT INTO admin.Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(8, '8 Jul 2019', 2567, 798);
INSERT INTO admin.Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(11, '14 Feb 2019', 1980, 900);

SELECT * FROM admin.Projections2020;
-- insert new data as Lab5_2PatrickWalsh
INSERT INTO admin.Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(6, 87635, 76884, 0.84);
INSERT INTO admin.Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(7, 34476, 43543, 0.54);
INSERT INTO admin.Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(8, 34588, 987978, 0.70);
INSERT INTO admin.Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(11, 45478, 875, 0.79);
INSERT INTO admin.Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(12, 438765, 3423, 0.37);
INSERT INTO admin.Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(13, 54388, 1457, 0.63);

-- update records as Lab5_2PatrickWalsh
UPDATE admin.Projections2020 SET QuarterlyPurchaseAmount=887 WHERE CustomerID=2;
UPDATE admin.Projections2020 SET QuarterlyProfitAmount=6098 WHERE CustomerID=4;
UPDATE admin.Projections2020 SET Confidence=0.58 WHERE CustomerID=6;
UPDATE admin.Projections2020 SET QuarterlyPurchaseAmount=40000 WHERE Confidence > 0.80;
UPDATE admin.Projections2020 SET QuarterlyProfitAmount=2555 WHERE CustomerID=7;

-- delete records as Lab5_2PatrickWalsh
DELETE FROM admin.Projections2020 WHERE Confidence < 0.70;
DELETE FROM admin.Projections2020 WHERE QuarterlyProfitAmount < 5000;

COMMIT;  --run to ensure SQL statements are completed
-------------------------------------------------------------------------
-- LOGIN AS Lab5_3PatrickWalsh user and perform the following queries:
-------------------------------------------------------------------------
-- see which user is logged in
SHOW USER;
SELECT * FROM admin.Customers;
-- insert new data as Lab5_3PatrickWalsh
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(9, 'Employee', 'New', 'new@test.com', '423-889-2432', '554-562-453');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(15, 'Employee', 'New', 'new@test.com', '687-342-6756', '556-465-5576');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(16, 'Employee', 'New', 'new@test.com', '512-342-8099', '899-223-3546');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone)
VALUES(17, 'Employee', 'New', 'new@test.com', '423-889-2432', '554-562-453');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(18, 'Employee', 'New', 'new@test.com', '687-342-6756', '556-465-5576');
INSERT INTO admin.Customers(CustomerID, CustomerLastName, CustomerFirstName, CustomerEmail, CustomerPhone, CustomerCellPhone) 
VALUES(19, 'Employee', 'New', 'new@test.com', '512-342-8099', '899-223-3546');

-- update records as Lab5_3PatrickWalsh
UPDATE admin.Customers SET CustomerEmail='new_emp@test.com' WHERE CustomerLastName='Employee';

-- delete records as Lab5_3PatrickWalsh
DELETE FROM admin.Customers WHERE CustomerLastName='Employee';

SELECT * FROM admin.Sales2019;
-- insert new data as Lab5_3PatrickWalsh
INSERT INTO admin.Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(12, '12 Oct 2019', 6654, 809);
INSERT INTO admin.Sales2019(CustomerID, TransactionDate, SalesAmount, ProfitAmount)
VALUES(13, '4 Nov 2019', 4523, 1233);

SELECT * FROM admin.Projections2020;
-- insert new data as Lab5_3PatrickWalsh
INSERT INTO admin.Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(11, 45478, 875, 0.79);
INSERT INTO admin.Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(12, 34588, 987978, 0.73);
INSERT INTO admin.Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(13, 54388, 1457, 0.63);
INSERT INTO admin.Projections2020(CustomerID, QuarterlyPurchaseAmount, QuarterlyProfitAmount, Confidence)
VALUES(14, 438765, 3423, 0.27);

-- update records as Lab5_3PatrickWalsh
UPDATE admin.Projections2020 SET QuarterlyPurchaseAmount=9000 WHERE CustomerID=5;
UPDATE admin.Projections2020 SET QuarterlyProfitAmount=7098 WHERE CustomerID=7;
UPDATE admin.Projections2020 SET Confidence=0.55 WHERE CustomerID=3;
UPDATE admin.Projections2020 SET QuarterlyPurchaseAmount=35444 WHERE Confidence > 0.85;
UPDATE admin.Projections2020 SET QuarterlyProfitAmount=2100 WHERE CustomerID=12;

-- delete records as Lab5_3PatrickWalsh
DELETE FROM admin.Projections2020 WHERE CustomerID=11;
DELETE FROM admin.Projections2020 WHERE CustomerID=1;
DELETE FROM admin.Projections2020 WHERE CustomerID=2;
DELETE FROM admin.Projections2020 WHERE CustomerID=5;
DELETE FROM admin.Projections2020 WHERE QuarterlyProfitAmount < 1000;

COMMIT;  --run to ensure SQL statements are completed



-------------------------------------------------------------------------
-- LOG BACK IN AS ADMIN
-------------------------------------------------------------------------
-- Query to see audit log:
SELECT username, extended_timestamp, action_name, obj_name FROM dba_audit_trail;



