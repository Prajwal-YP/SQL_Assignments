-- IN EmployeeDB Database

-- Table Department
CREATE TABLE Departments (
	DepartmentId NUMERIC PRIMARY KEY, 
	DepartmentName VARCHAR(200)); 

-- Table Employees
CREATE TABLE Employees ( 
	EmployeeId NUMERIC PRIMARY KEY,  
	FirstName VARCHAR(200) NOT NULL,  
	LastName VARCHAR(200) NOT NULL, 
	EmailId VARCHAR(200) UNIQUE,  
	PhoneNumber VARCHAR(200), 
	HireDate DATE DEFAULT CURRENT_DATE, 
	JobId VARCHAR(200), 
	Salary NUMERIC CHECK (salary > 0), 
	DepartmentId NUMERIC REFERENCES  Departments(DepartmentId),
	ManagerId NUMERIC REFERENCES Employees(EmployeeId)
		ON DELETE SET NULL ON UPDATE SET NULL,  
	Commission_pct numeric(2,2) ); 

-- Table JobHistory
CREATE TABLE JobHistory ( 
	EmployeeId NUMERIC, 
	StartDate DATE, 
	EndDate DATE, 
	JobId VARCHAR(200), 
	DepartmentId NUMERIC REFERENCES Departments(DepartmentId)
		ON DELETE SET NULL ON UPDATE SET NULL, 
	CONSTRAINT PK_JobHistory PRIMARY KEY (EmployeeId, StartDate),  
	CONSTRAINT FK_JobHistory_EmployeeId FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId) 
		ON DELETE SET NULL ON UPDATE SET NULL, 
	CONSTRAINT CK_JobHistory_Date CHECK (StartDate < EndDate) ); 

INSERT INTO Departments (DepartmentId, DepartmentName) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Operations'),
(6, 'Sales'),
(7, 'Engineering'),
(8, 'Customer Service'),
(9, 'Research'),
(10, 'Legal');



-- Insert data into Employees table

INSERT INTO Employees (EmployeeId, FirstName, LastName, EmailId, PhoneNumber, HireDate, JobId, Salary, DepartmentId, ManagerId, Commission_pct) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '123-456-7890', '2023-01-15', 'Manager', 70000, 1, NULL, 0.05),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '987-654-3210', '2023-02-20', 'Developer', 60000, 7, 1, 0.02),
(3, 'Mike', 'Johnson', 'mike.j@email.com', '555-123-4567', '2023-03-10', 'Analyst', 55000, 3, 1, NULL),
(4, 'Emily', 'White', 'emily.white@email.com', '333-555-7890', '2023-04-05', 'Marketing Specialist', 65000, 4, 1, 0.03),
(5, 'Chris', 'Lee', 'chris.lee@email.com', '111-222-3333', '2023-05-12', 'Customer Support', 50000, 8, 3, NULL),
(6, 'Sarah', 'Brown', 'sarah.b@email.com', '777-888-9999', '2023-06-18', 'Sales Representative', 60000, 6, 4, 0.01),
(7, 'Alex', 'Wong', 'alex.w@email.com', '444-666-7777', '2023-07-25', 'Engineer', 75000, 7, 6, NULL),
(8, 'Laura', 'Miller', 'laura.m@email.com', '222-444-8888', '2023-08-30', 'Researcher', 58000, 9, 6, 0.02),
(9, 'Tom', 'Chen', 'tom.c@email.com', '999-000-1111', '2023-09-05', 'Legal Counsel', 80000, 10, 7, 0.04),
(10, 'Olivia', 'Taylor', 'olivia.t@email.com', '666-999-2222', '2023-10-10', 'IT Specialist', 70000, 2, 7, NULL);



-- Insert data into JobHistory table

INSERT INTO JobHistory (EmployeeId, StartDate, EndDate, JobId, DepartmentId) VALUES
(1, '2023-01-15', NULL, 'Manager', 1),
(2, '2023-02-20', NULL, 'Developer', 7),
(3, '2023-03-10', NULL, 'Analyst', 3),
(4, '2023-04-05', NULL, 'Marketing Specialist', 4),
(5, '2023-05-12', NULL, 'Customer Support', 8),
(6, '2023-06-18', NULL, 'Sales Representative', 6),
(7, '2023-07-25', NULL, 'Engineer', 7),
(8, '2023-08-30', NULL, 'Researcher', 9),
(9, '2023-09-05', NULL, 'Legal Counsel', 10),
(10, '2023-10-10', NULL, 'IT Specialist', 2);


-- TABLES SCHEMA
----------------
-- Departments
-- DEPARTMENT_ID	|	DEPARTMENT_NAME

