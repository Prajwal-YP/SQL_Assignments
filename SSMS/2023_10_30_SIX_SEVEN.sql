CREATE DATABASE [Bank];

USE [Bank];

CREATE TABLE [AccountType](
[AccType] INT PRIMARY KEY,
[AccName] VARCHAR(50) NOT NULL);

CREATE TABLE [CustomerDetails](
[CusAccNo] INT PRIMARY KEY,
[CusName] VARCHAR(50) NOT NULL,
[CusAddress] VARCHAR(50) NOT NULL,
[CusAccType] INT FOREIGN KEY REFERENCES [AccountType]([AccType]));

CREATE TABLE [TransactionType](
[TransType] INT PRIMARY KEY,
[TransName] VARCHAR(50));

CREATE TABLE [AccountTransaction](
[TransId] INT PRIMARY KEY,
[AccNo] INT FOREIGN KEY REFERENCES [CustomerDetails]([CusAccNo]),
[Amount] [Money] NOT NULL,
[DateOfTrans] DATETIME NOT NULL,
[TransType] INT FOREIGN KEY REFERENCES [TransactionType]([TransType]));

--______________________________________________________________________________________

SELECT * FROM [AccountType]
SELECT * FROM [CustomerDetails]
SELECT * FROM [TransactionType]
SELECT * FROM [AccountTransaction]

--______________________________________________________________________________________
INSERT INTO [AccountType] VALUES
( 1, 'Savings Account'),
( 2, 'Current Account'),
( 3, 'Fixed Deposit Account');

INSERT INTO [AccountType] VALUES
( 4, 'Investment Account');

INSERT INTO [TransactionType] VALUES
(1, 'Deposit'),
(2, 'Withdrawal');

INSERT INTO [CustomerDetails] VALUES
(101, 'John Doe', '123 Main St,Mysore', 1),  -- Savings Account
(102, 'Alice Smith', '456 Elm St,Banglore', 2),  -- Current Account
(103, 'Bob Johnson', '123 Main St,Mysore', 1),  -- Savings Account
(104, 'Eva Green', '101 Pine St,Banglore', 3);   -- Fixed Deposit

INSERT INTO [CustomerDetails] VALUES
(105, 'Prajwal', '123 Main St,Mysore', 1);  -- Savings Account

INSERT INTO [CustomerDetails] VALUES
(106, 'Pavithra', '123 Main St,Mysore', 1);  -- Savings Account

INSERT INTO [AccountTransaction] VALUES
(1001, 101, 1000.00, '2023-10-15 10:30:00', 1),  -- Deposit
(1002, 102, 500.00, '2023-10-15 11:15:00', 1),  -- Deposit
(1003, 103, 750.00, '2023-10-16 09:45:00', 1),  -- Deposit
(1004, 104, 2000.00, '2023-10-16 14:30:00', 1), -- Deposit
(1005, 101, 200.00, '2023-10-17 13:20:00', 2),  -- Withdrawal
(1006, 102, 300.00, '2023-10-18 08:45:00', 2),  -- Withdrawal
(1007, 101, 1500.00, '2023-10-18 16:00:00', 1), -- Deposit
(1008, 104, 100.00, '2023-10-19 12:30:00', 1),  -- Deposit
(1009, 102, 1000.00, '2023-10-19 14:15:00', 1), -- Deposit
(1010, 103, 300.00, '2023-10-20 10:30:00', 2), -- Withdrawal
(1011, 101, 250.00, '2023-10-20 17:45:00', 2), -- Withdrawal
(1012, 102, 700.00, '2023-10-21 15:20:00', 1); -- Deposit
INSERT INTO [AccountTransaction] VALUES
(1013, 105, 1000.00, '2023-10-15 10:30:00', 2);
--______________________________________________________________________________________
--	ASSIGNMENT QUESTIONS

--1.List the Customer with transaction details who has done third lowest transaction 

