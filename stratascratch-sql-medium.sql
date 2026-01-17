/*Identify returning active users by finding users who made a second purchase within 1 to 7 days after their first purchase. Ignore same-day purchases. Output a list of these user_ids.

**COLUMNS**
created_at (date)
id (bigint)
item (text)
revenue (bigint)
user_id (bigint)

*/

-- use sliding rows between preceding and following WINDOWS function.
-- compartmentalize windows function result in a table, create a select statement that references from the table with a filter.
-- Unfortunately this solution is incorrect because it accounts for rows instead of dates. Multiple rows can technically be on the same date.

WITH SecondPurchasesTable AS (
    select user_id,
    COUNT(user_id) OVER (
        PARTITION BY user_id
        ORDER BY id
        ROWS BETWEEN 1 FOLLOWING AND 7 FOLLOWING
    ) as made_second_purchase_7days
    FROM amazon_transactions
) SELECT DISTINCT(user_id) FROM SecondPurchasesTable WHERE made_second_purchase_7days >= 2;




-- This problem requires date arithmetic so we must rewrite our sql
-- Create two tables for reference. Use the help of MIN to quickly grab the first purchase for firstPurchases
-- Ensure you include date arithmetic comparing the first purchase to the second purchase. 
-- Ensure you include logic to NOT count same day purchases

WITH firstPurchases AS (
	select user_id, MIN(created_at) as firstPurchaseDate
	FROM amazon_transactions
	GROUP BY user_id
)

secondPurchases7days AS (
	select s.user_id
	FROM amazon_transactions s JOIN firstPurchases f ON s.user_id = f.user_id
	WHERE s.created_at <= f.created_at + INTERVAL '7 days'
	AND s.created_at > f.created_at -- do not count same day purchases
)

SELECT DISTINCT(user_id) FROM secondPurchases7days