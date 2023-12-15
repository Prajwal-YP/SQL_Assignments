USE [Payroll];

-- CREATING tblDepartmentC 
DROP TABLE [tblDepartmentC];
CREATE TABLE [tblDepartmentC](
[DepartmentID] INT PRIMARY KEY,
[DepartmentName] VARCHAR(50) NOT NULL,
[Location] VARCHAR(50) NOT NULL);

--BONUS emp (10000)-> 2years
--Dislplay total sal bonus

-- CREATING tblEmployeeDtlC 
DROP TABLE [tblEmployeeDtlC]
CREATE TABLE [tblEmployeeDtlC](
[EmployeeID] INT PRIMARY KEY,
[EmployeeName] VARCHAR(50) NOT NULL,
[Designation] VARCHAR(50) NOT NULL,
[JoiningDate]  DATETIME  NOT NULL DEFAULT GETDATE(),
[EmailId] VARCHAR(25) UNIQUE  NOT NULL,
[PhoneNo] VARCHAR(10) NOT NULL,
[Salary] INT NOT NULL,
[DepartmentId] INT FOREIGN KEY REFERENCES [tblDepartmentC]([DepartmentID]),
CHECK( LEN([PhoneNo])=10),
CHECK( [Salary]>=15000));

-- INSERTING TO tblDepartmentC
INSERT INTO [tblDepartmentC] VALUES
(10, 'HR', 'Mysore'),
(20, 'Marketing', 'Delhi'),
(30, 'Finance', 'Banglore'),
(40, 'Sales', 'Manglore'),
(50, 'Customer Service', 'Udupi'),
(60, 'IT', 'Mysore'),
(70, 'R&D', 'Delhi'),
(80, 'Operations', 'Banglore'),
(90, 'Legal', 'Manglore'),
(100, 'Pulic Relations', 'Udupi');

INSERT INTO [tblEmployeeDtlC] VALUES
(1, 'Darshan', 'Recruiter', '2022-01-02','Darshan@excelindia.com', 1111111111, 30000,10),
(2, 'Raghu', 'HR Manager', '2021-01-21','Raghu@excelindia.com', 1111111112, 46000,10);

INSERT INTO [tblEmployeeDtlC] ([EmployeeID],[EmployeeName],[Designation],[EmailId],[PhoneNo],[Salary],[DepartmentId])
VALUES
(3, 'Prajwal Y P', 'Software Engineer','Prajwal.yp@excelindia.com', 9967917113, 50000,60),
(4, 'Sagar', 'Software Engineer','Sagar@excelindia.com', 9116818114, 31000,60),
(5, 'Nishanth', 'Software Engineer','Nishanth@excelindia.com', 9811171514, 31000,60);

INSERT INTO [tblEmployeeDtlC] VALUES
(6, 'Pavithra', 'Recruiter', '2021-01-02','Pavithra@excelindia.com', 8891214191, 30000,70),
(7, 'Vatsala Bhat', 'HR Manager', '2022-12-19','Vatsala@excelindia.com', 8916181112, 36000,70),
(8, 'Raghu Veer', 'HR Manager', '2020-08-26','Raghuveer@excelindia.com', 8141919112, 26000,90),
(9, 'Aakash', 'HR Manager', '2023-11-13','Aakash@excelindia.com', 8818191112, 26000,80),
(10, 'Mahesh', 'HR Manager', '2022-01-01','Mahesh@excelindia.com', 9721419112, 16000,90);

SELECT *
FROM [tblDepartmentC];

SELECT *
FROM [tblEmployeeDtlC];

--____________________________________________________________________________________________

-- CREATING TABLE tblSubjectDtl
CREATE TABLE [tblSubjectDtl](
[SubjectId] INT PRIMARY KEY,
[SubjectName] VARCHAR(50) NOT NULL);

-- CREATING TABLE tblStudentDtl
CREATE TABLE [tblStudentDtl](
[StudentId] INT PRIMARY KEY,
[StudentName] VARCHAR(50) NOT NULL);

-- CREATING TABLE tblStudentSubMarks
CREATE TABLE [tblStudentSubMarks](
[StudentId] INT FOREIGN KEY REFERENCES [tblStudentDtl]([StudentId]),
[SubjectId] INT FOREIGN KEY REFERENCES [tblSubjectDtl]([SubjectId]),
[Marks] DECIMAL(4,1) NOT NULL,
CONSTRAINT PK_StuSub PRIMARY KEY( [StudentId], [SubjectId] ),
CHECK([Marks] BETWEEN 0 AND 100));

EXEC sp_help [tblStudentSubMarks];


-- INSERTING TO tblSubjectDtl
INSERT INTO [tblSubjectDtl] VALUES
(100,'English'),
(101,'Kannada'),
(102,'Hindi'),
(103,'Tamil'),
(104,'Telugu'),
(105,'Malyali'),
(106,'Sanskrit'),
(107,'Urdu'),
(108,'Chinese'),
(109,'Tibetian');

