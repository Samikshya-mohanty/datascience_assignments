/* IMPORTANT INSTRUCTIONS FOR LEARNERS
1) DO NOT CHANGE THE ORDER OF COLUMNS.
2) YOUR QUERY SHOULD DISPLAY COLUMNS IN THE SAME ORDER AS MENTIONED IN ALL QUESTIONS.
3) YOU CAN FIND THE ORDER OF COLUMNS IN QUESTION TEMPLATE SECTION OF EACH QUESTION.
4) USE ALIASING AS MENTIONED IN QUESTION TEMPLATE FOR ALL COLUMNS
5) DO NOT CHANGE COLUMN NAMES*/
                   
-- Question 1 (Marks: 2)
-- Objective: Retrieve data using basic SELECT statements
-- List the names of all customers in the database.
-- Question Template: Display CustomerName Column

Select CustomerName
from Customers;

-- Question 2 (Marks: 2)
-- Objective: Apply filtering using the WHERE clause
-- Retrieve the names and prices of all products that cost less than $15.
-- Question Template: Display ProductName Column

Select ProductName
from Products
where Price < 15;

-- Question 3 (Marks: 2)
-- Objective: Use SELECT to extract multiple fields
-- Display all employees first and last names.
-- Question Template: Display FirstName, LastName Columns

Select FirstName,LastName
from Employees;

-- Question 4 (Marks: 2)
-- Objective: Filter data using a function on date values
-- List all orders placed in the year 1997.
-- Question Template: Display OrderID, OrderDate Columns

Select OrderID, OrderDate
From Orders
where year(OrderDate) = 1997;

-- Question 5 (Marks: 2)
-- Objective: Apply numeric filters
-- List all products that have a price greater than $50.
-- Question Template: Display ProductName, Price Column

Select ProductName,Price
from Products
where Price > 50;


-- Question 6 (Marks: 3)
-- Objective: Perform multi-table JOIN operations
-- Show the names of customers and the names of the employees who handled their orders.
-- Question Template: Display CustomerName, FirstName, LastName Columns

Select c.CustomerName,e.FirstName,e.LastName
from
Customers c join Orders o on c.CustomerID = o.CustomerID
join employees e on e.EmployeeID = o.EmployeeID;

-- Question 7 (Marks: 3)
-- Objective: Use GROUP BY for aggregation
-- List each country along with the number of customers from that country.
-- Question Template: Display Country, CustomerCount Columns

Select Country,count(CustomerID) as CustomerCount
from Customers
group by 1;

-- Question 8 (Marks: 3)
-- Objective: Group data by a foreign key relationship and apply aggregation
-- Find the average price of products grouped by category.
-- Question Template: Display CategoryName, AvgPrice Columns

Select c.CategoryName, avg(p.Price) as AvgPrice
from Products p join Categories c on p.CategoryID = c.CategoryID
group by 1;

-- Question 9 (Marks: 3)
-- Objective: Use aggregation to count records per group
-- Show the number of orders handled by each employee.
-- Question Template: Display EmployeeID, OrderCount Columns

Select e.EmployeeID,count(o.OrderID)
from Employees e join Orders o on e.EmployeeID = o.EmployeeID
group by 1;

-- Question 10 (Marks: 3)
-- Objective: Filter results using values from a joined table
-- List the names of products supplied by "Exotic Liquids".
-- Question Template: Display ProductName Column

SELECT
    P.ProductName
FROM
    Products P  
INNER JOIN
    Suppliers S ON P.SupplierID = S.SupplierID  
WHERE
    S.SupplierName = 'Exotic Liquid'; 

-- Question 11 (Marks: 5)
-- Objective: Rank records using aggregation and sort
-- List the top 3 most ordered products (by quantity).
-- Question Template: Display ProductID, TotalOrdered Columns

Select p.productID,sum(od.Quantity) as TotalOrdered
from products p join OrderDetails od on p.productID = od.ProductID
group by 1
ORDER BY TotalOrdered DESC
Limit 3;

-- Question 12 (Marks: 5)
-- Objective: Use GROUP BY and HAVING to filter on aggregates
-- Find customers who have placed orders worth more than $10,000 in total.
-- Question Template: Display CustomerName, TotalSpent Columns
with cust as 
(
Select od.OrderID, (Quantity* price) as TotalSpent
from products p join OrderDetails od on p.ProductId = od.ProductId
)

Select o.CustomerID,sum(TotalSpent) as customer_spent
from cust c join Orders o on c.OrderID = o.OrderID 
join Customers cu on o.CustomerID = o.CustomerID
group by o.CustomerID
having customer_spent > 10000;





-- Question 13 (Marks: 5)
-- Objective: Aggregate and filter at the order level
-- Display order IDs and total order value for orders that exceed $2,000 in value.
-- Question Template: Display OrderID, OrderValue Columns




Select od.OrderID, SUM(p.Price * od.quantity) as OrderValue
from products p join OrderDetails od
on p.ProductID = od.ProductID
Group by od.OrderID
having SUM(p.Price * od.Quantity) > 2000;





-- Question 14 (Marks: 5)
-- Objective: Use subqueries in HAVING clause
-- Find the name(s) of the customer(s) who placed the largest single order (by value).
-- Question Template: Display CustomerName, OrderID, TotalValue Column

SELECT
c.CustomerName,
o.OrderID,
SUM(p.price * od.Quantity) AS TotalValue
FROM Customers c
INNER JOIN
Orders o ON c.CustomerId = o.CustomerId
INNER JOIN
OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN
Products p ON p.ProductID = od.ProductID
GROUP BY
c.CustomerName, o.OrderID  
HAVING
SUM(p.price * od.Quantity) = (
	SELECT MAX(OrderTotal)
	FROM 
	(
		SELECT SUM(price * Quantity) AS OrderTotal
		FROM OrderDetails od2
		INNER JOIN Products p2
		ON p2.ProductID = od2.ProductID
		GROUP BY od2.OrderID
	) AS OrderTotals
)
ORDER BY TotalValue DESC;



-- Question 15 (Marks: 5)
-- Objective: Identify records using NOT IN with subquery
-- Get a list of products that have never been ordered.
-- Question Template: Display ProductName Columns

SELECT
    ProductName
FROM
    Products
WHERE
    ProductID NOT IN (
        
        SELECT DISTINCT
            ProductID
        FROM
            OrderDetails
    );
    
    
