CREATE TABLE Semester (course_ID INT PRIMARY KEY,
                            course_name VARCHAR(50),
                            start_date DATE,
                            end_date DATE,
                            unit_cost INT);

INSERT INTO Semester(course_ID, course_name, start_date, end_date, unit_cost)
VALUES(001, 'Relational Database Theory', '14 Aug 2021', '10 Oct 2021', 1500);

INSERT INTO Semester(course_ID, course_name, start_date, end_date, unit_cost)
VALUES(2, 'Marine biology II', '15 Aug 2021', '15 Oct 2021', 1560);

INSERT INTO Semester(course_ID, course_name, start_date, end_date, unit_cost)
VALUES(3, 'Advanced Python Development', '19 Oct 2021', '15 Dec 2021', 1298);

INSERT INTO Semester(course_ID, course_name, start_date, end_date, unit_cost)
VALUES(4, 'Writing research grants', '19 Oct 2021', '15 Dec 2021', 1750);


SELECT * FROM Semester;