-- Employees
-- EMPLOYEE_ID	|	FIRST_NAME	|	LAST_NAME	|	EMAIL_ID	|	PHONENUMBER	|	HIRE_DATE	|	JOB_ID	|	SALARY	|	DepartmentId	|	MANAGER_ID	|	COMMISSION_PCT

-- JobHistory
-- EMPLOYEE_ID	|	START_DATE	|	END_DATE	|	JOB_ID	|	DEPARTMENT_ID

SELECT * FROM departments
SELECT * FROM employees	
SELECT * FROM JobHistory

-- 1.Retrieve the information of all the employees working in the organization. 
SELECT * 
FROM Employees;

-- 2.fetch the specific details like employee_id, first_name, email_id and salary from the 
-- employees table. 
SELECT
	EmployeeId, FirstName, EmailId, Salary
FROM
	Employees;

-- 3.Display the department numbers in which employees are present. If the 
-- department_id is present more than once then, only one value should be retrieved. 

SELECT DISTINCT DepartmentId
FROM Employees
ORDER BY DepartmentId;

-- 4. Display different job roles that are available in the company.  

SELECT DISTINCT JobId
FROM Employees

-- 5.Display the department data  in the ascending order and salary must be in 
-- descending order. 

SELECT DepartmentId, Salary
FROM Employees
ORDER BY 
	DepartmentId ASC,
	Salary DESC;

-- 6.retrieve the details of all the employees working in 10th department. 

SELECT *
FROM Employees
WHERE DepartmentId IN (10);

-- 7.details of the employees working in 10th department along with the employee 
-- details whose earning is more than 40000. 

SELECT *
FROM Employees
WHERE 
	DepartmentId IN (10)
	AND 
	Salary >40000;

-- 8.display the last name and the job title of the employees who were not allocated to 
-- the manager.

SELECT LastName, JobId
FROM Employees
WHERE ManagerId IS NULL;

-- 9.Generate a report for the employees whose salary ranges from 50000 to 70000 and 
-- they should either belongs to department 2 or department 7. Display the last name and 
-- the salary of the employee.  

SELECT LastName, Salary
FROM Employees
WHERE
	Salary BETWEEN 50000 AND 70000
	AND
	DepartmentId IN (2,7);
	
-- 10. the employees details who had joined in the year 2003  

SELECT *
FROM Employees
WHERE
	EXTRACT(YEAR FROM HireDate)=2003;

-- 11.Write a query to display the last_name and number of  months for which the 
-- employee have worked rounding the months_worked column to its nearest whole number.   
-- Hint: No of months should be calculated from the date of joining of an employee to till date. 

SELECT
	LastName,
	HireDate,
	EXTRACT(YEAR FROM AGE(NOW(),HireDate))*12  +
	EXTRACT(MONTH FROM AGE(NOW(),HireDate)) AS "Months Worked"
FROM
	Employees;
	
-- 12.calculate their spending's designation-wise from each department.  

SELECT DepartmentId, JobId, SUM(Salary+COALESCE(Commission_pct,0))
FROM Employees
GROUP BY DepartmentId, JobId
ORDER BY DepartmentId, JobId

-- 13.calculate the following details of the employees using aggregate function
-- in a department. 
-- 	∙Employee with highest salary 
-- 	∙Employee with lowest salary 
-- 	∙Total salary of all the employees in the department  
-- 	∙Average salary of the department 
-- Write a query to display the output  rounding the resultant values to its nearest whole 
-- number. 
	
SELECT 
	E1.DepartmentId,
	(SELECT E2.FirstName FROM Employees E2 WHERE E2.DepartmentId=E1.DepartmentId ORDER BY E2.Salary LIMIT 1) AS "Lowest Salary Holder",
	(SELECT E2.FirstName FROM Employees E2 WHERE E2.DepartmentId=E1.DepartmentId ORDER BY E2.Salary DESC LIMIT 1) AS "Highest Salary Holder",
	ROUND(AVG(Salary)) AS "Average Salary",
	SUM(Salary) AS "Total Salary"
FROM Employees E1
GROUP BY E1.DepartmentId
ORDER BY E1.DepartmentId;

-- 14.Modify the result obtained in the previous exercise to display the minimum, 
-- maximum, total and average salary for each job type. 

SELECT
	JobId,
	MIN(Salary) AS "Minimum Salary",
	MAX(Salary) AS "Maximum Salary",
	SUM(Salary) AS "Total Salary",
	AVG(Salary) AS "Average Salary"
FROM
	Employees
GROUP BY
	JobId;

-- 15.fetch the details of the departments having less than 3 employees and are working in 
-- the department whose department_id is greater than 5.  

SELECT DepartmentId
FROM Employees
WHERE DepartmentId > 5
GROUP BY DepartmentId
HAVING COUNT(EmployeeId)<3;

