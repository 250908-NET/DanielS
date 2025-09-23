-- SETUP:
    -- Create a database server (docker)
        -- docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<password>" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2022-latest
    -- Connect to the server (Azure Data Studio / Database extension)
    -- Test your connection with a simple query (like a select)
    -- Execute the Chinook database (to create Chinook resources in your db)



-- On the Chinook DB, practice writing queries with the following exercises

-- BASIC CHALLENGES
-- List all customers (full name, customer id, and country) who are not in the USA
SELECT "FirstName", "LastName", "CustomerId", "Country"
FROM Customer
WHERE "Country" <> 'USA';

-- List all customers from Brazil
SELECT *
FROM "Customer"
WHERE "Country" = 'Brazil';

-- List all sales agents
SELECT *
FROM "Employee"
WHERE Title LIKE '%sales%agent%';

-- Retrieve a list of all countries in billing addresses on invoices
SELECT DISTINCT "BillingCountry"
FROM "Invoice";

-- Retrieve how many invoices there were in 2009, and what was the sales total for that year?
SELECT COUNT(*) AS 'Count', SUM("Total") AS 'Sales Total'
FROM "Invoice"
WHERE YEAR("InvoiceDate") = 2009;

    -- (challenge: find the invoice count sales total for every year using one query)
SELECT YEAR("InvoiceDate") AS 'Year', COUNT(*) AS 'Count', SUM("Total") AS 'Sales Total'
FROM "Invoice"
GROUP BY YEAR("InvoiceDate");

-- how many line items were there for invoice #37
SELECT COUNT(*)
FROM "InvoiceLine"
WHERE "InvoiceId" = 37;

-- how many invoices per country? BillingCountry  # of invoices -
SELECT "BillingCountry", COUNT(*)
FROM "Invoice"
GROUP BY "BillingCountry";

-- Retrieve the total sales per country, ordered by the highest total sales first.
SELECT "BillingCountry", SUM("Total") AS 'Total Sales'
FROM "Invoice"
GROUP BY "BillingCountry"
ORDER BY 'Total Sales' desc;


-- JOINS CHALLENGES
-- Every Album by Artist
SELECT Album.Title AS "Album Title", Artist.Name as "Artist Name"
FROM "Album" JOIN "Artist"
ON "Album"."ArtistId" = "Artist"."ArtistId";

-- All songs of the rock genre
SELECT Track.Name AS 'Track Name', Genre.Name AS 'Genre'
FROM "Track" JOIN "Genre"
ON Track.GenreId = Genre.GenreId
WHERE Genre.Name = 'Rock';

-- Show all invoices of customers from brazil (mailing address not billing)
SELECT Customer.Country, Invoice.*
FROM Invoice JOIN Customer
ON Invoice.CustomerId = Customer.CustomerId
WHERE Customer.Country = 'Brazil';

-- Show all invoices together with the name of the sales agent for each one
SELECT Employee.FirstName AS "SA first name", Employee.LastName AS "SA last name", Invoice.*
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
JOIN Employee ON Customer.SupportRepId = Employee.EmployeeId;

-- Which sales agent made the most sales in 2009?
WITH MostSales AS (
    SELECT e.FirstName, e.LastName, "Total Sales"
    FROM Employee AS e JOIN (
        SELECT Employee.EmployeeId, SUM(Invoice.Total) AS "Total Sales"
        FROM Invoice
        JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
        JOIN Employee ON Customer.SupportRepId = Employee.EmployeeId
        GROUP BY Employee.EmployeeId
    ) AS sales
    ON e."EmployeeId" = sales."EmployeeId"
)
SELECT *
FROM MostSales
WHERE "Total Sales" = (SELECT Max("Total Sales") FROM MostSales);

-- How many customers are assigned to each sales agent?
SELECT Employee."FirstName", Employee."LastName", COUNT(*) AS "Number of Customers"
FROM Customer JOIN Employee
ON Customer."SupportRepId" = Employee."EmployeeId"
GROUP BY Employee."FirstName", Employee."LastName";

