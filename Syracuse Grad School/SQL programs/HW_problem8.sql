USE tinyu
GO

-- Let’s rewrite this procedure to be transaction safe.
-- To be transaction safe, it must handle errors and exceptions to the data logic.
DROP PROCEDURE IF EXISTS [dbo].[p_upsert_major]
GO
CREATE PROCEDURE dbo.p_upsert_major(
    @major_code CHAR(3),
    @major_name VARCHAR(50)
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        -- data logic
        IF EXISTS (SELECT * FROM majors WHERE major_code = @major_code) BEGIN
            UPDATE majors SET major_name = @major_name
            WHERE major_code = @major_code
        END
        ELSE BEGIN
            DECLARE @id INT = (SELECT MAX(major_id) FROM majors) + 1
            INSERT INTO majors (major_id, major_code, major_name)
            VALUES(@id, @major_code, @major_name)
        END
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        ;
        THROW
    END CATCH
END


-- To handle custom data logic, we must consider the expected output of the procedure. 
-- How many rows should it affect upon success? Are there required values? In this 
-- case, we always expect one row to be affected by the upsert operation (either 
-- inserted or updated):
USE tinyu
GO
DROP PROCEDURE IF EXISTS dbo.p_upsert_major
GO
CREATE PROCEDURE dbo.p_upsert_major(
    @major_code CHAR(3),
    @major_name VARCHAR(50)
) AS BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        -- data logic
        IF EXISTS (SELECT * FROM majors WHERE major_code = @major_code) BEGIN
            UPDATE majors SET major_name = @major_name
            WHERE major_code = @major_code
            IF @@ROWCOUNT <> 1 THROW 50001, 'p_upsert_major: Update Error',1
        END
        ELSE BEGIN
            DECLARE @id INT = (SELECT MAX(major_id) FROM majors) + 1
            INSERT INTO majors (major_id, major_code, major_name)
            VALUES(@id, @major_code, @major_name)
            IF @@ROWCOUNT <> 1 THROW 50002, 'p_upsert_major: Update Error',1
        END
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW
    END CATCH
END


-- 1. Provide a screen shot of your code execution from the walkthrough where you 
-- modified p_upsert_major  in the TinyU database to be transaction safe.
-- DONE

-- 2. Provide a screen shot of examples of executing the p_upsert_major procedure 
-- to demonstrate it is transaction safe.
-- DONE

-- 3. Rewrite the p_place_bid stored procedure from the vBay database so that it is 
-- transaction safe. Provide a screen shot of the code and its execution.
USE vbay
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
DROP PROCEDURE IF EXISTS [dbo].[p_place_bid]
GO
create procedure [dbo].[p_place_bid]
(
	@bid_item_id int,
	@bid_user_id int,
	@bid_amount money
)
as
begin
    BEGIN TRY
        BEGIN TRANSACTION
            declare @max_bid_amount money
            declare @item_seller_user_id int
            declare @bid_status varchar(20)
            -- be optimistic :-)
            set @bid_status = 'ok'
            -- set @max_bid_amount to the higest bid amount for that item id 
            set @max_bid_amount = (select max(bid_amount) from vb_bids where bid_item_id=@bid_item_id and bid_status='ok') 
            -- set @item_seller_user_id to the seller_user_id for the item id
            set @item_seller_user_id = (select item_seller_user_id from vb_items where item_id=@bid_item_id) 
            -- if no bids then set the @max_bid_amount to the item_reserve amount for the item_id
            if (@max_bid_amount is null) 
                set @max_bid_amount = (select item_reserve from vb_items where item_id=@bid_item_id) 
            -- if you're the item seller, set bid status
            if ( @item_seller_user_id = @bid_user_id)
                set @bid_status = 'item_seller'
            -- if the current bid lower or equal to the last bid, set bid status
            if ( @bid_amount <= @max_bid_amount)
                set @bid_status = 'low_bid'  
            -- insert the bid at this point and return the bid_id 		
            insert into vb_bids (bid_user_id, bid_item_id, bid_amount, bid_status)
                values (@bid_user_id, @bid_item_id, @bid_amount, @bid_status)
        COMMIT
            return  @@identity
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW 
    END CATCH
end


-- 4. Execute your stored procedure in Step 3 to demonstrate the procedure works. 
-- Make User 2 bid $105 on Item 36 and show the bid was placed with a SELECT.
EXEC dbo.p_place_bid
    @bid_item_id = 36,
    @bid_user_id = 2,
    @bid_amount = 105.00

