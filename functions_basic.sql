SELECT * FROM Movie; -- show whole Movie table

SELECT movie_title AS "Title", release_date AS "Date", running_length AS "Runtime"
FROM Movie
WHERE release_date in (SELECT MIN(release_date) FROM Movie)
FETCH NEXT 1 ROW ONLY; -- show earliest release date

SELECT COUNT(*) AS "Copies of Movie"
FROM Movie
WHERE release_date in (SELECT MIN(release_date) FROM Movie); -- show how many copies of this movie

SELECT MIN(running_length) AS "Shortest runtime", MAX(running_length) AS "Longest runtime", ROUND(AVG(running_length), 2) AS "Average"
FROM Movie;  -- show runtime minumum, maximum, and average for all movies