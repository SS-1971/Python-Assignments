-- Q4 · Aggregation and NULL behaviour
--
-- Question: some customers have no credit_limit. Show how COUNT, AVG and SUM
-- each treat those NULLs, and produce the figure a business user actually means
-- when they ask for "average credit limit".

-- TODO: write your query here.
-- Run `python -m pytest -k q04` to check it.
-- SELECT 'not implemented' AS todo;

    -- AVG ignores NULLs entirely: it divides by customers_with_a_limit
-- TODO: write your query here.
-- Run `python -m pytest -k q04` to check it.
-- SELECT 'not implemented' AS todo;

    -- Treating NULL as zero changes the denominator and the answer
-- TODO: write your query here.
-- Run `python -m pytest -k q04` to check it.
-- SELECT 'not implemented' AS todo;

    -- SUM ignores NULLs too, so the totals agree even though the averages differ
-- TODO: write your query here.
-- Run `python -m pytest -k q04` to check it.
-- SELECT 'not implemented' AS todo;

-- The question to ask the business is which they mean. "Average limit across
-- customers who have one" and "average limit across all customers, counting
-- unset as zero" are different numbers and both are defensible. Guessing is not.
--
-- Also worth knowing: NULL = NULL is not true, it is NULL. Use IS NULL.
-- COUNT(*) vs COUNT(credit_limit)
SELECT
    COUNT(*) AS all_customers,
    COUNT(credit_limit) AS customers_with_limit,
    COUNT(*) - COUNT(credit_limit) AS null_credit_limits,
    AVG(credit_limit) AS avg_ignoring,
    AVG(COALESCE(credit_limit, 0)) AS avg_zero,
    SUM(credit_limit) AS sum_ignoring,
    SUM(COALESCE(credit_limit, 0)) AS sum_coalesce
FROM customers;