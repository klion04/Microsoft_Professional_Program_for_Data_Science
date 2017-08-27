
------------------------------------------------------------------------------------------------------------------------
                                               --//-- [Lab 2] --\\--
------------------------------------------------------------------------------------------------------------------------

                                   ---------------------------------------------
                                    -- RETRIEVING TRANSPORTATION REPORT DATA --
                                   ---------------------------------------------

-- Create a two-column list containing all values for City and State Province without duplicates

SELECT DISTINCT
  City,
  StateProvince
FROM SalesLT.Address;

-- Retrieve the Top 10% from the Name column, ordered by Weight in descending order

SELECT TOP 10 PERCENT Name
FROM SalesLT.Product
ORDER BY Weight DESC;

-- List the heaviest 100 products not including the 10 heaviest ones

SELECT Name
FROM SalesLT.Product
ORDER BY Weight DESC
  OFFSET 10 ROWS FETCH NEXT 100 ROWS ONLY;

                                         -------------------------------
                                          -- RETRIEVING PRODUCT DATA --
                                         -------------------------------

-- List the Name, Color and Size of products whose Product Model ID is '1'

SELECT
  Name,
  Color,
  Size
FROM SalesLT.Product
WHERE ProductModelID = 1;

-- List the Product Number and Name of the products that have a Color of Black, Red, or White and a Size of S or M

SELECT
  ProductNumber,
  Name
FROM SalesLT.Product
WHERE Color IN ('Black', 'Red', 'White') AND Size IN ('S', 'M');

-- Retrieve the Product Number, Name, and List Price of products that have a Product Number beginning with 'BK-'

SELECT
  ProductNumber,
  Name,
  ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE 'BK-%';

/*
List the Product Number, Name, and List Price of products with Product Number beginning with 'BK-' followed by any
character other than 'R', and ending with a '-' followed by any two numerals.
*/

SELECT
  ProductNumber,
  Name,
  ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE 'BK-[^R]___-[0-9][0-9]';