SELECT *
FROM [tblSubjectDtl];

-- INSERTING TO tblStudentDtl
INSERT INTO [tblStudentDtl] VALUES
(1000,'Prajwal Y P'),
(1001,'Pavithra'),
(1002,'Sagar'),
(1003,'Nishanth'),
(1004,'Raj Shekar'),
(1005,'Raghu Veer'),
(1006,'Mahesh'),
(1007,'Aakash'),
(1008,'Sushil'),
(1009,'Harshith');

SELECT *
FROM [tblStudentDtl];

-- INSERTING TO tblStudentDtl
INSERT INTO [tblStudentSubMarks] VALUES
(1000,100,90), (1000,101,71)	,(1000,102,91.1),(1000,103,100)	,(1000,104,60.2),(1000,105,82)	,(1000,106,93)	,(1000,107,84)	,(1000,108,98)	,(1000,109,63),
(1001,100,92), (1001,101,90)	,(1001,102,80)	,(1001,103,90)	,(1001,104,90)	,(1001,105,80)	,(1001,106,70)	,(1001,107,30)	,(1001,108,19)	,(1001,109,100),
(1002,100,90), (1002,101,90)	,(1002,102,90)	,(1002,103,93)	,(1002,104,90)	,(1002,105,96)	,(1002,106,99)	,(1002,107,90)	,(1002,108,100)	,(1002,109,34),
(1003,100,90), (1003,101,40)	,(1003,102,60)	,(1003,103,90)	,(1003,104,90)	,(1003,105,100)	,(1003,106,90)	,(1003,107,90)	,(1003,108,70)	,(1003,109,98),
(1004,100,95), (1004,101,33)	,(1004,102,55)	,(1004,103,46)	,(1004,104,90)	,(1004,105,57)	,(1004,106,67)	,(1004,107,90)	,(1004,108,89)	,(1004,109,90),
(1005,100,68), (1005,101,100)	,(1005,102,90)	,(1005,103,90)	,(1005,104,80)	,(1005,105,87)	,(1005,106,90)	,(1005,107,97)	,(1005,108,100)	,(1005,109,96),
(1006,100,96), (1006,101,19)	,(1006,102,90)	,(1006,103,90)	,(1006,104,24)	,(1006,105,90)	,(1006,106,43)	,(1006,107,90)	,(1006,108,73)	,(1006,109,100),
(1007,100,90), (1007,101,90)	,(1007,102,96)	,(1007,103,90)	,(1007,104,48)	,(1007,105,100)	,(1007,106,90)	,(1007,107,90)	,(1007,108,90)	,(1007,109,99),
(1008,100,90), (1008,101,90)	,(1008,102,90)	,(1008,103,54)	,(1008,104,90)	,(1008,105,100)	,(1008,106,90)	,(1008,107,90)	,(1008,108,90)	,(1008,109,90),
(1009,100,90), (1009,101,76)	,(1009,102,100)	,(1009,103,90)	,(1009,104,90)	,(1009,105,76)	,(1009,106,90)	,(1009,107,37)	,(1009,108,90)	,(1009,109,100);

SELECT TOP 10 *
FROM [tblStudentSubMarks]
ORDER BY [Marks] DESC;
--____________________________________________________________________________________________

SELECT *
FROM [tblDepartmentC];

SELECT *
FROM [tblEmployeeDtlC];

SELECT *
FROM [tblSubjectDtl];

SELECT *
FROM [tblStudentDtl];

SELECT TOP 10 *
FROM [tblStudentSubMarks]
ORDER BY [Marks] DESC;
--____________________________________________________________________________________________


-- Dis-associate the trainees from the department in the employee table
UPDATE [tblEmployee]
SET [DepartmentId] = NULL
WHERE [Designation] LIKE '%Trainee%';

-- Give Bonus of Rs.10000 for employees who have more than 2 years experience.
-- Add Bonus column in employee table

ALTER TABLE [tblEmployee]
ADD [Bonus] INT;

UPDATE [tblEmployee]
SET [Bonus] = 10000
WHERE DATEDIFF(YEAR,[JoiningDate],GETDATE())>2;

SELECT *, [Salary]+COALESCE([Bonus],0) AS [Final Salary]
FROM [tblEmployee];
--					OR
SELECT *, [Salary]+ISNULL([Bonus],0) AS [Final Salary]
FROM [tblEmployee];

SELECT 2+98;
SELECT '2'+'98';
SELECT 2+'9'+'8';

-- COALESCE
--	It literally means 'combine (elements) in a mass or whole'
--	It takes multiples parameters
--	Result: It retuens the first Non-Null Parameters VALUE
SELECT COALESCE(NULL,2,NULL);
SELECT COALESCE(NULL,NULL,NULL);
-- Error: 'At least one of the arguments to COALESCE must be an expression that is not the NULL constant.'
