-- Q5 · HAVING versus WHERE
--
-- Question: for shipped orders only, list regions with more than 150 orders,
-- ordered by order count. Use WHERE and HAVING correctly and explain in a
-- comment why each clause is where it is.
--
-- WHERE filters rows BEFORE grouping. HAVING filters groups AFTER aggregating.
-- Putting an aggregate in WHERE is an error. Putting a row condition in HAVING
-- works but scans more rows than it needs to.

-- TODO: write your query here.
-- Run `python -m pytest -k q05` to check it.
SELECT c.region,count(*) as order_count,count(distinct(c.customer_id)) 
from customers c JOIN orders o ON c.customer_id=o.customer_id where status="shipped"
group by region having count(*)>150 ORDER BY order_count DESC
