
------------------------------------------------------------------------------------------------------------------------
                                               --//-- [Lab 5] --\\--
------------------------------------------------------------------------------------------------------------------------

                                       --------------------------------------
                                        -- RETRIEVING PRODUCT INFORMATION --
                                       --------------------------------------

/*
Return the product ID of each product, together with the product name formatted as upper case and a column named
ApproxWeight with the weight of each product rounded to the nearest whole unit.
*/

SELECT
  ProductID,
  UPPER(Name)      AS ProductName,
  ROUND(Weight, 0) AS ApproxWeight
FROM SalesLT.Product;

/*
Extend the previous query to include columns named SellStartYear and SellStartMonth containing the year and month in
which AdventureWorks started selling each product.
*/

SELECT
  ProductID,
  UPPER(Name)         AS ProductName,
  ROUND(Weight, 0)    AS ApproxWeight,
  YEAR(SellStartDate) AS SellStartYear,
  DATENAME(MM, SellStartDate)
FROM SalesLT.Product;

/*
Extend the previous query to include a column named ProductType that contains the leftmost two characters from the
product number.
*/

SELECT
  ProductID,
  UPPER(Name)                    AS ProductName,
  ROUND(Weight, 0)               AS ApproxWeight,
  YEAR(SellStartDate)            AS SellStartYear,
  DATENAME(MM, SellStartDate),
  SUBSTRING(ProductNumber, 1, 2) AS ProductType
FROM SalesLT.Product;

/*
Extend the previous query to filter the product returned so that only products with a numeric size are included.
*/

SELECT
  ProductID,
  UPPER(Name)                    AS ProductName,
  ROUND(Weight, 0)               AS ApproxWeight,
  YEAR(SellStartDate)            AS SellStartYear,
  DATENAME(MM, SellStartDate),
  SUBSTRING(ProductNumber, 1, 2) AS ProductType
FROM SalesLT.Product
WHERE ISNUMERIC(Size) = 1;

                                         ------------------------------------
                                          -- RANKING CUSTOMERS BY REVENUE --
                                         ------------------------------------

/*
Returns a list of company names with a ranking of their place in a list of highest TotalDue values from the
SalesOrderHeader table.
*/

SELECT
  C.CompanyName,
  SOH.TotalDue                   AS Revenue,
  RANK()
  OVER (
    ORDER BY SOH.TotalDue DESC ) AS RankByRevenue
FROM SalesLT.Customer AS C
  INNER JOIN SalesLT.SalesOrderHeader AS SOH
    ON C.CustomerID = SOH.CustomerID;

                                          ---------------------------------
                                           -- AGGREGATING PRODUCT SALES --
                                          ---------------------------------

/*
Retrieve a list of the product names and the total revenue calculated as the sum of the Line Total from the
SalesOrderDetail table, with the results sorted in descending order of total revenue.
*/

SELECT
  P.Name,
  SUM(SOD.LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS SOD
  INNER JOIN SalesLT.Product AS P
    ON SOD.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY TotalRevenue DESC;

/*
Add to the previous query to include sales totals for products that have a list price of more than 1000.
*/

SELECT
  P.Name,
  SUM(SOD.LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS SOD
  INNER JOIN SalesLT.Product AS P
    ON SOD.ProductID = P.ProductID
WHERE P.ListPrice > 1000
GROUP BY P.Name
ORDER BY TotalRevenue DESC;

/*
Add to the previous query to only include products with total sales greater than 20000.
*/

SELECT
  P.Name,
  SUM(SOD.LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS SOD
  INNER JOIN SalesLT.Product AS P
    ON SOD.ProductID = P.ProductID
WHERE P.ListPrice > 1000
GROUP BY P.Name
HAVING SUM(SOD.LineTotal) > 20000
ORDER BY TotalRevenue DESC;