USE [Payroll];

-- SALESMAN TABLE
CREATE TABLE [Salesman](
[Snum] INT PRIMARY KEY,
[Sname] VARCHAR(50) NOT NULL,
[City] VARCHAR(50) NOT NULL,
[Commission] INT NOT NULL);
--_____________________________________________________
-- CUSTOMER TABLE
CREATE TABLE [Customer](
[Cnum] INT PRIMARY KEY,
[Cname] VARCHAR(50) NOT NULL,
[City] VARCHAR(50) NOT NULL,
[Rating] INT NOT NULL,
[Snum] INT FOREIGN KEY REFERENCES [Salesman]([Snum]));


--_____________________________________________________
-- ORDER TABLE
CREATE TABLE [Orders](
[Onum] INT PRIMARY KEY,
[Oamount] DECIMAL(7,2) NOT NULL,
[Odate] DATETIME NOT NULL,
[Cnum] INT FOREIGN KEY REFERENCES [Customer]([Cnum]),
[Snum] INT FOREIGN KEY REFERENCES [Salesman]([Snum]));

--_____________________________________________________

INSERT INTO [Salesman] VALUES
(1001, 'Piyush', 'London', 11), 
(1002, 'Sejal', 'Surat', 10),
(1004, 'Rashmi', 'London', 21),
(1007, 'Rajesh', 'Baroda', 14),
(1003, 'Anand', 'New Delhi', 15);

INSERT INTO [Salesman] VALUES
(1005, 'Sandeep', 'Mumbai', 10);

INSERT INTO [Customer] VALUES
(2001, 'Harsh', 'London', 100, 1001),
(2002, 'Gita', 'Rome', 200, 1003),
(2003, 'Lalit', 'Surat', 200, 1002),
(2004, 'Govind', 'Bombay', 300, 1002),
(2006, 'Chirag', 'London', 100, 1001),
(2008, 'Chinmay', 'Surat', 300, 1007),
(2007, 'Pratik', 'Rome', 100, 1004);

INSERT INTO [Customer] VALUES
(2005, 'Virat', 'New Delhi', 100, 1001);

INSERT INTO [Orders] VALUES
(3001, 18.69, '10/03/06', 2008, 1007),
(3003, 767.19, '10/03/06', 2001, 1001),
(3002, 1900.10, '10/03/06', 2007, 1004),
(3005, 5160.45, '10/03/06', 2003, 1002),
(3006, 1098.16, '10/03/06', 2008, 1007),
(3009, 1713.23, '10/04/06', 2002, 1003),
(3007, 75.75, '10/04/06', 2004, 1002),
(3008, 4723.00, '10/05/06', 2006, 1001),
(3010, 1309.95, '10/06/06', 2004, 1002),
(3011, 9891.88, '10/06/06', 2006, 1001);

SELECT * FROM [Salesman]
SELECT * FROM [Customer]
SELECT * FROM [Orders]


--	1.	Display the following information about each order. 
--			a.Order No, Customer Name, Order Amount, Order Date 
SELECT 
	[Onum], [Cname], [Oamount], [Odate]
FROM 
	[Orders] [O] 
	INNER JOIN [Customer] [C] 
		ON [O].[Cnum]=[C].[Cnum]
ORDER BY 
	[Odate];
--______________________________________________________________________________________
--	2.	Display customers associated with each Salesman 

SELECT 
	*
FROM 
	[Salesman] [S] 
	LEFT OUTER JOIN [Customer] [C] 
		ON [S].[Snum]=[C].[Snum];

--______________________________________________________________________________________
--	3.	Display following information about each order: 
--			a.OrderNo , Customer Name, Salesman Name, Order Amount, Order Date
SELECT 
	[Onum], [Cname], [Sname], [Odate]
FROM 
	[Orders] [O] 
	INNER JOIN [Salesman] [S] 
		ON [O].[Snum]=[S].[Snum]
	INNER JOIN [Customer] [C] 
		ON [O].[Cnum]=[C].[Cnum];

--______________________________________________________________________________________
--	4.	Display salesman with their order details in the decreasing order 
--		value(Include salesman who has not captured any order) 
--			a.Salesman name, Customer name,Ordervalue 
SELECT * FROM [Salesman];

SELECT 
	[Sname], [Cname], [Oamount]
FROM 
	[Orders] [O] 
	INNER JOIN [Customer] [C] 
		ON [O].[Cnum]=[C].[Cnum]
	RIGHT JOIN [Salesman] [S] 
		ON [O].[Snum]=[S].[Snum];
--						OR
SELECT * FROM [Salesman];

SELECT 
	[Sname], [Cname], [Oamount]
FROM 
	[Salesman] [S]
	LEFT JOIN [Orders] [O] 
		ON [O].[Snum]=[S].[Snum]
	LEFT JOIN [Customer] [C] 
		ON [O].[Cnum]=[C].[Cnum];

