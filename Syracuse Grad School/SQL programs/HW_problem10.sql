


use demo
GO
drop table if exists fudgenbooks
GO
create table fudgenbooks
(
    isbn varchar(20) not null,
    title varchar(50) not null,
    price money,
    author1 varchar(20) not null,
    author2 varchar(20) null,
    author3 varchar(20) null, 
    subjects varchar(100) not null,
    pages int not null,
    pub_no int not null,
    pub_name varchar(50) not null,
    pub_website varchar(50) not null,
    constraint pk_fudgenbooks_isbn primary key (isbn)
)
GO
insert into fudgenbooks VALUES
('372317842','Introduction to Money Laundering', 29.95,'Mandafort', 'Made-Off', NULL, 'scams,money laundering',367,101,'Rypoff','http://www.rypoffpublishing.com'),
('472325845','Imbezzle Like a Pro',34.95,'Made-Off','Moneesgon', NULL,'imbezzle,scams',670,101,'Rypoff','http://www.rypoffpublishing.com'),
('535621977','The Internet Scammer''s Bible',44.95, 'Screwm', 'Sucka', NULL, 'phising,id theft,scams',944,102, 'BS Press','http://www.bspress.com/books'),
('635619239','Art of the Ponzi Scheme', 39.95, 'Dewey','Screwm','Howe','scams,ponzi',450,102,'BS Press','http://www.bspress.com/books')

GO
select * from fudgenbooks


-- The 1NF version of fudgenbooks is simple:
SELECT isbn, title, price, pages, pub_no, pub_name, pub_website
FROM fudgenbooks


-- Then we write our migration script using the four-step resolution process 
-- from above (drop, make table, add PK constraint, select to verify).
DROP TABLE IF EXISTS fudgenbooks_1nf
GO
SELECT isbn, title, price, pages, pub_no, pub_name, pub_website
INTO fudgenbooks_1nf
FROM fudgenbooks
GO
ALTER TABLE fudgenbooks_1nf
ADD CONSTRAINT pk_fudgenbooks_1nf PRIMARY KEY (isbn)
GO
SELECT * FROM fudgenbooks_1nf
GO



-- To create the lookup table, we must combine the unique values from columns author1, 
-- author2, and author3. Here, a UNION query does the trick. This is the common 
-- approach to use when there are multiple columns.
SELECT author1 AS author_name
FROM fudgenbooks
WHERE author1 IS NOT NULL
    UNION
SELECT author2
FROM fudgenbooks
WHERE author2 IS NOT NULL
    UNION
SELECT author3
FROM fudgenbooks
WHERE author3 IS NOT NULL



-- With the desired output, we then turn this into a migration script with our four-step process once more:
DROP TABLE IF EXISTS fb_authors
GO
SELECT a.author_name
INTO fb_authors
FROM (
    SELECT author1 AS author_name
    FROM fudgenbooks
    WHERE author1 IS NOT NULL
        UNION
    SELECT author2
    FROM fudgenbooks
    WHERE author2 IS NOT NULL
        UNION
    SELECT author3
    FROM fudgenbooks
    WHERE author3 IS NOT NULL
) AS a
GO
ALTER TABLE fb_authors ALTER COLUMN author_name VARCHAR(20) NOT NULL
GO
ALTER TABLE fb_authors ADD CONSTRAINT pk_fb_authors PRIMARY KEY (author_name)
GO
SELECT * FROM fb_authors 



-- In the last step of the resolution of the authors columns, we must create the bridge 
-- table, assigning each isbn and author_name a row in the table. When the values are 
-- in multiple columns, we use the UNPIVOT clause to build the bridge table:
SELECT isbn, author_name
FROM fudgenbooks UNPIVOT(
    author_name FOR author_column IN (author1, author2, author3)
) AS upvt



-- Next, we transform this query into a migration script:
DROP TABLE IF EXISTS fb_book_authors
GO
SELECT isbn, author_name INTO fb_book_authors
FROM fudgenbooks UNPIVOT(
    author_name FOR author_column IN (author1, author2, author3)
) AS upvt
GO
ALTER TABLE fb_book_authors ALTER COLUMN author_name VARCHAR(20) NOT NULL
GO
ALTER TABLE fb_book_authors ADD CONSTRAINT pk_fb_book_authors PRIMARY KEY (isbn, author_name)
GO
SELECT * FROM fb_book_authors 




