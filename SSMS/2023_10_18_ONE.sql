-- ASSIGNMENTS (18-10-2023)

USE Payroll;

-- Refer 19_10_2023_Asgn-1.sql to see the creation code

-- 1.Insert 10 records into each table. 

	-- Inserting records into tblDepartments
INSERT INTO tblDepartment VALUES
(10, 'Development', 'Mysore'),
(20, 'Finance', 'Delhi'),
(30, 'Marketing', 'Banglore'),
(40, 'Testing', 'Manglore'),
(50, 'Management', 'Udupi');

	-- Inserting records into tblEmployees
INSERT INTO tblEmployee VALUES
(1000, 'Prajwal_Y_P', 'Software Engineer', '2019-10-16','prajwal@excelindia.com', 50000,10),
(1001, 'Sagar', 'Trainee Software Engineer', '2022-01-12','Sagar@excelindia.com', 35000,10),
(1002, 'Nishanth', 'Business Analysts', '2021-04-12','Nishanth@excelindia.com', 48000,20),
(1003, 'Raghu', 'Business Analysts', '2022-02-01','Raghu@excelindia.com', 16000,20),
(1004, 'Sushil', 'Copywriter', '2022-01-12','Sushil@excelindia.com', 15000,30),
(1005, 'Pavithra', 'Copywriter', '2019-10-12','Pavithra@excelindia.com', 38000,30),
(1006, 'Vatsala', 'Teacher', '2020-08-14','Vatsala@excelindia.com', 13000,NULL),
(1007, 'Subramanya', 'Teacher', '2019-09-18','Subramanya@excelindia.com', 19000,NULL),
(1008, 'Akash', 'Software Tester', '2017-09-08','Akash@excelindia.com', 38000,40),
(1009, 'Raj Shekara', 'Software Tester', '2017-09-08','Rajshekara@excelindia.com', 21000,50);


-- 2.Display Table information. 
--	EXEC sp_help tblEmployee;
SELECT *
FROM tblEmployee;

-- 3. Display Employee’s name,  EmployeeId, departmentId  from tblEmployee 
SELECT EmployeeName, EmployeeId, DepartmentID
FROM tblEmployee;

-- 4. Display Employee’s name,  EmployeeId, departmentId  of department 20 and 40. 
SELECT EmployeeName, EmployeeId, DepartmentId
FROM tblEmployee
WHERE DepartmentId IN (20,40);

-- 5.Display information about all ‘ Trainees Software Engineer’  having salary less than 20000. 
SELECT *
FROM tblEmployee
WHERE Designation IN ('Trainee Software Engineer') AND Salary<20000;

-- 6. Display information about all employees of department 30 having salary greater than 20000.
SELECT *
FROM tblEmployee
WHERE DepartmentId IN (30) AND Salary>20000;

-- 7.Display list of employees who are not allocated with Department. 
SELECT *
FROM tblEmployee
WHERE DepartmentID IS NULL;

-- 8.Display name and department of all ‘ Business Analysts’. 
SELECT EmployeeName, DepartmentId
FROM tblEmployee
WHERE Designation IN ('Business Analysts');

-- 9.	Display name, Designation and salary of all the employees of department 30 who earn 
--		more than 20000 and less than 40000. 
SELECT EmployeeName, Designation, Salary
FROM tblEmployee
WHERE DepartmentId IN (30) AND Salary BETWEEN 20000+1 AND 40000-1;
--WHERE DepartmentId IN (30) AND Salary>20000 AND Salary<40000;

-- 10.Display unique job of tblEmployee. 
SELECT DISTINCT Designation
FROM tblEmployee
ORDER BY Designation;

-- 11.Display list of employees who earn more than 20000 every year of department 20 and 30. 
SELECT *
FROM tblEmployee
WHERE Salary>20000 AND DepartmentID IN (20,30);

-- 12.  List Designation, department no and Joined date in the format of Day, Month, and Year of 
--		department 20. 

--SELECT Designation, DepartmentId, Day(JoiningDate) AS 'Day', MONTH(JoiningDate) AS 'Month', YEAR(JoiningDate) AS 'Year'
--FROM tblEmployee
--WHERE DepartmentId IN (20);
--								OR
--SELECT Designation, DepartmentId,FORMAT(JoiningDate,'dd-MM-yyyy') AS 'dd-mm-yyyy'
--FROM tblEmployee
--WHERE DepartmentId IN (20);
--								OR
SELECT Designation, DepartmentId, CONVERT(VARCHAR,DATEPART(DD,JoiningDate)) +'-'+CONVERT(VARCHAR,DATEPART(MM,JoiningDate))+'-'+CONVERT(VARCHAR,DATEPART(YYYY,JoiningDate),105) AS [dd-mm-yyyy]
FROM tblEmployee
WHERE DepartmentId IN (20);
select CONVERT(varchar,getdate(),104)
-- 13.Display employees whose name starts with an vowel 
SELECT *
FROM tblEmployee
--WHERE EmployeeName LIKE 'a%' OR EmployeeName LIKE 'e%' OR EmployeeName LIKE 'i%' OR EmployeeName LIKE 'o%' OR EmployeeName LIKE 'u%' OR EmployeeName LIKE 'A%' OR EmployeeName LIKE 'E%' OR EmployeeName LIKE 'I%' OR EmployeeName LIKE 'O%' OR EmployeeName LIKE 'U%';
WHERE EmployeeName LIKE '[aeiouAEIOU]%';

-- 14.Display employees whose name is less than 10 characters 
SELECT *
FROM tblEmployee
WHERE LEN(EmployeeName)<10;

-- 15.Display employees who have ‘N’ in their name 
SELECT *
FROM tblEmployee	
WHERE EmployeeName LIKE '%N%';

-- 16.Display the employees with more than three years of experience 
SELECT *
FROM tblEmployee
WHERE DATEDIFF(year,JoiningDate,GETDATE())>3;

-- 17.Display employees who joined on Monday 
SELECT *
FROM tblEmployee
WHERE DATENAME(dw,JoiningDate) IN ('Monday');

-- 18.Display employees who joined on 1st. 
SELECT *
FROM tblEmployee
WHERE DATEPART(DD,JoiningDate)=1;
--WHERE DAY(JoiningDate);


-- 19.Display all Employees joined in January 
SELECT *
FROM tblEmployee
WHERE MONTH(JoiningDate) IN (01);

-- 20.Display Employees with their Initials. 
SELECT *
FROM tblEmployee
WHERE EmployeeName LIKE '%[-_ ]_%';
