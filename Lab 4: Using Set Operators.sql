------------------------------------------------------------------------------------------------------------------------
                                               --//-- [Lab 4] --\\--
------------------------------------------------------------------------------------------------------------------------

                                       -------------------------------------
                                        -- RETRIEVING CUSTOMER ADDRESSES --
                                       -------------------------------------

/*
Retrieves the Company Name, first line of the street Address, City, and a column named AddressType with the value
'Billing' for Customers where the Address Type in the Customer Address table is 'Main Office'.
*/

SELECT
  C.CompanyName,
  A.AddressLine1,
  A.City,
  'Billing' AS AddressType
FROM SalesLT.Customer AS C
  JOIN SalesLT.CustomerAddress AS CA
    ON C.CustomerID = CA.CustomerID
  JOIN SalesLT.Address AS A
    ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Main Office';

/*
Retrieves the Company Name, first line of the street Address, City, and a column named AddressType with the value
'Shipping' for Customers where the Address Type in the Customer Address table is 'Shipping'.
*/

SELECT
  C.CompanyName,
  A.AddressLine1,
  A.City,
  'Shipping' AS AddressType
FROM SalesLT.Customer AS C
  JOIN SalesLT.CustomerAddress AS CA
    ON C.CustomerID = CA.CustomerID
  JOIN SalesLT.Address AS A
    ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Shipping';

/*
UNION ALL is used to combine the results returned by the two queries to create a list of all customer addresses that
is sorted by Company name and then Address Type.
*/

SELECT
  C.CompanyName,
  A.AddressLine1,
  A.City,
  'Billing' AS AddressType
FROM SalesLT.Customer AS C
  JOIN SalesLT.CustomerAddress AS CA
    ON C.CustomerID = CA.CustomerID
  JOIN SalesLT.Address AS A
    ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Main Office'
UNION ALL
SELECT
  C.CompanyName,
  A.AddressLine1,
  A.City,
  'Shipping' AS AddressType
FROM SalesLT.Customer AS C
  JOIN SalesLT.CustomerAddress AS CA
    ON C.CustomerID = CA.CustomerID
  JOIN SalesLT.Address AS A
    ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Shipping';

                                       ------------------------------------
                                        -- FILTERING CUSTOMER ADDRESSES --
                                       ------------------------------------

/*
Returns the Company Name of each company that appears in a table of Customers with a 'Main Office' Address, but not
in a table of Customers with a 'Shipping' Address.
*/

SELECT C.CompanyName
FROM SalesLT.Customer AS C
  JOIN SalesLT.CustomerAddress AS CA
    ON C.CustomerID = CA.CustomerID
  JOIN SalesLT.Address AS A
    ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Main Office'
EXCEPT
SELECT C.CompanyName
FROM SalesLT.Customer AS C
  JOIN SalesLT.CustomerAddress AS CA
    ON C.CustomerID = CA.CustomerID
  JOIN SalesLT.Address AS A
    ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Shipping';

/*
Returns the Company Name of each company that appears in a table of Customers with a 'Main Office' Address, and also
in a table of Customers with a 'Shipping' Address
*/

SELECT C.CompanyName
FROM SalesLT.Customer AS C
  JOIN SalesLT.CustomerAddress AS CA
    ON C.CustomerID = CA.CustomerID
  JOIN SalesLT.Address AS A
    ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Main Office'
INTERSECT
SELECT C.CompanyName
FROM SalesLT.Customer AS C
  JOIN SalesLT.CustomerAddress AS CA
    ON c.CustomerID = CA.CustomerID
  JOIN SalesLT.Address AS A
    ON CA.AddressID = A.AddressID
WHERE CA.AddressType = 'Shipping';