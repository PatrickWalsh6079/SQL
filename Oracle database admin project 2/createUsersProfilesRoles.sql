-------------------------------------------------------------------------------------------------------------------------------------
/*
1. Create a unique Profile based on the following requirements:
a. Password complexity should meet requirements for Ora12 Verify function.
b. User may have up to 3 concurrent sessions.
c. User may have up to 4 consecutive failed attempts to log in before the account is locked.
d. User may wait up till 120 days before their password must be changed. 
e. User account will be locked for 1 hours after the specified number of consecutive failed login attempts.
f. Default values for other Profile parameters is acceptable.
g. You should name the Profile PFirstnameLastname where Lastname and Firstname are your First and Lastname.
*/
CREATE PROFILE PPatrickWalsh
LIMIT
PASSWORD_VERIFY_FUNCTION ora12c_verify_function  --sets up password complexity requirements
SESSIONS_PER_USER 3  --number of concurrent sessions allowed per user
FAILED_LOGIN_ATTEMPTS 4  --number of times a user can fail to login
PASSWORD_LIFE_TIME 120  --number of days user can use password before it needs to be reset
PASSWORD_LOCK_TIME 1/24;  --number of days account will be locked after failed login attempts reached
--DROP PROFILE PPatrickWalsh CASCADE;  --delete profile
-------------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------------
/*
2. Verify your Profile was successfully created by Creating and executing a SQL statement querying the appropriate Data Dictionaryobjects.
*/
SELECT * FROM DBA_PROFILES  WHERE PROFILE = 'PPATRICKWALSH';
-------------------------------------------------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------------------------------------------------
/*
3. Create 2 users assign them to the Permanent Tablespace of Users with a Quota of 30M. 
Assign the new users the Profile you established in Step 1 of this lab. 
Be sure to expire their passwords upon creation. 
Name the users as follows:
a. U1FirstnameLastname
b. U2FirstnameLastname Where Firstname and Lastname are your first and lastname.
*/
CREATE USER U1PatrickWalsh  --username
IDENTIFIED BY "TestPass123!"   --password
DEFAULT TABLESPACE Users  --tablespace user is assigned to
QUOTA 30M on Users  --max space on tablespace user is allowed to use
PROFILE PPatrickWalsh  --user profile user is assigned to
PASSWORD EXPIRE  --requires user to reset password upon login
TEMPORARY TABLESPACE temp;  --temporary tablespace for user to use

SELECT USERNAME, LAST_LOGIN, EXPIRY_DATE FROM DBA_USERS WHERE USERNAME = 'U1PATRICKWALSH';
--DROP USER U1PatrickWalsh CASCADE;  --delete user

CREATE USER U2PatrickWalsh  --username
IDENTIFIED BY "TestPass123!"   --password
DEFAULT TABLESPACE Users  --tablespace user is assigned to
QUOTA 30M on Users  --max space on tablespace user is allowed to use
PROFILE PPatrickWalsh  --user profile user is assigned to
PASSWORD EXPIRE  --requires user to reset password upon login
TEMPORARY TABLESPACE temp;  --temporary tablespace for user to use

SELECT USERNAME, LAST_LOGIN, EXPIRY_DATE FROM DBA_USERS WHERE USERNAME = 'U2PATRICKWALSH';
--DROP USER U2PatrickWalsh CASCADE;  --delete user
-------------------------------------------------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------------------------------------------------
/*
4. Create a role allowing users assigned to be able to connect to the database and create tables. 
Name this R1FirstnameLastname where Firstname and Lastname are your first and lastname.
*/
CREATE ROLE R1PatrickWalsh;
GRANT CREATE SESSION TO R1PatrickWalsh;  --Role allows user to connect to database
GRANT CREATE TABLE TO R1PatrickWalsh;  --Role allows user to creat tables
--DROP ROLE R1PatrickWalsh;  --delete role
-------------------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------------------
/*
5. Create two tables in your (root/admin) schema. Name them User1Data and User2Data. 
The tables should contain a primary key and 3 additional columns of your choice. 
Insert 3 records into each table.
*/
CREATE TABLE admin.User1Data (
    studentID INT PRIMARY KEY,
    firstName VARCHAR2(30),
    lastName VARCHAR2(30),
    major VARCHAR2(30)
);
CREATE TABLE admin.User2Data (
    studentID INT PRIMARY KEY,
    firstName VARCHAR2(30),
    lastName VARCHAR2(30),
    major VARCHAR2(30)
);

INSERT INTO admin.User1Data(studentID, firstName, lastName, major) VALUES(1, 'Mike', 'Magic', 'Dance');
INSERT INTO admin.User1Data(studentID, firstName, lastName, major) VALUES(2, 'Napolean', 'Dynamite', 'Ligerology');
INSERT INTO admin.User1Data(studentID, firstName, lastName, major) VALUES(3, 'Harry', 'Potter', 'Wizardry');

