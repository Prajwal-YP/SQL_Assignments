--  ============================================POSTGRES ASSESMENT============================================

-- tblUsers 
CREATE TABLE tblUsers(
	UserId INT PRIMARY KEY,
	UserName VARCHAR NOT NULL,
	Email VARCHAR NOT NULL);

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
	CategoryName VARCHAR NOT NULL,
	Description VARCHAR NOT NULL);

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
	ProductName VARCHAR NOT NULL,
	Quantity INT NOT NULL,
	ProductPrice INT NOT NULL,
	CategoryId INT REFERENCES tblCategory(CategoryId) NOT NULL);
	
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
	SalesUserId INT REFERENCES tblUsers(UserId) NOT NULL,
	ProductId INT REFERENCES tblProducts(ProductId) NOT NULL);

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
Questions 
 
-- 1.Write a function to fetch the names of the product,category and users along with 
-- the cost for each product sold depending on the sales_id. Also 
-- 	if the cost for each product is more than 2000, then display a message stating that 'The product has gained profit'.  
-- 	If the product cost is between 500 and 1000, then raise a message stating that 'The product has occured loss'.  
-- 	If the product cost is less than 500, then raise an exception stating 'No profit no loss'. 

CREATE OR REPLACE FUNCTION UDF_SaleReport(IN _SaleId INT)
	RETURNS TABLE(ProductName VARCHAR, CategoryName VARCHAR,UserName VARCHAR)
AS
$$
DECLARE 
	_Price BIGINT;
	_ProductName VARCHAR;
	_CategoryName VARCHAR;
	_UserName VARCHAR;
BEGIN
	--VALIDATION
	IF NOT EXISTS(SELECT * FROM tblSales WHERE SalesId IN (_SaleId))
	THEN
		RAISE EXCEPTION 'INVALID SALE-ID !!';
	END IF;
	
	--EXTRACT VALUES
	SELECT P.ProductPrice, P.ProductName, C.CategoryName, U.UserName
	INTO _Price,_ProductName, _CategoryName, _UserName
	FROM 
			tblSales S
			INNER JOIN tblUsers U 
				ON S.SalesUserId=U.UserId
			INNER JOIN tblProducts P
				ON S.ProductId=P.ProductId
			INNER JOIN tblCategory C
				ON P.CategoryId=C.CategoryId
		WHERE
			S.SalesId IN (_SaleId);
	
	-- PRICE MESSAGES
	IF _Price>2000 
		THEN 
			RAISE NOTICE 'The product has gained profit';
		ELSIF _Price BETWEEN 500 AND 1000 THEN
			RAISE NOTICE 'The product has occured loss';
		ELSIF _Price<500 THEN
			RAISE EXCEPTION 'No profit no loss';
	END IF;
	
	-- INSERTION
	RETURN QUERY
		SELECT _ProductName, _CategoryName, _UserName;
END;
$$
LANGUAGE PLPGSQL;

-- SELECT STATEMENTS
SELECT * FROM tblUsers;
SELECT * FROM tblCategory;
SELECT * FROM tblProducts;
SELECT * FROM tblSales;

-- OUTPUT
SELECT * FROM UDF_SaleReport(509);

--  ======================================================================================
-- 2.Write a procedure to update the name of the category from 'Electronics' to 'Modern Gadgets' and 
-- also fetch the category and product names when the userid is passed as the input parameter. 

CREATE OR REPLACE PROCEDURE USP_GiveDetails(IN _UserId INT, INOUT Answer VARCHAR DEFAULT NULL)
AS
$$
DECLARE
	res RECORD;
BEGIN
		--UDATING THE CATEGORY TABLE
		UPDATE tblCategory
		SET CategoryName = 'Modern Gadgets'
		WHERE CategoryName =  'Electronics';

		-- VALIDATION
		IF NOT EXISTS(SELECT * FROM tblUsers WHERE UserId =_UserId)
		THEN
			RAISE EXCEPTION 'INVALID USER !!';
		END IF;

		-- USERS PURCHASE REPORT
		Answer= '';

		FOR res IN (
			SELECT * 
			FROM  
				tblSales S
				INNER JOIN tblProducts P
					ON S.ProductId=P.ProductId
				INNER JOIN tblCategory C
					ON P.CategoryId=C.CategoryId
			WHERE
				S.SalesuserId IN (1001))
		LOOP
			Answer = Answer || '( ' || res.CategoryName || ' -> ' || res.ProductName || ' ), ';
		END LOOP;

		Answer=	RTRIM(Answer,', ');
	EXCEPTION 
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE EXCEPTION '%', SQLERRM;
END;
$$
LANGUAGE PLPGSQL;

-- SELECT STATEMENTS
SELECT * FROM tblUsers;
SELECT * FROM tblCategory;
SELECT * FROM tblProducts;
SELECT * FROM tblSales;

-- OUTPUT
CALL USP_GiveDetails(1001);

--SAMPLE OUTPUT 1
--===============
-- I/P: 1001
-- O/P: "( Modern Gadgets -> Mobile Phone ), ( Apparel -> Lounge Wear ), ( Modern Gadgets -> Refrigerator )"

--SAMPLE OUTPUT 2
--===============
-- I/P: 101
-- O/P: Error: INVALID USERS (Alll actions are rolled back)

--  ======================================================================================