-- Because the subjects column is a multivalued single column, we use the STRING_SPLIT 
-- function to help us extract the values. We also need distinct to pare down the number 
-- of unique values in the lookup table:
SELECT DISTINCT VALUE AS subject
FROM fudgenbooks
CROSS APPLY string_split(subjects, ',')


-- Turn this into a migration script that creates the table fb_subjects, populated with 
-- data and having the appropriate primary key set. 
-- Create the fb_subjects table
CREATE TABLE fb_subjects (
  subject_id INT IDENTITY(1,1),
  subject VARCHAR(255) NOT NULL
  CONSTRAINT pk_fb_subjects PRIMARY KEY (subject_id)
)
-- Populate the fb_subjects table with distinct subjects from fudgenbooks
INSERT INTO fb_subjects (subject)
SELECT DISTINCT TRIM(value) AS subject
FROM fudgenbooks
CROSS APPLY STRING_SPLIT(subjects, ',')
-- Alter the fudgenbooks table to add the foreign key
ALTER TABLE fudgenbooks
ADD subject_id INT
-- Create the foreign key constraint between fudgenbooks and fb_subjects
ALTER TABLE fudgenbooks
ADD CONSTRAINT fk_fudgenbooks_subject_id
FOREIGN KEY (subject_id) REFERENCES fb_subjects(subject_id);




-- Here is the SQL to for the bridge table, which is similar to the lookup table.
SELECT isbn, VALUE AS subject
FROM fudgenbooks
CROSS APPLY string_split(subjects, ',')

-- Turn this into a migration script that creates the fb_book_subjects table. 
-- Create the fb_book_subjects table
CREATE TABLE fb_book_subjects (
  isbn VARCHAR(20) NOT NULL,
  subject VARCHAR(255) NOT NULL
)
-- Populate the fb_book_subjects table
INSERT INTO fb_book_subjects (isbn, subject)
SELECT isbn, TRIM(value) AS subject
FROM fudgenbooks
CROSS APPLY STRING_SPLIT(subjects, ',');
-- Add foreign key constraint to fb_book_authors table (assuming it already exists)
-- ALTER TABLE fb_book_subjects
-- ADD CONSTRAINT fk_fb_book_subjects_isbn
-- FOREIGN KEY (subject) REFERENCES fb_book_authors(isbn);




-- First, remove the transitive dependencies from the fudgenbooks_1nf  table to create the table fb_books.
SELECT isbn, title, price, pages, pub_no
FROM fudgenbooks_1nf

-- First, remove the transitive dependencies from the fudgenbooks_1nf  table to create the table fb_books
-- Create the fb_books table
CREATE TABLE fb_books (
  isbn VARCHAR(20) NOT NULL,
  title VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  pages INT NOT NULL,
  pub_no INT NOT NULL
  CONSTRAINT pk_fb_books PRIMARY KEY (isbn)
);
-- Populate the fb_books table
INSERT INTO fb_books (isbn, title, price, pages, pub_no)
SELECT isbn, title, price, pages, pub_no
FROM fudgenbooks_1nf;



-- The migration script for the table fb_books is left to the reader to complete.
SELECT DISTINCT pub_no, pub_name, pub_website
FROM fudgenbooks_1nf

-- The migration script for the table fb_publishers is left to the reader to complete.
-- Create the fb_publishers table
CREATE TABLE fb_publishers (
  pub_no INT PRIMARY KEY,
  pub_name VARCHAR(255) NOT NULL,
  pub_website VARCHAR(255) NOT NULL
);
-- Populate the fb_publishers table
INSERT INTO fb_publishers (pub_no, pub_name, pub_website)
SELECT DISTINCT pub_no, pub_name, pub_website
FROM fudgenbooks_1nf;



-- Left to the reader, write an up/down script to add the following foreign keys:
-- Table	Column	FK Name	References
-- fb_book_authors	isbn	fk_book_authors_isbn	fb_books(isbn)
-- fb_book_authors	author_name	fk_book_authors_author_name	fb_authors(author_name)
-- fb_book_subjects	isbn	fk_book_subjects_isbn	fb_books(isbn)
-- fb_book_subjects	subject	fk_book_subjects_subject	fb_subjects(subject)
-- fb_books	pub_no	fk_books_pub_no	fb_publishers(pub_no)

