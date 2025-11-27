-- Ecommerce Product Analytics Project - SQL Queries
-- Author: Arun Santhosh
-- Tools: MySQL

-- 1. View raw Amazon category data
SELECT * 
FROM amazon_categories_2024
LIMIT 20;

-- 2. View raw product listings
SELECT * 
FROM amazon_products_2024
LIMIT 20;

-- 3. Remove duplicates from categories table
CREATE TABLE cleaned_categories AS
SELECT DISTINCT *
FROM amazon_categories_2024;

-- 4. Remove duplicates from product table
CREATE TABLE cleaned_products AS
SELECT DISTINCT *
FROM amazon_products_2024;

-- 5. Validate NULL values
SELECT 
    SUM(category IS NULL) AS category_nulls,
    SUM(product_name IS NULL) AS product_nulls,
    SUM(price IS NULL) AS price_nulls,
    SUM(rating IS NULL) AS rating_nulls,
    SUM(reviews IS NULL) AS reviews_nulls
FROM cleaned_products;

-- 6. Convert price to numeric
UPDATE cleaned_products
SET price = REPLACE(price, '₹', '');

-- 7. Convert rating to decimal
UPDATE cleaned_products
SET rating = NULLIF(rating, 'No rating');

-- 8. Create final reporting table
CREATE TABLE final_ecommerce AS
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.rating,
    p.reviews,
    c.main_category,
    c.sub_category
FROM cleaned_products p
LEFT JOIN cleaned_categories c
    ON p.category_id = c.category_id;

-- 9. Find top 10 best-selling products
SELECT *
FROM final_ecommerce
ORDER BY reviews DESC
LIMIT 10;

-- 10. Category-level summary
SELECT 
    main_category,
    COUNT(product_id) AS total_products,
    AVG(price) AS avg_price,
    AVG(rating) AS avg_rating
FROM final_ecommerce
GROUP BY main_category
ORDER BY total_products DESC;
