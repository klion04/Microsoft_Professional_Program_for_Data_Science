
------------------------------------------------------------------------------------------------------------------------
                                               --//-- [Lab 6] --\\--
------------------------------------------------------------------------------------------------------------------------

                                    --------------------------------------------
                                     -- RETRIEVING PRODUCT PRICE INFORMATION --
                                    --------------------------------------------
/*
Retrieve the product ID, name, and list price for each product where the list price is higher than the average unit
price for all products that have been sold.
*/

SELECT
  ProductID,
  Name,
  ListPrice
FROM SalesLT.Product
WHERE ListPrice >
      (SELECT AVG(UnitPrice)
       FROM SalesLT.SalesOrderDetail)
ORDER BY ProductID;

/*
Retrieve the product ID, name, and list price for each product where the list price is 100 or more, and the product
has been sold for (strictly) less than 100.
*/

SELECT
  ProductID,
  Name,
  ListPrice
FROM SalesLT.Product
WHERE ProductID IN
      (SELECT SOD.ProductID
       FROM SalesLT.SalesOrderDetail AS SOD
       WHERE UnitPrice < 100)
      AND ListPrice >= 100
ORDER BY ProductID;

/*
Retrieve the product ID, name, cost, and list price for each product along with the average unit price for which that
product has been sold.
*/

SELECT
  ProductID,
  Name,
  StandardCost,
  ListPrice,
  (SELECT AVG(UnitPrice)
   FROM SalesLT.SalesOrderDetail AS SOD
   WHERE P.ProductID = SOD.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS P
ORDER BY P.ProductID;

/*
Filter the previous query to include only products where the cost is higher than the average selling price.
*/

SELECT
  ProductID,
  Name,
  StandardCost,
  ListPrice,
  (SELECT AVG(UnitPrice)
   FROM SalesLT.SalesOrderDetail AS SOD
   WHERE P.ProductID = SOD.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS P
WHERE StandardCost >
      (SELECT AVG(UnitPrice)
       FROM SalesLT.SalesOrderDetail AS SOD
       WHERE P.ProductID = SOD.ProductID)
ORDER BY P.ProductID;

                                      ---------------------------------------
                                       -- RETRIEVING CUSTOMER INFORMATION --
                                      ---------------------------------------

/*
Retrieve the sales order ID, customer ID, first name, last name, and total due for all sales orders from the
Sales Order Header table and the dbo.ufnGetCustomerInformation function.
*/

SELECT
  SOH.SalesOrderID,
  SOH.CustomerID,
  CI.FirstName,
  CI.LastName,
  SOH.TotalDue
FROM SalesLT.SalesOrderHeader AS SOH
  CROSS APPLY dbo.ufnGetCustomerInformation(SOH.CustomerID) AS CI
ORDER BY SOH.SalesOrderID;

/*
Retrieve the customer ID, first name, last name, address line 1 and city for all customers from the Address and
Customer Address tables, using the dbo.ufnGetCustomerInformation function.
*/

SELECT
  CA.CustomerID,
  CI.FirstName,
  CI.LastName,
  A.AddressLine1,
  A.City
FROM SalesLT.Address AS A
  JOIN SalesLT.CustomerAddress AS CA
    ON A.AddressID = CA.AddressId
  CROSS APPLY dbo.ufnGetCustomerInformation(CA.AddressID) AS CI
ORDER BY CA.CustomerID;