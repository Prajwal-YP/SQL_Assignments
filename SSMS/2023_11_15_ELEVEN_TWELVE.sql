--MovieGo is a ticket booking application to book movie tickets. 
--The application allows registered users to login and view the shows available based on the choice of location. 
--User can then choose a show and book tickets based on the availability of seats in a theatre. 
--To persist the data related to registered users, theaters available, shows currently running and the booking details. 
--The application has to store the data in a relational database. The application has the following features to be implemented. 

--	Users must register and then login to access the application 
--	The registered users can book movie tickets in theaters of their choice based on the location 
--	The ticket shows the show timings, seat number and theatre address 
--	The users must be able to view their previous bookings in the application 

CREATE DATABASE [MovieGo];

USE [MovieGo];

CREATE TABLE [tblUsers](
	[UserId]	VARCHAR(50)	Primary Key,
	[UserName]	VARCHAR(50)	NOT NULL,
	[Password]	VARCHAR(50)	NOT NULL,
	[Age]	INT	NOT NULL,
	[Gender]	CHAR(1)	NOT NULL,
	[EmailId]	VARCHAR(50)	UNIQUE,
	[PhoneNumber]	NUMERIC(10)	NOT NULL);

INSERT INTO [tblUsers]
VALUES
('mary_potter', 'Mary Potter', 'Mary@123', 25, 'F', 'mary_p@gmail.com', 9786543211),
('jack_sparrow', 'Jack Sparrow', 'Spar78!jack', 28, 'M', 'jack_spa@yahoo.com', 7865432102);


SELECT * FROM [tblUsers];


CREATE TABLE [tblTheatreDetails](
	[TheatreId]	INT	PRIMARY KEY, 
	[TheatreName] VARCHAR(50) NOT NULL,
	[Location] VARCHAR(50) NOT NULL);

INSERT INTO [tblTheatreDetails]
VALUES
	(1, 'PVR', 'Mysuru'),
	(2, 'Inox', 'Bengaluru');

SELECT * FROM [tblTheatreDetails];

CREATE TABLE [tblShowDetails](
	[ShowId] INT PRIMARY KEY IDENTITY(1001,1),
	[TheatreId] INT FOREIGN KEY REFERENCES [tblTheatreDetails]([TheatreId]),
	[ShowDate] DATE NOT NULL,
	[ShowTime] TIME NOT NULL,
	[MovieName] VARCHAR(50) NOT NULL,
	[TicketCost] DECIMAL(6,2) NOT NULL,
	[TicketsAvailable] INT NOT NULL);

INSERT INTO [tblShowDetails]
VALUES
	(1, '2023-11-28', '14:30:00', 'Avengers', 250.00, 100),
	(2, '2023-11-26', '17:30:00', 'Hit Man', 200.00, 150);

SELECT * FROM [tblShowDetails]

CREATE TABLE [tblBookingDetails](
[BookingId] VARCHAR(5) PRIMARY KEY,
[UserId] VARCHAR(50) FOREIGN KEY REFERENCES [tblUsers]([UserId]) NOT NULL,
[ShowId] INT FOREIGN KEY REFERENCES [tblShowDetails]([ShowId]) NOT NULL,
[NoOfTickets] INT NOT NULL,
[TotalAmt] DECIMAL(6,2) NOT NULL);

INSERT INTO [tblBookingDetails]
VALUES
('B1001', 'mary_potter', 1001, 2, 500.00),
('B1002', 'jack_sparrow', 1002, 5, 1000.00);

SELECT * FROM [tblBookingDetails]

--_________________________________________________________________________________________________________
--Create a stored procedure named usp_BookTheTicket to insert values into the BookingDetails table. 
--Implement appropriate exception handling.
--	Input Parameters:
--		UserId
--		ShowId
--		NoOfTickets
--	Functionality:
--		Check if UserId is present in Users table
--		Check if ShowId is present in ShowDetails table
--		Check if NoOfTickets is a positive value and is less than or equal to TicketsAvailable value for the particular ShowId
--		If all the validations are successful, insert the data by generating the BookingId and calculate the total amount based on the TicketCost
--	Return Values:
--		+1, in case of successful insertion
--		-1,if UserId is invalid
--		-2,if ShowId is invalid
--		-3,if NoOfTickets is less than zero
--		-4,if NoOfTickets is greater than TicketsAvailable
--		-99,in case of any exception

