-- Q11 · Point-in-time lookup
--
-- Question: value each order using the price that was in force ON THE ORDER
-- DATE, not the price today. Show what using today's price would have cost you.
--
-- This is the query most people get wrong, and it is wrong in a way that looks
-- perfectly fine until someone reconciles against the source system.

-- TODO: write your query here.
-- Run `python -m pytest -k q11` to check it.
SELECT 'not implemented' AS todo;

-- CORRECT: the price row whose validity window contains the order date.
-- valid_to is exclusive, so the comparison is >= valid_from AND < valid_to.
-- TODO: write your query here.
-- Run `python -m pytest -k q11` to check it.
SELECT 'not implemented' AS todo;

-- WRONG: today's price applied to every historical order.
-- TODO: write your query here.
-- Run `python -m pytest -k q11` to check it.
SELECT 'not implemented' AS todo;

-- TODO: write your query here.
-- Run `python -m pytest -k q11` to check it.
SELECT 'not implemented' AS todo;

-- Two checks worth running before you trust this:
--   1. priced_lines should equal the number of order_item rows for latest orders.
--      If it is lower, some order dates fall outside every validity window and
--      the INNER join has silently dropped them.
--   2. No order line should match two price rows. If the count is higher than
--      expected, your validity windows overlap and you have a fan-out.
WITH latest_orders AS (
    SELECT
        order_id,
        customer_id,
        order_date
    FROM (
        SELECT
            o.*,
            ROW_NUMBER() OVER (
                PARTITION BY order_id
                ORDER BY updated_at DESC, order_row_id DESC
            ) AS rn
        FROM orders o
    )
    WHERE rn = 1
),

priced_lines AS (
    SELECT
        lo.order_id,
        oi.product_id,
        oi.quantity,
        ph.unit_price AS historical_price
    FROM latest_orders lo
    JOIN order_items oi
        ON oi.order_id = lo.order_id
    JOIN price_history ph
        ON ph.product_id = oi.product_id
       AND lo.order_date >= ph.valid_from
       AND lo.order_date < ph.valid_to
),

current_prices AS (
    SELECT
        product_id,
        unit_price AS current_price
    FROM price_history
    WHERE valid_to = '9999-12-31'
)

SELECT
    ROUND(SUM(pl.quantity * pl.historical_price), 2) AS pit,
    ROUND(SUM(pl.quantity * cp.current_price), 2) AS today,
    ROUND(
        SUM(pl.quantity * cp.current_price)
        - SUM(pl.quantity * pl.historical_price),
        2
    ) AS overstatement,
    COUNT(*) AS lines
FROM priced_lines pl
JOIN current_prices cp
    ON cp.product_id = pl.product_id;