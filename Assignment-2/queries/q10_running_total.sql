-- Q10 · Running totals and window framing
--
-- Question: daily shipped-order counts for 2024, with a cumulative running
-- total and a 7-day moving average. Be explicit about the frame.

-- TODO: write your query here.
-- Run `python -m pytest -k q10` to check it.
SELECT 'not implemented' AS todo;

-- TODO: write your query here.
-- Run `python -m pytest -k q10` to check it.
SELECT 'not implemented' AS todo;

-- TODO: write your query here.
-- Run `python -m pytest -k q10` to check it.
SELECT 'not implemented' AS todo;

    -- Cumulative from the start of the window to this row
-- TODO: write your query here.
-- Run `python -m pytest -k q10` to check it.
SELECT 'not implemented' AS todo;

    -- Trailing 7-day average: this row plus the six before it
-- TODO: write your query here.
-- Run `python -m pytest -k q10` to check it.
SELECT 'not implemented' AS todo;

    -- Centred 7-day average, for comparison
-- TODO: write your query here.
-- Run `python -m pytest -k q10` to check it.
SELECT 'not implemented' AS todo;

-- The frame matters more than people expect. With ORDER BY and no explicit
-- frame the default is RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW, and
-- RANGE groups tied ORDER BY values together — so with duplicate days you get
-- the same running total on both rows rather than an incrementing one.
-- Write the frame out. It costs one line and removes an entire class of bug.
WITH daily AS (
    SELECT
        order_date AS day,
        COUNT(*) AS orders
    FROM orders
    WHERE status = 'shipped'
      AND order_date >= '2024-01-01'
      AND order_date < '2025-01-01'
    GROUP BY order_date
)

SELECT
    day,
    orders,

    SUM(orders) OVER (
        ORDER BY day
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total,

    AVG(orders) OVER (
        ORDER BY day
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS ma7,

    AVG(orders) OVER (
        ORDER BY day
        ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
    ) AS centred

FROM daily
ORDER BY day;