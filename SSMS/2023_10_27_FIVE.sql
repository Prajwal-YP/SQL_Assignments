USE [Payroll];
--_____________________________________________________________________
--					H O S P I T A L
--_____________________________________________________________________
-- Creating table Patient
CREATE TABLE [Patient](
[PId] VARCHAR(5) PRIMARY KEY,
[Pname] VARCHAR(50) NOT NULL,
[Pcity] VARCHAR(50) NOT NULL);

-- Creating table Doctor
CREATE TABLE [Doctor](
[DId] VARCHAR(5) PRIMARY KEY,
[Dname] VARCHAR(50) NOT NULL,
[Ddepartment] VARCHAR(50) NOT NULL,
[Salary] DECIMAL(7,1) NOT NULL);

-- Creating table Consultation
CREATE TABLE [Consultation](
[CId] INT PRIMARY KEY,
[PId] VARCHAR(5) FOREIGN KEY REFERENCES [Patient]([PId]) NOT NULL,
[DId] VARCHAR(5) FOREIGN KEY REFERENCES [Doctor]([DId]) NOT NULL,
[Fee] DECIMAL(5,1) NOT NULL);

--_____________________________________________________________________

-- INSERTING TO Patient
INSERT INTO [Patient] VALUES
('P101', 'Kevin', 'New York'),
('P102', 'Merlin', 'Boston'),
('P103', 'Eliza', 'Chicago'),
('P104', 'Robert', 'New York'),
('P105', 'David', 'Chicago');

INSERT INTO [Doctor] VALUES
('D201', 'Jane', 'Cardiology', 150000),
('D202', 'Maria', 'Nephrology', 110000),
('D203', 'John', 'Cardiology', 160000),
('D204', 'Jack', 'Neurology', 125000);
INSERT INTO [Doctor] VALUES
('D205', 'Johnanna', 'Cardiology', 160000);

INSERT INTO [Consultation] VALUES
(501, 'P101', 'D204', 500),
(502, 'P102', 'D201', 600),
(503, 'P103', 'D202', 1100),
(504, 'P104', 'D203', 900),
(505, 'P105', 'D203', 550),
(506, 'P101', 'D202', 450);

UPDATE [Consultation]
SET [Fee]=900
WHERE [CId] IN (504)
--_____________________________________________________________________

--ASSIGNMENT QUESTION

--Requirement 1:	Identify the consultation details of patients with the letter ‘e’ anywhere in their name, 
--					who have consulted a cardiologist. Write a SQL query to display doctor’s name and patient’s 
--					name for the identified consultation details.

SELECT * FROM [Doctor]
SELECT * FROM [Patient]
SELECT * FROM [Consultation]

SELECT 
	[Dname], [Pname]
FROM 
	[Consultation] [C]
	INNER JOIN  [Doctor] [D]
		ON [C].[DId]=[D].[DId]
	INNER JOIN [Patient] [P]
		ON [C].[PId]=[P].[PId]
WHERE 
	[Pname] LIKE '%e%' AND [Ddepartment] IN ('cardiology');

--_____________________________________________________________________________________________________________________
-- Requirement 2 : 
--	Identify the doctors who have provided consultation to patients from the cities ‘Boston’ 
--	and ‘Chicago’. Write a SQL query to display department and number of patients as 
--	PATIENTS who consulted the identified doctor(s). 

SELECT 
	[Ddepartment], [D].[Dname], COUNT([P].[PId]) AS [Number of patients]
FROM 
	[Consultation] [C]
	INNER JOIN  [Doctor] [D] 
		ON [C].[DId]=[D].[DId]
	INNER JOIN [Patient] [P] 
		ON [C].[PId]=[P].[PId]
WHERE 
	[Pcity] IN ('Boston','Chicago')
GROUP BY 
	[Ddepartment],[D].[DId],[D].[Dname];

--_____________________________________________________________________________________________________________________
-- Requirement 3 : 
--	Identify the cardiologist(s) who have provided consultation to more than one patient. 
--	Write a SQL query to display doctor’s id and doctor’s name for the identified 
--	cardiologists. 
SELECT * FROM [Doctor]
SELECT * FROM [Patient]
SELECT * FROM [Consultation]

SELECT 
	[D].[DId], [Dname], COUNT([C].[PId]) AS [Number of patients]
	--"COUNT([C].[PId])" is not required
FROM 
	[Consultation] [C]
	INNER JOIN [Doctor] [D] 
		ON [C].[DId]=[D].[DId]
WHERE 
	[Ddepartment] IN ('Cardiology')
GROUP BY 
	[D].[DId],[Dname]
HAVING 
	COUNT([C].[PId])>1;

