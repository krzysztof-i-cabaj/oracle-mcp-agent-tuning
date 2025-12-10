-- Scenario: Slow queries for optimization

-- 1. Full Table Scan on Orders (search by date using a function)
-- Problem: Function usage on the column prevents standard index usage
SELECT /*+ MONITOR */ * FROM demo_orders 
WHERE TO_CHAR(order_date, 'YYYY-MM') = '2022-05';

-- 2. Join without index on FK
-- Problem: Missing index on Foreign Key causes full scans during joins
SELECT /*+ MONITOR */ c.last_name, count(o.order_id)
FROM demo_customers c
JOIN demo_orders o ON c.customer_id = o.customer_id
WHERE c.segment = 'VIP'
GROUP BY c.last_name;

-- 3. Sorting large amounts of data
-- Problem: High PGA usage for sorting without index support
SELECT * FROM demo_order_items 
ORDER BY unit_price DESC 
FETCH FIRST 100 ROWS ONLY;