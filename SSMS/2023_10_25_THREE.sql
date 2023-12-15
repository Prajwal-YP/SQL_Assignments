-- ASSIGNMENTS

USE [Payroll];

SELECT * FROM [tblDepartmentC];

SELECT * FROM [tblEmployeeDtlC];

-- 1.	Display all the employees data by sorting the date of joining in the ascending order and 
-- then by name in descending order. 

SELECT *
FROM [tblEmployeeDtlC]
ORDER BY [JoiningDate], [EmployeeName] DESC;

--______________________________________________________________________________________________________
-- 2.	Modify the column name EmployeeName to Employee_FirstName and also add another 
-- column Employee_LastName  

EXEC sp_rename '[tblEmployeeDtlC].[EmployeeName]', 'Employee_FirstName','COLUMN';

ALTER TABLE [Employees]
ADD [Employee_LastName] VARCHAR(50);

-- Caution: Changing any part of an object name could break scripts and stored procedures.

--______________________________________________________________________________________________________ 
-- 3.	Write a query to change the table name to Employees. 

EXEC sp_rename '[tblEmployeeDtlC]', 'Employees'
SELECT * FROM [Employees];

--______________________________________________________________________________________________________ 
-- 4.	Write a query to update the salary of those employees whose location is ‘Mysore’ to 35000.

UPDATE [Employees]
SET [Salary] = 35000
WHERE [DepartmentId] IN (
	SELECT [DepartmentId]
	FROM [tblDepartmentC]
	WHERE [Location] IN ('Mysore'));

--______________________________________________________________________________________________________ 
-- 5.	Write a query to disassociate all trainees from their department  

UPDATE [Employees]
SET [DepartmentId]=NULL
WHERE [Designation] LIKE '%Trainees%';

--______________________________________________________________________________________________________ 
-- 6.	Write a query which adds another column ‘Bonus’ to the table Employees where the bonus 
-- is equal to the salary multiplied by ten. Update the value only when the experience is two 
-- years or above. 

ALTER TABLE [Employees]
ADD [Bonus] INT DEFAULT 0;

UPDATE [Employees]
SET [BONUS] =[Salary]*10
WHERE DATEDIFF(YYYY,[JoiningDate], GETDATE())>2;

SELECT * FROM [Employees]
--______________________________________________________________________________________________________ 
-- 7.	Display name and salary of top 5 salaried employees from Mysore and Banglore. 

SELECT TOP 5 [Employee_FirstName], [Salary]
FROM [Employees] INNER JOIN [tblDepartmentC]
ON ( [Employees].[DepartmentId] = [tblDepartmentC].[DepartmentId] )
WHERE [Location] IN ('Mysore','Banglore')
ORDER BY [Salary] DESC;

--______________________________________________________________________________________________________ 
-- 8.	Display name and salary of top 3 salaried employees(Include employees with tie) 

SELECT TOP 3 WITH TIES [Employee_FirstName], [Salary]
FROM [Employees]
ORDER BY [Salary] DESC;

--______________________________________________________________________________________________________ 
-- 9.	Display top 1% salaried employees from Mysore and Bangalore 

SELECT TOP 1 PERCENT *
FROM [Employees] INNER JOIN [tblDepartmentC]
ON ( [Employees].[DepartmentId] = [tblDepartmentC].[DepartmentId] )
WHERE [Location] IN ('Mysore','Banglore')
ORDER BY [Salary] DESC;

--______________________________________________________________________________________________________ 
-- 10.	Find average and total salary for each job. 

SELECT [Designation] AS [Role], AVG([Salary]) AS [Average Salary], SUM([Salary]) AS [Total Salary]
FROM [Employees]
GROUP BY [Designation];

--______________________________________________________________________________________________________ 
-- 11.	Find highest salary of all departments. 
SELECT [DepartmentId], MAX([Salary]) AS [Maximum Salary]
FROM [Employees]
GROUP BY [DepartmentId];
--______________________________________________________________________________________________________ 
-- 12.	Find minimum salary of all departments. 

SELECT [DepartmentId], MIN([Salary]) AS [Minimum Salary]
FROM [Employees]
GROUP BY [DepartmentId];

--______________________________________________________________________________________________________ 
-- 13.	Find difference in highest and lowest salary for all departments. 

SELECT MAX([Salary])-MIN([Salary]) AS [Salary Difference]
FROM [Employees]
GROUP BY [DepartmentId];

--______________________________________________________________________________________________________ 
-- 14.	Find average and total salary for trainees 

SELECT AVG([Salary]) AS [Average Salary], SUM([Salary]) AS [Total Salary]
FROM [Employees]
WHERE [Designation] LIKE '%Trainees%';

--______________________________________________________________________________________________________ 
-- 15.	Count total different jobs held by dept no 30 

SELECT COUNT( DISTINCT [Designation])
FROM [Employees]
WHERE DepartmentId IN (30);

--______________________________________________________________________________________________________ 
-- 16.	Find highest and lowest salary for non-managerial job 

SELECT MAX([Salary]) AS [Maximum Salary], MIN([Salary]) AS [Minimum Salary]
FROM [Employees]
WHERE [Designation] NOT LIKE '%manager%'
GROUP BY [Desgination];


--______________________________________________________________________________________________________ 
-- 17.	Count employees and  average annual salary of each department. 

SELECT [DepartmentId], COUNT(*) AS [Total Employees], AVG([Salary]*12) AS [Average Annual Salary]
FROM [Employees]
GROUP BY [DepartmentId];

--______________________________________________________________________________________________________ 
-- 18.	Display the number of employees sharing same joining date. 

SELECT [JoiningDate], COUNT(*) AS [Total Employees]
FROM [Employees]
GROUP BY [JoiningDate]
HAVING [Total Employees]>1;

--______________________________________________________________________________________________________ 
-- 19.	Display number of employees with same experience 

SELECT [JoiningDate], COUNT(*) AS [Total Employees]
FROM [Employees]
GROUP BY [JoiningDate];

--______________________________________________________________________________________________________ 
-- 20.	Display total number of employees in each department with same salary 

SELECT [DepartmentId], [Salary], COUNT(*) AS [Total Employees]
FROM [Employees]
GROUP BY [DepartmentId], [Salary];

--______________________________________________________________________________________________________ 
-- 21.	Display the  number of Employees above 35 years in each department 

SELECT [DepartmentId], COUNT(*) AS [Employees experienced 35 years]
FROM [Employees]
GROUP BY [DepartmentId]
HAVING DATEDIFF(YY,[JoiningDate],GETDATE())=35;

--______________________________________________________________________________________________________ 
