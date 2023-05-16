GO
SELECT * FROM vb_items;
SELECT * FROM vb_bids;

-- join tables on bid_id=item_id
SELECT * FROM vb_items JOIN vb_bids ON item_id=bid_id;
SELECT * FROM vb_items JOIN vb_bids ON item_id=bid_id WHERE bid_status = 'ok';

-- use GROUP BY and ORDER BY along with aliases
SELECT item_name, 
        item_reserve, 
        min(bid_amount) AS min_bid,
        max(bid_amount) AS max_bid,
        item_soldamount
FROM vb_items
JOIN vb_bids ON item_id=bid_id
WHERE bid_status = 'ok'
GROUP BY item_name, item_reserve, item_soldamount
ORDER BY item_reserve DESC;

-- vBay! would like to classify their users based on the numbers of valid bids they have placed. 
-- Low Activity = 0 or 1 bids
-- Moderate Activity = 2 to 4 bids
-- High Activity = 5 or more bids
SELECT s.user_email, s.user_firstname, s.user_lastname, COUNT(*) as bid_counts
FROM vb_users s 
LEFT JOIN vb_bids b ON b.bid_user_id=s.user_id
WHERE b.bid_status = 'ok'
GROUP BY s.user_email, s.user_firstname, s.user_lastname;

-- expand upon query to include bid activity bins
SELECT s.user_email, s.user_firstname, s.user_lastname, COUNT(*) as bid_counts,
CASE 
    WHEN COUNT(*) BETWEEN 0 AND 1 THEN 'Low'
    WHEN COUNT(*) BETWEEN 2 AND 4 THEN 'Moderate'
    ELSE 'High' END AS user_bid_activity
FROM vb_users s 
LEFT JOIN vb_bids b ON b.bid_user_id=s.user_id
WHERE b.bid_status = 'ok'
GROUP BY s.user_email, s.user_firstname, s.user_lastname;

-- now take last query and put into WITH clause
WITH user_bids AS (
SELECT s.user_email, s.user_firstname, s.user_lastname, COUNT(*) as bid_counts,
CASE 
    WHEN COUNT(*) BETWEEN 0 AND 1 THEN 'Low'
    WHEN COUNT(*) BETWEEN 2 AND 4 THEN 'Moderate'
    ELSE 'High' END AS user_bid_activity
FROM vb_users s 
LEFT JOIN vb_bids b ON b.bid_user_id=s.user_id
WHERE b.bid_status = 'ok'
GROUP BY s.user_email, s.user_firstname, s.user_lastname)

SELECT * FROM user_bids;

-- now take last query and use GROUP BY and ORDER BY to filter results
WITH user_bids AS (
SELECT s.user_email, s.user_firstname, s.user_lastname, COUNT(*) as bid_counts,
CASE 
    WHEN COUNT(*) BETWEEN 0 AND 1 THEN 'Low'
    WHEN COUNT(*) BETWEEN 2 AND 4 THEN 'Moderate'
    ELSE 'High' END AS user_bid_activity
FROM vb_users s 
LEFT JOIN vb_bids b ON b.bid_user_id=s.user_id
WHERE b.bid_status = 'ok'
GROUP BY s.user_email, s.user_firstname, s.user_lastname)

SELECT user_bid_activity, COUNT(*) as user_count
FROM user_bids
GROUP BY user_bid_activity
ORDER BY user_count;


-- new query from vb_items table
SELECT item_name, item_type, item_reserve, item_soldamount
FROM vb_items
WHERE item_type = 'Collectables'
ORDER BY item_name;

-- QUESTION 1 
-- How many item types are there? Perform an analysis of each item type.
-- For each item type, provide the count of items in that type and the 
-- minimum, average, and maximum item reserve prices for that type. 
-- Sort the output by item type.
SELECT COUNT(DISTINCT item_type) AS [Number of Item Types]
FROM vb_items;


