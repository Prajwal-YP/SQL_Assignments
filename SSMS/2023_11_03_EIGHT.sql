DECLARE @Var_1 INT=1
PRINT @Var_1

--To generate first 100 even numbers
DECLARE @Number INT = 2, @Count INT =1
WHILE (@Count<101)
BEGIN
	PRINT @Number
	SET @Number = @Number +2
	SET @Count += 1;
END

--check a num is even or odd
DECLARE @Number INT = 50
IF (@Number %  2) =  0
	PRINT CAST(@Number AS VARCHAR) +' is a Even Number'
ELSE
	PRINT CAST(@Number AS VARCHAR) +'Odd Number'

--fibonacci sequence
DECLARE @Number1 BIGINT = 1, @Number2 BIGINT = 1, @Count INT = 3, @NewNumber BIGINT;
PRINT 'Number-0: 0';
PRINT 'Number-1: '+CAST(@Number1 AS VARCHAR);
PRINT 'Number-2: '+CAST(@Number2 AS VARCHAR);

WHILE @Count<=50
BEGIN
	SET @NewNumber = @Number1+@Number2;
	PRINT 'Number-'+CAST(@Count AS VARCHAR)+': '+CAST(@NewNumber AS VARCHAR);
	SET @Number1 = @Number2;
	SET @Number2 = @NewNumber;

	SET @Count += 1;
END

USE [Payroll]

SELECT 
	[Employee_FirstName], 
	[Location],
	(	CASE 
			WHEN [Location] IN ('Bombay','Delhi')
				THEN 'METRO'
			WHEN [Location] IN ('Mysore','Banglore')
				THEN 'TIER-1'
			ELSE
				'TIER-2'
		END ) AS [LocationCategories]
FROM [Employees]

--___________________________________________________________________________________________
--1.Write T-SQL block to generate Fibonacci series 
DECLARE @Number1 BIGINT = 1, @Number2 BIGINT = 1, @Count INT = 3, @NewNumber BIGINT;
PRINT 'Number-0: 0';
PRINT 'Number-1: '+CAST(@Number1 AS VARCHAR);
PRINT 'Number-2: '+CAST(@Number2 AS VARCHAR);

WHILE @Count<=50
BEGIN
	SET @NewNumber = @Number1+@Number2;
	PRINT 'Number-'+CAST(@Count AS VARCHAR)+': '+CAST(@NewNumber AS VARCHAR);
	SET @Number1 = @Number2;
	SET @Number2 = @NewNumber;

	SET @Count += 1;
END
--___________________________________________________________________________________________
--2.Create student and result table and perform the following: 

--		Refer previous SQL file

--___________________________________________________________________________________________
--3.Write query to find the grade of a student, if he scores above 90 its 'A’, 
--above 80 'B', above 70 ‘C’, above 60 ‘D’, above 50 ‘F’ or else print 
--failed.(Hint: Use Case ) 
USE [StudentMarks];

SELECT [MarkDtl].*,
	(	CASE
			WHEN [Marks]>90
				THEN 'A'
			WHEN [Marks]>80
				THEN 'B'
			WHEN [Marks]>70
				THEN 'C'
			WHEN [Marks]>60
				THEN 'D'
			ELSE
				'F'
		END) AS [Grade]
FROM 
	[MarkDtl]

--___________________________________________________________________________________________
--4.Display month on which the employee is born. Use case statement. 
USE [Payroll];
SELECT * FROM [Employees]

SELECT 
	[Employees].*,
	(	CASE
			WHEN DATEPART(MM, [JoiningDate])=1 
				THEN 'January'
			WHEN DATEPART(MM, [JoiningDate])=2
				THEN 'February'
			WHEN DATEPART(MM, [JoiningDate])=3 
				THEN 'March'
			WHEN DATEPART(MM, [JoiningDate])=4 
				THEN 'April'
			WHEN DATEPART(MM, [JoiningDate])=5 
				THEN 'May'
			WHEN DATEPART(MM, [JoiningDate])=6 
				THEN 'June'
			WHEN DATEPART(MM, [JoiningDate])=7 
				THEN 'July'
			WHEN DATEPART(MM, [JoiningDate])=8 
				THEN 'August'
			WHEN DATEPART(MM, [JoiningDate])=9 
				THEN 'September'
			WHEN DATEPART(MM, [JoiningDate])=10 
				THEN 'October'
			WHEN DATEPART(MM, [JoiningDate])=11
				THEN 'November'
			ELSE 'December'
		END) 
FROM
	[Employees]


