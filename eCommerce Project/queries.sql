

-- Creating a table for dataset 

CREATE TABLE eCommerce(
    event_time TIMESTAMP,
    event_type VARCHAR(10),
    product_id INT,
    category_id BIGINT,
    category_code VARCHAR(50),
    brand VARCHAR(50),
    price FLOAT,
    user_id INT,
    user_session VARCHAR(50)
)


-- Copying dataset from file 

COPY eCommerce FROM '/Users/piotrmilner/Desktop/Project B/2020-Apr.csv' DELIMITER ',' CSV HEADER;

-- EDA 

SELECT
  'category_id' as "Column",
  count(category_id) as "Not null",
  null_searching."Null",
  NULL as "25th percentile",
  NULL as "Median",
  NULL as "75th percentile",
  (MIN(category_id)::VARchar(20)) as "Min",
  (MAX(category_id)::VARchar(20)) as "Max",
  NULL AS "Avg",
  COUNT(dist) as "Unique Values"
FROM ecommerce, (select count(category_id) as "Null" from ecommerce where category_id is nULL) as null_searching, (select distinct category_id as dist from ecommerce) as search_distinct
GROUP BY "Column", null_searching."Null"

Union

SELECT
  'price' as "Column",
  count(price) as "Not null",
  null_searching."Null",
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price) as "25th percentile",
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) as "Median",
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price) as "75th percentile",
  (MIN(price)::VARchar(20)) as "Min",
  (MAX(price)::VARchar(20)) as "Max",
  AVG(price) AS "Avg",
  COUNT(dist) as "Unique Values"
FROM ecommerce, (select count(price) as "Null" from ecommerce where price is nULL) as null_searching, (select distinct price as dist from ecommerce) as search_distinct
GROUP BY "Column", null_searching."Null"

Union 

SELECT
  'user_id' as "Column",
  count(user_id) as "Not null",
  null_searching."Null",
  NULL as "25th percentile",
  NULL as "Median",
  NULL as "75th percentile",
  (MIN(user_id)::VARchar(20)) as "Min",
  (MAX(user_id)::VARchar(20)) as "Max",
  NULL AS "Avg",
  COUNT(dist) as "Unique Values"
FROM ecommerce, (select count(user_id) as "Null" from ecommerce where user_id is nULL) as null_searching, (select distinct  user_id as dist from ecommerce) as search_distinct
GROUP BY "Column", null_searching."Null"

UNION

SELECT
  'event_time' as "Column",
  count(event_time) as "Not null",
  null_searching."Null",
  NULL as "25th percentile",
  NULL as "Median",
  NULL AS "75th percentile",
  (MIN(event_time)::VARchar(20)) as "Min",
  (MAX(event_time)::VARchar(20)) as "Max",
  NULL AS "Avg",
  COUNT(dist) as "Unique Values"
FROM ecommerce, (select count(*) as "Null" from ecommerce where event_time is nULL) as null_searching, (select distinct event_time as dist from ecommerce) as search_distinct
GROUP BY "Column", null_searching."Null"

Union 

SELECT
  'product_id' as "Column",
  count(user_id) as "Not null",
  null_searching."Null",
  NULL as "25th percentile",
  NULL as "Median",
  NULL as "75th percentile",
  (MIN(product_id)::VARchar(20)) as "Min",
  (MAX(product_id)::VARchar(20)) as "Max",
  NULL AS "Avg",
  COUNT(dist) as "Unique Values"
FROM ecommerce, (select count(user_id) as "Null" from ecommerce where product_id is nULL) as null_searching, (select distinct product_id as dist from ecommerce) as search_distinct
GROUP BY "Column", null_searching."Null"

union

SELECT
  'user_sessison' as "Column",
  count('user_sessison') as "Not null",
  null_searching."Null",
  NULL as "25th percentile",
  NULL as "Median",
  NULL as "75th percentile",
  (MIN(length('user_sessison'))::VARchar(20)) as "Min",
  (MAX(length('user_sessison'))::VARchar(20)) as "Max",
  NULL AS "Avg",
  COUNT(dist) as "Unique Values"
FROM ecommerce, (select count('user_sessison') as "Null" from ecommerce where 'user_sessison' is nULL) as null_searching, (select distinct user_session as dist from ecommerce) as search_distinct
GROUP BY "Column", null_searching."Null"

union 

SELECT
  'event_type' as "Column",
  count(event_type) as "Not null",
  null_searching."Null",
  NULL as "25th percentile",
  NULL as "Median",
  NULL as "75th percentile",
  (MIN(length(event_type))::VARchar(20)) as "Min",
  (MAX(length(event_type))::VARchar(20)) as "Max",
  NULL AS "Avg",
  COUNT(dist) as "Unique Values"
