--Consider a website “FlyTrip.com” used by the customers to book the online flight tickets. 
--Customers can signup/register to book tickets for international and domestic travel. The 
--website helps check the availability of seats based on a source and destination city on a 
--given date.Here are some assumptions with respect to this scenario 
--The website allows customers to book tickets multiple times 
--Customers can choose the seats such as economy class, business class while booking 
--the ticket 
--The flight charges are based on the source and destination and include the charges 
--for the travel class seat chosen at the time of booking. 
--Here is the database design used by the developers of the website. 


--1.Identify the customer(s) who have not booked any flight tickets or not booked any 
--flights tickets of travel class ‘Economy’.Display custid and custname of the identified 
--customer(s).

SELECT 
	[CustomerId],
	[CustomerName]
FROM 
	[tblCustomers]
WHERE [CustomerId] NOT IN (
	SELECT 
		[C].[CustomerId]
	FROM
		[tblCustomers] [C]
		INNER JOIN [tblBooking] [B]
			ON [C].[CustomerId]=[B].[CustomerId] 
	WHERE 
		[B].[TravelClass] IN ('Economy'));

--2.Identify the booking(s) with flightcharge greater than the average flightcharge of all the 
--flights booked for the same travel class. Display flightid, flightname and  custname of 
--the identified bookings(s). 

SELECT DISTINCT
	[F1].[FlightId],
	[F1].[FlightName],
	[C1].[CustomerName]
FROM
	[tblBooking] [B1]
	INNER JOIN [tblCustomers] [C1]
		ON [C1].[CustomerId]=[B1].[CustomerId]
	INNER JOIN [tblFlight] [F1]
		ON [F1].[FlightId]=[B1].[FlightId]
WHERE
	[F1].[FlightCharge]>(
		SELECT
			AVG([FlightCharge])
		FROM
			[tblFlight] [F2]
		WHERE 
			[F2].[TravelClass]=[F1].[TravelClass]);

--3.Identify the bookings done by the same customer for the same flight type and travel 
--class. Display flightid and the flighttype of the identified bookings. 

SELECT DISTINCT
	[F].[FlightId],
	[F].[FlightType]
FROM(
	SELECT
		[CustomerId],
		[FlightId]
	FROM
		[tblBooking]
	GROUP BY
		[CustomerId],
		[FlightId]
	HAVING
		COUNT([FlightId])>1) AS [Ans]
	INNER JOIN [tblFlight] [F]
		ON [F].[FlightId]=[Ans].[FlightId]

--4.Identify the flight(s) for which the bookings are done to destination ‘Kolkata’, ‘Italy’ or 
--‘Spain’. Display flightid and flightcharge of the identified booking(s) in the increasing 
--order of flightname and decreasing order of flightcharge. 

SELECT DISTINCT
	[F].[FlightId],
	[F].[FlightName],
	[F].[FlightCharge]
FROM
	[tblFlight] [F]
	INNER JOIN [tblBooking] [B]
		ON 
			[F].[FlightId]=[B].[FlightId]
			AND
			[F].[Destination] IN ('Kolkata', 'Italy', 'Spain')
ORDER BY
	[F].[FlightName],
	[F].[FlightCharge] DESC

--5.Identify the month(s) in which the maximum number of bookings are made. Display 
--custid and custname of the customers who have booked flights tickets in the identified 
--month(s). 

SELECT
	[C].[CustomerId],
	[C].[CustomerName]
FROM
	[tblCustomers] [C]
	INNER JOIN [tblBooking] [B]
		ON [C].[CustomerId]=[B].[CustomerId]
WHERE DATENAME(MM,[B].[BookingDate])=(
	SELECT TOP 1 WITH TIES
		DATENAME(MM,[BookingDate])
	FROM 
		[tblBooking]
	GROUP BY
		DATENAME(MM,[BookingDate])
	ORDER BY
		SUM([TotalAmount]) DESC)

--6.Identify the booking(s) done in the year 2019 for the flights having the letter ‘u’ 
--anywhere in their source or destination and booked by the customer having atleast 5 
--characters in their name. Display bookingid prefixed with ‘B’ as “BOOKINGID” ( column 
--alias) and the numeric part of custid as “CUSTOMERID” (column alias) for the identified 
--booking(s). 

SELECT
	'B'+ CAST([B].[BookingId] AS VARCHAR) AS [Booking Id],
	SUBSTRING([C].[CustomerId],2,5) AS [Customer Id]
FROM
	[tblBooking] [B]
	INNER JOIN [tblCustomers] [C]
		ON 
			[B].[CustomerId]=[C].[CustomerId]
			AND 
			LEN([C].[CustomerName])>=5
	INNER JOIN [tblFlight] [F]
		ON
			[F].[FlightId]=[B].[FlightId]
			AND (
				[F].[Source] LIKE '%u%'
				OR
				[F].[Destination] LIKE '%u%')

--7.Identify the customer(s) who have booked the seats of travel class ‘Business’ for 
--maximum number of times. Display custid and custname of the identified customer(s). 

SELECT TOP 1 WITH TIES
	[C].[CustomerId],
	[C].[CustomerName],
	COUNT([B].[FlightId])
FROM
	[tblCustomers] [C]
	INNER JOIN [tblBooking] [B]
		ON 
			[C].[CustomerId]=[B].[CustomerId]
			AND
			[B].[TravelClass] IN ('Business')
GROUP BY
	[C].[CustomerId],
	[C].[CustomerName]
ORDER BY
	COUNT([B].[FlightId]) DESC
