-- -- Q6 · CTEs and readability
-- --
-- -- Question: the nested version below works. Rewrite it with CTEs so that a
-- -- reviewer can follow it, and confirm both return the same rows.
-- --
-- -- Nested subqueries are read inside-out. CTEs are read top-down, which is how
-- -- people actually read. That is the entire argument, and it is enough.

-- -- BEFORE (do not ship this):
-- --   SELECT region, avg_items FROM (
-- --     SELECT c.region, AVG(x.items) AS avg_items FROM (
-- --       SELECT o.order_id, o.customer_id, COUNT(i.order_item_id) AS items
-- --       FROM (SELECT * FROM (SELECT o.*, ROW_NUMBER() OVER (...) rn FROM orders o) WHERE rn=1) o
-- --       JOIN order_items i ON i.order_id = o.order_id GROUP BY o.order_id, o.customer_id
-- --     ) x JOIN customers c ON c.customer_id = x.customer_id GROUP BY c.region
-- --   ) WHERE avg_items > 2;

-- -- AFTER:
-- -- TODO: write your query here.
-- -- Run `python -m pytest -k q06` to check it.
-- SELECT 'not implemented' AS todo;

-- -- TODO: write your query here.
-- -- Run `python -m pytest -k q06` to check it.
-- SELECT 'not implemented' AS todo;

-- -- TODO: write your query here.
-- -- Run `python -m pytest -k q06` to check it.
-- SELECT 'not implemented' AS todo;

-- -- TODO: write your query here.
-- -- Run `python -m pytest -k q06` to check it.
-- SELECT 'not implemented' AS todo;

-- -- One caveat worth knowing before you use CTEs everywhere: in some engines a
-- -- CTE is an optimisation fence and is materialised rather than inlined. In
-- -- SQLite and modern Postgres it is usually inlined. If a CTE rewrite is
-- -- suddenly slower than the nested version, that is why.

WITH latest_orders AS (
    SELECT
        order_id,
        customer_id
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

order_item_counts AS (
    SELECT
        o.order_id,
        o.customer_id,
        COUNT(i.order_item_id) AS items
    FROM latest_orders o
    JOIN order_items i
        ON i.order_id = o.order_id
    GROUP BY
        o.order_id,
        o.customer_id
),

regional_averages AS (
    SELECT
        c.region,
        COUNT(*) AS order_count,
        AVG(o.items) AS avg_items
    FROM order_item_counts o
    JOIN customers c
        ON c.customer_id = o.customer_id
    GROUP BY c.region
)

SELECT
    region,
    order_count,
    avg_items
FROM regional_averages
WHERE avg_items > 2
ORDER BY region;