-- Which track was purchased the most ing 20010?
WITH Purchases AS (
    SELECT InvoiceLine."TrackId", Track."Name", SUM(InvoiceLine."Quantity") AS NumberSold
    FROM InvoiceLine
        JOIN Invoice ON InvoiceLine."InvoiceId" = Invoice."InvoiceId"
        JOIN Track ON InvoiceLine."TrackId" = Track."TrackId"
    WHERE YEAR(Invoice."InvoiceDate") = 2010
    GROUP BY InvoiceLine."TrackId", Track."Name"
)
SELECT *
FROM "Purchases"
WHERE NumberSold = (SELECT MAX(NumberSold) FROM Purchases);

-- Show the top three best selling artists.
SELECT Artist.ArtistId, Artist.Name, SUM(InvoiceLine.Quantity) AS TracksSold
-- FROM Artist, Album, Track, InvoiceLine
FROM InvoiceLine
    JOIN Track ON InvoiceLine.TrackId = Track.TrackId
    JOIN Album ON Track.AlbumId = Album.AlbumId
    JOIN Artist ON Album.ArtistId = Artist.ArtistId
GROUP BY Artist.ArtistId, Artist.Name
ORDER BY TracksSold desc
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

-- Which customers have the same initials as at least one other customer?
SELECT c1."FirstName", c1."LastName"
FROM Customer AS c1 JOIN Customer AS c2
ON SUBSTRING(c1.FirstName, 1, 1) = SUBSTRING(c2.FirstName, 1, 1)
AND SUBSTRING(c1.LastName, 1, 1) = SUBSTRING(c2.LastName, 1, 1)
AND c1.CustomerId <> c2.CustomerId;



-- ADVACED CHALLENGES
-- solve these with a mixture of joins, subqueries, CTE, and set operators.
-- solve at least one of them in two different ways, and see if the execution
-- plan for them is the same, or different.

-- 1. which artists did not make any albums at all?
SELECT *
FROM Artist
WHERE ArtistId NOT IN (SELECT ArtistId FROM Album);

-- 2. which artists did not record any tracks of the Latin genre?

-- 3. which video track has the longest length? (use media type table)

-- 4. find the names of the customers who live in the same city as the
--    boss employee (the one who reports to nobody)

-- 5. how many audio tracks were bought by German customers, and what was
--    the total price paid for them?

-- 6. list the names and countries of the customers supported by an employee
--    who was hired younger than 35.


-- DML exercises

-- 1. insert two new records into the employee table.
INSERT INTO Employee (EmployeeId, LastName, FirstName, Title)
VALUES (9, 'Last1', 'First1', 'Title1'),
    (10, 'Last2', 'First2', 'Title2');
-- SELECT * FROM Employee ORDER BY EmployeeId ASC;

-- 2. insert two new records into the tracks table.
INSERT INTO Track (TrackId, Name, MediaTypeId, Milliseconds, UnitPrice)
VALUES (3504, 'Track1', 1, 180000, 1.00),
    (3505, 'Track2', 5, 150000, 2.00);
-- SELECT * FROM Track ORDER BY TrackId DESC;

-- 3. update customer Aaron Mitchell's name to Robert Walter
UPDATE Customer
SET FirstName = 'Robert',
    LastName = 'Walter'
WHERE Customer.FirstName = 'Aaron' AND Customer.LastName = 'Mitchell';
-- SELECT * FROM Customer WHERE Customer.FirstName = 'Aaron' AND Customer.LastName = 'Mitchell';
-- SELECT * FROM Customer WHERE Customer.FirstName = 'Robert' AND Customer.LastName = 'Walter';

-- 4. delete one of the employees you inserted.
DELETE FROM Employee
WHERE EmployeeId = 10;
-- SELECT * FROM Employee WHERE EmployeeId = 10;

-- 5. delete customer Robert Walter.
DELETE FROM Customer
WHERE FirstName = 'Robert' AND LastName = 'Walter';
-- SELECT * FROM Customer WHERE FirstName = 'Robert' AND LastName = 'Walter';