SELECT * FROM vb_bids WHERE bid_user_id = 2;
-- DELETE FROM vb_bids WHERE bid_user_id = 2


-- 5. Rewrite the p_rate_user stored procedure from the VBay database so that it is 
-- transaction safe. Provide a screen shot of the code and its execution.
DROP PROCEDURE IF EXISTS [dbo].[p_rate_user]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[p_rate_user]
(
	@rating_by_user_id int,
	@rating_for_user_id int,
	@rating_astype varchar(20),
	@rating_value int,
	@rating_comment text 
)
as
begin
    BEGIN TRY
        BEGIN TRANSACTION
            insert into vb_user_ratings (rating_by_user_id, rating_for_user_id, rating_astype, rating_value,rating_comment)
            values (@rating_by_user_id, @rating_for_user_id, @rating_astype, @rating_value, @rating_comment)
        COMMIT
            return @@identity 
    END TRY
    BEGIN CATCH
        ROLLBACK
        ;
        THROW 50001, 'p_rate_user: Update Error',1
    END CATCH
end
GO

-- 6. Execute the stored procedure in Step 5 to demonstrate the rollback works. You 
-- should give a six-star rating and then execute again where someone attempts to 
-- rate themselves. Produce a screen shot as evidence the rollback worked.
EXEC dbo.p_rate_user
    @rating_by_user_id = 1,
    @rating_for_user_id = 2,
    @rating_astype = 'Buyer',
    @rating_value = 6,
    @rating_comment = 'Great user!'

EXEC dbo.p_rate_user
    @rating_by_user_id = 2,
    @rating_for_user_id = 2,
    @rating_astype = 'Self-Rating',
    @rating_value = 5,
    @rating_comment = 'Good job!'


-- 7. There is a conceptual data requirement that says that no TinyU major can have 
-- more than 15 students in it. (I know, this seems silly, but think of the bigger 
-- problem—how do we enforce a specific minimum or maximum cardinality instead of 
-- just one or “many”?)  Write data logic using an instead-of trigger to do this.

-- Create a view to handle the insert and update operations
USE tinyu
GO

-- Create a view to handle the insert and update operations
-- DROP VIEW IF EXISTS v_students
-- GO
-- CREATE VIEW v_students
-- AS
-- SELECT *
-- FROM students;
-- GO

-- Create an instead-of trigger to enforce the data logic
DROP TRIGGER IF EXISTS trg_limit_major_students
GO
CREATE TRIGGER trg_limit_major_students
ON students
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    -- Check if the inserted/updated rows violate the data logic
    -- IF EXISTS (
    --     SELECT m.major_id
    --     FROM inserted i
    --     INNER JOIN majors m ON i.student_major_id = m.major_id
    --     GROUP BY m.major_id
    --     HAVING COUNT(*) > 15
    -- )
    BEGIN
        -- Perform the insert/update operation
        INSERT INTO students (student_firstname, student_lastname, student_year_name, student_major_id)
        SELECT student_firstname, student_lastname, student_year_name, student_major_id
        FROM students;
    END
    IF EXISTS (
        SELECT student_major_id
        FROM students
        GROUP BY student_major_id
        HAVING COUNT(*) > 15
    )
    BEGIN
        -- Raise an error if the data logic is violated
        RAISERROR ('A TinyU major cannot have more than 15 students.', 16, 1)
        ROLLBACK TRANSACTION
    END
    -- ELSE
    -- BEGIN
    --     -- Perform the insert/update operation
    --     INSERT INTO students (student_firstname, student_lastname, student_year_name, student_major_id)
    --     SELECT student_firstname, student_lastname, student_year_name, student_major_id
    --     FROM students;
    -- END
END;


-- SELECT * FROM v_students WHERE major_name = 'Applied Data Science'
SELECT * FROM students WHERE student_major_id = 2

-- 8. Test Step 7 by trying to add or update a student and change their major to ADS. 
-- The ADS major has 15 students already.  Your code should drop/create the trigger 
-- and also test the success and failure of the trigger.
INSERT INTO students (student_firstname, student_lastname, student_year_name, student_major_id, student_gpa)
VALUES ('John', 'Snow', 'Freshman', 2, 3.2);


DELETE FROM students WHERE student_id > 30