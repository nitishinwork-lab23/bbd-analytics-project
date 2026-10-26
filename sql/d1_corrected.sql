-- Which regions generated more than INR 80,000 in completed-order revenue?
SELECT c.region, SUM(o.amount) AS sales
FROM orders AS o
JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY sales DESC;