--______________________________________________________________________________________
--	5.	Display customers with their orders in the ascending order of date(Include 
--		customers who hasn’t booked any order) 
--			a.Customer Name, Order Value Order date 

SELECT * FROM [Customer];
SELECT [Cname], [Oamount], [Odate]
FROM [Customer] [C]
LEFT JOIN [Orders] [O] ON [C].[Cnum]=[O].[Cnum]
ORDER BY [Odate];

--______________________________________________________________________________________
--	6.	List the number of customers handled by each salesman.(Sales man 
--		name, Number of Customers handled) 
SELECT [Sname], COUNT(Cnum) AS [Number Of Customers Handled]
FROM [Salesman] [S]
LEFT JOIN [Customer] [C] ON [S].[Snum]=[C].[Snum]
GROUP BY [S].[Snum],[Sname];
--______________________________________________________________________________________
--	7.	List the customers(Name of the customer) who have placed more than 
--		one order 

SELECT [Cname]
FROM  [Customer] [C]
INNER JOIN [Orders] [O] ON [C].[Cnum]=[O].[Cnum]
GROUP BY [Cname]
HAVING COUNT([Onum])>1;

--______________________________________________________________________________________
--	8.	Display sum of orders from each city from each customer and salesman 

SELECT 
	[Sname],[C].[City],[CName], COUNT(Onum) AS [Total Orders], SUM([Oamount]) AS [Total Revenue]
FROM 
	[Customer] [C]
	INNER JOIN [Salesman] [S]
		ON [C].[Snum]=[S].[Snum]
	INNER JOIN [Orders] [O] 
		ON [c].[Cnum]=[O].[Cnum]
GROUP BY 
	[Sname],[S].[Snum],[C].[City],[C].[Cnum],[CName];
--______________________________________________________________________________________


--	1. Display All employees with their Department Names(Exclude the employees not allocated with department)
SELECT 
	[Employee_FirstName],  [DepartmentName]
FROM 
	[Employees] [E]
	INNER JOIN [tblDepartmentC] [D]	
		ON [E].[DepartmentId]=[D].[DepartmentID];

--_____________________________________________________________________________________________
--	2. Display employees joined in the year 2020 with their Department Names
SELECT 
	[Employee_FirstName],  [DepartmentName]
FROM 
	[Employees] [E]
	INNER JOIN [tblDepartmentC] [D] 
		ON [E].[DepartmentId]=[D].[DepartmentID]
WHERE 
	DATEPART(YYYY,[JoiningDate])=2020;
--_____________________________________________________________________________________________
--	3. Display employees who work in their hometown  with their Department Names(Exclude the employees not allocated with department)
SELECT [E].*,  [DepartmentName]
FROM [Employees] [E]
INNER JOIN [tblDepartmentC] [D] ON [E].[DepartmentId]=[D].[DepartmentID]
WHERE [E].[Location]=[D].[Location];

--_____________________________________________________________________________________________
--	4. Display All Departments with their employees(Include departments without Employees too)
SELECT [D].*, [Employee_FirstName]
FROM [tblDepartmentC] [D]
LEFT JOIN [Employees] [E] ON [D].[DepartmentID]=[E].[DepartmentId]
ORDER BY [DepartmentName], [Employee_FirstName];

--_____________________________________________________________________________________________
--	5. Display all employees with their department locations(Include employees who are not allocated with department)
SELECT [Employee_FirstName], [D].[Location]
FROM [Employees] [E]
LEFT JOIN [tblDepartmentC] [D] ON [E].[DepartmentId]=[D].[DepartmentID]

--_____________________________________________________________________________________________

-- SELF JOIN
--	Ued to establish connection with two columns of a same table
SELECT * FROM [Employees]
SELECT * FROM [tblDepartmentC]

ALTER TABLE [Employees]
ADD [ManagerId] INT FOREIGN KEY REFERENCES [Employees]([EmployeeId]);

SELECT [E1].[Employee_FirstName] AS [Employees], [E2].[Employee_FirstName] AS [Manager]
FROM [Employees] [E1]
LEFT JOIN [Employees] [E2] ON [E1].[ManagerId]=[E2].[EmployeeID];


-- Display all employees who have atleast 1 person reporting to them
SELECT [E2].[Employee_FirstName] AS [Managers], COUNT([E1].[Employee_FirstName]) AS [Number of Employees]
FROM [Employees] [E1]
INNER JOIN [Employees] [E2] ON [E1].[ManagerId]=[E2].[EmployeeID]
GROUP BY [E2].[Employee_FirstName];

-- Display all employees with number of persons reporting to them
SELECT [E1].[Employee_FirstName] AS [Employee], COUNT([E2].[Employee_FirstName]) AS [Number of employees reports]
FROM [Employees] [E1]
LEFT JOIN [Employees] [E2] ON [E1].[EmployeeID]=[E2].[ManagerId]
GROUP BY [E1].[Employee_FirstName];
