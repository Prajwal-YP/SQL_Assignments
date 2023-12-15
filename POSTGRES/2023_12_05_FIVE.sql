--  1.Write a query to fetch the student_name,stipend and department_name from the students 
--  and departments table where the student_id is between 1 to 5 AND stipend is in the range of 2000 to 4000.

WITH 
	RequiredStudents AS(
		SELECT 
			StudentName AS "NAME",
			Stipend AS "STIPEND",
			StudentDepartment AS "Did"
		FROM 
			Students
		WHERE
			StudentId BETWEEN 1 AND 5)
SELECT 
	"NAME", "STIPEND", DepartmentName AS "DEPARTMENT_NAME"
FROM 
	RequiredStudents S 
	INNER JOIN Departments D 
		ON S."Did"=D.DepartmentId
WHERE
	"STIPEND" BETWEEN 2000 AND 4000;
	
-- 2.Write a query to fetch the sum value of the stipend from the students table based on 
-- the department_id where the departments 'Animation' and 'Marketing' should not be included and 
-- the sum value should be less than 4000.

WITH
	RequiredDepartments AS(
		SELECT *
		FROM Departments
		WHERE DepartmentName NOT IN ('Animation','Marketing')),
	RequiredStudents AS(
		SELECT * 
		FROM Students S 
			INNER JOIN RequiredDepartments D
				ON S.StudentDepartment=D.DepartmentId) 
SELECT DepartmentId, DepartmentName, SUM(Stipend)
FROM RequiredStudents
GROUP BY DepartmentId, DepartmentName
HAVING SUM(Stipend)<4000;

-- 3.Using the concept of multiple cte, fetch the maximum value, minimm value, average and sum of the 
-- stipend based on the department and return all the values.

WITH 
	MinMax AS(
		SELECT 
			StudentDepartment AS ID,
			MIN(Stipend) AS MINIMUM, 
			Max(Stipend) AS MAXIMUM
		FROM 
			Students
		GROUP BY
			StudentDepartment),
	SumAvg AS(
		SELECT 
			StudentDepartment AS ID,
			SUM(Stipend) AS SUM, 
			ROUND(AVG(Stipend),2) AS AVERGAE
		FROM 
			Students
		GROUP BY
			StudentDepartment)
SELECT
	*
FROM MinMax T1
	INNER JOIN SumAvg T2 USING (ID);