SELECT DISTINCT TOP 1 WITH TIES 
	[CusAccNo],[CusName],[Amount]
FROM 
	[AccountTransaction] [T]
	INNER JOIN [CustomerDetails] [C] 
		ON [T].[AccNo]=[C].[CusAccNo]
WHERE 
	[Amount] NOT IN (
		SELECT DISTINCT TOP 2 
			[Amount]
		FROM 
			[AccountTransaction]
		ORDER BY 
			[Amount])
ORDER BY 
	[Amount];

--______________________________________________________________________________________
--2.List the customers who has done more transactions than average number of transaction  

SELECT * FROM [CustomerDetails]
SELECT [AccNo], COUNT([TransId]) FROM [AccountTransaction] GROUP BY [AccNo]

SELECT 
	[CusName]
FROM 
	[CustomerDetails] [C]
	INNER JOIN [AccountTransaction] [T] 
		ON [C].[CusAccNo]=[T].[AccNo]
GROUP BY 
	[CusName]
HAVING 
	COUNT([TransId])>(
		SELECT 
			AVG([NumOfTrans]) 
		FROM (
			SELECT 
				COUNT([TransId]) AS [NumOfTrans] 
			FROM 
				[AccountTransaction] 
			GROUP BY 
				[AccNo]) AS [AvgNumOfTrans])
ORDER BY 
	[CusName];
--______________________________________________________________________________________
--3.List the total transactions under each account type. 

SELECT 
	[AccName], COUNT([TransId]) [NumOfTrans]
FROM 
	[AccountType] [A]
	LEFT OUTER JOIN [CustomerDetails] [C] 
		ON [A].[AccType] = [C].[CusAccType]
	INNER JOIN [AccountTransaction] [T] 
		ON [C].[CusAccNo]=[T].[AccNo]
GROUP BY 
	[A].[AccType],[AccName];

--______________________________________________________________________________________
--4.List the total amount of transaction under each account type 
SELECT 
	[AccName], ISNULL(SUM([Amount]),0) [TotalAmount]
FROM 
	[AccountType] [A]
	LEFT OUTER JOIN [CustomerDetails] [C] 
		ON [A].[AccType] = [C].[CusAccType]
	LEFT OUTER JOIN [AccountTransaction] [T] 
		ON [C].[CusAccNo]=[T].[AccNo]
GROUP BY 
	[A].[AccType],[AccName];

--______________________________________________________________________________________
--5.List the total tranctions along with the total amount on a Sunday. 

SELECT 
	[DateOfTrans], COUNT([TransId]) AS [NumOfTrans], SUM([TransId]) AS [TotalAmount]
FROM 
	[AccountTransaction] 
WHERE 
	DATENAME(DW,[DateOfTrans])='Sunday'
GROUP BY 
	[DateOfTrans];


--______________________________________________________________________________________
--6.List the name, address, account type and total deposit from each customer account. 

--SELECT * FROM [CustomerDetails]
--SELECT * FROM [AccountTransaction]

SELECT 
	[CusName], [CusAddress], [CusAccNo], [TransName], ISNULL([Total Deposit],0)
FROM
	[CustomerDetails] [C]
	LEFT OUTER JOIN (
		SELECT 
			[AccNo],[TransName], SUM([Amount]) [Total Deposit]
		FROM
			[AccountTransaction] [A]
			INNER JOIN [TransactionType] [T]
				ON [A].[TransType]=[T].[TransType]
		WHERE 
			[TransName] IN ('Deposit')
		GROUP BY 
			[AccNo],[TransName]) AS [tblDeposit]
			ON [C].[CusAccNo]=[tblDeposit].[AccNo];
--					OR
SELECT 
	[CusName], [CusAddress], [AccName], [TransName], SUM([Amount]) [Total Deposit]
