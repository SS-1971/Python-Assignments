-- Q9 · LAG — month-over-month change
--
-- Question: monthly shipped order counts, with the previous month's figure and
-- the percentage change. Handle the first month, which has no previous value.

-- TODO: write your query here.
-- Run `python -m pytest -k q09` to check it.
SELECT 'not implemented' AS todo;

-- TODO: write your query here.
-- Run `python -m pytest -k q09` to check it.
SELECT 'not implemented' AS todo;

-- TODO: write your query here.
-- Run `python -m pytest -k q09` to check it.
SELECT 'not implemented' AS todo;

-- LAG returns NULL for the first row of each partition. Returning NULL is the
-- honest answer — do not COALESCE it to zero, which would report a 100% drop
-- that never happened.
--
-- LEAD is the same function looking forward. LAG(orders, 3) looks back three rows.

WITH monthly AS (
    SELECT
        substr(order_date, 1, 7) AS month,
        COUNT(*) AS shipped_orders
    FROM orders
    WHERE status = 'shipped'
    GROUP BY substr(order_date, 1, 7)
),

with_previous AS (
    SELECT
        month,
        shipped_orders,
        LAG(shipped_orders) OVER (
            ORDER BY month
        ) AS previous_month_orders
    FROM monthly
)

SELECT
    month,
    shipped_orders,
    previous_month_orders,
    shipped_orders - previous_month_orders AS change,
    CASE
        WHEN previous_month_orders IS NULL
             OR previous_month_orders = 0
        THEN NULL
        ELSE ROUND(
            (shipped_orders - previous_month_orders) * 100.0
            / previous_month_orders,
            2
        )
    END AS percentage_change
FROM with_previous
ORDER BY month;