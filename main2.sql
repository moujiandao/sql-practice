/* 2-6-2026 SQL scripting practice
Your task:

-- Sample data (imagine this is loaded)
CREATE TABLE store_items (
    sku VARCHAR(20),
    item_name VARCHAR(100),
    price DECIMAL(10,2),
    department VARCHAR(50),
    uploaded_at TIMESTAMP
);

-- 1. Find all SKUs that appear more than once
-- 2. For duplicates, keep only the most recent record
-- 3. Show how many duplicates you eliminated*/



-- 1.
select sku, count(*) as duplicateCount
from store_items
group by sku
having count(*) > 1


-- 2.
with rankedSkus as(
SELECT
sku,
item_name,
price,
department,
uploaded_at,
ROW_NUMBER() over (partition by sku order by uploaded_at desc) as skuRank)

select * from rankedSkus where skuRank = 1


-- 3.
WITH ranked_skus AS (
    SELECT
        sku,
        item_name,
        price,
        department,
        uploaded_at,
        ROW_NUMBER() OVER (PARTITION BY sku ORDER BY uploaded_at DESC) as sku_rank
    FROM store_items
)
SELECT 
    COUNT(*) as total_records,
    SUM(CASE WHEN sku_rank = 1 THEN 1 ELSE 0 END) as clean_records,
    SUM(CASE WHEN sku_rank > 1 THEN 1 ELSE 0 END) as eliminated_records,
    ROUND(100.0 * SUM(CASE WHEN sku_rank > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) as pct_duplicates
FROM ranked_skus;



/* Output:

total_records: 9
clean_records: 4
eliminated_records: 5
pct_duplicates: 55.56
*/