/*Highest Cost Orders - Find the total cost of each customer's orders. Output customer's id, first name, and the total order cost. Order records by customer's first name alphabetically.*/

SELECT customers.id, first_name, SUM(orders.total_order_cost) FROM customers
JOIN orders ON customers.id = orders.cust_id
GROUP BY customers.id, first_name
ORDER BY first_name;
