
------------------------------------------------------------------------------------------------------------------------
                                               --//-- [Lab 8] --\\--
------------------------------------------------------------------------------------------------------------------------

                                      ----------------------------------------
                                       -- RETRIEVING REGIONAL SALES TOTALS --
                                      ----------------------------------------

/*
Retrieves the Country, State / Province, and Revenue for each country
*/

SELECT
  A.CountryRegion,
  A.StateProvince,
  SUM(SOH.TotalDue) AS Revenue
FROM SalesLT.Address AS A
  JOIN SalesLT.CustomerAddress AS CA
    ON A.AddressID = CA.AddressID
  JOIN SalesLT.Customer AS C
    ON CA.CustomerID = C.CustomerID
  JOIN SalesLT.SalesOrderHeader AS SOH
    ON C.CustomerID = SOH.CustomerID
GROUP BY A.CountryRegion, A.StateProvince
ORDER BY A.CountryRegion, A.StateProvince;

/*
Retrieves a grand total for all sales revenue and a subtotal for each Country in addition to the State / Province
subtotals that are already returned.
*/

SELECT
  A.CountryRegion,
  A.StateProvince,
  SUM(SOH.TotalDue) AS Revenue
FROM SalesLT.Address AS A
  JOIN SalesLT.CustomerAddress AS CA
    ON A.AddressID = CA.AddressID
  JOIN SalesLT.Customer AS C
    ON CA.CustomerID = C.CustomerID
  JOIN SalesLT.SalesOrderHeader AS SOH
    ON C.CustomerID = SOH.CustomerID
GROUP BY ROLLUP(A.CountryRegion, A.StateProvince)
ORDER BY A.CountryRegion, A.StateProvince;

/*
Adds a column called level that indicates at which level in the total, Country and State / Province hierarchy the
revenue figure in the row is aggregated.
*/

SELECT
  A.CountryRegion,
  A.StateProvince,
  IIF(GROUPING_ID(A.CountryRegion) = 1 AND GROUPING_ID(A.StateProvince) = 1, 'Total',
      IIF(GROUPING_ID(A.StateProvince) = 1, A.CountryRegion + ' Subtotal', A.StateProvince + ' Subtotal')) AS Level,
  SUM(SOH.TotalDue)                                                                                        AS Revenue
FROM SalesLT.Address AS A
  JOIN SalesLT.CustomerAddress AS CA
    ON A.AddressID = CA.AddressID
  JOIN SalesLT.Customer AS C
    ON CA.CustomerID = C.CustomerID
  JOIN SalesLT.SalesOrderHeader AS SOH
    ON C.CustomerID = SOH.CustomerID
GROUP BY ROLLUP(A.CountryRegion, A.StateProvince)
ORDER BY A.CountryRegion, A.StateProvince;

/*
Extends the above query to include a grouping for individual cities
*/

SELECT
  A.CountryRegion,
  A.StateProvince,
  A.City,
  CHOOSE(1 + GROUPING_ID(A.CountryRegion) + GROUPING_ID(A.StateProvince) + GROUPING_ID(A.City),
         A.City + ' Subtotal', A.StateProvince + ' Subtotal',
         A.CountryRegion + ' Subtotal', 'Total') AS Level,
  SUM(SOH.TotalDue)                              AS Revenue
FROM SalesLT.Address AS A
  JOIN SalesLT.CustomerAddress AS CA
    ON A.AddressID = CA.AddressID
  JOIN SalesLT.Customer AS C
    ON CA.CustomerID = C.CustomerID
  JOIN SalesLT.SalesOrderHeader AS SOH
    ON C.CustomerID = SOH.CustomerID
GROUP BY ROLLUP(A.CountryRegion, A.StateProvince, A.City)
ORDER BY A.CountryRegion, A.StateProvince, A.City;

                                    ---------------------------------------------
                                     -- RETRIEVING CUSTOMER SALES BY CATEGORY --
                                    ---------------------------------------------

/*
Retrieve a list of customer company names together with their total revenue for each parent category in Accessories,
Bikes, Clothing, and Components.
*/

SELECT *
FROM
    (SELECT
       CAT.ParentProductCategoryName,
       CUST.CompanyName,
       SOD.LineTotal
     FROM SalesLT.SalesOrderDetail AS SOD
       JOIN SalesLT.SalesOrderHeader AS SOH ON SOD.SalesOrderID = SOH.SalesOrderID
       JOIN SalesLT.Customer AS CUST ON SOH.CustomerID = CUST.CustomerID
       JOIN SalesLT.Product AS PROD ON SOD.ProductID = PROD.ProductID
       JOIN SalesLT.vGetAllCategories AS CAT ON PROD.ProductcategoryID = CAT.ProductCategoryID) AS catsales
  PIVOT (SUM(LineTotal) FOR ParentProductCategoryName
  IN ([Accessories], [Bikes], [Clothing], [Components])) AS pivotedsales
ORDER BY CompanyName;