FROM 
	[CustomerDetails] [C]
	LEFT OUTER JOIN [AccountType] [A] 
		ON [C].[CusAccType]=[A].[AccType]
	LEFT OUTER JOIN [AccountTransaction] [T] 
		ON [C].[CusAccNo]=[T].[AccNo]
	LEFT OUTER JOIN [TransactionType] [Ttype] 
		ON [T].[TransType]=[Ttype].[TransType]
GROUP BY 
	[CusAccNo],[CusName], [CusAddress], [AccName],[TransName]
	HAVING [TransName] IN ('Deposit');

--______________________________________________________________________________________
--7.List the total amount of transactions of Mysore customers. 
SELECT * FROM [CustomerDetails]

SELECT 
	[CusName], SUM([Amount]) AS [Total Amount]
FROM 
	[CustomerDetails] [C]
	INNER JOIN [AccountTransaction] [T] 
		ON [C].[CusAccNo]=[T].[AccNo]
WHERE 
	[CusAddress] LIKE '%mysore%'
GROUP BY 
	[CusName]

--______________________________________________________________________________________
--8.List the name,account type and the number of transactions performed by each customer. 
SELECT 
	[CusName], [AccName], COUNT(TransId) AS [NumOfTrans]
FROM 
	[CustomerDetails] [C]
	INNER JOIN [AccountType] [A] 
		ON [C].[CusAccType]=[A].[AccType]
	LEFT OUTER JOIN [AccountTransaction] [T] 
		ON [C].[CusAccNo]=[T].[AccNo]
GROUP BY 
	[CusName], [AccName]

--______________________________________________________________________________________
--9.List the amount of transaction from each Location. 

SELECT [CusAddress], SUM([Amount]) AS [TotalAmount]
FROM [CustomerDetails] [C]
INNER JOIN [AccountTransaction] [T] ON [C].[CusAccNo]=[T].[AccNo]
GROUP BY [CusAddress]
--______________________________________________________________________________________
--10.Find out the number of customers Under Each Account Type 

SELECT [AccName], COUNT([CusAccNo]) AS [NumOfCus]
FROM [CustomerDetails] [C]
INNER JOIN [AccountType] [A] ON [C].[CusAccType]=[A].[AccType]
GROUP BY [AccName]
--______________________________________________________________________________________

--Consider following tables  
---------------------------
CREATE DATABASE [SalesDB];

USE [SalesDB];

--Salesman (Smid, Sname, Location) 
CREATE TABLE [Salesman](
[SmId] INT PRIMARY KEY,
[SmName] VARCHAR(50) NOT NULL,
[SmLocation] VARCHAR(50) NOT NULL);

INSERT INTO [Salesman] 
VALUES
(1,'John Smith','New York'),
(2,'Alice Johnson','Los Angeles'),
(3,'Bob Davis','Chicago'),
(4,'Eve Brown','San Francisco'),
(5,'David Greem','Mexico');


--Product (Prodid, Pdesc, Price, Category, Discount) 
CREATE TABLE [Product](
[ProdId] INT PRIMARY KEY,
[ProdDesc] VARCHAR(50) NOT NULL,
[ProdPrice] MONEY NOT NULL,
[ProdCategory] VARCHAR(50) NOT NULL,
[Discount] MONEY NOT NULL);

INSERT INTO [Product]
VALUES
(1, 'Smartphone', 500.00, 'Electronics', 50.00),
(2, 'Jeans', 40.00, 'Clothing', 5.00),
(3, 'Laptop', 1000.00, 'Electronics', 100.00),
(4, 'Chocolate Bar', 2.00, 'Food', 0.25),
(5, 'T-Shirt', 20.00, 'Clothing', 2.50);

--Sale (Saleid, Smid, Sldate, Amount) 
CREATE TABLE [Sale](
[SaleId] INT PRIMARY KEY,
[SmId] INT NOT NULL,
[SaleDate] DATETIME NOT NULL,
[Amount] MONEY NOT NULL,
CONSTRAINT FK_Sale_Salesman_SmId FOREIGN KEY([SmId]) REFERENCES [Salesman]([SmId]));

