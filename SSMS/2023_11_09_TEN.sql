--1.Consider table tblEmployeeDtls and write a stored procedure to generate 
--	bonus to employees for the given date  as below: 
--	A)One month salary  if Experience>10 years  
--	B)50% of salary  if experience between 5 and 10 years  
--	C)Rs. 5000  if experience is less than 5 years 
--Also, return the total bonus dispatched for the year as output parameter.

USE [Payroll];

SELECT *
FROM [tblEmployee]

ALTER PROCEDURE [usp_tblEmployee_Bonus](
	@GivenDate DATE,
	@TotalBonus MONEY OUTPUT)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		(	CASE
				WHEN DATEDIFF(YYYY,[JoiningDate],@GivenDate)>10
					THEN [Salary]
				WHEN DATEDIFF(YYYY,[JoiningDate],@GivenDate) BETWEEN 5 AND 10
					THEN [Salary] * 0.5
				ELSE
					5000
			END) AS [BonusAmt]
	INTO #Bonus
	FROM [tblEmployee];

	SELECT * FROM [#Bonus]

	SELECT @TotalBonus= SUM([BonusAmt])
	FROM [#Bonus];

END

DECLARE @TotalBonus MONEY;
EXEC [usp_tblEmployee_Bonus] '2023-11-09', @TotalBonus OUTPUT;
PRINT @TotalBonus

--________________________________________________________________________________________
--2.Create a stored procedure that returns a sales report for a given time period 
--for a given Sales Person. Write commands to invoke the procedure

USE [SalesDB];

SELECT * FROM [Salesman]
SELECT * FROM [Sale]
SELECT * FROM [SaleDetail]
SELECT * FROM [Product]

--CREATE PROCEDURE [usp_SalesReport](
--	@GivenTime DATE,
--	@SalemanId INT,
--	@Report NVARCHAR(1000) OUTPUT)
--AS
--BEGIN
--	SET @Report = 'On '+CAST(@GivenTime AS varchar)+', ';

--	SELECT 
--		[S].[SaleId],[SM].[SmName], [P].[ProdDesc],[P].[ProdPrice],[S].[Amount],[SD].[Quantity]
--	INTO 
--		#NEWTEMPTABLE
--	FROM
--		[Sale] [S]
--		INNER JOIN [SaleDetail] [SD]
--			ON [S].[SaleId]=[SD].[SaleId]
--		INNER JOIN [Salesman] [SM]
--			ON [SM].[SmId] = [S].[SmId]
--		INNER JOIN [Product] [P]
--			ON [P].[ProdId] = [SD].[ProdId]
--	WHERE
--		[SM].[SmId] IN (@SalemanId)
--		AND
--		[S].[SaleDate] IN (@GivenTime)

--	SELECT DISTINCT @Report += [smName] FROM #NEWTEMPTABLE

--	SET @Report += ' have made '
	
--	SELECT @Report+=CAST(COUNT(DISTINCT [SaleId]) AS varchar)
--	FROM #NEWTEMPTABLE

--	SET @Report += ' sales. In total he/she sold '

--	SELECT @Report+= ', '+ CAST(SUM([Quantity]) AS VARCHAR)+ ' ' + [ProdDesc] + '(Rs. '+CAST([ProdPrice] AS VARCHAR)+') '
--	FROM #NEWTEMPTABLE
--	GROUP BY [ProdDesc], [ProdPrice]

--	SET @Report += ' and made a Total sales of Rs.';

--	SELECT @Report += CAST(SUM([Amount]) AS VARCHAR)
--	FROM(
--		SELECT [Amount]
--		FROM #NEWTEMPTABLE
--		GROUP BY [SaleId],[Amount]) as [A]
--END
--DECLARE @ReportAns NVARCHAR(1000);
--EXEC [usp_SalesReport] '2023-01-10', 1,@ReportAns OUTPUT
--PRINT(@ReportAns)

ALTER PROCEDURE [usp_SalesReport]
	@SourceDuration DATETIME,
	@DestinationDuration DATETIME,
	@SalesmanId INT
AS
BEGIN

	SELECT
		[S].[SaleId],[SM].[SmName], [P].[ProdDesc],[P].[ProdPrice],[SD].[Quantity], [S].[SaleDate]
	FROM
		[Sale] [S]
		INNER JOIN [SaleDetail] [SD]
			ON [S].[SaleId]=[SD].[SaleId]
		INNER JOIN [Salesman] [SM]
			ON [SM].[SmId] = [S].[SmId]
		INNER JOIN [Product] [P]
			ON [P].[ProdId] = [SD].[ProdId]
	WHERE 
		[SM].[SmId] IN (@SalesmanId)
		AND
		[S].[SaleDate] BETWEEN @SourceDuration AND @DestinationDuration;

END
[usp_SalesReport] '2023-01-10 00:00:00.000', '2023-05-05 00:00:00.000', 1

--________________________________________________________________________________________
--3.Also generate the month and maximum ordervalue booked by the given 
--salesman(use output parameter)

ALTER PROCEDURE [usp_SalesMaxReport]
	@SourceDuration DATETIME,
	@DestinationDuration DATETIME,
	@SalesmanId INT,
	@Month VARCHAR(15) OUTPUT,
	@Maximum MONEY OUTPUT
AS
BEGIN

	SELECT
		TOP 1 @Month=DATENAME(MM,[S].[SaleDate]), @Maximum=SUM([P].[ProdPrice])
	FROM
		[Sale] [S]
		INNER JOIN [SaleDetail] [SD]
			ON [S].[SaleId]=[SD].[SaleId]
		INNER JOIN [Salesman] [SM]
			ON [SM].[SmId] = [S].[SmId]
		INNER JOIN [Product] [P]
			ON [P].[ProdId] = [SD].[ProdId]
	WHERE 
		[SM].[SmId] IN (@SalesmanId)
		AND
		[S].[SaleDate] BETWEEN @SourceDuration AND @DestinationDuration
	GROUP BY 
		DATENAME(MM,[S].[SaleDate])
	ORDER BY 
		SUM([P].[ProdPrice]) DESC;
END

DECLARE @Month VARCHAR(15), @Maximum MONEY;
EXEC [usp_SalesMaxReport] '2023-01-10 00:00:00.000', '2023-05-05 00:00:00.000', 1, @Month OUTPUT, @Maximum OUTPUT
PRINT @Month
PRINT @Maximum

--________________________________________________________________________________________
--4.Consider Toy Centre database 
--Procedure Name : usp_UpdatePrice 
--Description:    This procedure is used to update the price of a given product. 
 
--Input Parameters: 
--∙	ProductId 
--∙	Price 

--Output Parameter 
--    UpdatedPrice 
--Functionality: 

--	Check if the product id is valid, i.e., it exists in the Products table 
--	If all the validations are successful, update the price in the table Products appropriately 
--	Set the output parameter to the updated price 
--	If the update is not successful or in case of exception, undo the entire operation and set the output parameter to 0 

--Return Values: 
--	1 in case of successful update 
--	-1 in case of any errors or exception 

ALTER PROCEDURE [usp_UpdatePrice]
	@ProductId INT,
	@Price MONEY,
	@UpdatedPrice MONEY OUTPUT
AS
BEGIN

	IF @ProductId NOT IN (SELECT [ProdId] FROM [Product])
	BEGIN
		RAISERROR('Invalid Project Id !!',16,1);
		RETURN -1;
	END
	
	BEGIN TRANSACTION
		BEGIN TRY
			UPDATE 
				[Product]
			SET
				[ProdPrice] = @Price
			WHERE
				[ProdId] IN (@ProductId);
		END TRY

		BEGIN CATCH
			RAISERROR('Can not update the new price !!',16,1);
			RETURN -1;
		END CATCH
	COMMIT

	SET @UpdatedPrice = @Price;
	RETURN 1

END

SELECT * FROM [Product]

DECLARE @Ans MONEY, @Status INT
EXECUTE @Status = [usp_UpdatePrice] 1, 5000, @Ans OUTPUT
PRINT @Status
PRINT @Ans

SELECT * FROM [Product]

--________________________________________________________________________________________
--5.Procedure Name : usp_InsertPurchaseDetails 
--Description: 
--	This procedure is used to insert the purchase details into the table PurchaseDetails and 
--	update the available quantity of the product in the table Products by performing the 
--	necessary validations based on the business requirements. 
USE [Payroll]
ALTER PROCEDURE [usp_InsertPurchaseDetails]
	@CustomerId INT,
	@ToyId VARCHAR(5),
	@QuantityPurchased INT,
	@Op VARCHAR(50) OUTPUT
AS
BEGIN
	IF 
		@CustomerId IS NULL
	BEGIN 
		RAISERROR('Customer id should not be NULL',16,1)
		RETURN -1
	END

	IF 
		@CustomerId NOT IN (SELECT [CusId] FROM [Customers])
	BEGIN 
		RAISERROR('Invlid customer !!',16,1)
		RETURN -2
	END

	IF 
		@ToyId IS NULL
		
	BEGIN 
		RAISERROR('Toy id should not be NULL',16,1)
		RETURN -3
	END

	IF 
		@ToyId NOT IN (SELECT [TId] FROM [Toys])
		
	BEGIN 
		RAISERROR('Invlid toy !!',16,1)
		RETURN -4
	END

	DECLARE @AvailStock INT = (SELECT [Stock] FROM [Toys] WHERE [TId] IN (@ToyId))
	IF 
		@AvailStock < @QuantityPurchased
		OR
		@QuantityPurchased<1
		OR
		@QuantityPurchased IS NULL
	BEGIN
		RAISERROR('OUT OF STOCK or invalid Quantity !!',16,1)
		RETURN -5
	END

		BEGIN TRY
			BEGIN TRANSACTION
				UPDATE [Toys]
				SET [Stock] = [Stock]-@QuantityPurchased
				WHERE [TId] IN (@ToyId)

				DECLARE @Price INT, @NewId INT 
				SELECT @Price=[Price] FROM [Toys] WHERE [TId] IN (@ToyId);
				SELECT TOP 1 @NewId=[TxnId]  FROM [Transactions] ORDER BY [TxnId] DESC

				INSERT INTO [Transactions]([TxnId],[CusId],[TId],[Quantity],[Txncost])
				VALUES
				(@NewId+1,@CustomerId,@ToyId,@QuantityPurchased,@Price*@QuantityPurchased);
			COMMIT
		END TRY

		BEGIN CATCH
			ROLLBACK
			RAISERROR('CAN NOT BE UPDATED!!',16,1)
			RETURN -99
		END CATCH
	SELECT @Op =[Cname] FROM [Customers] WHERE [CusId] IN (@CustomerId)
	RETURN 1
END



SELECT * FROM [Customers]
SELECT * FROM [Toys]
SELECT * FROM [Transactions]

DECLARE @ans VARCHAR(50), @state INT
EXECUTE @state=[usp_InsertPurchaseDetails] 104, 'T1004', 2, @ans OUTPUT
PRINT @ans

--________________________________________________________________________________________

USE [SmartPhone];

DROP TABLE [Vendors];
CREATE TABLE [Vendors](
	[VendorId] INT PRIMARY KEY IDENTITY,
	[vendorName] NVARCHAR(50) NOT NULL);

INSERT INTO [Vendors]
VALUES
	('Samsung'),
	('Microsoft'),
	('Philips');

DROP TABLE [Category];
CREATE TABLE [Category](
	[CategoryId] INT PRIMARY KEY IDENTITY(101,1),
	[CategoryName] NVARCHAR(50) NOT NULL);

INSERT INTO [Category]
VALUES
	('Mobile'),('Entertainment'),('Philips');

--DROP TABLE [Products];
CREATE TABLE [Products](
	[ProductId] NVARCHAR(5) PRIMARY KEY,
	[ProductName] NVARCHAR(50) NOT NULL,
	[CategoryId] INT,
	[VendorId] INT,
	[ProductPrice] MONEY NOT NULL,
	[AvailableQty] INT NOT NULL,
	CONSTRAINT FK_CategoryId_Category FOREIGN KEY([CategoryId]) REFERENCES [Category]([CategoryId]),
	CONSTRAINT FK_VendorId_Vendor FOREIGN KEY([VendorId]) REFERENCES [Vendors]([VendorId]));

INSERT INTO [Products]([ProductId], [ProductName], [CategoryId], [VendorId],[ProductPrice],[AvailableQty])
VALUES
	('P1', 'LED Television', 102, 1, 23000,10),
	('P2', 'X-Box', 102, 2, 34000,7),
	('P3', 'Grand 7', 101, 1, 17000,23);

CREATE TABLE [Customer](
	[CustomerId] NVARCHAR(5) PRIMARY KEY,
	[CustomerName] NVARCHAR(50) NOT NULL,
	[CustomerLocation] NVARCHAR(50) NOT NULL,
	[CustomerEmail] NVARCHAR(50) NOT NULL,
	[CustomerMobile] BIGINT UNIQUE);

INSERT INTO [Customer]
VALUES
	('C1', 'Chakraborty', 'WestBengal', 'chakraborty@gmail.com', 8765456718),
	('C2', 'Sanjana', 'Mysore', 'sanjana@gmail.com', 9871234567);

CREATE TABLE [PaymentMode](
	[ModeId] INT PRIMARY KEY IDENTITY,
	[ModeName] NVARCHAR(20) NOT NULL);

INSERT INTO [PaymentMode]
VALUES
('COD'), ('Debit Card');

CREATE TABLE [Sales](
[BillNo] INT PRIMARY KEY IDENTITY,
[CustomerId] NVARCHAR(5),
[DateOfPurchase] DATETIME NOT NULL,
[ModeOfPayment] INT,
CONSTRAINT FK_CustomerId_Customer FOREIGN KEY([CustomerId]) REFERENCES [Customer]([CustomerId]),
CONSTRAINT FK_ModeOfPayment_PaymentMode FOREIGN KEY([ModeOfPayment]) REFERENCES [PaymentMode]([ModeId]));

INSERT INTO [Sales]
VALUES
('C1', '2018-03-12', 1),
('C1', '2018-02-12', 2),
('C2', '2018-11-12', 1);

CREATE TABLE [SaleDetails](
[BillNo] INT FOREIGN KEY REFERENCES [Sales]([BillNo]),
[ProductId] NVARCHAR(5) REFERENCES [Products]([ProductId]),
[Quantity] INT NOT NULL,
PRIMARY KEY([BillNo],[ProductId]));

INSERT INTO [SaleDetails]
VALUES
(1, 'P1', 5),
(1, 'P3', 13),
(2, 'P2', 3),
(3, 'P1', 2),
(3, 'P3', 2);

SELECT * FROM [Vendors]
SELECT * FROM [Category]
SELECT * FROM [Products]
SELECT * FROM [Customer]
SELECT * FROM [PaymentMode]
SELECT * FROM [Sales]
SELECT * FROM [SaleDetails]


--1.Create a procedure to list the sales details of the products belonging to the 
--given vendor and for the given interval

USE [SmartPhone];

CREATE PROCEDURE [usp_SaleDetail]
	@VendorName NVARCHAR(50),
	@StartDate DATETIME,
	@EndDate DATETIME
AS
BEGIN
	SELECT
		[S].[BillNo],[ProductName],[VendorName],[ProductPrice],[Quantity],[DateOfPurchase] 
	FROM
		[Products] [P]
		INNER JOIN [SaleDetails] [SD]
			ON [P].[ProductId] = [SD].[ProductId]
		INNER JOIN [Vendors] [V]
			ON [V].[VendorId]=[P].[VendorId]
		INNER JOIN [Sales] [S]
			ON [S].[BillNo]=[SD].[BillNo]
	WHERE
		[V].[vendorName] IN (@VendorName)
		AND
		[S].[DateOfPurchase] BETWEEN @StartDate AND @EndDate;
END

EXECUTE [usp_SaleDetail] 'Samsung', '2018-03-01', '2018-12-30'

--___________________________________________________________________________________________________________
--2.Create a procedure to list the sales details of the products belonging to the 
--given vendor and for the given interval where in the total sales amount exceeds 
--the given value 

ALTER PROCEDURE [usp_PremiumSaleDetail]
	@VendorName NVARCHAR(50),
	@StartDate DATETIME,
	@EndDate DATETIME,
	@Threshold MONEY
AS
BEGIN
	
	SELECT
		[ProductName], SUM([Quantity]) AS [Total Quantities], SUM([ProductPrice]) AS  [Total Price]
	FROM
		[Products] [P]
		INNER JOIN [SaleDetails] [SD]
			ON [P].[ProductId] = [SD].[ProductId]
		INNER JOIN [Vendors] [V]
			ON [V].[VendorId]=[P].[VendorId]
		INNER JOIN [Sales] [S]
			ON [S].[BillNo]=[SD].[BillNo]
	WHERE
		[V].[vendorName] IN (@VendorName)
		AND
		[S].[DateOfPurchase] BETWEEN @StartDate AND @EndDate
	GROUP BY 
		[ProductName]
	HAVING
		SUM([ProductPrice])>@Threshold;

END

EXECUTE [usp_PremiumSaleDetail] 'Samsung', '2018-03-01', '2023-12-30', 35000

--___________________________________________________________________________________________________________
--3.Create a procedure to list the total no of products sold and the revenue 
--earned for the given category of products within the specified interval 
--Triggers: 
--1.Write a Trigger to restrict operations on Employee table 
--2.Write a Trigger to Alert the user whenever there is an update in tblEmployeedtls  table 

ALTER PROCEDURE [usp_CategorySaleDetail]
	@CategoryName NVARCHAR(50),
	@StartDate DATETIME,
	@EndDate DATETIME
AS
BEGIN
	
	SELECT
		SUM([Quantity]) AS [Total Product Sold],SUM([ProductPrice]) AS [Total Revenue Earned]
	FROM
		[Products] [P]
		INNER JOIN [SaleDetails] [SD]
			ON [P].[ProductId] = [SD].[ProductId]
		INNER JOIN [Sales] [S]
			ON [S].[BillNo]=[SD].[BillNo]
		INNER JOIN [Category] [C]
			ON [C].[CategoryId] = [P].[CategoryId]
	WHERE
		[CategoryName] IN (@CategoryName)
		AND
		[DateOfPurchase] BETWEEN @StartDate AND @EndDate;

END

[usp_CategorySaleDetail] 'Entertainment', '2018-01-01', '2018-05-01'

--___________________________________________________________________________________________________________

--1.Write a Trigger to restrict operations on Employee table 
USE [Payroll];

SELECT * FROM [emp]


ALTER TRIGGER [TR_Restrict_Chk]
	ON [EMP]
	FOR INSERT, DELETE, UPDATE
AS
BEGIN
	IF 
		DATENAME(DW, GETDATE()) IN ('Saturday', 'Sunday')
		OR
		CAST(GETDATE() AS TIME)<CAST('09:00:00' AS TIME)
		OR
		CAST(GETDATE() AS TIME)>CAST('17:30:00' AS TIME)
	BEGIN
		ROLLBACK
		PRINT 'WORK TIME IS 9 AM to 6:30PM (MON-FRI)'
	END
END


SELECT * FROM [emp]
INSERT INTO [emp] VALUES
(4,'ram','anand',22,'banglore');
DELETE FROM [EMP]
WHERE ID IN (4)
--___________________________________________________________________________________________________________
