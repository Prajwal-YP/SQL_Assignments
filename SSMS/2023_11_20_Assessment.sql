--Consider a website “FlyTrip.com” used by the customers to book the online flight tickets. 
--Customers can signup/register to book tickets for international and domestic travel. The 
--website helps check the availability of seats based on a source and destination city on a 
--given date.Here are some assumptions with respect to this scenario 
--	The website allows customers to book tickets multiple times 
--	Customers can choose the seats such as economy class, business class while booking the ticket 
--	The flight charges are based on the source and destination and include the charges for the travel class seat chosen at the time of booking. 


-- CREATING TABLE CUSTOMERS

CREATE DATABASE [Assesment];

USE [Assesment];

CREATE TABLE [tblCustomers](
	[CustomerId] VARCHAR(5) PRIMARY KEY,
	[CustomerName] VARCHAR(50) NOT NULL);

INSERT INTO [tblCustomers]
VALUES
	('C301','John'),
	('C302','Sam'),
	('C303','Robert'),
	('C304','Albert'),
	('C305','Jack');


SELECT * FROM [tblCustomers];

CREATE TABLE [tblFlight](
	[FlightId] VARCHAR(5) PRIMARY KEY,
	[FlightName] VARCHAR(100) NOT NULL,
	[FlightType] VARCHAR(50) NOT NULL,
	[Source] VARCHAR(50) NOT NULL,
	[Destination] VARCHAR(50) NOT NULL,
	[FlightCharge] MONEY NOT NULL,
	[TicketsAvailable] INT NOT NULL,
	[TravelClass] VARCHAR(50) NOT NULL);


INSERT INTO [tblFlight]
VALUES
	('F101', 'Spice Jet Airlines', 'Domestic', 'Mumbai', 'Kolkata', 2000, 20, 'Business'),
	('F102', 'Indian Airlines', 'International', 'Delhi', 'Germany', 8000, 20, 'Business'),
	('F103', 'Deccan Airlines', 'Domestic', 'Chennai', 'Bengaluru', 3000, 34, 'Economy'),
	('F104', 'British Airlines', 'International', 'London', 'Italy', 1000, 3, 'Economy'),
	('F105', 'Swiss Airlines', 'International', 'Zurich', 'Spain', 3000, 10, 'Business');

SELECT * FROM [tblFlight]


CREATE TABLE [tblBooking](
	[BookingId] INT PRIMARY KEY,
	[FlightId] VARCHAR(5) FOREIGN KEY REFERENCES [tblFlight]([FlightId]) NOT NULL,
	[CustomerId] VARCHAR(5) FOREIGN KEY REFERENCES [tblCustomers]([CustomerId]) NOT NULL,
	[TravelClass] VARCHAR(50) NOT NULL,
	[NumberOfSeats] INT NOT NULL,
	[BookingDate] DATE NOT NULL,
	[TotalAmount] MONEY NOT NULL);

--f101 Business
--f102 Business
--f103 Economy
--f104 Economy
--f105 Business

INSERT INTO [tblBooking]
VALUES
(201, 'F101', 'C301', 'Business', 6, '2018-03-22', 12000),
(202, 'F105', 'C303', 'Business', 10, '2018-03-22', 30000),
(203, 'F103', 'C302', 'Economy', 1, '2018-03-22', 3000),
(204, 'F101', 'C302', 'Business', 5, '2018-03-22', 10000),
(205, 'F104', 'C303', 'Economy', 25, '2018-03-22', 25000),
(206, 'F105', 'C301', 'Business', 10, '2018-03-22', 30000),
(207, 'F104', 'C304', 'Economy', 22, '2018-03-22', 22000),
(208, 'F101', 'C304', 'Business', 6, '2018-03-22', 12000);

SELECT * FROM [tblBooking]

--_________________________________________________________________________________________


--Stored Procedure: usp_BookTheTicket 
--____________________________________
--Create a stored procedure named usp_BookTheTicket to insert values into the 
--tblBookingDetails. Implement appropriate exception handling. 
--Input Parameters: 
--	CustId 
--	FlightId 
--	NoOfTickets 
--Functionality: 
--	Check if CustId is present in tblCustomer 
--	Check if FlightId is present in tblFlight 
--	Check if NoOfTickets is a positive value and is less than or equal to TicketsAvailable value for that flight 
--	If all the validations are successful, insert the data by generating the BookingId and calculate the total amount based on the TicketCost 
--Return Values: 
--	 1, in case of successful insertion 
--	-1,if CustId is invalid 
--	-2,if FlightId is invalid 
--	-3,if NoOfTickets is less than zero 
--	-4,if NoOfTickets is greater than TicketsAvailable 
--	-99,in case of any exception

CREATE OR ALTER PROCEDURE [USP_BookTheTicket]
	@CustomerId VARCHAR(5),
	@FlightId VARCHAR(5),
	@NumberOfTickets INT,
	@AvailabelTickets INT OUTPUT