SELECT * FROM [tblUsers];
SELECT * FROM [tblTheatreDetails];
SELECT * FROM [tblShowDetails]
SELECT * FROM [tblBookingDetails]


CREATE OR ALTER PROCEDURE [usp_BookTheTicket]
	@UserId VARCHAR(50),
	@ShowId INT,
	@NoOfTickets INT
AS
BEGIN
	IF @UserId NOT IN ( SELECT [UserId] FROM [tblUsers] )
	BEGIN
		PRINT 'Not a valid User!!'
		RETURN -1;
	END

	IF @ShowId NOT IN ( SELECT [ShowId] FROM [tblShowDetails] )
	BEGIN
		PRINT 'Not a valid Show!!'
		RETURN -2;
	END

	IF @NoOfTickets<=0
	BEGIN
		PRINT 'Number of tickets booked should be 1 or more !!!'
		RETURN -3
	END

	DECLARE @AvailTickets INT=0;
	SELECT @AvailTickets= [TicketsAvailable] FROM [tblShowDetails] WHERE [ShowId] IN (@ShowId);
	IF @NoOfTickets>@AvailTickets
	BEGIN
		PRINT 'Tickets not available. ' + CAST(@AvailTickets AS VARCHAR) + ' tickets available !!'
		RETURN -4
	END

	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @NewId INT, @Price MONEY;
			SELECT TOP 1 @NewId=CAST(RIGHT([BookingId],4) AS INT) FROM [tblBookingDetails] ORDER BY [BookingId] DESC

			SELECT @Price=[TicketCost] FROM [tblShowDetails] WHERE [ShowId] IN (@ShowId)

			UPDATE [tblShowDetails]
			SET [TicketsAvailable] = [TicketsAvailable]-@NoOfTickets
			WHERE [ShowId] IN (@ShowId);

			INSERT INTO [tblBookingDetails]([BookingId],[ShowId],[NoOfTickets],[UserId],[TotalAmt]) 
			VALUES('B'+ CAST(@NewId+1 AS VARCHAR),@ShowId,@NoOfTickets,@UserId,@Price*@NoOfTickets);
		COMMIT
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
		RETURN -99;
	END CATCH
END

EXEC [usp_BookTheTicket] 'jack_sparrow' , 1001, 10

SELECT * FROM [tblUsers];
SELECT * FROM [tblTheatreDetails];
SELECT * FROM [tblShowDetails]
SELECT * FROM [tblBookingDetails]

--_________________________________________________________________________________________________________________________
--Function: ufn_GetMovieShowtimes 
--Create a function ufn_GetMovieShowtimes to get the show details based on the MovieName 
--and Location 
--Input Parameter: 
--	MovieName 
--	Location 
--Functionality: 
--	Fetch the details of the shows available for a given MovieName in a location 
--Return Value: 
--	A table containing following fields: 
--		MovieName 
--		ShowDate 
--		ShowTime 
--		TheatreName 
--		TicketCost 

ALTER FUNCTION [ufn_GetMovieShowtimes](@MovieName VARCHAR(50), @Location VARCHAR(50))
RETURNS TABLE
AS
RETURN
	SELECT [S].[MovieName], [S].[ShowDate], [S].[ShowTime], [T].[TheatreName], [S].[TicketCost]
	FROM
		[tblTheatreDetails] [T]
		INNER JOIN [tblShowDetails] [S]
			ON [T].[TheatreId]=[S].[TheatreId]
	WHERE
		[MovieName] IN (@MovieName)
		AND
		[Location] IN (@Location);

SELECT * FROM [dbo].[ufn_GetMovieShowtimes]('Avengers','Mysuru')
DROP FUNCTION [ufn_GetMovieShowtimes]

--_____________________________________________________________________________________________________________
--Function: ufn_BookedDetails 
--Create a function ufn_BookedDetails to get the booking details based on the BookingId 
--Input Parameter: 
--	BookingId 
--Functionality: 
--	Fetch the details of the ticket purchased based on the BookingId 
--Return Value: 
--A table containing following fields: 
--	BookingId 
--	UserName 
--	MovieName 
--	TheatreName 
--	ShowDate 
--	ShowTime 
--	NoOfTickets 
--	TotalAmt 

