/*
Database contains eight tables:

Customers: customer data
Employees: all employee information
Offices: sales office information
Orders: customers' sales orders
OrderDetails: sales order line for each sales order
Payments: customers' payment records
Products: a list of scale model cars
ProductLines: a list of product line categories 

*/
-- Table descriptions
SELECT 'Customers' AS table_name, 
        (SELECT COUNT(*) FROM pragma_table_info('customers')) AS number_of_attributes,
        COUNT(*) AS number_of_row
  FROM customers
 
UNION ALL

SELECT 'Products' AS table_name, 
        (SELECT COUNT(*) FROM pragma_table_info('products')) AS number_of_attributes,
        COUNT(*) AS number_of_row
  FROM products
  
UNION ALL

SELECT 'Productlines' AS table_name, 
        (SELECT COUNT(*) FROM pragma_table_info('productlines')) AS number_of_attributes,
        COUNT(*) AS number_of_row
  FROM productlines
  
UNION ALL

SELECT 'Orders' AS table_name, 
        (SELECT COUNT(*) FROM pragma_table_info('orders')) AS number_of_attributes,
        COUNT(*) AS number_of_row
  FROM orders

UNION ALL

SELECT 'OrderDetails' AS table_name, 
        (SELECT COUNT(*) FROM pragma_table_info('orderdetails')) AS number_of_attributes,
        COUNT(*) AS number_of_row
  FROM orderdetails
  


UNION ALL

SELECT 'Payments' AS table_name, 
        (SELECT COUNT(*) FROM pragma_table_info('payments')) AS number_of_attributes,
        COUNT(*) AS number_of_row
  FROM payments

UNION ALL

SELECT 'Employees' AS table_name, 
        (SELECT COUNT(*) FROM pragma_table_info('employees')) AS number_of_attributes,
        COUNT(*) AS number_of_row
  FROM employees

UNION ALL

SELECT 'Offices' AS table_name, 
        (SELECT COUNT(*) FROM pragma_table_info('offices')) AS number_of_attributes,
        COUNT(*) AS number_of_row
  FROM offices;
  
-- low stock prodcts
SELECT p.productCode,p.productName,p.productLine, round(CAST(SUM(od.quantityOrdered) AS REAL)/p.quantityInStock,2)AS low_stock
  FROM products p
  JOIN orderdetails od
    ON p.productCode=od.productCode
 WHERE p.quantityInStock > 0
 GROUP BY p.productCode 
 ORDER BY low_stock DESC
 LIMIT 20;
 
-- Product performance
SELECT p.productCode,p.productName,SUM(od.quantityOrdered*od.priceEach)AS product_performance
  FROM products p 
  JOIN orderdetails od
    ON p.productCode=od.productCode
 GROUP BY p.productCode 
 ORDER BY product_performance DESC
 LIMIT 10;
 
--using a Common Table Expression (CTE) to display priority products for restocking
WITH low_stock_products AS (
SELECT p.productCode,p.productName,p.productLine, round(CAST(SUM(od.quantityOrdered) AS REAL)/p.quantityInStock,2)AS low_stock
  FROM products p
  JOIN orderdetails od
    ON p.productCode=od.productCode
 WHERE p.quantityInStock > 0
 GROUP BY p.productCode 
 ORDER BY low_stock DESC
 ),
 product_performance AS (
 SELECT productCode,SUM(quantityOrdered*priceEach)AS product_performance
  FROM orderdetails
 GROUP BY productCode 
 ORDER BY product_performance DESC
 )
 SELECT ls.productCode,ls.productName,ls.productLine, ls.low_stock, pp. product_performance
   FROM low_stock_products ls
   JOIN product_performance pp
     ON ls.productCode=pp.productCode
  WHERE ls.low_stock>=1
  ORDER BY pp.product_performance DESC;
  
--Top 5 VIP customers
WITH profit_per_customer AS (
SELECT o.customerNumber, sum(od.quantityOrdered*(od.priceEach-p.buyPrice))AS profit_per_customer
  FROM orders o
  JOIN orderdetails od
    ON o.orderNumber=od.orderNumber
  JOIN products p
    ON od.productCode=p.productCode
 GROUP BY o.customerNumber
 ORDER BY profit_per_customer DESC
)

SELECT c.contactLastName, c.contactFirstName, c.city, c.country,ppc.profit_per_customer
  FROM customers c
  JOIN profit_per_customer ppc
    ON c.customerNumber=ppc.customerNumber
 ORDER BY ppc.profit_per_customer DESC
 LIMIT 5;

 --5 least-engaged customers
WITH profit_per_customer AS (
SELECT o.customerNumber, sum(od.quantityOrdered*(od.priceEach-p.buyPrice))AS profit_per_customer
  FROM orders o
  JOIN orderdetails od
    ON o.orderNumber=od.orderNumber
  JOIN products p
    ON od.productCode=p.productCode
 GROUP BY o.customerNumber
 ORDER BY profit_per_customer DESC
)

SELECT c.contactLastName, c.contactFirstName, c.city, c.country,ppc.profit_per_customer
  FROM customers c
  JOIN profit_per_customer ppc
    ON c.customerNumber=ppc.customerNumber
 ORDER BY ppc.profit_per_customer 
 LIMIT 5;
 
 -- Average customer profit
WITH profit_per_customer AS (
SELECT o.customerNumber, sum(od.quantityOrdered*(od.priceEach-p.buyPrice))AS profit_per_customer
  FROM orders o
  JOIN orderdetails od
    ON o.orderNumber=od.orderNumber
  JOIN products p
    ON od.productCode=p.productCode
 GROUP BY o.customerNumber
 ORDER BY profit_per_customer DESC
)

SELECT round(avg(profit_per_customer),2)
  FROM profit_per_customer;

 --the number of new customers arriving each month 
 
WITH 
payment_with_year_month_table AS (
SELECT *, 
       CAST(SUBSTR(paymentDate, 1,4) AS INTEGER)*100 + CAST(SUBSTR(paymentDate, 6,7) AS INTEGER) AS year_month
  FROM payments p
),

customers_by_month_table AS (
SELECT p1.year_month, COUNT(*) AS number_of_customers, SUM(p1.amount) AS total
  FROM payment_with_year_month_table p1
 GROUP BY p1.year_month
),

new_customers_by_month_table AS (
SELECT p1.year_month, 
       COUNT(DISTINCT customerNumber) AS number_of_new_customers,
       SUM(p1.amount) AS new_customer_total,
       (SELECT number_of_customers
          FROM customers_by_month_table c
        WHERE c.year_month = p1.year_month) AS number_of_customers,
       (SELECT total
          FROM customers_by_month_table c
         WHERE c.year_month = p1.year_month) AS total
  FROM payment_with_year_month_table p1
 WHERE p1.customerNumber NOT IN (SELECT customerNumber
                                   FROM payment_with_year_month_table p2
                                  WHERE p2.year_month < p1.year_month)
 GROUP BY p1.year_month
)

SELECT year_month, 
       ROUND(number_of_new_customers*100/number_of_customers,1) AS number_of_new_customers_props,
       ROUND(new_customer_total*100/total,1) AS new_customers_total_props
  FROM new_customers_by_month_table;
  

	 