--_____________________________________________________________________________________________________________________
-- Requirement 4 : 
--		Report 1 – Display doctor’s id of all cardiologists who have been consulted by 
--		patients. 
			SELECT 
				[D].[DId]
			FROM 
				[Consultation] [C]
			INNER JOIN  
				[Doctor] [D] ON [C].[DId]=[D].[DId]
			WHERE 
				[Ddepartment]='Cardiology'
			GROUP BY 
				[D].[DId];
			--HAVING COUNT([P].[PId])>0;
--		Report 2 – Display doctor’s id of all doctors whose total consultation fee charged 
--		in the portal is more than INR 800. 
			SELECT 
				[DId]
			FROM 
				[Consultation]
			GROUP BY 
				[DId]
			HAVING 
				SUM([Fee])>800;
--	Write a SQL query to combine the results of the following two reports into a single report. 
--	The query result should NOT contain duplicate records. 
				(SELECT 
					DISTINCT [D].[DId]
				 FROM 
					[Consultation] [C]
					 INNER JOIN  [Doctor] [D] 
						ON [C].[DId]=[D].[DId]
				 WHERE 
					[Ddepartment]='Cardiology')
			UNION
				(SELECT 
					[DId]
				 FROM 
					[Consultation]
				 GROUP BY 
					[DId]
				 HAVING 
					SUM([Fee])>800);
			 --			OR

			 --SELECT [D].[DId]
			 --FROM [Consultation] [C]
			 --INNER JOIN  [Doctor] [D] ON [C].[DId]=[D].[DId]
			 --GROUP BY [D].[DId]
			 --HAVING SUM([Fee])>800;



--_____________________________________________________________________________________________________________________
-- Requirement 5 : 
--	Report 1 – Display patient’s id belonging to ‘New York’ city who have consulted 
--	with the doctor(s) through the portal. 
		SELECT 
			DISTINCT [P].[PId]
		FROM 
			[Consultation] [C]
			INNER JOIN [Patient] [P] 
				ON [C].[PId]=[P].[PId]
		WHERE 
			[Pcity] IN ('New York')
		GROUP BY 
			[P].[PId];

--	Report 2 – Display patient’s id who have consulted with doctors other than 
--	cardiologists and have paid a total consultation fee less than INR 1000. 
		SELECT 
			[PId]
		FROM 
			[Consultation] [C]
			INNER JOIN  [Doctor] [D] ON [C].[DId]=[D].[DId]
		WHERE 
			[Ddepartment] NOT IN ('Cardiology') 
		GROUP BY 
			[PId]
		HAVING 
			SUM([Fee])<1000;

			SET STATISTICS TIME ON;


-- Write a SQL query to combine the results of the following two reports into a single report. 
-- The query result should NOT contain duplicate records. 
			(SELECT 
				DISTINCT [P].[PId]
			 FROM 
				[Consultation] [C]
				INNER JOIN [Patient] [P] 
					ON [C].[PId]=[P].[PId]
			 WHERE 
				[Pcity] IN ('New York'))
		UNION
			(SELECT 
				[PId]
			 FROM 
				[Consultation] [C]
				INNER JOIN  [Doctor] [D] 
					ON [C].[DId]=[D].[DId]
			 WHERE 
				[Ddepartment] NOT IN ('Cardiology')
			 GROUP BY 
				[PId]
			 HAVING 
				SUM([Fee])<1000);

--_____________________________________________________________________________________________________________________


--_____________________________________________________________________
--					T O Y - S T O R E
--_____________________________________________________________________

-- CREATING TABLE Customers
CREATE TABLE [Customers](
	[CusId] INT PRIMARY KEY,
	[Cname] VARCHAR(50) NOT NULL,
	[Ctype] CHAR(1));

-- CREATING TABLE Category
CREATE TABLE [Category](
	[CId] CHAR(4) PRIMARY KEY,
	[Cname] VARCHAR(50) NOT NULL);

-- CREATING TABLE Toys
CREATE TABLE [Toys](
	[TId] CHAR(5) PRIMARY KEY,
	[Tname] VARCHAR(50) UNIQUE NOT NULL,
	[CId] CHAR(4) FOREIGN KEY REFERENCES [Category]([CId]) NOT NULL,
	[Price] INT NOT NULL,
	[Stock] INT NOT NULL);

-- CREATING TABLE Transactions
CREATE TABLE [Transactions](
	[TxnId] INT PRIMARY KEY,
	[CusId] INT FOREIGN KEY REFERENCES [Customers]([CusId]) NOT NULL,
	[TId] CHAR(5) FOREIGN KEY REFERENCES [Toys]([TId]) NOT NULL,
	[Quantity] INT,
	[Txncost] INT);


INSERT INTO [Customers] 
VALUES
	(101,'Tom','R'),
	(102,'Haary',NULL),
	(103,'Dick','P'),
	(104,'Joy','P');

INSERT INTO [Category] VALUES
('C101','Vehicles'),
('C102','Musical'),
('C103','Dolls'),
('C104','Craft');

