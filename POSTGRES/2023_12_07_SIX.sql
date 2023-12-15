--	EmployeesDB

-- 1.Consider table tblEmployeeDtls and write a stored procedure to generate 
-- bonus to employees for the given date  as below: 
-- 	A)One month salary  if Experience>10 years  
-- 	B)50% of salary  if experience between 5 and 10 years  
-- 	C)Rs. 5000  if experience is less than 5 years 
-- 	Also, return the total bonus dispatched for the year as output parameter. 






-- CREATE PROCEDURE ProName  ({IN|OUT|INOUT} PArameter1 DATATYPE)
-- AS
-- $$
-- BEGIN
-- 	--CODE
-- END
-- $$
--LANGUAGE PLPGSQL;

SELECT * FROM EMPLOYEES


CALL USP_InsUdt(11,'Spider','Blue')


CREATE OR REPLACE PROCEDURE USP_InsUdt(IN P1 INT, IN P2 VARCHAR,IN P3 VARCHAR)
AS
$$
BEGIN
	IF EXISTS(SELECT * FROM EMPLOYEES WHERE employeeid=P1)
	THEN
		--UPDATE CODE
		UPDATE Employees
		SET FirstName=P2, LastName=P3
		WHERE EmployeeId = P1;
	ELSE
		--INSERT CODE
		INSERT INTO Employees(EmployeeId,FirstName,LastName)
		VALUES
		(P1,P2,P3);
	END IF;
END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE PROCEDURE USP_inc(IN n1 INT, INOUT n2 INT DEFAULT NULL)
AS
$$
BEGIN
	n2=n1+1;
END;
$$
LANGUAGE PLPGSQL;

CALL USP_inc (5)

DO
$$
DECLARE res INT;
BEGIN
	CALL USP_inc(5, res);
	RAISE NOTICE '%',res;
END;
$$

-----------------------------------------------------------------------------
-- CALLING
CALL USP_EmpBonus()

-- PROCEDURE
CREATE OR REPLACE PROCEDURE USP_EmpBonus(
	IN GivenDate DATE DEFAULT NOW()::DATE, 
	INOUT Bonus NUMERIC DEFAULT NULL)
AS
$PROCEDURE$
BEGIN
	WITH BonusTbl AS(
		SELECT 
			HIREDATE, 
			SALARY,
			EXTRACT (YEAR FROM AGE(GivenDate,HireDate)) AS EXPERIENCE,
			(CASE
				WHEN EXTRACT (YEAR FROM AGE(GivenDate,HireDate)) >10
					THEN Salary
				WHEN EXTRACT (YEAR FROM AGE(GivenDate,HireDate)) BETWEEN 5 AND 10
					THEN Salary * (50.0/100) 
				ELSE
					 5000
			END)  AS BONUSAmt
		FROM EMPLOYEES)
	SELECT SUM(BonusAmt) INTO Bonus 
	FROM Bonustbl;
END;
$PROCEDURE$
LANGUAGE PLPGSQL;


--WITHOUT CTE
SELECT SUM(BonusAmt) INTO Bonus
FROM (SELECT 
			HIREDATE, 
			SALARY,
			EXTRACT (YEAR FROM AGE('2025-10-10',HireDate)) AS EXPERIENCE,
			(CASE
				WHEN EXTRACT (YEAR FROM AGE('2025-10-10',HireDate)) >10
					THEN Salary
				WHEN EXTRACT (YEAR FROM AGE('2025-10-10',HireDate)) BETWEEN 5 AND 10
					THEN Salary * (50.0/100) 
				ELSE
					 5000
			END)  AS BONUSAmt
		FROM EMPLOYEES) restbl
-- _______________________________________________________________________________________________________________________
-- 2.Create a stored procedure that returns a sales report for a given time period 
-- for a given Sales Person. Write commands to invoke the procedure 

-- I/p
-- 	TIME PERIOD 
-- 		START DATE 
-- 		END DATE
-- 	SalesManId

-- O/P --> Sales Report
-- 	SaleId
-- 	Date of Sale
-- 	total Amount
-- 	Quantity

-- TABLE STRUCTURE
	
--SALESMAN
CREATE TABLE Salesman(
SmId INT PRIMARY KEY,
SmName VARCHAR NOT NULL,
SmLocation VARCHAR NOT NULL);

INSERT INTO Salesman(SmId, SmName, SmLocation)
VALUES
(1,'Anjali','Mysore'),
(2,'Manjunath','Mandya');

--PRODUCTS
CREATE TABLE Products(
Pid INT PRIMARY KEY,
Pdesc VARCHAR NOT NULL,
Pprice BIGINT NOT NULL);

INSERT INTO Products(Pid,Pdesc,Pprice)
VALUES
(1,'Keyboard',50),
(2,'Mouse',150),
(3,'USB',300);

--SALES
CREATE TABLE Sales(
Sid INT PRIMARY KEY,
SmId INT REFERENCES Salesman(SmId) NOT NULL,
Samount BIGINT NOT NULL);

ALTER TABLE Sales
ADD COLUMN Sdate DATE NOT NULL;


INSERT INTO Sales(Sid,SmId,Sdate,Samount)
VALUES
(1, 1, '2023-12-06', 800),
(2, 1, '2023-12-07', 300),
(3, 2, '2023-12-07', 1500);


--SaleDetails
CREATE TABLE SaleDetails(
Sid INT REFERENCES Sales(Sid),
Pid INT REFERENCES Products(Pid),
Quantity INT NOT NULL,
CONSTRAINT PK_SaleDetails PRIMARY KEY(Sid,Pid));


