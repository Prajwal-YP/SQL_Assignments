CREATE TABLE Departments
(
   DepartmentId INT PRIMARY KEY,
   DepartmentName VARCHAR(100));

CREATE TABLE Students
(
	StudentId INT PRIMARY KEY,
	StudentName VARCHAR(100),
	StudentDepartment INT,
	Stipend INT,
	CONSTRAINT FK_Students 
	FOREIGN KEY(StudentDepartment) REFERENCES Departments(DepartmentId));
  
INSERT INTO Departments(DepartmentId,DepartmentName)
VALUES
(1,'Science'),
(2,'Commerce'),
(3,'Bio-Chemistry'),
(4,'Bio-Medical'),
(5,'Fine Arts'),
(6,'Literature'),
(7,'Animation'),
(8,'Marketing');

INSERT INTO Students(StudentId,StudentName,StudentDepartment,Stipend)
VALUES
(1,'Hadria',7,2000),
(2,'Trumann',2,2000),
(3,'Earlie',3,2000),
(4,'Monika',4,2000),
(5,'Aila',5,2000),
(6,'Trina',5,2000),
(7,'Esteban',3,2000),
(8,'Camilla',1,2000),
(9,'Georgina',4,2000),
(10,'Reed',6,16000),
(11,'Northrup',7,2000),
(12,'Tina',2,2000),
(13,'Jonathan',	2,2000),
(14,'Renae',7,2000),
(15,'Sophi',6,16000),
(16,'Rayner',3,2000),
(17,'Mona',6,16000),
(18,'Aloin',5,2000),
(19,'Florance',5,2000),
(20,'Elsie',5,2000);

SELECT * FROM Departments;
SELECT * FROM Students;

-- --stored procedures
-- 1.Write a stored procedure to insert values into the student table and 
-- also update the student_department to 7 when the student_id is between 400 and 700.

CALL USP_AddStudent(21,'Prajwal Y P',1,25000);

CREATE OR REPLACE PROCEDURE USP_AddStudent(
	IN _StudentId INT,
	IN _StudentName VARCHAR(100),
	IN _StudentDepartment INT,
	IN _Stipend INT)
AS
$$
BEGIN
	IF EXISTS(SELECT * FROM Students WHERE StudentID=_StudentId)
	THEN
		RAISE NOTICE 'Invalid Student ID';
		RETURN;
	END IF;
		INSERT INTO Students(StudentId,StudentName,StudentDepartment,Stipend)
		VALUES
		(_StudentId,_StudentName,_StudentDepartment,_Stipend);
		
		RAISE NOTICE 'Student ''%'' has been added !!',_StudentName;
	EXCEPTION
		WHEN OTHERS THEN
			RAISE NOTICE 'ERROR';
END;
$$
LANGUAGE PLPGSQL;

-- 2.Write a procedure to update the department name to 'Animation' when the department id is 7. 
-- This command has to be committed. Write another statement to delete the record from the students
-- table based on the studentid passed as the input parameter.This statement should not be committed.
SELECT * FROM Departments
SELECT * FROM Students;


CREATE OR REPLACE PROCEDURE USP_ModifyData(IN _StudentId INT)
AS
$$
DECLARE
	_DepartmentId INT;
	_Err VARCHAR[];
BEGIN	
		--AUTOMATICALLY TRANSACTION BEGAN
		BEGIN	-- BEGIN FOR TRY
			SELECT StudentDepartment INTO _DepartmentId
			FROM Students
			WHERE StudentId=_StudentId;

			IF _DepartmentId=7
			THEN
				UPDATE Departments
				SET DepartmentName = 'Anima'
				WHERE DepartmentId IN (_DepartmentId);
			END IF;
			
			EXCEPTION	-- BEGIN FOR CATCH
				WHEN OTHERS THEN
					RAISE NOTICE 'COULD NOT UPDATE !!';
					RAISE EXCEPTION '%',SQLERRM;
		END;	-- END OF TRY-CATCH
		COMMIT;
		
		--AUTOMATICALLY TRANSACTION BEGAN
		BEGIN	-- BEGIN FOR TRY
			DELETE FROM Students
			WHERE StudentId IN (_StudentId);
			EXCEPTION	-- BEGIN FOR CATCH
				WHEN OTHERS THEN
					RAISE NOTICE 'COULD NOT DELETE!!';
					RAISE EXCEPTION '%', SQLERRM;
		END;	-- END OF TRY-CATCH
		ROLLBACK;
		
