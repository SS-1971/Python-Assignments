-- Q1 · Grain
--
-- Question: what is the grain of the orders table? Prove it with a query rather
-- than asserting it, and show how many order_ids have more than one row.
--
-- Why this is first: grain is the first thing to establish about any table and
-- the thing most people assume instead of checking. Every later query in this
-- lab depends on getting this right.

-- TODO: write your query here.
-- Run `python -m pytest -k q01` to check it.
-- with order_grain as(
-- SELECT order_id,count(order_id) 
-- from orders group by order_id 
-- having count(order_id)>1)

-- SELECT count(*) as multiple_order_id_count from order_grain

SELECT count(*) as total
,count(distinct(order_id)) as "DISTINCT",
count(*)-count(distinct(order_id)) as surplus ,
 count(*)/(count(*)-count(distinct(order_id))) as ratio from orders 

    


-- count(*) as total
-- The grain is NOT one row per order. It is one row per *version* of an order.
-- Any query that treats order_id as unique will double count the corrected ones.