-- 16.fetch the manager_id and the minimum salary of the employee reporting to him. 
-- Arrange the result in descending order of the salaries excluding the details given below: 
-- ∙Exclude the employee whose manager is not mapped / not known. 
-- ∙Exclude the details if the minimum salary is less than or equal to 6000. 

SELECT E1.EmployeeId AS "Manager Id", MIN(E2.Salary) AS "Minimum Salary Employee"
FROM 
	Employees E1
	INNER JOIN Employees E2
		ON 
			E1.EmployeeId = E2.ManagerId
			AND
			E1.ManagerId IS NOT NULL
GROUP BY
	E1.EmployeeId;


-- 17. details of the employees who have never changed their job role in the company. 

SELECT EmployeeId, FirstName||LastName AS "EmployeeName"
FROM Employees E1
WHERE EmployeeId In (
	SELECT EmployeeId
	FROM jobhistory
	GROUP BY EmployeeId
	HAVING COUNT(*)=1)
ORDER BY EmployeeId;

-- SELECT CONCAT_WS(',','A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')
-- SELECT LPAD('abc',1,'0')
-- SELECT POSITION('Excel' IN 'Excelsoft')
-- SELECT SPLIT_PART('2023-01-13','-',2)

-- 18.fetch the employee names and their departments in which they are working. 

SELECT
	CONCAT_WS(' ',FirstName,LastName) AS "Employee Name",
	DepartmentName
FROM
	Employees E
	INNER JOIN Departments D
		ON E.DepartmentId=D.DepartmentId;

-- 19.retrieve all the department information with their corresponding employee names 
-- along with the newly added departments. 

SELECT 
	D.*,
	CONCAT_WS(' ',FirstName,LastName) AS "Employee Name"
FROM
	Employees E
	INNER JOIN Departments D
		ON E.DepartmentId=D.DepartmentId;


-- 20.details of the employee along with their managers. 

SELECT 
	E1.FirstName||E1.LastName AS "Manager",
	E2.FirstName||E2.LastName AS "Employee"
FROM 
	Employees E1
	INNER JOIN Employees E2
		ON E1.employeeId=E2.ManagerId
ORDER BY
	"Manager", "Employee";
	
-- 21. employee details who are reporting to the same manager as 'Emily White' reports to. 

SELECT 
	E1.FirstName||E1.LastName AS "Employees"
FROM 
	Employees E1
WHERE
		E1.ManagerId IN (
			SELECT E2.ManagerId
			FROM Employees E2
			WHERE E2.FirstName||E2.LastName = 'EmilyWhite');



-- 22.fetch the details of the employees working in the Legal department. 

SELECT *
FROM 
	Employees E
	INNER JOIN Departments D
	 ON 
	 	E.DepartmentId=D.DepartmentId
		AND
		D.Departmentname <> 'Legal'; 

-- 23.fetch the details of employee whose salary is greater than the 
-- average salary of all the employees. 

SELECT	*
FROM Employees
WHERE Salary > (
	SELECT AVG(Salary)
	FROM Employees)

-- 24. Write a query which displays all Ellen's colleague's names. 
-- Label the name as "John Doe's colleague".  
-- Hint: If an employee is Ellen's colleague then their department_id will be same. 

SELECT *
FROM Employees
WHERE 
	DepartmentId IN (
		SELECT DepartmentId
		FROM Employees
		WHERE firstName||LastName = 'JohnDoe')
	AND
	FirstName||LastName <> 'JohnDoe';

-- 25.which employees from adminstration team is/are earning less than 
-- all the employees. 

SELECT *
FROM Employees
ORDER BY Salary
OFFSET 0 ROWS
FETCH FIRST 1 ROWS WITH TIES;

-- 26.  Write a query to display the last name and salary of 
-- those who reports to JohnDoe. 

SELECT LastName, Salary
FROM Employees
WHERE ManagerId In (
	SELECT EmployeeId
	FROM Employees
	WHERE FirstName||LastName='JohnDoe');

-- 27. Write a query to display the below requirement.   
-- Fetch employee id and first name of who work in a department 
-- with the employee's having ‘e’ in the  last_name.  

SELECT EmployeeId, FirstName
FROM Employees
WHERE
	DepartmentId IS NOT NULL
	AND
	LastName ILIKE '%e%'; 

-- 28.the employee who is getting highest pay in the specific department. 

SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 0 ROWS
FETCH FIRST 1 ROWS WITH TIES

-- 29. the details of different employees who have atleast one person 
-- reporting to them. 

SELECT * FROM Employees
WHERE EmployeeId IN (
	SELECT DISTINCT ManagerId
	FROM Employees
	WHERE ManagerId IS NOT NULL);

-- 30. the departments which was formed but it does not have employees 
-- working in them currently.

SELECT *
FROM Departments
WHERE DepartmentId NOT IN (
	SELECT DISTINCT DepartmentId
	FROM Employees);