--8.Identify the bookings done with the same flightcharge. For every customer who has 
--booked the identified bookings, display custname and bookingdate as “BDATE” (column 
--alias). Display ‘NA’ in BDATE if the customer does not have any booking or if no such 
--booking is done by the customer. 

SELECT * 
FROM 
	[tblBooking] [B]
	INNER JOIN [tblFlight] [F]
		ON [B].[FlightId]=[F].[FlightId]
	INNER JOIN [tblCustomers] [C]
		ON [C].[CustomerId]=[B].[CustomerId]
GROUP BY 
	[C].[CustomerId],
	[C].[CustomerName],
	[F].[FlightId]

--9.Identify the customer(s) who have paid highest flightcharge for the travel class 
--economy. Write a SQL query to display id, flightname and name of the identified 
--customers. 
SELECT * FROM [tblBooking]
SELECT * FROM [tblFlight]
SELECT * FROM [tblCustomers]

SELECT 
	[B].[BookingId], [F].[FlightName], [C].[CustomerName]
FROM
	[tblCustomers] [C]
	INNER JOIN [tblBooking] [B] 
		ON  [C].[CustomerId]=[B].[CustomerId]
	INNER JOIN [tblFlight] [F]
		ON [F].[FlightId]=[B].[FlightId]
WHERE 
	[C].[CustomerId] IN (
		SELECT TOP 1 WITH TIES
			[C].[CustomerId]
		FROM 
			[tblCustomers] [C]
			INNER JOIN [tblBooking] [B] 
				ON  [C].[CustomerId]=[B].[CustomerId]
			INNER JOIN [tblFlight] [F]
				ON [F].[FlightId]=[B].[FlightId]
		WHERE 
			[F].[TravelClass] IN ('Economy')
		ORDER BY 
			[F].[FlightCharge] DESC)

--10.Identify the International flight(s) which are booked for the maximum number of 
--times.Write a SQL query to display id and name of the identified flights. 

SELECT TOP 1
	[F].[FlightId],[F].[FlightName]
FROM 
	[tblFlight] [F]
	INNER JOIN  [tblBooking] [B]
		ON [F].[FlightId]=[B].[FlightId]
WHERE 
	[F].[FlightType] IN ('International')
ORDER BY COUNT([B].[BookingId]) OVER (PARTITION BY [F].[FlightId]) DESC

--11.Identify the customer(s) who have bookings during the months of January 2018 to 
--January 2019 and paid overall total flightcharge less than the average flightcharge of all 
--bookings belonging to travel class ‘Business’. Write a SQL query to display id and name 
--of the identified customers. 

SELECT 
	[C].[CustomerId], [C].[CustomerName]
FROM 
	[tblCustomers] [C]
	INNER JOIN [tblBooking] [B] 
		ON [B].[CustomerId]=[C].[CustomerId]
WHERE 
	[B].[BookingDate] BETWEEN '2018-01-01' AND '2019-01-31'
GROUP BY 
	[C].[CustomerId], [C].[CustomerName]
HAVING SUM([B].[TotalAmount]) >(
		SELECT 
			AVG([TotalAmount])
		FROM 
			[tblBooking] [B1] 
			INNER JOIN [tblFlight] [F1]
				ON [B1].[FlightId]=[F1].[FlightId]
		WHERE 
			[F1].[TravelClass] IN ('Business'))

--12.Identify the bookings with travel class ‘Business’ for the International flights.Write a SQL 
--query to display booking id, flight id and customer id of those customer(s) not having 
--letter ‘e’ anywhere in their name and have booked the identified flight(s). 

SELECT *
FROM 
	[tblFlight] [F]
	INNER JOIN [tblBooking] [B]
		ON [F].[FlightId]=[B].[FlightId]
	INNER JOIN [tblCustomers] [C]
		ON [C].[CustomerId]=[B].[CustomerId]
WHERE	
	[F].[TravelClass] IN ('Business')
	AND 
	[F].[FlightType] IN ('International')
	AND
	[C].[CustomerName] NOT LIKE '%e%';

--13.Identify the booking(s) which have flight charges paid is less than the average flight 
--charge for all flight ticket bookings belonging to same flight type. Write a SQL query to 
--display booking id, source city, destination city and booking date of the identified 
--bookings. 

SELECT
	[B].[BookingId], [F].[Source], [F].[Destination], [B].[BookingDate]
FROM 
	[tblBooking] [B]
	INNER JOIN [tblFlight] [F]
		ON [F].[FlightId]=[B].[FlightId]
WHERE [B].[TotalAmount]<(
	SELECT AVG([B1].[TotalAmount])
	FROM 
		[tblBooking] [B1]
		INNER JOIN [tblFlight] [F1]
			ON [F1].[FlightId]=[B1].[FlightId]
	WHERE 
		[F1].[FlightType]=[F1].[FlightType])


--14.Write a SQL query to display customer’s id and name of those customers who have paid 
--the flight charge which is more than the average flightcharge for all international flights. 

SELECT
	[C].[CustomerId],
	[C].[CustomerName]
FROM
	[tblCustomers] [C]
	INNER JOIN [tblBooking] [B]
		ON [B].[CustomerId]=[C].[CustomerId]
GROUP BY
	[C].[CustomerId],
	[C].[CustomerName]
HAVING
	SUM([B].[TotalAmount])>(
		SELECT 
			AVG([B1].[TotalAmount])
		FROM 
			[tblBooking] [B1]
			INNER JOIN [tblFlight] [F1]
				ON [B1].[FlightId]=[F1].[FlightId]
		WHERE 
			[F1].[FlightType] IN ('International'));
