
-----------------------------------------------------------------------------------------------------------------------
                                               --//-- [Lab 1] --\\--
-----------------------------------------------------------------------------------------------------------------------

                                          --------------------------------
                                           -- RETRIEVING CUSTOMER DATA --
                                          --------------------------------

/*
AdventureWorks Cycles is a company that sells directly to retailers, who then sell products to consumers. Each
retailer that is an AdventureWorks customer has provided a named contact for all communication from AdventureWorks.

The sales manager at AdventureWorks has asked you to generate some reports containing details of the company's
customers to support a direct sales campaign. Let's start with some basic exploration.

Familiarize yourself with the Customer table by writing a Transact-SQL query that retrieves all columns for
all customers.
*/

SELECT *
FROM SalesLT.Customer;

                                      ----------------------------------------
                                       -- CREATE LIST OF CUSTOMER CONTACTS --
                                      ----------------------------------------

/*
Create a table that lists all customer contact names. The table will include the Title, FirstName, MiddleName,
LastName and Suffix of all customers.
*/

SELECT Title, FirstName, MiddleName, LastName, Suffix
FROM SalesLT.Customer;

/*
-- List the following elements for all customers:
   -- The salesperson
   -- A column named CustomerName that displays how the customer contact should be greeted (e.g. "Mr Smith")
   -- The customer's phone number
*/

SELECT SalesPerson,Title + ' ' + LastName AS CustomerName, Phone
FROM SalesLT.Customer;

                                   ------------------------------------------
                                    -- RETRIEVING CUSTOMER AND SALES DATA --
                                   ------------------------------------------

/*
List all customer companies in the format <Customer ID>: <Company Name> [e.g. 78: Preferred Bikes]
*/

SELECT CAST(CustomerID AS VARCHAR) + ': ' + CompanyName AS CustomerCompany
FROM SalesLT.Customer;

/*
Create a two-column table that shows:
  -- Sales order number and revision number in the format <Order Number> (<Revision>); [e.g. SO71774 (2)]
  -- The order date converted to ANSI standard format yyyy.mm.dd [e.g. 2015.01.31]
*/

SELECT SalesOrderNumber + ' (' + STR(RevisionNumber, 1) + ')' AS  OrderRevision,
  CONVERT(NVARCHAR(30), OrderDate, 102) AS OrderDate
FROM SalesLT.SalesOrderHeader;

                                     -----------------------------------------
                                      -- RETRIEVING CUSTOMER CONTACT NAMES --
                                     -----------------------------------------

/*
Create a list that contains customers' names in the format <First Name> <Last Name> [e.g. Kieth Harris] if the middle
name is unknown and in the format <First Name> <Middle Name> <Last Name> [e.g. Jane M. Gates] is the middle name is
stored in the database
*/

SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName AS CustomerName
FROM SalesLT.Customer;

                                    ------------------------------------------
                                     -- RETRIEVING PRIMARY CONTACT DETAILS --
                                    ------------------------------------------

/*
Create a two column list containing:
  -- The Customer ID
  -- The customer's primary contact method
      -- The customer's email address should be used as primary contact but if a customer does not have an email
         address in our database, we will populate this column with their phone number

~~~ Our test database does not have any missing email addresses, so we will have to remove some in order to check
if our query is written properly ~~~
*/

-- Removal of some customers' email addresses

UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;

-- Creation of two column list

SELECT CustomerID, COALESCE(EmailAddress, Phone) AS PrimaryContact
FROM SalesLT.Customer;

                                       ----------------------------------
                                        -- RETRIEVING SHIPPING STATUS --
                                       ----------------------------------

/*
Create a three-column list containing:
  -- The Sales Order ID
  -- The Order Date
  -- A column named ShippingStatus which contains the word 'Shipped' if an order has a value for Ship Date
     and the words 'Awaiting Shipment' if the order has a NULL for Ship Date.

~~~ Our test database does not have any missing Ship Dates, so we will have to remove some in order to check
if our query is written properly ~~~
*/

-- Removal of some of the Ship Dates

UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899

--Creation of List

SELECT SalesOrderID, OrderDate,
  CASE
    WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
    ELSE 'Shipped'
  END AS ShippingStatus
FROM SalesLT.SalesOrderHeader;