INSERT INTO admin.User2Data(studentID, firstName, lastName, major) VALUES(1, 'William', 'Gates', 'Windowsology');
INSERT INTO admin.User2Data(studentID, firstName, lastName, major) VALUES(2, 'Steven', 'Jobs', 'Pomology');
INSERT INTO admin.User2Data(studentID, firstName, lastName, major) VALUES(3, 'Mark', 'Zuckerburg', 'Data Mining');

SELECT * FROM admin.User1Data;
SELECT * FROM admin.User2Data;
--DROP TABLE admin.User1Data;
--DROP TABLE admin.User2Data;
-------------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------------
/*
6. Provide privileges for U1FirstnameLastname and U2FirstnameLastname to be able to connect to the database and create tables. 
Be sure to use security best practices when assigning these privileges. 
In addition, provide one user the privileges to select from User1Data and Insert into User1Data. 
Provide the other user the privileges to select from User1Data and User2Data.
*/
GRANT R1PatrickWalsh TO U1PatrickWalsh;  --assigns R1PatrickWalsh role to user U1PatrickWalsh
GRANT R1PatrickWalsh TO U2PatrickWalsh;  --assigns R1PatrickWalsh role to user U2PatrickWalsh
GRANT SELECT ON User1Data TO R1PatrickWalsh;  --allows users with role R1PatrickWalsh to SELECT on User1Data table

CREATE ROLE InsertIntoUser1Data;  --create new role
GRANT InsertIntoUser1Data TO U1PatrickWalsh;  --assign role to U1PatrickWalsh
GRANT INSERT ON User1Data TO InsertIntoUser1Data;  --give role privilege to INSERT INTO the User1Data table 
--DROP ROLE InsertIntoUser1Data;  --delete role

CREATE ROLE SelectFromUser2Data;  --create new role
GRANT SelectFromUser2Data TO U2PatrickWalsh;  --assign role to U1PatrickWalsh
GRANT SELECT ON User2Data TO SelectFromUser2Data;  --give role privilege to INSERT INTO the User1Data table 
--DROP ROLE SelectFromUser2Data;  --delete role
-------------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------------
/*
7. Prepare and execute a detailed test plan to verify the two users have all the privileges they need but no additional privileges. 
Be sure to test by logging in as those users, changing their passwords, connecting, creating table and then using the 
assigned privileges in the User1Data and User2Data tables and performing and documenting other tests as required. 
*/
-- LOGOUT FROM ADMIN USER BEFORE PROCEEDING

-- MUST FIRST LOGIN AS U1PatrickWalsh BEFORE EXECUTING STATEMENTS

-- Execute this statement to ensure you are logged in with U1PatrickWalsh and make sure user has correct privileges:
SELECT * FROM USER_ROLE_PRIVS;  --see which roles have been granted to the user

-- Now try to query from each of the tables. U1PatrickWalsh should be able to query User1Data but NOT User2Data:
SELECT * FROM admin.User1Data;  --query User1Data table as U1PatrickWalsh user
SELECT * FROM admin.User2Data;  --query User2Data table as U1PatrickWalsh user

-- Now try to insert data into each table. U1PatrickWalsh should be able to insert into User1Data but NOT User2Data:
INSERT INTO admin.User1Data(studentID, firstName, lastName, major) VALUES(4, 'Donald', 'Duck', 'Anger Management');
INSERT INTO admin.User2Data(studentID, firstName, lastName, major) VALUES(4, 'Sean', 'Parker', 'Entrepreneur Studies');

COMMIT;  --run to ensure SQL statements are completed



-- LOGOUT OF U1PatrickWalsh AND LOGIN AS U2PatrickWalsh BEFORE EXECUTING NEXT STATEMENTS



-- Execute this statement to ensure you are logged in with U2PatrickWalsh and make sure user has correct privileges:
SELECT * FROM USER_ROLE_PRIVS;  --see which roles have been granted to the user

-- Now try to query from each of the tables. U2PatrickWalsh should be able to query User1Data AND User2Data:
SELECT * FROM admin.User1Data;  --query User1Data table as U2PatrickWalsh user
SELECT * FROM admin.User2Data;  --query User2Data table as U2PatrickWalsh user

-- Now try to insert data into each table. U2PatrickWalsh should NOT be able to insert into User1Data or User2Data:
INSERT INTO admin.User1Data(studentID, firstName, lastName, major) VALUES(5, 'Mickey', 'Mouse', 'Business Admin');
INSERT INTO admin.User2Data(studentID, firstName, lastName, major) VALUES(4, 'Sean', 'Parker', 'Entrepreneur Studies');


                                        -- END OF LAB --
-------------------------------------------------------------------------------------------------------------------------------------




--LOG BACK IN WITH ADMIN USER FIRST

-- Drop statements to reset exercise:
DROP PROFILE PPatrickWalsh CASCADE;  --delete profile
DROP USER U1PatrickWalsh CASCADE;  --delete user
DROP USER U2PatrickWalsh CASCADE;  --delete user
DROP ROLE R1PatrickWalsh;  --delete role
DROP TABLE admin.User1Data;  --delete table
DROP TABLE admin.User2Data;  --delete table
DROP ROLE InsertIntoUser1Data;  --delete role
DROP ROLE SelectFromUser2Data;  --delete role

