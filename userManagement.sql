-- Creates user profile with default settings:
CREATE PROFILE sdev350Classmates
LIMIT
FAILED_LOGIN_ATTEMPTS 10  --number of times a user can fail to login
PASSWORD_LIFE_TIME UNLIMITED  --number of days user can use password before it needs to be reset
PASSWORD_REUSE_TIME UNLIMITED  --number of days before password cannot be reused
PASSWORD_REUSE_MAX UNLIMITED  --number of times password must be changed before being able to reuse current password
PASSWORD_LOCK_TIME 1  --number of days account will be locked after failed login attempts reached
PASSWORD_GRACE_TIME 7  --number of days after the grace period begins during which a warning is issued and login is allowed
PASSWORD_VERIFY_FUNCTION null;  --sets up password complexity requirements
SELECT * FROM DBA_PROFILES  WHERE PROFILE = 'SDEV350CLASSMATES';
DROP PROFILE sdev350Classmates CASCADE;


-- Creates table space with default settings:
CREATE TABLESPACE sdev350TableSpace DATAFILE AUTOEXTEND ON MAXSIZE 500M;
SELECT FILE_NAME, BLOCKS, TABLESPACE_NAME FROM DBA_DATA_FILES;
DROP TABLESPACE sdev350TableSpace INCLUDING CONTENTS AND DATAFILES;


-- Creates user 1
CREATE USER classmate_1  --username
IDENTIFIED BY "SET PASSWORD HERE"   --password
DEFAULT TABLESPACE sdev350TableSpace  --tablespace user is assigned to
QUOTA 5M on Users  --max space on tablespace user is allowed to use
TEMPORARY TABLESPACE temp  --temporary tablespace for user to use
PROFILE sdev350Classmates  --user profile user is assigned to
PASSWORD EXPIRE;  --requires user to reset password upon login
GRANT CREATE SESSION TO classmate_1;  --must give permission for user to connect
SELECT USERNAME, LAST_LOGIN, EXPIRY_DATE FROM DBA_USERS WHERE USERNAME = 'CLASSMATE_1';
DROP USER classmate_1 CASCADE;

-- Creates user 2
CREATE USER classmate_2  --username
IDENTIFIED BY "SET PASSWORD HERE"   --password
DEFAULT TABLESPACE sdev350TableSpace  --tablespace user is assigned to
QUOTA 5M on Users  --max space on tablespace user is allowed to use
TEMPORARY TABLESPACE temp  --temporary tablespace for user to use
PROFILE sdev350Classmates  --user profile user is assigned to
PASSWORD EXPIRE;  --requires user to reset password upon login
GRANT CREATE SESSION TO classmate_2;  --must give permission for user to connect
SELECT USERNAME, LAST_LOGIN, EXPIRY_DATE FROM DBA_USERS WHERE USERNAME = 'CLASSMATE_2';
DROP USER classmate_2;

-- Creates user 3
CREATE USER classmate_3  --username
IDENTIFIED BY "SET PASSWORD HERE"   --password
DEFAULT TABLESPACE sdev350TableSpace  --tablespace user is assigned to
QUOTA 5M on Users  --max space on tablespace user is allowed to use
TEMPORARY TABLESPACE temp  --temporary tablespace for user to use
PROFILE sdev350Classmates  --user profile user is assigned to
PASSWORD EXPIRE;  --requires user to reset password upon login
GRANT CREATE SESSION TO classmate_3;  --must give permission for user to connect
SELECT USERNAME, LAST_LOGIN, EXPIRY_DATE FROM DBA_USERS WHERE USERNAME = 'CLASSMATE_3';
DROP USER classmate_3;

--Check to see all current users:
SELECT USERNAME, LAST_LOGIN, EXPIRY_DATE FROM DBA_USERS WHERE USERNAME LIKE 'CLASSMATE_%';