CREATE OR ALTER FUNCTION [ufn_BookedDetails](@BookingId VARCHAR(5))
RETURNS TABLE
AS
RETURN
	SELECT
		[B].[BookingId], 
		[U].[UserName], 
		[S].[MovieName],
		[T].[TheatreName],
		[S].[ShowDate],
		[S].[ShowTime],
		[B].[NoOfTickets],
		[B].[TotalAmt]
	FROM
		[tblBookingDetails] [B]
		INNER JOIN [tblUsers] [U]
			ON [B].[UserId] = [U].[UserId]
		INNER JOIN [tblShowDetails] [S]
			ON [S].[ShowId] = [B].[ShowId]
		INNER JOIN [tblTheatreDetails] [T]
			ON [T].[TheatreId] = [S].[TheatreId]
	WHERE
		[B].[BookingId] IN (@BookingId)

SELECT * FROM [ufn_BookedDetails]('B1001')
--_____________________________________________________________________________________________________________
--Write a function to display all emp who has more than 10y exp
USE [Payroll]

SELECT * FROM Employees
SELECT * FROM tblDepartmentC

CREATE OR ALTER FUNCTION [Emp_Senior](@Loc VARCHAR(50))
RETURNS TABLE
AS
RETURN
	SELECT
		[E].[EmployeeID] AS [EmpId], 
		[E].[Employee_FirstName] AS [EmployeeName],
		[E].[JoiningDate],
		DATEDIFF(YYYY,[E].[JoiningDate],GETDATE()) AS [Experience],
		[D].[DepartmentName],
		[E].[Salary]
	FROM
		[Employees] [E]
		INNER JOIN [tblDepartmentC] [D]
			ON [E].[DepartmentId]=[D].[DepartmentID]
	WHERE
		DATEDIFF(YYYY,[E].[JoiningDate],GETDATE())>5
		AND
		[E].[Location] IN (@Loc);


SELECT * FROM [dbo].[Emp_Senior]('delhi')

--_____________________________________________________________________________________________________________
DECLARE @t TABLE(
	[EmpID] INT NOT NULL);

SELECT * FROM @t

--_____________________________________________________________________________________________________________
CREATE DATABASE [Student];

USE [Student]

CREATE TABLE [tblDepartments](
	[DepartmentId] INT PRIMARY KEY,
	[DepartmentName] VARCHAR(50) NOT NULL);

INSERT INTO [tblDepartments]
VALUES
	(1, 'CSE'),
	(2, 'ISE'),
	(3, 'ECE');

SELECT * FROM [tblDepartments]

CREATE TABLE [tblStudentMaster](
	[StudentId] INT PRIMARY KEY,
	[StudentName] VARCHAR(50) NOT NULL,
	[DateOfJoin] DATETIME NOT NULL,
	[DepartmentId] INT FOREIGN KEY REFERENCES [tblDepartments]([DepartmentId]));

INSERT INTO [tblStudentMaster]
VALUES
	(1, 'Ravi', '1/5/2022', 1) ,
	(2, 'Shanthala', '3/7/2021', 2) ,
	(3, 'Sunad', '9/8/2021', 2) ;

SELECT * FROM [tblStudentMaster];

CREATE TABLE [tblSubjects](
	[SubjectId] INT PRIMARY KEY,
	[SubjectName] VARCHAR(50) NOT NULL);

INSERT INTO [tblSubjects]
VALUES
	(101, 'Web Design'),
	(102, 'C#.Net'),
	(103, 'RDBMS');

SELECT * FROM [tblSubjects];

CREATE TABLE [tblDepartmentSubjects](
	[SlNo] INT PRIMARY KEY,
	[DepartmentId] INT FOREIGN KEY REFERENCES [tblDepartments]([DepartmentId]),
	[SubjectId] INT FOREIGN KEY REFERENCES [tblSubjects]([SubjectId]),
	CONSTRAINT UK_tblDepartmentSubjects UNIQUE([DepartmentId],[SubjectId]));

INSERT INTO [tblDepartmentSubjects]
VALUES
	(1, 1, 101),
	(2, 2, 102),
	(3, 2, 101),
	(4, 1, 103);

SELECT * FROM [tblDepartmentSubjects] ORDER BY [SlNo];

CREATE TABLE [tblMarks](
	[StudentId] INT FOREIGN KEY REFERENCES [tblStudentMaster]([StudentId]),
	[SubjectId] INT FOREIGN KEY REFERENCES  [tblSubjects]([SubjectId]),
	[DoE] DATETIME NOT NULL,
	[Score] DECIMAL(5,2) NOT NULL,
	CONSTRAINT CK_tblMarks_Score CHECK([Score]>=0 AND [Score]<=100),
	CONSTRAINT PK_tblMarks_StuId_SubId PRIMARY KEY([StudentId],[SubjectId]));

