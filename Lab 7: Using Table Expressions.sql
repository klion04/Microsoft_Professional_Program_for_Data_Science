
------------------------------------------------------------------------------------------------------------------------
                                               --//-- [Lab 6] --\\--
------------------------------------------------------------------------------------------------------------------------

                                       --------------------------------------
                                        -- RETRIEVING PRODUCT INFORMATION --
                                       --------------------------------------

/*
Retrieve the product ID, product name, product model name, and product model summary for each product from the Product
table and the vProductModelCatalogDescription view.
*/

SELECT
  P.ProductID,
  P.Name  AS ProductName,
  PM.Name AS ProductModel,
  PM.Summary
FROM SalesLT.Product AS P
  INNER JOIN SalesLT.vProductModelCatalogDescription AS PM
    ON P.ProductModelID = PM.ProductModelID
ORDER BY ProductID;

/*
Create a table variable and populate it with a list of distinct colors from the Product table. Then use the table
variable to filter a query that returns the product ID, name, and color from the Product table so that only products
with a color listed in the table variable are returned.
*/

DECLARE @Colors AS TABLE(Color NVARCHAR(15));

INSERT INTO @Colors
  SELECT DISTINCT Color
  FROM SalesLT.Product;

SELECT
  ProductID,
  Name,
  Color
FROM SalesLT.Product
WHERE Color IN (SELECT Color
                FROM @Colors);

/*
A query that uses the unfGetAllCategories function to return a list of all products including their parent category and
their own category in addition to the product ID and product name.
*/

SELECT
  C.ParentProductCategoryName AS ParentCategory,
  C.ProductCategoryName       AS Category,
  P.ProductID,
  P.Name                      AS ProductName
FROM SalesLT.Product AS P
  JOIN dbo.ufnGetAllCategories() AS C
    ON P.ProductCategoryID = C.ProductCategoryID
ORDER BY ParentCategory, Category, ProductName;

/*
Retrieve a list of customers in the format Company (Contact Name) together with the total revenue for each customer.

This can be achieved two ways, using a derived table or a common table expression, both of which are detailed below.
*/

-- Derived Table

SELECT
  CompanyContact,
  SUM(SalesAmount) AS Revenue
FROM
  (SELECT
     CONCAT(C.CompanyName, CONCAT(' (' + C.FirstName + ' ', C.LastName + ')')) AS CompanyContact,
     SOH.TotalDue                                                              AS SalesAmount
   FROM SalesLT.SalesOrderHeader AS SOH
     JOIN SalesLT.Customer AS C
       ON SOH.CustomerID = C.CustomerID) AS CustomerSales
GROUP BY CompanyContact
ORDER BY CompanyContact;


-- CTE

WITH CustomerSales(CompanyContact, SalesAmount)
AS
(SELECT
   CONCAT(C.CompanyName, CONCAT(' (' + C.FirstName + ' ', C.LastName + ')')),
   SOH.TotalDue
 FROM SalesLT.SalesOrderHeader AS SOH
   JOIN SalesLT.Customer AS C
     ON SOH.CustomerID = C.CustomerID)
SELECT
  CompanyContact,
  SUM(SalesAmount) AS Revenue
FROM CustomerSales
GROUP BY CompanyContact
ORDER BY CompanyContact;

