  --  ============================================POSTGRES ASSESMENT============================================

CREATE DATABASE UserDtlAssesment;

USE UserDtlAssesment;

-- tblUsers 
CREATE TABLE tblUsers(
	UserId INT PRIMARY KEY,
	UserName VARCHAR(100) NOT NULL,
	Email VARCHAR(100) NOT NULL);

INSERT INTO tblUsers(UserId,UserName, Email)
VALUES
	(1001,'Akash','akash@gmail.com'),
	(1002,'Arvind','arvind123@gmail.com'),
	(1003,'Sakshi','sakshimys12@gmail.com'),
	(1004,'Kumar','kumar987@gmail.com');

SELECT * FROM tblUsers;

--  ======================================================================================
-- tblCategory 
CREATE TABLE tblCategory(
	CategoryId  INT PRIMARY KEY,
	CategoryName VARCHAR(100) NOT NULL,
	Description VARCHAR(100) NOT NULL);

INSERT INTO tblCategory(CategoryId, CategoryName, Description)
VALUES
	(201,'Electronics','One stop for electronic items'),
	(202,'Apparel','Apparel is the next destination for fashion'),
	(203,'Grocery','All needs in one place');

SELECT * FROM tblCategory;

--  ======================================================================================
-- tblProducts 
CREATE TABLE tblProducts(
	ProductId INT PRIMARY KEY,
	ProductName VARCHAR(100) NOT NULL,
	Quantity INT NOT NULL,
	ProductPrice INT NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES tblCategory(CategoryId) NOT NULL);
	
INSERT INTO tblProducts(ProductId, ProductName, Quantity, ProductPrice, CategoryId)
VALUES
	(1,'Mobile Phone',1000,15000,201 ),
	(2,'Television',500,40000,201 ),
	(3,'Denims',2000,700,202 ),
	(4,'Vegetables',4000,40,203 ),
	(5,'Ethnic Wear',300,1500,202 ),
	(6,'Wireless Earphone',5000,2500,201 ),
	(7,'Lounge Wear',200,1600,202 ),
	(8,'Refrigerator',50,30000,201 ),
	(9,'Pulses',60,150,202 ),
	(10,'Fruits',100,250,202 );
	
SELECT * FROM tblProducts;

--  ======================================================================================
-- tblSales 
CREATE TABLE tblSales(
	SalesId INT PRIMARY KEY,
	SalesUserId INT FOREIGN KEY REFERENCES tblUsers(UserId) NOT NULL,
	ProductId INT FOREIGN KEY REFERENCES tblProducts(ProductId) NOT NULL);

INSERT INTO tblSales(SalesId, SalesUserId, ProductId)
VALUES
(500,1001,1),
(501,1002,1),
(502,1003,2),
(504,1004,3),
(505,1004,1),
(506,1004,1),
(507,1002,2),
(508,1003,1),
(509,1001,7),
(510,1001,8);
 
 SELECT * FROM tblSales;
 
 --  ======================================================================================
 
-- SELECT STATEMENTS
SELECT * FROM tblUsers;
SELECT * FROM tblCategory;
SELECT * FROM tblProducts;
SELECT * FROM tblSales;

--  ======================================================================================
--Questions 
 
-- 1.Write a function to fetch the names of the product,category and users along with 
-- the cost for each product sold depending on the sales_id. Also 
-- 	if the cost for each product is more than 2000, then display a message stating that 'The product has gained profit'.  
-- 	If the product cost is between 500 and 1000, then raise a message stating that 'The product has occured loss'.  
-- 	If the product cost is less than 500, then raise an exception stating 'No profit no loss'. 

CREATE OR ALTER FUNCTION UDF_SaleReport(@SaleId INT)
RETURNS @Res TABLE(
	ProductName VARCHAR(100), 
	CategoryName VARCHAR(100),
	ProductPrice MONEY,
	UserName VARCHAR(100),
	Status VARCHAR(200))
AS
BEGIN
	
	--VALIDATION
	IF NOT EXISTS(SELECT * FROM tblSales WHERE SalesId IN (@SaleId))
	BEGIN
		INSERT INTO @Res(Status) VALUES ('Invalid Sales Id !!');
		RETURN;
	END

	--EXTRACT VALUES
	INSERT INTO @Res(ProductName,CategoryName,ProductPrice,UserName,Status)
		SELECT 
			P.ProductName,
			C.CategoryName,  
			P.ProductPrice,
			U.UserName,
			(CASE
				WHEN P.ProductPrice>2000 THEN 'The product has gained profit'
				WHEN P.ProductPrice BETWEEN 500 AND 1000 THEN 'The product has occured loss'
				WHEN P.ProductPrice<500 THEN 'No profit no loss'
				ELSE 'SUCCESS'
			END) AS Status
		FROM 
				tblSales S
				INNER JOIN tblUsers U 
					ON S.SalesUserId=U.UserId
				INNER JOIN tblProducts P
					ON S.ProductId=P.ProductId
				INNER JOIN tblCategory C
					ON P.CategoryId=C.CategoryId
			WHERE
				S.SalesId IN (@SaleId);
	RETURN;

END

-- SELECT STATEMENTS
SELECT * FROM tblUsers;
SELECT * FROM tblCategory;
SELECT * FROM tblProducts;
SELECT * FROM tblSales;

-- OUTPUT
SELECT * FROM UDF_SaleReport(504);

UPDATE tblProducts
SET ProductPrice=30
WHERE ProductId=3;
--  ======================================================================================
-- 2.Write a procedure to update the name of the category from 'Electronics' to 'Modern Gadgets' and 
-- also fetch the category and product names when the userid is passed as the input parameter. 

CREATE OR ALTER PROCEDURE USP_GiveDetails(@UserId INT)
AS
BEGIN
	BEGIN TRANSACTION;
		BEGIN TRY
			DECLARE @CatName VARCHAR(100), @ProdName VARCHAR(100);

			--UDATING THE CATEGORY TABLE
			UPDATE tblCategory
			SET CategoryName = 'Modern Gadgets'
			WHERE CategoryName =  'Electronics';
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION;
			DECLARE @err VARCHAR(100)=ERROR_MESSAGE();
			RAISERROR(@err,16,1);
		END CATCH
	COMMIT TRANSACTION;

		-- VALIDATION
		IF NOT EXISTS(SELECT * FROM tblUsers WHERE UserId =@UserId)
		BEGIN
			RAISERROR('INVALID USER !!',16,1);
			RETURN;
		END

		SELECT  
			C.CategoryName ,
			P.ProductName ,
			COUNT(*) OVER (PARTITION BY C.CategoryId) TotalSales
		FROM  
			tblSales S
			INNER JOIN tblProducts P
				ON S.ProductId=P.ProductId
			INNER JOIN tblCategory C
				ON P.CategoryId=C.CategoryId
		WHERE
			S.SalesuserId IN (@UserId);
		
END

-- SELECT STATEMENTS
SELECT * FROM tblUsers;
SELECT * FROM tblCategory;
SELECT * FROM tblProducts;
SELECT * FROM tblSales;

-- OUTPUT
EXEC USP_GiveDetails  1001;

--SAMPLE OUTPUT 1
--===============
-- I/P: 1001
-- O/P: "( Modern Gadgets -> Mobile Phone ), ( Apparel -> Lounge Wear ), ( Modern Gadgets -> Refrigerator )"

--SAMPLE OUTPUT 2
--===============
-- I/P: 101
-- O/P: Error: INVALID USERS (Alll actions are rolled back)

--  ======================================================================================
