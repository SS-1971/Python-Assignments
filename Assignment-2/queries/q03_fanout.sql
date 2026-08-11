-- Q3 · The fan-out trap
--
-- Question: one row per order joined to many rows per order_item. Show the
-- inflated figure a naive join produces, then produce the correct one.
--
-- This is the bug that produces a revenue number three times too big and is
-- only caught when someone in finance says "that can't be right".

-- TODO: write your query here.
-- Run `python -m pytest -k q03` to check it.
SELECT 'not implemented' AS todo;
    -- Use only the latest version of each order, so the fan-out is the only
    -- thing being demonstrated here (see Q7 for the deduplication itself).
-- TODO: write your query here.
-- Run `python -m pytest -k q03` to check it.
-- SELECT 'not implemented' AS todo;
--  WITH latest_orders as (
--     SELECT o.*
--     ,ROW_NUMBER()
--     OVER (PARTITION BY order_id ORDER BY o.order_date DESC) as rk from orders o
--  )

-- SELECT * from latest_orders where rk=1


-- WRONG: counting distinct orders after joining to items multiplies the count
-- TODO: write your query here.
-- Run `python -m pytest -k q03` to check it.
-- SELECT 'not implemented' AS todo;
-- WITH order_item_count as (
--     SELECT order_id,SUM(quantity) from orders o JOIN order_items oi ON o.order_id=oi.order_id GROUP BY o.order_id 
-- )

-- SELECT * from order_item_count
-- RIGHT: aggregate the many-side first, then join one-to-one
-- TODO: write your query here.
-- Run `python -m pytest -k q03` to check it.
-- SELECT 'not implemented' AS todo;

-- TODO: write your query here.
-- Run `python -m pytest -k q03` to check it.
-- SELECT 'not implemented' AS todo;

-- Note that total_quantity is identical in both. Summing the many-side is fine.
-- It is COUNT(*) and any aggregate over the ONE-side that get inflated.



WITH latest_orders AS (
    SELECT
        order_id,
        status
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

item_totals AS (
    SELECT
        order_id,
        SUM(quantity) AS total_quantity
    FROM order_items
    GROUP BY order_id
),

fanout AS (
    SELECT
        lo.status,
        COUNT(*) AS inflated,
        COUNT(DISTINCT lo.order_id) AS correct,
        SUM(oi.quantity) AS qty_wrong
    FROM latest_orders lo
    JOIN order_items oi
        ON lo.order_id = oi.order_id
    GROUP BY lo.status
),

correct_totals AS (
    SELECT
        lo.status,
        COUNT(*) AS correct,
        SUM(it.total_quantity) AS qty_right
    FROM latest_orders lo
    JOIN item_totals it
        ON lo.order_id = it.order_id
    GROUP BY lo.status
)

SELECT
    f.status,
    f.inflated,
    f.correct,
    f.inflated - f.correct AS added,
    f.qty_wrong,
    c.qty_right
FROM fanout f
JOIN correct_totals c
    ON f.status = c.status
ORDER BY f.status;