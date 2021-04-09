/*
Student: Patrick Walsh
Date: 3/23/2021
Course: SDEV 350 7380
Professor: Reginald Haseltine
*/

/*
1. Write and test a set of SQL statements that will drop the following tables:
a. Engineers
b. Faculty
c. Classes
d. ClassEnrollments

Use CASCADE CONSTRAINTS to ensure table is dropped even if there are constraints
*/
DROP TABLE Engineers CASCADE CONSTRAINTS;
DROP TABLE Faculty CASCADE CONSTRAINTS;
DROP TABLE Classes CASCADE CONSTRAINTS;
DROP TABLE ClassEnrollments CASCADE CONSTRAINTS;
DROP SEQUENCE seq_eng;
DROP SEQUENCE seq_fac;
DROP SEQUENCE seq_class;
DROP SEQUENCE seq_enroll;
DROP VIEW cool_view;



/*
2. Write and test a set of SQL statements that will create the following tables:
a. Engineers
    Primary Key: EID
    Columns: Lastname, Firstname, Email, Graddate
b. Faculty 
    Primary Key: FID
    Columns: Lastname, Firstname, Email, Hiredate
c. Classes
    Primary Key: CID 
    Columns: Subject (e.g. SDEV), Catalognbr (e.g. 350), Title (e.g Database Security )
d. ClassEnrollments 
    Primary Key: EnID
    Foreign Keys: CID(from Classes), FID(from Faculty), EID(from Engineers)
*/
CREATE TABLE Engineers (
    EID INT PRIMARY KEY,
    Lastname VARCHAR2(30),
    Firstname VARCHAR2(30),
    Email VARCHAR2(30),
    Graddate DATE
);
CREATE TABLE Faculty (
    FID INT PRIMARY KEY,
    Lastname VARCHAR2(30),
    Firstname VARCHAR2(30),
    Email VARCHAR2(30),
    Hiredate DATE
);
CREATE TABLE Classes (
    CID INT PRIMARY KEY,
    Subject VARCHAR2(30),
    Catalognbr NUMBER(3),
    Title VARCHAR2(50)
);
CREATE TABLE ClassEnrollments (
    EnID INT PRIMARY KEY,
    CID INT,
    FID INT,
    EID INT,
    FOREIGN KEY(CID) REFERENCES Classes(CID),
    FOREIGN KEY(FID) REFERENCES Faculty(FID),
    FOREIGN KEY(EID) REFERENCES Engineers(EID)
);




/*
3. Write and test a set of SQL statements that will insert the following 
quantity of records into each table
a. 15 Engineers
b. 3 Faculty
c. 3 Classes
d. 15 ClassEnrollments
Your Primary Key IDs should always start with 1 and increment by 1. You 
can use an Oracle sequence but it is not required. Just hardcoding the 
Primary Key ID is Okay for this exercise.
*/
CREATE SEQUENCE seq_eng;  -- allows PK to be auto-incremented
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Halpert', 'Jim', 'jhalpert@test.com', '12 Mar 2012');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Scott', 'Michael', 'mscott@test.com', '15 May 2010');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Beesley', 'Pam', 'pbeesley@test.com', '1 Jun 2018');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Packer', 'Todd', 'tpacker@test.com', '6 Sep 2011');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Kapoor', 'Kelly', 'kkapoor@test.com', '8 Dec 2002');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Flenderson', 'Toby', 'tflenderson@test.com', '10 Nov 1997');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Philbin', 'Darryl', 'dphilbin@test.com', '11 Dec 2020');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Shrute', 'Dwight', 'dshrute@test.com', '11 Jun 2003');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Howard', 'Ryan', 'rhoward@test.com', '3 Nov 2009');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Hudson', 'Stanley', 'shudson@test.com', '19 Mar 2010');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Bernard', 'Andy', 'abernard@test.com', '26 Sep 2002');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Malone', 'Kevin', 'kmalone@test.com', '21 Mar 1986');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Martinez', 'Oscar', 'omartinez@test.com', '2 Aug 1995');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Martin', 'Angela', 'amartin@test.com', '4 Jun 1999');
INSERT INTO Engineers(EID, Lastname, Firstname, Email, Graddate) VALUES(seq_eng.NEXTVAL, 'Lapin', 'Phyllis', 'plapin@test.com', '7 Feb 2017');
--SELECT * FROM Engineers;