-- Drop existing foreign keys (if they exist) before starting the migration
-- Table: fb_book_authors
ALTER TABLE fb_book_authors 
DROP CONSTRAINT IF EXISTS fk_book_authors_isbn
ALTER TABLE fb_book_authors 
DROP CONSTRAINT IF EXISTS fk_book_authors_author_name

-- Table: fb_book_subjects
ALTER TABLE fb_book_subjects 
DROP CONSTRAINT IF EXISTS fk_book_subjects_isbn
ALTER TABLE fb_book_subjects 
DROP CONSTRAINT IF EXISTS fk_book_subjects_subject

-- Table: fb_books
ALTER TABLE fb_book_authors 
DROP CONSTRAINT IF EXISTS fk_books_pub_no

-- Add new foreign keys

-- Table: fb_book_authors
ALTER TABLE fb_book_authors
  ADD CONSTRAINT fk_book_authors_isbn
  FOREIGN KEY (isbn) REFERENCES fudgenbooks(isbn);

ALTER TABLE fb_book_authors
  ADD CONSTRAINT fk_book_authors_author_name
  FOREIGN KEY (author_name) REFERENCES fb_authors(author_name);

-- Table: fb_book_subjects
ALTER TABLE fb_book_subjects
  ADD CONSTRAINT fk_book_subjects_isbn
  FOREIGN KEY (isbn) REFERENCES fb_books(isbn);

-- Table: fb_books
ALTER TABLE fb_books
  ADD CONSTRAINT fk_books_pub_no
  FOREIGN KEY (pub_no) REFERENCES fb_publishers(pub_no);




-- At this point, our tables are in third normal form. Our normalized model is complete, 
-- and so now we should reintroduce our foreign keys back into the model. 
-- Here are our tables:
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'fb_%'



-- Your script should alter the tables, add the FKs at the bottom of the script, and drop the 
-- foreign keys (if they exist) before you start the migration. Code like this, which soft-drops 
-- the FK, should appear at the top, before any migrations. (Repeat for each foreign key.)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_books_pub_no')
ALTER TABLE fb_books DROP fk_books_pub_no

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_book_authors_author_name')
ALTER TABLE fb_book_authors DROP fk_book_authors_author_name

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_book_authors_isbn')
ALTER TABLE fb_book_authors DROP fk_book_authors_isbn

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
    WHERE CONSTRAINT_NAME = 'fk_book_subjects_isbn')
ALTER TABLE fb_book_subjects DROP fk_book_subjects_isbn



create database xyz
go 
use xyz
go
drop table if exists xyz_consulting
go
create table xyz_consulting
(
    project_id int not null,
    project_name varchar(50) not null,
    employee_id int not null,
    employee_name varchar(50) not null,
    rate_category char(1) not null,
    rate_amount money not null,
    billable_hours int not null,
    total_billed money not null,
    constraint pk_xyz_consulting primary key(project_id, employee_id)
)
insert into xyz_consulting values 
(1023,	'Madagascar travel site',	11,	'Carol Ling',	'A',	 60.00, 	5,	 300.00 ),
(1023,	'Madagascar travel site',	12,	'Chip Atooth',	'B',	 50.00, 	10,	 500.00 ),
(1023,	'Madagascar travel site',	16,	'Charlie Horse',	'C',	 40.00, 	2,	 80.00), 
(1056,	'Online estate agency',	11,	'Carol Ling',	'D',	 90.00, 	5,	 450.00 ),
(1056,	'Online estate agency',	17,	'Avi Maria',	'B',	 50.00, 	2,	 100.00 ),
(1099,	'Open travel network',	11,	'Carol Ling',	'A',	 60.00, 	6,	 360.00 ),
(1099,	'Open travel network',	12,	'Chip Atooth',	'C',	 40.00, 	8,	 320.00 ),
(1099,	'Open travel network',	14,	'Arnie Hurtz',	'D',	 90.00, 	3,	 270.00 )
GO

select distinct project_id, project_name from xyz_consulting order by project_name


