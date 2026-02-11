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





-- Meta: Recommendation System - You are given the list of Facebook friends and the list of Facebook pages that users follow. Your task is to create a new recommendation system for Facebook. For each Facebook user, find pages that this user doesn't follow but at least one of their friends does. Output the user ID and the ID of the page that should be recommended to this user.

select distinct f.user_id, f.friend_id, s.page_id
from users_friends as f JOIN users_pages as s ON f.friend_id = s.user_id
WHERE (f.user_id, s.page_id) NOT IN (

select user_id, page_id FROM users_pages 

);




-- 2-9-26 
-- Highest Cost Orders

-- Find the customers with the highest daily total order cost between 2019-02-01 and 2019-05-01. If a customer had more than one order on a certain day, sum the order costs on a daily basis. Output each customer's first name, total cost of their items, and the date. If multiple customers tie for the highest daily total on the same date, return all of them.

-- For simplicity, you can assume that every first name in the dataset is unique.

-- customers
-- id	first_name	last_name	city	address	phone_number
-- 8	John	Joseph	San Francisco		928-386-8164
-- 7	Jill	Michael	Austin		813-297-0692
-- 4	William	Daniel	Denver		813-368-1200
-- 5	Henry	Jackson	Miami		808-601-7513
-- 13	Emma	Isaac	Miami		808-690-5201

-- orders
-- id	cust_id	order_date	order_details	total_order_cost
-- 1	3	2019-03-04	Coat	100
-- 2	3	2019-03-01	Shoes	80
-- 3	3	2019-03-07	Skirt	30
-- 4	7	2019-02-01	Coat	25
-- 5	7	2019-03-10	Shoes	80


-- join the tables first (when to use left join or regular join for this problem?)
WITH total_daily_spending AS (
select first_name, order_date, SUM(total_order_cost) AS daily_order_cost 
from customers c join orders o on c.id = o.cust_id
WHERE order_date BETWEEN '2019-02-01' AND '2019-05-01'
GROUP BY order_date, first_name, last_name 
ORDER BY daily_order_cost desc
),

customer_rankings AS (
select first_name, daily_order_cost, order_date,
DENSE_RANK() OVER (ORDER BY daily_order_cost desc) AS customer_rank
from total_daily_spending
)

SELECT * FROM customer_rankings WHERE customer_rank = 1;





-- Users By Average Session Time
-- Calculate each user's average session time, where a session is defined as the time difference between a page_load and a page_exit. Assume each user has only one session per day. If there are multiple page_load or page_exit events on the same day, use only the latest page_load and the earliest page_exit. Only consider sessions where the page_load occurs before the page_exit on the same day. Output the user_id and their average session time.

-- facebook_web_log
-- user_id	timestamp	action
-- 0	2019-04-25 13:30:15	page_load
-- 0	2019-04-25 13:30:18	page_load
-- 0	2019-04-25 13:30:40	scroll_down
-- 0	2019-04-25 13:30:45	scroll_up
-- 0	2019-04-25 13:31:10	scroll_down

-- my attempted solution
WITH facebook_earliest_page_load AS (
SELECT user_id, action, date(timestamp) as date, max(timestamp) AS latest_page_load
from facebook_web_log 
where action = 'page_load'
group by date(timestamp), user_id, action),

facebook_latest_page_exit AS (
SELECT user_id, action, date(timestamp) as date, min(timestamp) AS earliest_page_exit
from facebook_web_log 
where action = 'page_exit'
group by date(timestamp), user_id, action)

SELECT pl.user_id, avg(pe.earliest_page_exit - pl.latest_page_load) as avg_session_duration FROM facebook_earliest_page_load pl JOIN facebook_latest_page_exit pe ON 
pl.date = pe.date AND pl.user_id = pe.user_id -- need to join on both id and date
WHERE earliest_page_exit > latest_page_load
GROUP BY pl.user_id -- we only group by user_id and do not group by date to get the average among all the dates.