INSERT INTO [Toys] VALUES
('T1001', 'GT Racing Car', 'C101', 500, 40),
('T1002', 'Hummer Monster Car', 'C101', 600, 20),
('T1003', 'ThunderBot Car', 'C101', 700, 15),
('T1004', 'Ken Beat', 'C102', 150, 20),
('T1005', 'Drummer', 'C102', 200, 10),
('T1006', 'Kelly', 'C103', 150, 13),
('T1007', 'Barbie', 'C103', 550, 40);

INSERT INTO [Toys] VALUES
('T1008', 'Ben10', 'C103', 550, 40);

INSERT INTO [Transactions] VALUES
(1000, 103, 'T1006', 5, 2750),
(1001, 104, 'T1002', 2, 1200),
(1002, 103, 'T1005', 3, 600),
(1003, 101, 'T1001', 1, 500),
(1004, 101, 'T1004', 3, 450),
(1005, 103, 'T1003', 3, 2100),
(1006, 104, 'T1003', 4, 2400);


SELECT * FROM [Customers]
SELECT * FROM [Category]
SELECT * FROM [Toys]
SELECT * FROM [Transactions]

--_________________________________________________________________

--	ASSIGNMENT QUESTIONS

-- 1.	Display CustName and total transaction cost as TotalPurchase for those customers 
--		whose total transaction cost is greater than 1000
SELECT 
	[Cname], SUM([T].[Txncost])
FROM 
	[Customers] [C]
	INNER JOIN [Transactions] [T]
		ON [C].[CusId]=[T].[CusId]
GROUP BY 
	[C].[Cname]
HAVING 
	SUM([T].[Txncost])>1000;

--_________________________________________________________________
-- 2.	List all the toyid, total quantity purchased as 'total quantity' irrespective of the 
--		customer. Toys that have not been sold should also appear in the result with total units as 0 
SELECT 
	[T].[TId], ISNULL(SUM([Quantity]),0) AS [Total Quantity]
FROM 
	[Toys] [T]
	LEFT JOIN [Transactions] [Tr] 
		ON [T].[TId]=[Tr].[TId]
GROUP BY 
	[T].[TId];

--_________________________________________________________________
--3.	The CEO of Toys corner wants to know which toy has the highest total Quantity sold. 
--		Display CName, ToyName, total Quantity sold of this toy. 
SELECT 
	TOP 1 WITH TIES [Cname],[Tname], SUM([Quantity]) AS [Total Quantity]
FROM 
	[Category] [C]
	INNER JOIN [Toys] [TY]
		ON [C].[CId]=[TY].[CId]
	INNER JOIN [Transactions][T] 
		ON [TY].[TId]=[T].[TId]
GROUP BY
	[Cname],[Tname]
ORDER BY
	SUM([Quantity]) DESC
--_________________________________________________________________

--		SELECT THE TOP 4th SALARY

	SELECT DISTINCT [SALARY]
	FROM [Employees]
	ORDER BY [Salary] DESC

	SELECT DISTINCT TOP(3) [Salary] 
	FROM [Employees] 
	ORDER BY [Salary] DESC

SELECT TOP 1 WITH TIES [Employee_FirstName],[Salary]
FROM  [Employees]
WHERE [Salary] NOT IN (SELECT DISTINCT TOP 3 [Salary] FROM [Employees] ORDER BY [Salary] DESC) 
ORDER BY [Salary] DESC;


SELECT * FROM [Employees]
SELECT * FROM [tblDepartmentC]

-- Employee who draws more salary than his departments average salary
SELECT [Employee_FirstName], [Salary], [AvgSal]
FROM [Employees] [E]
INNER JOIN (
	SELECT [DepartmentId], AVG([Salary]) AS [AvgSal]
	FROM [Employees]
	GROUP BY [DepartmentId]) [Ds] 
	ON [E].[DepartmentId]=[Ds].[DepartmentId]
WHERE [E].[Salary]>[Ds].[AvgSal]

-- Display the department drawing the highest sum of salaries
SELECT [D].[DepartmentId], [DepartmentName], SUM([Salary])
FROM [tblDepartmentC] [D]
INNER JOIN [Employees] [E] ON [D].[DepartmentID]=[E].[DepartmentId]
GROUP BY [D].[DepartmentId], [DepartmentName]
HAVING SUM([Salary])=(
	SELECT MAX(DeptSal) 
	FROM(
		SELECT [DepartmentId], SUM([Salary]) AS [DeptSal]
		FROM [Employees]
		GROUP BY [DepartmentId]) [T1]);

SELECT *
FROM [Employees] [E1]
WHERE [Salary]>(
	SELECT AVG([Salary])
	FROM [Employees] [E2]
	WHERE [E1].[DepartmentId]=[E2].[DepartmentId]);

SELECT *
FROM [tblDepartmentC] [D]
WHERE NOT EXISTS (
	SELECT 1
	FROM [Employees] [E]
	WHERE [E].[DepartmentId]=[D].[DepartmentId]);