END;
$$
LANGUAGE PLPGSQL;
CALL USP_ModifyData(1)


-- 3.Write a procedure to display the sum,average,minimum and maximum values 
-- of the column stipend from the students table.

CREATE OR REPLACE PROCEDURE USP_StipendDetails(
	INOUT "SUM" INT=NULL ,
	INOUT "AVERAGE" INT =NULL,
	INOUT "MINIMUM" INT=NULL,
	INOUT "MAXIMUM" INT=NULL )
AS
$$
	BEGIN
		SELECT 
			SUM(Stipend),AVG(Stipend),MIN(Stipend),MAX(Stipend) 
			INTO 
			"SUM","AVERAGE","MINIMUM","MAXIMUM"
		FROM
			Students;
	END
$$
LANGUAGE PLPGSQL;

CALL USP_StipendDetails()

-- --subqueries
-- 1.Fetch all the records from the table students where the stipend is more than 'Florence'
SELECT *
FROM Students
WHERE Stipend > ALL (
	SELECT Stipend
	FROM Students
	WHERE StudentName IN ('Florance'));

-- 2.Return all the records from the students table who get more than the minimum stipend of
-- the department 'FineArts'.
SELECT *
FROM Students
WHERE Stipend > (
	SELECT MIN(Stipend)
	FROM Students s 
	INNER JOIN Departments d
		ON s.StudentDepartment=d.DepartmentId
		AND d.DepartmentName IN ('Fine Arts'));


-- ---------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------
-- Questions based on the employee table 
-- 1.Using a subquery, list the name of the employees, paid more than 'Fred Costner' from employees.
SELECT CONCAT_WS(' ',FirstName,LastName) AS "Name"
FROM Employees
WHERE Salary*(1+COALESCE(Commission_PCT,0))> ALL(
	SELECT  Salary*(1+COALESCE(Commission_PCT,0))
	FROM Employees
	WHERE CONCAT_WS(' ',FirstName,LastName) IN ('Fred Costner') );
	
-- 2.Find all employees who earn more than the average salary in their department.
SELECT *
FROM Employees E1
WHERE E1.Salary>(
	SELECT AVG(Salary)
	FROM Employees E2
	WHERE E1.DepartmentId=E2.DepartmentId);

-- 3.Write a query to select those employees who does not work 
-- in those department where the managers of ID between 1 and 2 works.
SELECT *
FROM Employees E1
WHERE 
	ManagerId IN (1,2)
	AND
	DepartmentId NOT IN (
		SELECT DepartmentId
		FROM Employees E2
		WHERE E1.ManagerId=E2.EmployeeId);


-- 4.Find employees who have at least one person reporting to them.
SELECT * 
FROM Employees E1
WHERE EXISTS(
	SELECT *
	FROM Employees E2
	WHERE E1.EmployeeId=E2.ManagerId);
-- ---------------------------------------------------------------------------------------------

CREATE TABLE H(
id INT,
name VARCHAR)
-------------------------------------------------------------

CREATE OR REPLACE FUNCTION UDF_TR_INS()
RETURNS TRIGGER
AS
$$
BEGIN

	RAISE NOTICE '%
	%',OLD.name,NEW.name;

	IF OLD.name is NULL
	THEN
		RAISE EXCEPTION 'it can not be null';
	END IF;
	
	RETURN NEW;
END;
$$
Language PLPGSQL;
-------------------------------------------------------------

CREATE TRIGGER tr_ins
BEFORE INSERT
ON H
FOR EACH ROW
EXECUTE PROCEDURE UDF_TR_INS();

INSERT INTO H VALUES (1,'yp');
-------------------------------------------------------------------
