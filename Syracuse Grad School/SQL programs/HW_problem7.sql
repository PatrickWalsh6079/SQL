USE tinyu
GO


-- QUESTION 1
-- Write an SQL Stored procedure called p_upsert_major, which, given a major_code (business key) and a major_name, 
-- does an Upsert, which is the following:
--      Checks if the major_code exists in the table already.
--      If yes, updates the table and makes the major_name match the new major name.
--      If no, inserts the new major_name and major_code into the table. HINT: major_id is not a surrogate key, so you 
--      will need to determine the next ID yourself in code!
-- Test your stored procedure by executing it to make these changes:
-- Change : CSC—Computer Sciences to CSC—Computer Science
-- Add: FIN—Finance

DROP PROCEDURE IF EXISTS p_upsert_major
GO
CREATE PROCEDURE p_upsert_major (
    @p_major_code VARCHAR(5),
    @p_major_name VARCHAR(50)
) AS
BEGIN
    DECLARE @v_major_id INT

    -- Check if major_code already exists
    IF EXISTS (SELECT major_id FROM majors WHERE major_code = @p_major_code)

        -- Update the existing row
        UPDATE majors
        SET major_name = @p_major_name
        WHERE major_code = @p_major_code
    ELSE
        -- Insert a new row
        INSERT INTO majors (major_id, major_code, major_name)
        VALUES ((SELECT COALESCE(MAX(major_id), 0) + 1 FROM majors), @p_major_code, @p_major_name)   
END;

SELECT * FROM majors
EXEC p_upsert_major @p_major_code='CSC', @p_major_name='Computer Science'
EXEC p_upsert_major @p_major_code='FIN', @p_major_name='Finance'
SELECT * FROM majors

-- DOWN CODE (reset table to beginning state)
DELETE FROM majors WHERE major_code='FIN'
UPDATE majors SET major_name='Computer Sciences' WHERE major_id=4



-- QUESTION 2
-- Write a user-defined function called f_concat that combines the any two varchars @a and @b together with  
-- a one-character @sep in between. 
-- For example:
-- SELECT dbo.f_concat('half','baked','-') -- 'half-baked'
-- SELECT dbo.f_concat('mike','fudge',' ') -- 'mike fudge'
-- Now create a view called v_students that displays the student_id, student name (first last), student name 
-- (last, first), GPA, and name of major. You should call the function you created in 2.a. After you create 
-- the view, execute it with a SELECT statement.

-- 2A
GO
DROP FUNCTION IF EXISTS f_concat
GO
CREATE FUNCTION f_concat(@a VARCHAR(100), @b VARCHAR(100), @sep CHAR(1))
RETURNS VARCHAR(201)
AS
BEGIN
    DECLARE @result VARCHAR(201);
    SET @result = CONCAT(@a, @sep, @b);
    RETURN @result;
END;

-- Test function to see if it works
GO
SELECT dbo.f_concat('half','baked','-');  -- Expected output: 'half-baked'
SELECT dbo.f_concat('mike','fudge',' ');  -- Expected output: 'mike fudge'

-- 2B
GO
DROP VIEW IF EXISTS v_students
GO
CREATE VIEW v_students AS
SELECT
    student_id,
    dbo.f_concat(student_firstname, student_lastname, ' ') AS student_name_first_last,
    dbo.f_concat(student_lastname, student_firstname, ', ') AS student_name_last_first,
    student_gpa,
    major_name
FROM
    students
JOIN
    majors ON students.student_major_id = majors.major_id;

-- Test view to see if it works
GO
SELECT * FROM v_students



-- QUESTION 3
-- Write a query on the majors table so that the major_name is broken up into keywords, one per row. 
-- HINT: You must use string_split() with cross-apply. 
 
-- Then use the query in 3.a to create a table-valued function f_search_majors that allows you to 
-- search the majors by keyword. Demonstrate calling the TVF by querying all majors with the “Science” keyword.

-- 3A
SELECT
    major_id,
    major_code,
    major_name,
    VALUE AS value
FROM
    majors
CROSS APPLY
    STRING_SPLIT(major_name, ' ');

-- 3B
GO
DROP FUNCTION IF EXISTS f_search_majors
GO
CREATE FUNCTION f_search_majors (@keyword VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT
        major_id,
        major_code,
        major_name,
        VALUE AS keyword
    FROM
        majors
    CROSS APPLY
        STRING_SPLIT(major_name, ' ')
    WHERE
        value = @keyword
);

-- Test function using 'Science' keyword
GO
SELECT * FROM f_search_majors('Science');



-- QUESTION 4
-- Alter the students table and add the following columns:
--      student_active char(1) default (‘Y’) not null
--      student_inactive_date date null 
-- Create a trigger on the students table: when there is an student_inactive_date set, set 
-- student_active to ‘N’, and whenever there is not a student_inactive_date, then student_active is set to ‘Y’.
-- Write SQL code to deactivate all the ‘Graduate’ students with a date of ‘2020-08-01’.
-- Write SQL code to reactivate all the ‘Graduate’ students.

-- 4A
GO
SELECT student_id, student_firstname, student_lastname, student_year_name FROM students

ALTER TABLE students
ADD student_active CHAR(1) 
    CONSTRAINT default_value DEFAULT 'Y' NOT NULL,
    student_inactive_date DATE NULL;

SELECT student_id, student_firstname, student_lastname, student_year_name, student_active, student_inactive_date FROM students

-- 4B
-- Create trigger
GO
DROP TRIGGER IF EXISTS tr_update_student_active
GO
CREATE TRIGGER tr_update_student_active
ON students
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE students
    SET students.student_active = CASE
                            WHEN students.student_inactive_date IS NOT NULL THEN 'N'
                            ELSE 'Y'
                        END
    FROM inserted
    WHERE students.student_id = inserted.student_id;
END;


-- 4C
GO
UPDATE students
SET student_inactive_date = '2020-08-01'
WHERE student_year_name = 'Graduate';
SELECT student_id, student_firstname, student_lastname, student_year_name, student_active, student_inactive_date FROM students


-- 4D
UPDATE students
SET student_inactive_date = NULL
WHERE student_year_name = 'Graduate';
SELECT student_id, student_firstname, student_lastname, student_year_name, student_active, student_inactive_date FROM students


-- DOWN SCRIPT (drop columns)
ALTER TABLE students
DROP CONSTRAINT IF EXISTS default_value
ALTER TABLE students
DROP COLUMN IF EXISTS student_active, student_inactive_date;