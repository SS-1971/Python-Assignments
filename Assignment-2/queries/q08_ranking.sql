-- Q8 · ROW_NUMBER versus RANK versus DENSE_RANK
--
-- Question: top 3 products by quantity sold in each region. Show all three
-- ranking functions side by side so the difference at a tie is visible.

-- TODO: write your query here.
-- Run `python -m pytest -k q08` to check it.
-- SELECT 'not implemented' AS todo;

-- TODO: write your query here.
-- Run `python -m pytest -k q08` to check it.
-- SELECT 'not implemented' AS todo;

-- TODO: write your query here.
-- Run `python -m pytest -k q08` to check it.
-- SELECT 'not implemented' AS todo;

-- TODO: write your query here.
-- Run `python -m pytest -k q08` to check it.
-- SELECT 'not implemented' AS todo;

--   ROW_NUMBER  1,2,3,4  — always unique, arbitrary at a tie unless you break it
--   RANK        1,2,2,4  — ties share a rank, then it skips
--   DENSE_RANK  1,2,2,3  — ties share a rank, no gap
--
-- "Top 3" is ambiguous when there are ties. Ask which behaviour is wanted before
-- you pick one. Choosing ROW_NUMBER silently drops a genuinely tied product.
WITH product_sales AS (
    SELECT
        c.region,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS quantity_sold
    FROM orders o
    JOIN customers c
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    JOIN products p
        ON p.product_id = oi.product_id
    GROUP BY
        c.region,
        p.product_id,
        p.product_name
),

ranked AS (
    SELECT
        region,
        product_id,
        product_name,
        quantity_sold,

        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY quantity_sold DESC
        ) AS row_number_rank,

        RANK() OVER (
            PARTITION BY region
            ORDER BY quantity_sold DESC
        ) AS rank_rank,

        DENSE_RANK() OVER (
            PARTITION BY region
            ORDER BY quantity_sold DESC
        ) AS dense_rank_rank

    FROM product_sales
)

SELECT
    region,
    product_id,
    product_name,
    quantity_sold,
    row_number_rank,
    rank_rank,
    dense_rank_rank
FROM ranked
WHERE row_number_rank <= 3
   OR rank_rank <= 3
   OR dense_rank_rank <= 3
ORDER BY
    region,
    quantity_sold DESC,
    product_id;