SELECT item_type, 
COUNT(item_name) AS [Number of Items],
min(item_reserve) AS [Min Reserve Price],
max(item_reserve) AS [Max Reserve Price],
avg(item_reserve) AS [Avg Reserve Price]
FROM vb_items
GROUP BY item_type
ORDER BY item_type;


-- QUESTION 2
-- Perform an analysis of each item in the “Antiques” and “Collectables” item types. 
-- For each item, display the name, item type, and item reserve. Include the minimum, 
-- maximum, and average item reserve over each item type so that the current item 
-- reserve can be compared to these values.
WITH item_counts AS (
SELECT  item_type,
        min(item_reserve) AS [Min Reserve Price],
        max(item_reserve) AS [Max Reserve Price],
        avg(item_reserve) AS [Avg Reserve Price]
FROM vb_items
WHERE item_type = 'Antiques' OR item_type = 'Collectables'
GROUP BY item_type)

SELECT v.item_name, 
        v.item_type, 
        v.item_reserve, 
        i.[Min Reserve Price],
        i.[Max Reserve Price],
        i.[Avg Reserve Price]
FROM vb_items v
JOIN item_counts i ON v.item_type=i.item_type
ORDER BY v.item_name;


-- QUESTION 3
-- Write a query to include the names, counts (number of ratings), and average seller 
-- ratings (as a decimal) of users. For reference, User Carrie Dababbi has four seller 
-- ratings and an average rating of 4.75. 
SELECT user_firstname, 
        user_lastname,
        COUNT(rating_for_user_id) AS [Number of Ratings],
        avg(CAST(rating_value AS DECIMAL(3,2))) AS [Avg Seller Rating]
FROM vb_users
JOIN vb_user_ratings ON user_id=rating_for_user_id
WHERE rating_astype='Seller'
GROUP BY user_firstname, user_lastname
ORDER BY user_firstname;


-- QUESTION 4
-- Create a list of “Collectable” item types with more than one bid. Include the 
-- name of the item and the number of bids, making sure the item with the most bids appear first.
SELECT item_name, COUNT(b.bid_item_id) AS [Number of bids]
FROM vb_items AS i
INNER JOIN vb_bids AS b ON i.item_id=b.bid_item_id
WHERE item_type = 'Collectables'
GROUP BY item_name
HAVING COUNT(*) > 1
ORDER BY [Number of bids] DESC;


-- QUESTION 5
-- Generate a valid bidding history for any given item of your choice. 
-- Display the item ID, item name, a number representing the order the 
-- bid was placed, the bid amount, and the bidder’s name.
WITH bidders AS (
    SELECT user_id, user_firstname + ' ' + user_lastname AS bidder
    FROM vb_users
)

SELECT i.item_id, 
        i.item_name, 
        -- b.bid_id,
        RANK() OVER (
            PARTITION BY item_name
            ORDER BY b.bid_amount) AS bid_order,
        b.bid_amount, 
        bidder
FROM vb_items AS i
INNER JOIN vb_bids AS b ON i.item_id=b.bid_item_id
INNER JOIN bidders ON b.bid_user_id=bidders.user_id
WHERE bid_status = 'ok';



-- QUESTION 6
-- Rewrite your query in the previous question to include the names of the next and previous bidders
WITH bidders AS (
    SELECT user_id, user_firstname + ' ' + user_lastname AS bidder
    FROM vb_users
)

SELECT i.item_id, 
        i.item_name, 
        -- b.bid_id,
        RANK() OVER (
            PARTITION BY item_name
            ORDER BY b.bid_amount) AS bid_order,
        b.bid_amount, 
        bidder,
        LAG(bidder) OVER (
            PARTITION BY item_name
            ORDER BY b.bid_amount) AS previous_bidder,
        LEAD(bidder) OVER (
            PARTITION BY item_name
            ORDER BY b.bid_amount) AS next_bidder
FROM vb_items AS i
INNER JOIN vb_bids AS b ON i.item_id=b.bid_item_id
INNER JOIN bidders ON b.bid_user_id=bidders.user_id
WHERE bid_status = 'ok';