-- Normalize the xyz_consulting database to 1NF
-- Create the projects table
CREATE TABLE projects (
    project_id INT,
    project_name VARCHAR(50) NOT NULL
    CONSTRAINT pk_projects PRIMARY KEY (project_id)
)
-- Create the employees table
CREATE TABLE employees (
    employee_id INT,
    employee_name VARCHAR(50) NOT NULL
    CONSTRAINT pk_employees PRIMARY KEY (employee_id)
)
-- Create the consulting_rates table
CREATE TABLE consulting_rates (
    project_id INT NOT NULL,
    employee_id INT NOT NULL,
    rate_category CHAR(1) NOT NULL,
    rate_amount MONEY NOT NULL,
    billable_hours INT NOT NULL,
    total_billed MONEY NOT NULL,
    CONSTRAINT pk_consulting_rates PRIMARY KEY (project_id, employee_id),
    CONSTRAINT fk_consulting_rates_project FOREIGN KEY (project_id) REFERENCES projects (project_id),
    CONSTRAINT fk_consulting_rates_employee FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
)
-- Populate the projects table
INSERT INTO projects (project_id, project_name)
SELECT DISTINCT project_id, project_name
FROM xyz_consulting
-- Populate the employees table
INSERT INTO employees (employee_id, employee_name)
SELECT DISTINCT employee_id, employee_name
FROM xyz_consulting
-- Populate the consulting_rates table
INSERT INTO consulting_rates (project_id, employee_id, rate_category, rate_amount, billable_hours, total_billed)
SELECT project_id, employee_id, rate_category, rate_amount, billable_hours, total_billed
FROM xyz_consulting




-- Normlalize to 2NF
DROP TABLE IF EXISTS consulting_rates
GO
DROP TABLE IF EXISTS projects
GO
DROP TABLE IF EXISTS employees
GO
DROP TABLE IF EXISTS consultants
GO

-- Create the projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50) NOT NULL
)
-- Create the consultants table
CREATE TABLE consultants (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL
)
-- Create the consulting_rates table
CREATE TABLE consulting_rates (
    project_id INT NOT NULL,
    employee_id INT NOT NULL,
    rate_category CHAR(1) NOT NULL,
    rate_amount MONEY NOT NULL,
    billable_hours INT NOT NULL,
    total_billed MONEY NOT NULL,
    CONSTRAINT pk_consulting_rates PRIMARY KEY (project_id, employee_id),
    CONSTRAINT fk_consulting_rates_project FOREIGN KEY (project_id) REFERENCES projects (project_id),
    CONSTRAINT fk_consulting_rates_consultant FOREIGN KEY (employee_id) REFERENCES consultants (employee_id)
)
-- Populate the projects table
INSERT INTO projects (project_id, project_name)
SELECT DISTINCT project_id, project_name
FROM xyz_consulting
-- Populate the consultants table
INSERT INTO consultants (employee_id, employee_name)
SELECT DISTINCT employee_id, employee_name
FROM xyz_consulting
-- Populate the consulting_rates table
INSERT INTO consulting_rates (project_id, employee_id, rate_category, rate_amount, billable_hours, total_billed)
SELECT project_id, employee_id, rate_category, rate_amount, billable_hours, total_billed
FROM xyz_consulting



-- Normalize to 3NF
DROP TABLE IF EXISTS consulting_rates
GO
DROP TABLE IF EXISTS projects
GO
DROP TABLE IF EXISTS employees
GO
DROP TABLE IF EXISTS consultants
GO

-- Create the projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50) NOT NULL
)
-- Create the consultants table
CREATE TABLE consultants (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL
)
-- Create the consulting_rates table
CREATE TABLE consulting_rates (
    project_id INT NOT NULL,
    employee_id INT NOT NULL,
    rate_category CHAR(1) NOT NULL,
    rate_amount MONEY NOT NULL,
    billable_hours INT NOT NULL,
    total_billed MONEY NOT NULL,
    CONSTRAINT pk_consulting_rates PRIMARY KEY (project_id, employee_id),
    CONSTRAINT fk_consulting_rates_project FOREIGN KEY (project_id) REFERENCES projects (project_id),
    CONSTRAINT fk_consulting_rates_consultant FOREIGN KEY (employee_id) REFERENCES consultants (employee_id)
)
-- Populate the projects table
INSERT INTO projects (project_id, project_name)
SELECT DISTINCT project_id, project_name
FROM xyz_consulting
-- Populate the consultants table
INSERT INTO consultants (employee_id, employee_name)
SELECT DISTINCT employee_id, employee_name
FROM xyz_consulting
-- Populate the consulting_rates table
INSERT INTO consulting_rates (project_id, employee_id, rate_category, rate_amount, billable_hours, total_billed)
SELECT project_id, employee_id, rate_category, rate_amount, billable_hours, total_billed
FROM xyz_consulting