INSERT INTO SaleDetails(Sid,Pid,Quantity)
VALUES
(1,3,1),
(1,1,6),
(2,2,2),
(3,3,2),
(3,2,3),
(3,1,1);

-- I/p
-- 	TIME PERIOD 
-- 		START DATE 
-- 		END DATE
-- 	SalesManId

-- O/P --> Sales Report
-- 	SaleId
-- 	Date of Sale
-- 	total Amount
-- 	Quantity
-- productName





SELECT * FROM Salesman
SELECT * FROM Products
SELECT * FROM sales
SELECT * FROM SaleDetails

-- SalesMan sm
-- 		SmId |  SmName	|	 SmLocation		
-- Product
-- 		Pid | Pdesc	|	Pprice	
-- Sales s
-- 		Sid | SmId	|	Sdate	|	Samount
-- SaleDetails sd
-- 		Sid | Pid	|	Quantity	

CREATE OR REPLACE PROCEDURE USP_SaleReport(
	IN StartDate DATE,
	IN EndDate DATE,
	IN SalesmanId INT,
	OUT TableName VARCHAR)
AS
$$
BEGIN
--CODE
	DROP TABLE IF EXISTS ResultTbl;
	CREATE TEMP TABLE ResultTbl
	AS
	SELECT 
		S.sid "Sale Id",
		S.Sdate "Sale Date", 
		SD.Quantity*P.PPrice AS "Total Amount",
		SD.Quantity
	FROM Sales S 
		INNER JOIN SaleDetails SD
			ON S.Sid=SD.Sid
		INNER JOIN Products P
			ON P.Pid=SD.Pid
	WHERE 
		S.Sdate BETWEEN StartDate AND EndDate
		AND
		S.SmID = SalesmanId;
		
	TableName = 'ResultTbl';
END;
$$
LANGUAGE PLPGSQL;

-- OUTPUT
CALL USP_SaleReport('2023-12-07','2023-12-09',1,NULL);
SELECT * FROM ResultTbl;
-- _______________________________________________________________________________________
-- SOLVING SAME QUESTION USING FUNCTION
CREATE FUNCTION UDF_SalesReport(
	IN StartDate DATE,
	IN EndDate DATE,
	IN SalesmanId INT)
RETURNS TABLE(
	"Sale Id" INT,
	"Sale Date"	DATE,
	"Total Amount"	BIGINT,
	quantity INT)
AS
$$
BEGIN
	RETURN QUERY
		SELECT 
			S.sid "Sale Id",
			S.Sdate "Sale Date", 
			SD.Quantity*P.PPrice AS "Total Amount",
			SD.Quantity
		FROM Sales S 
			INNER JOIN SaleDetails SD
				ON S.Sid=SD.Sid
			INNER JOIN Products P
				ON P.Pid=SD.Pid
		WHERE 
			S.Sdate BETWEEN StartDate AND EndDate
			AND
			S.SmID = SalesmanId;
END;
$$
LANGUAGE PLPGSQL;

-- OUTPUT
SELECT * FROM UDF_SalesReport('2023-12-07','2023-12-09',2)
-- __________________________________________________________________________________
-- 3.Also generate the month and maximum ordervalue booked by the given 
-- salesman(use output parameter) 

-- SalesMan sm
-- 		SmId |  SmName	|	 SmLocation		
-- Product
-- 		Pid | Pdesc	|	Pprice	
-- Sales s
-- 		Sid | SmId	|	Sdate	|	Samount
-- SaleDetails sd
-- 		Sid | Pid	|	Quantity	

-- SELECT TO_CHAR(AGE('2023-10-10','2013-10-10'),'YYYY-MM-DD')

SELECT * FROM SALES;
SELECT * FROM SALEDETAILS;

CREATE OR REPLACE PROCEDURE USP_MaxMonSale(IN StartDate DATE,IN EndDate DATE,IN SalesmanId INT,OUT MonthName VARCHAR)
AS
$$
DECLARE
res RECORD;
BEGIN
	
	FOR res IN (
	SELECT  TO_CHAR(Sdate,'MONTH') "Mon"
	FROM Sales 
	WHERE 
		SmId IN (SalesmanId)
		AND
		Sdate BETWEEN StartDate AND EndDate
	GROUP BY TO_CHAR(Sdate,'MONTH')
	ORDER BY SUM(Samount) DESC
	OFFSET 0 ROWS
	FETCH FIRST 1 ROWS WITH TIES)
	LOOP
-- 		RAISE NOTICE '%',res."Mont";
		MonthName := COALESCE(MonthName,'') || res."Mon" || ',';
	END LOOP;
	MonthName:=RTRIM(MonthName,',');
END;
$$
LANGUAGE PLPGSQL;

CALL USP_MaxMonSale('2023-11-01','2023-12-20',1,NULL)

--USING FUNCTIONS
CREATE FUNCTION UDF_MaxMonSale(IN StartDate DATE,IN EndDate DATE,IN SalesmanId INT)
RETURNS TABLE(MonthName VARCHAR)
AS
$$
BEGIN
	RETURN QUERY
		SELECT TO_CHAR(Sdate,'MONTH')::VARCHAR
		FROM Sales
		WHERE 
			SmId IN (SalesmanId)
			AND
			Sdate BETWEEN StartDate AND EndDate
		GROUP BY TO_CHAR(Sdate,'MONTH')
		ORDER BY SUM(Samount) DESC
		OFFSET 0 ROWS
		FETCH FIRST 1 ROWS WITH TIES;
END;
$$
LANGUAGE PLPGSQL;


SELECT * FROM UDF_MaxMonSale('2023-11-01'::DATE,'2023-12-20'::DATE,1)

---------------------------------------------------------------------------------------------

