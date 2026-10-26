-- What are completed-order metrics by customer region and order month?
-- INNER JOIN keeps matched customer orders; DISTINCT counts each customer once per region-month despite multiple orders.
SELECT c.region, o.order_month, COUNT(o.order_id) AS number_of_orders,
COUNT(DISTINCT o.customer_id) AS number_of_customers,
SUM(o.amount) AS total_revenue, AVG(o.amount) AS average_revenue
FROM orders AS o JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region, o.order_month ORDER BY c.region, o.order_month;
