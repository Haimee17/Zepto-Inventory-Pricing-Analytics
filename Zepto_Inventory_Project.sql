CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountpercent NUMERIC(5,2),
    availablequantity INTEGER,
    discountedsellingprice NUMERIC(8,2),
    weightingms INTEGER,
    outofstock BOOLEAN,
    quantity INTEGER
);

--data exploration

--count of rows
select * from zepto
limit 10;

--null values
select * from zepto
where name is null
or
category is null
or
mrp is null
or
discountpercent is null
or
availablequantity is null
or
discountedsellingprice is null
or
weightingms is null
or
outofstock is null
or
quantity is null

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
select outOfStock, count(sku_id)
from zepto
group by outOfStock;

--product names present multiple times
select name, count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

--data cleaning

--products with price=0
select * from zepto
where mrp = 0 or discountedsellingprice = 0;

delete from zepto
where mrp = 0;

--convert paise to rupees
update zepto
set mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

select mrp, discountedsellingprice from zepto

--Q1. Find the top 10 best-value products based on the discount percentage

select DISTINCT name, mrp, discountPercent
from zepto
order by discountpercent desc
limit 10;

--Q2. What are the Products with high MRP but out of stock

select DISTINCT name, mrp, outofstock
from zepto
where outofstock = TRUE and mrp > 300
order by mrp desc;

--Q3. Calculate estimated revenue for each category

select category, sum(discountedsellingprice * availablequantity) AS total_revenue
from zepto
group by category
order by total_revenue;

--Q4. Find all products where MRP is greater than 500 and discount is less than 10%

select DISTINCT name, mrp, discountPercent from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent desc;

--Q5. Identify the top 5 categories offering the highest average discount percentage

select category, round(avg(discountPercent),2) AS avg_discount
from zepto
group by category
order by avg_discount desc
LIMIT 5;

--Q6. Find the price per gram for products above 100gm and sort by best value.

select distinct name, weightingms, discountedsellingprice,
round(discountedsellingprice / weightingms,2) AS price_per_gm
from zepto
where weightingms >= 100
order by price_per_gm;

--Q7. Group the products into categories like low, medium, bulk.

select distinct name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
	 WHEN weightingms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
from zepto;	 
	 
--Q8. What is the total inventory weight per category

select category,
sum(weightingms * availableQuantity) AS total_weight
from zepto
group by category
order by total_weight;










