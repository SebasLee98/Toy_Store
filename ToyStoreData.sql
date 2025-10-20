-- Identify customers on file that did not order a vintage car
With First_Query AS (
SELECT A.customerName, C.orderNumber, D.productLine, C.productCode, C.quantityOrdered FROM customers A
JOIN orders B ON A.customerNumber = B.customerNumber
JOIN orderdetails C ON B.orderNumber = C.orderNumber
JOIN products D ON C.productCode = D.productCode  
)
SELECT distinct customerName, productLine, orderNumber
FROM First_Query WHERE productLine <> "Vintage Cars"

-- Most popular products ranked
SELECT B.productName, A.quantityOrdered FROM orderdetails A
LEFT JOIN products B ON A.productCode = B.productCode
ORDER BY quantityOrdered DESC LIMIT 15;

-- The most popular product in each country
WITH Set_Up AS (
SELECT ROW_NUMBER() OVER (PARTITION BY D.country ORDER BY B.quantityOrdered DESC) AS First_Step, D.country, A.productName, B.quantityOrdered FROM products A 
RIGHT JOIN orderdetails B ON A.productCode = B.productCode
RIGHT JOIN orders C ON B.orderNumber = C.orderNumber
LEFT JOIN customers D ON C.customerNumber = D.customerNumber
)
SELECT * FROM Set_Up WHERE First_Step = 1;

-- Most successful employees
SELECT A.firstName, A.lastName, A.employeeNumber, count(C.orderNumber) AS Orders_Made, sum(D.quantityOrdered * D.priceEach) AS Profit_Generated 
FROM employees A INNER JOIN customers B ON A.employeeNumber = B.salesRepEmployeeNumber
RIGHT JOIN orders C ON B.customerNumber = C.customerNumber
LEFT JOIN orderdetails D ON C.orderNumber = D.orderNumber
GROUP BY A.employeeNumber
ORDER BY Orders_Made DESC;

SELECT * FROM customers;

SELECT 
CASE WHEN creditLimit < 75000 then 'a: Less than $75K'
WHEN creditLimit BETWEEN 75000 AND 100000 THEN 'b: $750 - $100K'
WHEN creditLimit BETWEEN 100000 AND 150000 THEN 'c: $100k - $150k'
WHEN creditLimit > 150000 THEN 'd: over $150k'
ELSE 'Other' END AS credit_limit,
count(distinct c.customerNumber) AS customers
FROM customers AS c
GROUP BY credit_limit;