--___________________________________________________________________________________________
--5.Write T-SQL statements to generate 10 prime numbers greater than 1000. 
DECLARE @Number INT = 1001, @Count INT =1;
WHILE(@Count<=10)
BEGIN
	DECLARE @Num INT = 2, @IsPrime BIT =1;
	WHILE(@Num <= SQRT(@Number))
	BEGIN
		IF (@Number % @Num) = 0
		BEGIN
			SET @IsPrime=0;
			BREAK
		END

		SET @Num += 1;
	END

	IF (@IsPrime=1)
	BEGIN
		PRINT @Number;
		SET @Count+=1;
	END
	
	SET @Number += 1;
END



--___________________________________________________________________________________________
--6.Consider HR Database and generate bonus to employees as below: 
--A)one month salary  if Experience>10 years  
--B)50% of salary  if experience between 5 and 10 years  
--C)Rs. 5000  if Eexperience less than 5 years 
SELECT * FROM [Employees]
SELECT * FROM [tblDepartmentC]


SELECT
	[E].*, 
	(	CASE
			WHEN DATEDIFF(YYYY,[JoiningDate],GETDATE())>10
				THEN [Salary]
			WHEN DATEDIFF(YYYY,[JoiningDate],GETDATE()) BETWEEN 5 AND 10
				THEN [Salary]*0.5
			ELSE
				5000
		END) AS [NewBonus]
FROM
	[Employees] [E]
	INNER JOIN [tblDepartmentC] [D]
		ON [E].[DepartmentId]=[D].[DepartmentID]
WHERE 
	[DepartmentName] IN ('HR');

--___________________________________________________________________________________________ 
USE [Bank];
/*
SELECT * FROM [CustomerDetails];
SELECT * FROM [AccountType];
SELECT * FROM [AccountTransaction] ORDER BY [DateOfTrans] ASC;
SELECT * FROM [TransactionType];

CREATE TABLE [Passbook](
[AccNo] INT,
[TransId] INT,
[TransDate] DATETIME,
[TransType] INT,
[TransAmount] MONEY,
[Balance] MONEY,
CONSTRAINT FK_TransType_Passbook_CustomerDetails FOREIGN KEY([TransType]) REFERENCES [TransactionType]([TransType]),
CONSTRAINT FK_AccNo_Passbook_CustomerDetails FOREIGN KEY([AccNo]) REFERENCES [CustomerDetails]([CusAccNo]),
CONSTRAINT FK_TransId_Passbook_AccountTransaction FOREIGN KEY([TransId]) REFERENCES [AccountTransaction]([TransId]),
CONSTRAINT PK_AccNo_TransID PRIMARY KEY([AccNo],[TransID]));
*/
--7.Consider Banking database and Create a procedure to list the customers 
--with more than the specified minimum balance as on the given date. 

DECLARE @Given_date DATE='2023-10-19', @Min_balance MONEY=5000,@ans DATETIME;
SELECT * FROM [Passbook]

SELECT
	*
FROM 
	[CustomerDetails] [C1]
WHERE EXISTS
(
	SELECT
		1
	FROM(
		SELECT
			TOP 1 *
		FROM
			[Passbook] [P2]
		WHERE 
			[P2].[AccNo]=[C1].[CusAccNo]
			AND
			CAST([TransDate] AS DATE)<=@Given_date
		ORDER BY
			[TransDate] DESC) AS [Required]
	WHERE
		[Required].[Balance]>@Min_balance
)


--___________________________________________________________________________________________
--8.Based on balance categorize the customers as below: 
--a.if the balance is greater than minimum balance declare them as 
--‘Premium Customer' 
--b.if the balance is less than 0, 'Overdue Customer' 
--c.Else 'NON Premium Customer' 
USE [Bank];
SELECT * FROM [CustomerDetails]
SELECT 
	P.AccNo, 
	C.CusName, 
	P.Balance,
	(CASE
		WHEN P.Balance>@minBal THEN 'Premium Customer'
		WHEN P.Balance<0 THEN 'Overdue Customer'
		ELSE 'NON Premium Customer'
	END) AS StatusMessage
FROM Passbook P INNER JOIN CustomerDetails C ON P.AccNo=C.CusAccNo
WHERE P.TransId IN (SELECT MAX(TransId) FROM PassBook P1 WHERE P1.AccNo=P.AccNo ) 
--___________________________________________________________________________________________
-- 9. ADD Rs. 10000 as bonus to all the employees if the month is november

USE [Payroll];

DECLARE @Today VARCHAR(15) 
SET @Today = DATENAME(MM, GETDATE()) 
IF @Today = 'November'
BEGIN
	SELECT [Employee_FirstName], [Salary], [Salary] + 10000 AS [New Salary]
	FROM [Employees]
END
ELSE
	PRINT 'This month is ' + @Today + ', not November'

--_________________________ __________________________________________________________________
