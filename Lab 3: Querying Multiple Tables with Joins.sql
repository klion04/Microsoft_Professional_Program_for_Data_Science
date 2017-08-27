-----------------------------------------------------------------------------------------------------------------------
                                               --//-- [Lab 3] --\\--
-----------------------------------------------------------------------------------------------------------------------

                                       ----------------------------------
                                        -- GENERATING INVOICE REPORTS --
                                       ----------------------------------

/*
Returns the Company Name from the Customer table, the Sales Order ID and Total Due from the Sales Order Header table.
*/

SELECT
  C.CompanyName,
  OH.SalesOrderID,
  OH.TotalDue
FROM SalesLT.Customer AS C
  INNER JOIN SalesLT.SalesOrderHeader AS OH
    ON C.CustomerID = OH.CustomerID;

/*
This query extends the above query to include the main office address for each customer. This includes the:
  -- Full Street Address
  -- City
  -- State or Province
  -- Postal Code
  -- Country or Region
*/

SELECT
  C.CompanyName,
  A.AddressLine1,
  ISNULL(A.AddressLine2, '') AS AddressLine2,
  A.City,
  A.StateProvince,
  A.PostalCode,
  A.CountryRegion,
  OH.SalesOrderID,
  OH.TotalDue
FROM SalesLT.Customer AS C
  INNER JOIN SalesLT.SalesOrderHeader AS OH
    ON C.CustomerID = OH.CustomerID
  INNER JOIN SalesLT.CustomerAddress AS CA
    ON c.CustomerID = CA.CustomerID AND AddressType = 'Main Office'
  INNER JOIN SalesLT.Address AS A
    ON CA.AddressID = A.AddressID;

                                           -----------------------------
                                            -- RETRIEVING SALES DATA --
                                           -----------------------------

/*
Returns a list of all customer companies and their contacts (First Name and Last Name) showing the Sales Order ID and
Total Due for each order they have placed.

Customers who have not placed any orders should be placed at the bottom of the list with null values for the total due.
*/

SELECT
  C.CompanyName,
  C.FirstName,
  C.LastName,
  OH.SalesOrderID,
  OH.TotalDue
FROM SalesLT.Customer AS C
  LEFT OUTER JOIN SalesLT.SalesOrderHeader AS OH
    ON C.CustomerID = OH.CustomerID
ORDER BY OH.SalesOrderID DESC;

/*
Returns a list of Customer IDs, Company Names, contact names (First Name and Last Name), and Phone numbers for
customers with no Address stored in the database.
*/

SELECT
  C.CustomerID,
  C.CompanyName,
  C.FirstName,
  C.LastName,
  C.Phone
FROM SalesLT.Customer AS C
  LEFT OUTER JOIN SalesLT.CustomerAddress AS CA
    ON C.CustomerID = CA.CustomerID
WHERE CA.AddressID IS NULL;

/*
Returns a column of Customer IDs for customers who have never placed an order, and a column of Product IDs for products
that have never been ordered.

  -- Each row with a Customer ID should have a NULL product ID (because the customer has never ordered a product) and
     each row with a Product ID should have a NULL customer ID (because the product has never been ordered by a
     customer).
*/

SELECT
  C.CustomerID,
  P.ProductID
FROM SalesLT.Customer AS C
  FULL OUTER JOIN SalesLT.SalesOrderHeader AS OH
    ON C.CustomerID = OH.CustomerID
  FULL OUTER JOIN SalesLT.SalesOrderDetail AS OD
    ON OH.SalesOrderID = OD.SalesOrderID
  FULL OUTER JOIN SalesLT.Product AS P
    ON OD.ProductID = P.ProductID
WHERE OH.SalesOrderID IS NULL
ORDER BY P.ProductID, C.CustomerID;