-- the optimal solution that scans the table once
WITH daily_sessions AS (
    SELECT 
        user_id,
        DATE(timestamp) as date,
        MAX(CASE WHEN action = 'page_load' THEN timestamp END) as latest_load,
        MIN(CASE WHEN action = 'page_exit' THEN timestamp END) as earliest_exit
    FROM facebook_web_log
    GROUP BY user_id, DATE(timestamp)
)
SELECT 
    user_id,
    AVG(earliest_exit - latest_load) as avg_session_time
FROM daily_sessions
WHERE earliest_exit > latest_load
GROUP BY user_id
ORDER BY avg_session_time DESC;


-- Find the total number of available beds per hosts' nationality

-- Output the nationality along with the corresponding total number of available beds.
-- Sort records by the total available beds in descending order.

-- airbnb_apartments
-- host_id	apartment_id	apartment_type	n_beds	n_bedrooms	country	city
-- 0	A1	Room	1	1	USA	New York
-- 0	A2	Room	1	1	USA	New Jersey
-- 0	A3	Room	1	1	USA	New Jersey
-- 1	A4	Apartment	2	1	USA	Houston

-- airbnb_hosts
-- host_id	nationality	gender	age
-- 0	USA	M	28
-- 1	USA	F	29
-- 2	China	F	31
-- 3	China	M	24
-- 4	Mali	M	30


-- join the tables first
-- aggregate the sum of n_beds
-- group by nationality
-- order by n_beds desc
select ah.nationality, SUM(aa.n_beds) as total_available_beds
from airbnb_hosts ah join airbnb_apartments aa on ah.host_id = aa.host_id
group by ah.nationality
order by total_available_beds desc; -- can reference alias @ or past groupby clause




-- Ranking Hosts by total_available_beds
-- Rank each host based on the number of beds they have listed. The host with the most beds should be ranked 1 and the host with the least number of beds should be ranked last. Hosts that have the same number of beds should have the same rank but there should be no gaps between ranking values. A host can also own multiple properties.
-- Output the host ID, number of beds, and rank from highest rank to lowest.

-- host_id	apartment_id	apartment_type	n_beds	n_bedrooms	country	city
-- 0	A1	Room	1	1	USA	New York
-- 0	A2	Room	1	1	USA	New Jersey
-- 0	A3	Room	1	1	USA	New Jersey
-- 1	A4	Apartment	2	1	USA	Houston
-- 1	A5	Apartment	2	1	USA	Las Vegas
-- 2	A6	Yurt	3	1	Mongolia	-
-- 3	A7	Penthouse	3	3	China	Tianjin
-- 3	A8	Penthouse	5	5	China	Beijing


-- denserank window function
with rankings_table as (
select host_id, sum(n_beds) as total_beds,
dense_rank() OVER (ORDER BY sum(n_beds) desc) as host_rank
from airbnb_apartments
group by host_id
)

-- select * from rankings_table order by host_rank desc;
select * from rankings_table order by host_rank asc



-- Top Posts per Channel
-- Identify the top 3 posts with the highest like counts for each channel. Assign a rank to each post based on its like count, allowing for gaps in ranking when posts have the same number of likes. For example, if two posts tie for 1st place, the next post should be ranked 3rd, not 2nd. Exclude any posts with zero likes.

-- The output should display the channel name, post ID, post creation date, and the like count for each post. Because there could be ties in rankings, your output could have more than 3 rows for each channel.

-- posts
-- post_id	channel_id	created_at	likes	shares	comments
-- 101	1	2024-08-16	0	10	7
-- 102	1	2024-08-07	0	18	6
-- 103	1	2024-07-24	11	3	7

-- channels
-- channel_id	channel_name	channel_type
-- 1	TechNews	news
-- 2	GameStream	gaming
-- 3	SocialBuzz	social_media


-- -- join the tables
-- -- use rank()
-- -- where posts.likes > 0


with posts_rankings as (select
c.channel_name,
p.post_id,
p.created_at,
p.likes,
rank() over ( partition by c.channel_name order by p.likes desc ) as post_rank
from posts p join channels c on p.channel_id = c.channel_id
where p.likes > 0
order by c.channel_name
)

select * from posts_rankings where post_rank in (1,2,3) order by channel_name, post_rank