INSERT INTO [tblMarks]
VALUES
	(1, 101, '2022-01-01', 72),
	(2, 101, '2022-01-01', 42),
	(2, 102, '2022-01-02', 25),
	(3, 101, '2022-01-01', 52),
	(3, 102, '2022-01-02', 59);

SELECT * FROM [tblMarks];
--_______________________________________________________________________________________________________________
--1.Each department has only five Subjects 
--2.Some subjects can be a common subject between the departments 
--3.Student can take test/assessment on the subjects as per his department 
--4.Student can attempt only once in each subject 
--5.The Pass marks is variable, a student must pass in all subjects  to Pass 
--6.Grades are based on the percentage of scores, those above 79% would be graded as distinction 
--	Those with 60 and above percentage would be graded as first class and those who score above 
--	50% are graded as second class, the remaining are classified as Just passed 
--	Grades are awarded only to those who pass in all subjects 

SELECT * FROM [tblDepartments]
SELECT * FROM [tblStudentMaster];
SELECT * FROM [tblSubjects];
SELECT * FROM [tblDepartmentSubjects] ORDER BY [SlNo];
SELECT * FROM [tblMarks];


--1, Create a function to List the details as shown below for the students of a given department and 
--given pass marks 
--| StudentID | Name | Total Marks | Percent | age | No of Subjects Passed | 
--No of Subjects attempted | Result | Grade |

SELECT * FROM FN_DeptartmentsStudentsReport(2,35)

CREATE OR ALTER FUNCTION FN_DeptartmentsStudentsReport(@DepartmentId INT, @PassMarks DECIMAL(5,3))
RETURNS @Report TABLE(
	StudentID INT,
	StudentName VARCHAR(50),
	TotalMarks DECIMAL(6,3),
	Percentage DECIMAL(5,3),
	PassedSubjects INT,
	AttemptedSubjects INT,
	Result VARCHAR(50),
	Grade VARCHAR(50))
AS
BEGIN
	INSERT INTO @Report(StudentID,StudentName,TotalMarks,Percentage,PassedSubjects,AttemptedSubjects,Result,Grade)
	SELECT DISTINCT
		--*,
		[S].[StudentId],
		[S].[StudentName],
		SUM([M].[Score]) OVER (PARTITION BY [S].[StudentId]) AS [TotalMarks],
		SUM([M].[Score]) OVER (PARTITION BY [S].[StudentId])/COUNT([DS].[SubjectId]) OVER (PARTITION BY [S].[StudentId]) AS [Percentage],
		(SELECT COUNT(*) FROM [tblMarks] [M1] WHERE [M1].[StudentId]=[S].[StudentId] AND [M1].[Score]>=@PassMarks) AS [PassedSubjects],
		COUNT([M].[SubjectId]) OVER (PARTITION BY [S].[StudentId]) AS [AttemptedSubjects],
		(CASE
			WHEN COUNT([DS].[SubjectId]) OVER (PARTITION BY [S].[StudentId])<>(SELECT COUNT(*) FROM [tblMarks] [M1] WHERE [M1].[StudentId]=[M].[StudentId] AND [Score]>=@PassMarks)
			THEN	'FAIL'
			ELSE	'PASS'
		END) AS [Result],
		(CASE
			WHEN SUM([M].[Score]) OVER (PARTITION BY [S].[StudentId])/COUNT([DS].[SubjectId]) OVER (PARTITION BY [S].[StudentId])>79
			THEN	'DISTINCTION'
			WHEN SUM([M].[Score]) OVER (PARTITION BY [S].[StudentId])/COUNT([DS].[SubjectId]) OVER (PARTITION BY [S].[StudentId])>=60
			THEN	'FIRST CLASS'
			WHEN SUM([M].[Score]) OVER (PARTITION BY [S].[StudentId])/COUNT([DS].[SubjectId]) OVER (PARTITION BY [S].[StudentId])>50
			THEN	'SECOND CLASS'
			ELSE	'JUST PASS'
		END) AS [Grade]
	FROM 
		[tblStudentMaster] [s]
		INNER JOIN [tblDepartments] [D]
			ON [D].[DepartmentId]=[s].[DepartmentId] AND [D].[DepartmentId] IN (@DepartmentId)
		INNER JOIN [tblDepartmentSubjects] [DS]
			ON [D].[DepartmentId]=[DS].[DepartmentId]
		LEFT OUTER JOIN [tblMarks] [M]
			ON 
				[s].[StudentId]=[M].[StudentId]
				AND
				[DS].[SubjectId]=[M].[SubjectId]

	RETURN
