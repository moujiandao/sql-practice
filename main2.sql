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
SELECT -- Using SUM(CASE WHEN ...) is like using a pivot table to summarize data
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



-- 2-9-2026 SQL scripting practice

-- Insert with realistic grocery inventory levels
INSERT INTO store_products VALUES
-- Valid codes with varying stock levels
('SKU001', 'Organic Bananas', 'PRO', 1.29, 156, true),
('SKU002', 'Chicken Breast', 'MEA', 8.99, 42, true),
('SKU003', 'Whole Milk 1gal', 'DAI', 4.49, 88, true),
('SKU004', 'Sourdough Bread', 'BAK', 5.99, 24, true),
('SKU005', 'Frozen Pizza', 'FRZ', 7.99, 0, false),  -- Out of stock, inactive
('SKU006', 'Pasta Penne', 'DRY', 2.49, 234, true),
-- NULL dept_codes (data quality issues)
('SKU007', 'Mystery Item A', NULL, 3.99, 15, true),
('SKU008', 'Unknown Product', NULL, 12.50, 3, true),
-- Invalid/Unknown codes
('SKU009', 'Weird Product', 'XYZ', 6.75, 8, true),
('SKU010', 'Old Item', 'OBS', 4.25, 2, false),
('SKU011', 'Legacy SKU', 'DEL', 8.00, 12, true),
-- More valid ones
('SKU012', 'Apples Gala', 'PRO', 2.99, 203, true),
('SKU013', 'Ground Beef 80/20', 'MEA', 6.99, 67, true),
('SKU014', 'Cheddar Cheese', 'DAI', 5.49, 45, true),
('SKU015', 'Croissants 6pk', 'BAK', 4.99, 18, true);

SELECT * FROM store_products;

/*
Your task:

Map dept_codes to Vori categories (Produce, Protein, Dairy, Bakery, Frozen, Pantry)
Create an "Uncategorized" bucket for NULL/unknown dept_codes
Show product count and total inventory value (price * qty_on_hand) by Vori category
List all unmapped dept_codes with their counts and inventory values for investigation

Skills tested: CASE statements, COALESCE, GROUP BY, NULL handling, calculated fields
*/


WITH category_summary AS (

SELECT sku, product_name, dept_code, price, is_active, qty_on_hand,

CASE dept_code
WHEN 'PRO' THEN 'Produce'
WHEN 'MEA' THEN 'Protein'
WHEN 'DAI' THEN 'Dairy'
WHEN 'BAK' THEN 'Bakery'
WHEN 'FRZ' THEN 'Frozen'
WHEN 'DRY' THEN 'Pantry'
ELSE 'Uncategorized'
END AS food_category,
COALESCE(price * qty_on_hand, 0) AS inventory_value
FROM store_products
)

SELECT food_category, COUNT(*) AS product_count, SUM(inventory_value) AS total_inventory_value FROM category_summary GROUP BY food_category ORDER BY total_inventory_value DESC;