AS
BEGIN
	-- CutomerId Validation
	IF 
		@CustomerId IS NULL
		OR
		NOT EXISTS(SELECT [CustomerId] FROM [tblCustomers] WHERE [CustomerId] IN (@CustomerId))
	BEGIN
		PRINT 'INVALID CUSTOMER !!!';
		RETURN -1;
	END

	-- FlightId Validation
	IF
		@FlightId IS NULL
		OR
		NOT EXISTS(SELECT [FlightId] FROM [tblFlight] WHERE [FlightId] IN (@FlightId))
	BEGIN
		PRINT 'INVALID FLIGHT';
		RETURN -2;
	END

	-- Negetive Tickets Validation
	IF @NumberOfTickets<=0
	BEGIN
		PRINT 'You should book atleast 1 ticket !!';
		RETURN -3;
	END

	-- Declaring the needed variables
	DECLARE
		@NewId INT,
		@TravelClass VARCHAR(50),
		@AvailableTickets INT,
		@Price MONEY;

	SELECT
		@TravelClass=[TravelClass],
		@Price=[FlightCharge],
		@AvailableTickets=[TicketsAvailable]
	FROM
		[tblFlight]
	WHERE 
		[FlightId] IN (@FlightId);

	SELECT 
		@NewId=MAX([BookingId])+1
	FROM
		[tblBooking];

	-- Tickets stock availability Validation
	IF @NumberOfTickets>@AvailableTickets
	BEGIN
		PRINT 'Tickets OUT OF STOCK !!';
		RETURN -4;
	END

	-- Now begining the transaction to perform task
	BEGIN TRY 
		BEGIN TRANSACTION
			-- Updating the tickets availability
			UPDATE 
				[tblFlight]
			SET
				[TicketsAvailable] -= @NumberOfTickets
			WHERE 
				[FlightId] IN (@FlightId);

			-- Recording a new booking transaction 
			INSERT INTO [tblBooking]
				([BookingId], [FlightId], [CustomerId], [TravelClass], [NumberOfSeats], [BookingDate], [TotalAmount])
			VALUES
				(@NewId, @FlightId, @CustomerId,@TravelClass, @NumberOfTickets, CAST(GETDATE() AS DATE), @Price*@NumberOfTickets);
		COMMIT

		SELECT
			@AvailabelTickets=[TicketsAvailable]
		FROM
			[tblFlight]
		WHERE
			[FlightId] IN (@FlightId);

		RETURN 1;
	END TRY
	BEGIN CATCH 
		PRINT 'UNEXPECTED ERROR !!'
		PRINT ERROR_MESSAGE()
		ROLLBACK
		RETURN -99
	END CATCH

END

--	Function: ufn_BookedDetails 
--Create a function ufn_BookedDetails to get the booking details based on the BookingId 
--Input Parameter: 
--	BookingId 
--Functionality: 
--	Fetch the details of the ticket purchased based on the BookingId 
--Return Value: 
--A table containing following fields: 
--	BookingId 
--	CustName 
--	FlightName 
--	Source 
--	Destination 
--	BookingDate 
--	NoOfTickets 
--	TotalAmt 

CREATE OR ALTER FUNCTION [UFN_BookedDetails](@BookingId INT)
RETURNS TABLE
AS
RETURN
	SELECT
		[B].[BookingId] AS [Booking Id],
		[C].[CustomerName] AS [Customer Name],
		[F].[FlightName] AS [Flight Name],
		[F].[Source],
		[F].[Destination],
		[B].[BookingDate] AS [Booking Date],
		[B].[NumberOfSeats] AS [Number Of Tickets],
		[B].[TotalAmount] AS [Total Amount]
	FROM
		[tblBooking] [B]
		INNER JOIN [tblFlight] [F] ON [B].[FlightId]=[F].[FlightId]
		INNER JOIN [tblCustomers] [C] ON [C].[CustomerId]=[B].[CustomerId]
	WHERE
		[B].[BookingId] IN (@BookingId)
--___________________________________________________________________________________________

SELECT * FROM [tblCustomers];
SELECT * FROM [tblFlight];
SELECT * FROM [tblBooking];

--Stored Procedure output
DECLARE @Status INT,@AvailabelTickets INT;
	EXECUTE @Status = [USP_BookTheTicket] @CustomerId='C301', @FlightId='F101', @NumberOfTickets=2, @AvailabelTickets= @AvailabelTickets OUTPUT;
PRINT @Status;
PRINT 'There are '+CAST(@AvailabelTickets AS VARCHAR)+' tickets available.';

SELECT * FROM [tblCustomers];
SELECT * FROM [tblFlight];
SELECT * FROM [tblBooking];


--Function output
SELECT 
	*
FROM
	[UFN_BookedDetails](212)