FROM ecommerce, (select count(event_type) as "Null" from ecommerce where event_type is nULL) as null_searching, (select distinct event_type as dist from ecommerce) as search_distinct
GROUP BY "Column", null_searching."Null"

UNION

SELECT
  'category_code' as "Column",
  count(category_code) as "Not null",
  null_searching."Null",
  NULL as "25th percentile",
  NULL as "Median",
  NULL AS "75th percentile",
  (MIN(length(category_code))::VARchar(20)) as "Min",
  (MAX(length(category_code))::VARchar(20)) as "Max",
  AVG(length(category_code)) AS "Avg",
  COUNT(dist) as "Unique Values"
FROM ecommerce, (select count(*) as "Null" from ecommerce where category_code is nULL) as null_searching , (select distinct ‘category_code’ as dist from ecommerce) as search_distinct
GROUP BY "Column", null_searching."Null"

union

SELECT
  'brand' as "Column",
  count(brand) as "Not null",
  null_searching."Null",
  NULL as "25th percentile",
  NULL as "Median",
  NULL AS "75th percentile",
  (MIN(length(brand))::VARchar(20)) as "Min",
  (MAX(length(brand))::VARchar(20)) as "Max",
  AVG(length(brand)) AS "Avg",
  COUNT(dist) as "Unique Values"
FROM ecommerce, (select count(*) as "Null" from ecommerce where brand is nULL) as null_searching, (select distinct brand as dist from ecommerce) as search_distinct
GROUP BY "Column", null_searching."Null"


-- Shows traffic by day of week + target 

WITH t1 AS (SELECT EXTRACT (dow FROM event_time) AS h, count(user_id) AS count_cart
FROM ecommerce
WHERE event_type = 'cart'
GROUP BY h), 
t2 AS (SELECT EXTRACT (dow FROM event_time) AS h, count(user_id) AS count_purchase
FROM ecommerce
WHERE event_type = 'purchase'
GROUP BY h)

SELECT t2.h, t2.count_purchase, 0.3*t1.count_cart AS target
FROM t1
JOIN t2 USING(h)
ORDER BY t2.h 


-- Shows traffic by hour + target 

WITH t1 AS (SELECT EXTRACT (HOUR FROM event_time) AS h, count(user_id) AS count_cart
FROM ecommerce
WHERE event_type = 'cart'
GROUP BY h), 
t2 AS (SELECT EXTRACT (HOUR FROM event_time) AS h, count(user_id) AS count_purchase
FROM ecommerce
WHERE event_type = 'purchase'
GROUP BY h)

SELECT t2.h, t2.count_purchase, 0.3*t1.count_cart AS target
FROM t1
JOIN t2 USING(h)
ORDER BY t2.h 


-- Shows the breakdown of event types

SELECT ecommerce.event_type, (count(event_type)/t1.events_count_total::FLOAT)*100 AS percentage_of_events_count
FROM ecommerce, (SELECT count(event_type) AS events_count_total FROM ecommerce) AS t1
GROUP BY ecommerce.event_type, t1.events_count_total


-- Shows the breakdown of brands and revenue from their products

WITH 
t1 AS (
    SELECT sum(price) AS total_income
    FROM ecommerce
    WHERE event_type = 'purchase'
    ),
t2 AS 
    (
    SELECT initcap(ecommerce.brand) AS brand, (sum(ecommerce.price)/t1.total_income)*100 AS percentage_of_total_income, 
    sum(ecommerce.price) AS income_per_brand
    FROM ecommerce, t1
    WHERE brand IS NOT NULL AND event_type = 'purchase'
    GROUP BY ecommerce.brand, t1.total_income
    ORDER BY percentage_of_total_income DESC
    LIMIT 10
    )

SELECT *
FROM t2

UNION 

SELECT 'Others', 100-sum(t2.percentage_of_total_revenue)AS percentage_of_total_revenue, t1.total_revenue - sum(t2.revenue_per_brand) AS revenue_per_brand
FROM t1, t2
GROUP BY t1.total_revenue
ORDER BY percentage_of_total_revenue DESC


-- Loking for top 10 products with the highest revenue and pcs sold 

SELECT product_id, sum(price) AS revenue, count(product_id) AS pcs_sold
FROM ecommerce
WHERE event_type = 'purchase'
GROUP BY product_id
ORDER BY sum(price) DESC
LIMIT 10