CREATE SEQUENCE seq_fac;  -- allows PK to be auto-incremented
INSERT INTO Faculty(FID, Lastname, Firstname, Email, Hiredate) VALUES(seq_fac.NEXTVAL, 'Wallace', 'David', 'dwallace@test.com', '2 Jul 2013');
INSERT INTO Faculty(FID, Lastname, Firstname, Email, Hiredate) VALUES(seq_fac.NEXTVAL, 'Levonsen', 'Jan', 'jlevonsen@test.com', '15 Oct 2007');
INSERT INTO Faculty(FID, Lastname, Firstname, Email, Hiredate) VALUES(seq_fac.NEXTVAL, 'California', 'Robert', 'rcalifornia@test.com', '6 Jul 2008');
--SELECT * FROM Faculty;

CREATE SEQUENCE seq_class;  -- allows PK to be auto-incremented
INSERT INTO Classes(CID, Subject, Catalognbr, Title) VALUES(seq_class.NEXTVAL, 'SDEV', 350, 'Database Security');
INSERT INTO Classes(CID, Subject, Catalognbr, Title) VALUES(seq_class.NEXTVAL, 'CMSC', 335, 'Game Design');
INSERT INTO Classes(CID, Subject, Catalognbr, Title) VALUES(seq_class.NEXTVAL, 'CMIS', 242, 'Intermediate Programming');
--SELECT * FROM Classes;

CREATE SEQUENCE seq_enroll;  -- allows PK to be auto-incremented
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 1, 2, 2);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 3, 2, 7);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 2, 1, 5);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 1, 2, 2);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 3, 1, 8);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 1, 3, 12);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 1, 1, 11);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 2, 2, 9);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 2, 1, 6);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 2, 2, 4);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 1, 2, 1);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 3, 2, 13);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 3, 1, 10);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 2, 3, 7);
INSERT INTO ClassEnrollments(EnID, CID, FID, EID) VALUES(seq_enroll.NEXTVAL, 1, 1, 15);
--SELECT * FROM ClassEnrollments;




/*
4. Write and test a set of SQL statements that will select all records from 
each table. The output should display the records in descending order 
by Primary key.
*/
SELECT * FROM Engineers ORDER BY EID DESC;
SELECT * FROM Faculty ORDER BY FID DESC;
SELECT * FROM Classes ORDER BY CID DESC;
SELECT * FROM ClassEnrollments ORDER BY EnID DESC;



/*
5. Write and test a set of SQL statements that will Update records with the 
following specifications
a. Update the Lastname of one faculty in the Faculty table to be “Friendship”.
b. Update the Firstname of one engineer in the Engineers table to be “Amadeus”.
c. Update the Subject of one class in the Classes table to be “IOT Cyber”.
*/
UPDATE Faculty SET Lastname = 'Friendship' WHERE FID = 3;
--SELECT * FROM Faculty;
UPDATE Engineers SET Firstname = 'Amadeus' WHERE EID = 7;
--SELECT * FROM Engineers;
UPDATE Classes SET Subject = 'IOT Cyber' WHERE CID = 1;
--SELECT * FROM Classes;



/*
6. Write and test a SQL statement that will Delete the ClassEnrollments 
record with the lowest EnID
*/
DELETE FROM ClassEnrollments WHERE EnID = (SELECT MIN(EnID) FROM ClassEnrollments);
--SELECT * FROM ClassEnrollments;




/*
7. Write and test a SQL statement that creates a view joining the required 
tables such that a user can retrieve the Engineer’s Lastname and Firstname, 
the Faculty Lastname and Email and the Classes’s Subject and Title for each 
Course enrollment.
*/
CREATE VIEW cool_view AS SELECT 
EnID, eng.Lastname AS Eng_Last, eng.Firstname AS Eng_First, fac.Lastname AS Fac_Lastname, fac.Email AS Fac_Email, Subject, Title
FROM ClassEnrollments, Engineers eng, Faculty fac, Classes
WHERE ClassEnrollments.EID=eng.EID
AND ClassEnrollments.FID=fac.FID
AND ClassEnrollments.CID=Classes.CID
ORDER BY EnID;
SELECT * FROM cool_view;