-- QUESTION 7
-- Find the names and emails of the users who give out the worst ratings (lower 
-- than the overall average rating) to either buyers or sellers (no need to 
-- differentiate whether the user rated a buyer or seller), and include only those 
-- users who have submitted more than one rating.
SELECT u.user_id,
        u.user_firstname + ' ' + u.user_lastname AS username,
        u.user_email,
        r.rating_value,
        COUNT(*) OVER (PARTITION BY r.rating_by_user_id) AS occurs
FROM vb_users u
JOIN vb_user_ratings r ON u.user_id=r.rating_by_user_id
WHERE rating_value < (SELECT avg(CAST(rating_value AS DECIMAL)) AS avg_rating FROM vb_user_ratings)
ORDER BY occurs DESC

WITH multiratings AS(
    SELECT
    COUNT(*) OVER (PARTITION BY rating_by_user_id) AS occurs
    FROM vb_user_ratings
)
SELECT * FROM multiratings;



-- QUESTION 8
-- Produce a report of the KPI (key performance indicator) user bids per item. 
-- Show the user’s name and email, total number of valid bids, total count of items 
-- bid upon, and then the ratio of bids to items. As a check, Anne Dewey’s bids per 
-- item ratio is 1.666666.
WITH bids_per_item AS (
    SELECT u.user_firstname + ' ' + u.user_lastname AS bidder_name,
            u.user_email,
            COUNT(DISTINCT b.bid_item_id) AS item_count,
            COUNT(*) AS total_bids
    FROM vb_bids AS b
    JOIN vb_users AS u ON b.bid_user_id = u.user_id
    WHERE b.bid_status = 'ok'
    GROUP BY
        u.user_firstname,
        u.user_lastname,
        u.user_email
)
SELECT bidder_name,
        user_email,
        total_bids,
        item_count,
        CAST(total_bids AS DECIMAL) / CAST(item_count AS DECIMAL) AS bids_per_item_ratio
FROM bids_per_item;


-- QUESTION 9
-- Among items not sold, show highest bidder name and the highest bid for each item. 
-- Make sure to include only valid bids.
SELECT
    i.item_id,
    i.item_name,
    b.bid_amount AS highest_bid,
    u.user_firstname AS bidder_firstname,
    u.user_lastname AS bidder_lastname
FROM
    vb_items i
LEFT JOIN (
    SELECT
        bid_item_id,
        MAX(bid_amount) AS bid_amount,
        bid_user_id
    FROM
        vb_bids
    WHERE
        bid_status = 'ok'
    GROUP BY
        bid_item_id, bid_user_id
) b ON i.item_id = b.bid_item_id
LEFT JOIN vb_users u ON b.bid_user_id = u.user_id
WHERE
    i.item_sold = 0;



-- QUESTION 10
-- Write a query with output similar to Question 3, but also includes the overall average 
-- seller rating and the difference between each user’s average rating and the overall 
-- average. For reference, the overall average seller rating should be 3.2.
WITH overall_avg AS (
  SELECT avg(CAST(rating_value AS DECIMAL(3,2))) AS overall_avg_rating
  FROM vb_user_ratings
  WHERE rating_astype='Seller'
)
SELECT user_firstname,
    user_lastname,
    COUNT(rating_for_user_id) AS [Number of Ratings],
    avg(CAST(rating_value AS DECIMAL(3,2))) AS [Avg Seller Rating],
    overall_avg.overall_avg_rating AS [Overall Avg Seller Rating],
    avg(CAST(rating_value AS DECIMAL(3,2))) - overall_avg.overall_avg_rating AS [Rating Difference]
FROM vb_users
  JOIN vb_user_ratings ON user_id=rating_for_user_id
  CROSS JOIN overall_avg
WHERE
  rating_astype='Seller'
GROUP BY
  user_firstname,
  user_lastname,
  overall_avg.overall_avg_rating
ORDER BY user_firstname;