INSERT INTO [Sale]
VALUES
(1, 1, '2023-01-10', 450.00),
(2, 2, '2023-02-15', 35.00),
(3, 3, '2023-03-20', 900.00),
(4, 4, '2023-04-25', 1.75),
(5, 1, '2023-05-05', 1000.00),
(6, 2, '2023-06-10',20.00 ),
(7, 3, '2023-07-15', 875.00),
(8, 4, '2023-08-20', 1.50),
(9, 1, '2023-09-25', 360.00),
(10, 2, '2023-10-30', 42.50);


--Saledetail (Saleid, Prodid, Quantity) 
CREATE TABLE [SaleDetail](
[SaleId] INT NOT NULL,
[ProdId] INT NOT NULL,
[Quantity] INT NOT NULL,
CONSTRAINT FK_SaleDetail_Sale_SaleId FOREIGN KEY([SaleId]) REFERENCES [Sale]([SaleId]),
CONSTRAINT FK_SaleDetail_Product_ProId FOREIGN KEY([ProdId]) REFERENCES [Product]([ProdId]),
CONSTRAINT PK_SaleId_ProId PRIMARY KEY([SaleId],[ProdId]));

INSERT INTO [SaleDetail]
VALUES
(1,  1, 2),
(1,  2, 3),
(2,  4, 5),
(3,  1, 1),
(4,  2, 4),
(5,  3, 2),
(6,  4, 3),
(7,  5, 2),
(8,  1, 4),
(9,  2, 1),
(10, 3, 3);

--	Write queries for following: 
 

-- SCHEMA
--	Salesman	(Smid,		Sname,	Location) 
--	Product		(Prodid,	Pdesc,	Price,		Category,	Discount) 
--	Sale		(Saleid,	Smid,	Sldate,		Amount) 
--	Saledetail	(Saleid,	Prodid, Quantity) 

SELECT * FROM [Salesman]
SELECT * FROM [Product]
SELECT * FROM [Sale]
SELECT * FROM [SaleDetail]


--	1.	Display the sale id and date for most recent sale. 
SELECT TOP 1 WITH TIES
	[SaleId], [SaleDate]
FROM 
	[Sale]
ORDER BY 
	[SaleDate] DESC;

SET STATISTICS TIME ON

--_________________________________________________________________________________________________________________
--	2.	Display the names of salesmen who have made at least 2 sales. 

--SELECT * FROM [Salesman]
--SELECT * FROM [Product]
--SELECT * FROM [Sale]
--SELECT * FROM [SaleDetail]

SELECT 
	[SmName]
FROM 
	[Salesman]
WHERE 
	[SmId] IN (
		SELECT 
			[SmId]
		FROM 
			[Sale]
		GROUP BY 
			[SmId]
		HAVING 
			COUNT([SaleId])>1);

--_________________________________________________________________________________________________________________
--	3.	Display the product id and description of those products which are sold in minimum total quantity. 

SELECT [ProdId], SUM([Quantity])
FROM [SaleDetail]
GROUP BY [ProdId]

SELECT 
	[ProdId], [ProdDesc]
FROM 
	[Product] [P]
WHERE 
	[ProdId] IN (
		SELECT TOP 1 WITH TIES 
			[ProdId]
		FROM 
			[SaleDetail] [Sd]
		GROUP BY 
			[ProdId]
		ORDER BY 
			SUM([Quantity]));
--_________________________________________________________________________________________________________________
--	4.	Display SmId, SmName and Location of those salesmen who have total sales 
--		amount greater than average sales amount of all the sales made. Amount can 
--		be calculated from Price and Discount of Product and Quantity sold. 

--SELECT * FROM [Salesman]
--SELECT * FROM [Product]
--SELECT * FROM [Sale]
--SELECT * FROM [SaleDetail]

--Amount = (Price-Discount) * Quantity