END

CREATE OR ALTER FUNCTION FN_DeptartmentsStudentsReport(@DepartmentId INT, @PassMarks DECIMAL(5,3))
RETURNS @Report TABLE(
	StudentID INT,
	StudentName VARCHAR(50),
	TotalMarks DECIMAL(6,3),
	Percentage DECIMAL(5,3),
	PassedSubjects INT,
	AttemptedSubjects INT,
	Result VARCHAR(50),
	Grade VARCHAR(50))
AS
BEGIN
	DECLARE @Students TABLE(
		[StudentId] INT,
		[StudentName] VARCHAR(50),
		[DateOfJoin] DATETIME,
		[DepartmentId] INT)

	INSERT INTO @Students
	SELECT *
	FROM [tblStudentMaster]
	WHERE [DepartmentId] IN (@DepartmentId)

	DECLARE
		@StudentID INT,
		@StudentName VARCHAR(50),
		@TotalMarks DECIMAL(6,3),
		@Percentage DECIMAL(5,3),
		@PassedSubjects INT,
		@AttemptedSubjects INT,
		@Result VARCHAR(50),
		@Grade VARCHAR(50),
		@TotalSubjects INT;


	WHILE EXISTS(SELECT * FROM @Students)
	BEGIN
	
		-- ID AND NAME
		SELECT TOP 1
			@StudentID=[StudentId],
			@StudentName=[StudentName]
		FROM
			@Students
		ORDER BY
			[StudentId]
	
	-- Finding total subjects in this department
		SELECT
			@TotalSubjects =COUNT([SubjectId])
		FROM
			[tblDepartmentSubjects]
		WHERE
			[DepartmentId] IN (@DepartmentId)

		-- FINDING TOTAL AttemptedSubjects, MARKS AND PERCENTAGE
		SELECT 
			@TotalMarks =SUM([Score]),
			@Percentage=SUM([Score])/@TotalSubjects,
			@AttemptedSubjects=COUNT([SubjectId])
		FROM
			[tblMarks]
		WHERE
			[StudentId] IN (@StudentID)

		--FINDING Number of subjects passed
		SELECT
			@PassedSubjects=COUNT([SubjectId])
		FROM
			[tblMarks]
		WHERE
			[StudentId] IN (@StudentID)
			AND
			[Score]>=@PassMarks

		-- Finding Result
		IF
			@AttemptedSubjects<>@TotalSubjects
			OR
			@PassedSubjects<>@TotalSubjects
			OR
			@Percentage<@PassMarks
		BEGIN
			SET @Result='FAIL'
		END
		ELSE
		BEGIN
			SET @Result='PASS'
		END

		--FINDING GRADE
		SET @Grade=(
				CASE
					WHEN @Percentage>79		THEN 'DISTINCTION'
					WHEN @Percentage>=60	THEN 'FIRST CLASS'
					WHEN @Percentage>50		THEN 'SECOND CLASS'
					ELSE	'JUST PASS'
				END);
	
		--MAIN FUNCTION
		INSERT INTO @Report
		SELECT 
			@StudentID, 
			@StudentName, 
			@TotalMarks,
			@Percentage,
			@PassedSubjects,
			@AttemptedSubjects,
			@Result,
			@Grade

		-- DELETE PREVEIOUS STUDENT ID
		DELETE FROM 
			@Students
		WHERE
			[StudentId] IN (@StudentID);

	END

	RETURN
END

CREATE TABLE h(
	val INT PRIMARY KEY);

SELECT * FROM H

BEGIN TRANSACTION;
	INSERT INTO H VALUES(1);
	INSERT INTO H VALUES(2);
	BEGIN TRANSACTION;
		INSERT INTO H VALUES(3);
		INSERT INTO H VALUES(4);
	ROLLBACK TRANSACTION;	-- ALL TRANSACTIONS ROLLBACK
COMMIT TRANSACTION;

DROP TABLE H;


-- SAMPLE OUTPUT
--StudentID	StudentName	TotalMarks	Percentage	PassedSubjects	AttemptedSubjects	Result		Grade
--2			Shanthala	67.000		33.500		1				2					FAIL		JUST PASS
--3			Sunad		111.000		55.500		2				2					PASS		SECOND CLASS