UPDATE [Sale]
SET [Amount] = (
	SELECT
		[Amt]
	FROM (
		SELECT 
			[S].[SaleId] ,[S].[SmId],SUM((P.[ProdPrice] - P.[Discount]) * SD.[Quantity]) [Amt]
		FROM 
			[Sale] [S]
		INNER JOIN [SaleDetail] [SD] 
			ON S.[SaleId] = SD.[SaleId]
		INNER JOIN [Product] [P] 
			ON SD.[ProdId] = P.[ProdId]
		GROUP BY 
			[S].[SaleId], [S].[SmId]) AS [OpTbl]
	WHERE
		[Sale].[SaleId]=[OpTbl].[SaleId]);

--Used along wit the trigger after inserting to Salesdetails table

----------
SELECT * FROM [Sale]
SELECT AVG([Amount]) FROM [Sale]
----------
--ANSWER
SELECT 
	[Sm].[SmId], [SmName], [SmLocation]
FROM 
	[Salesman] [Sm]
	INNER JOIN [Sale] [S] 
		ON [Sm].[SmId]=[S].[SmId]
GROUP BY 
	[Sm].[SmId], [SmName], [SmLocation]
HAVING 
	SUM([Amount])>(
		SELECT 
			AVG([Amount])
		FROM 
			[Sale]);

--_________________________________________________________________________________________________________________
-- 5.	Display the product id, category, description and price for those products whose 
--		price is maximum in each category. 

--SELECT * FROM [Salesman]
--SELECT * FROM [Product]
--SELECT * FROM [Sale]
--SELECT * FROM [SaleDetail]

SELECT 
	[ProdId],[ProdCategory], [ProdDesc], [ProdPrice] 
FROM 
	[Product] [P1]
WHERE 
	[ProdPrice]=(
		SELECT 
			MAX([ProdPrice])
		FROM 
			[Product] [P2]
		WHERE 
			[P2].[ProdCategory]=[P1].[ProdCategory]);

--_________________________________________________________________________________________________________________
-- 6.	Display the names of salesmen who have not made any sales. 

--SELECT * FROM [Salesman]
--SELECT * FROM [Product]
--SELECT * FROM [Sale]
--SELECT * FROM [SaleDetail]

SELECT 
	[SmName]
FROM 
	[Salesman] [Sm]
WHERE NOT EXISTS(
	SELECT 
		[SaleId]
	FROM 
		[Sale] [S]
	WHERE 
		[S].SmId=[Sm].[SmId]);
--_________________________________________________________________________________________________________________
-- 7.	Display the names of salesmen who have made at least 1 sale in the month of 
--		Jun 2023. 

--SELECT * FROM [Salesman]
--SELECT * FROM [Product]
--SELECT * FROM [Sale]
--SELECT * FROM [SaleDetail]

SELECT 
	[SmName]
FROM 
	[Salesman] [Sm]
WHERE EXISTS(
	SELECT 
		[SaleId]
	FROM 
		[Sale] [S]
	WHERE 
		[Sm].SmId=[S].[SmId] AND DATENAME(MM,[S].[SaleDate])+DATENAME(YYYY,[S].[SaleDate]) = 'June2023');

--_________________________________________________________________________________________________________________
-- 8.	Display SmId, SmName and Location of those salesmen who have total sales amount
--		greater than average total sales amount of their location calculated per salesman. 
--		Amount can be calculated from Price and Discount of Product and Quantity sold. 

SELECT * FROM [Salesman]
SELECT * FROM [Product]
SELECT * FROM [Sale]
SELECT * FROM [SaleDetail]

SELECT 
	[Sm1].[SmId], [SmName], [SmLocation]
FROM 
	[Salesman] [Sm1]
	INNER JOIN [Sale] [S1] 
		ON [Sm1].[SmId]=[S1].[SmId]
GROUP BY 
	[Sm1].[SmId], [SmName], [SmLocation]
HAVING
	SUM([S1].[Amount]) > (
		SELECT 
			AVG([Amount])
		FROM 
			[Salesman] [Sm2]
			INNER JOIN [Sale] [S2] 
				ON [Sm2].[SmId]=[S2].[SmId]
		WHERE
			[Sm2].[SmLocation]=[Sm1].[SmLocation]);
			
--_________________________________________________________________________________________________________________


-- SCHEMA
--	Salesman	(Smid,		Sname,	Location) 
--	Product		(Prodid,	Pdesc,	Price,		Category,	Discount) 
--	Sale		(Saleid,	Smid,	Sldate,		Amount) 
--	Saledetail	(Saleid,	Prodid, Quantity) 

USE [TrainingDB];

--Salesman (Smid, Sname, Location) 
CREATE TABLE [Salesman](
[SmId] INT PRIMARY KEY,
[SmName] VARCHAR(50) NOT NULL,
[SmLocation] VARCHAR(50) NOT NULL);

INSERT INTO [Salesman] 
VALUES
(1,'John Smith','New York'),
(2,'Alice Johnson','Los Angeles'),
(3,'Bob Davis','Chicago'),
(4,'Eve Brown','San Francisco'),
(5,'David Greem','Mexico');


--Product (Prodid, Pdesc, Price, Category, Discount) 
CREATE TABLE [Product](
[ProdId] INT PRIMARY KEY,
[ProdDesc] VARCHAR(50) NOT NULL,
[ProdPrice] MONEY NOT NULL,
[ProdCategory] VARCHAR(50) NOT NULL,
[Discount] MONEY NOT NULL);

INSERT INTO [Product]
VALUES
(1, 'Smartphone', 500.00, 'Electronics', 50.00),
(2, 'Jeans', 40.00, 'Clothing', 5.00),
(3, 'Laptop', 1000.00, 'Electronics', 100.00),
(4, 'Chocolate Bar', 2.00, 'Food', 0.25),
(5, 'T-Shirt', 20.00, 'Clothing', 2.50);

--Sale (Saleid, Smid, Sldate, Amount) 
CREATE TABLE [Sale](
[SaleId] INT PRIMARY KEY,
[SmId] INT NOT NULL,
[SaleDate] DATETIME NOT NULL,
[Amount] MONEY NOT NULL,
CONSTRAINT FK_Sale_Salesman_SmId FOREIGN KEY([SmId]) REFERENCES [Salesman]([SmId]));

INSERT INTO [Sale]
VALUES
(1, 1, '2023-01-10', 450.00),
(2, 2, '2023-02-15', 35.00),
(3, 3, '2023-03-20', 900.00),
(4, 4, '2023-04-25', 1.75),
(5, 1, '2023-05-05', 1000.00),
(6, 2, '2023-06-10',20.00 ),
(7, 3, '2023-07-15', 875.00),
(8, 4, '2023-08-20', 1.50),
(9, 1, '2023-09-25', 360.00),
(10, 2, '2023-10-30', 42.50);


--Saledetail (Saleid, Prodid, Quantity) 
CREATE TABLE [SaleDetail](
[SaleId] INT NOT NULL,
[ProdId] INT NOT NULL,
[Quantity] INT NOT NULL,
CONSTRAINT FK_SaleDetail_Sale_SaleId FOREIGN KEY([SaleId]) REFERENCES [Sale]([SaleId]),
CONSTRAINT FK_SaleDetail_Product_ProId FOREIGN KEY([ProdId]) REFERENCES [Product]([ProdId]),
CONSTRAINT PK_SaleId_ProId PRIMARY KEY([SaleId],[ProdId]));

INSERT INTO [SaleDetail]
VALUES
(1,  1, 2),
(1,  2, 3),
(2,  4, 5),
(3,  1, 1),
(4,  2, 4),
(5,  3, 2),
(6,  4, 3),
(7,  5, 2),
(8,  1, 4),
(9,  2, 1),
(10, 3, 3);
