--  1.List the different languages of movies. 
 
 SELECT DISTINCT MovieLanguage
 FROM tblMovies
 
-- 2.Display the unique first names of all directors in ascending order by 
-- their first name and then for each group of duplicates, keep the 
-- first row in the returned result set. 
SELECT * FROM tblDirectors
SELECT DISTINCT  ON (FirstName) 
	DirectorId, FirstName, LastName
FROM
	tblDirectors;

-- 3. write a query to retrieve 4 records starting from the fourth one, to 
-- display the actor ID, name (first_name, last_name) and date of birth, and 
-- arrange the result as Bottom N rows from the actors table according to their 
-- date of birth.   

  SELECT ActorId, FirstName||LastName AS "Actor Name" 
  FROM tblactors
  ORDER BY dateofbirth DESC
  OFFSET 3 ROWS 
  FETCH FIRST 3 ROWS ONLY;
 
-- 4.Write a query to get the first names of the directors who holds the 
-- letter 'S' or 'J' in the first name.     


 SELECT *
 FROM tblDirectors
 WHERE FirstName ~* '[pq].*';
 
-- 5.Write a query to find the movie name and language of the movie of all 
-- the movies where the director name is "Pavithra". 
 SELECT 
 	M.MovieName,
	M.MovieLanguage
 FROM 
 	tblMovies M
	INNER JOIN tblDirectors D
		ON 
			M.DirectorId=D.DirectorId
			AND 
			D.FirstName||D.LastName ILIKE '%pavithra%';
 
-- Module 8: 
 
-- 6.Write a query to find the number of directors available in the movies 
-- table. 

 SELECT COUNT(DISTINCT DirectorId)::SMALLINT AS "Number of Directors"
 FROM tblMovies;
 
-- 7. Write a query to find the total length of the movies available in the 
-- movies table. 

 SELECT SUM(MovieLength)::SMALLINT AS "Total Length of Movies"
 FROM tblMovies;

-- 8.Write a query to get the average of movie length for all the directors 
-- who are working for more than 1 movie. 
 SELECT * FROM tblactors
 SELECT * FROM tbldirectors
 SELECT * FROM tblmovies
  
  SELECT AVG(MovieLength) "Avg Movie Length Directed by popular Directors"
  FROM tblMovies
  WHERE DirectorId IN (
	  SELECT DirectorId
	  FROM tblMovies
	  GROUP BY DirectorId
	  HAVING COUNT(*)>1);
  
-- 9.Write a query to find the age of the actor vijay for the 
-- year 2001-04-10. 
   
 SELECT 
 	A.*, 
	AGE('2001-04-10',DateOfBirth)::VARCHAR AS "Age"
 FROM tblActors A
 WHERE FirstName||LastName ILIKE '%vijay%';
   
   
-- 10.Write a query to fetch the week of this release date "2010-12-01"
  
SELECT 
	M.*,
	TO_CHAR(ReleaseDate,'WW')::SMALLINT AS "WEEK of YEAR",
	TO_CHAR(ReleaseDate,'W')::SMALLINT AS "WEEK of Month"
FROM tblMovies M
WHERE ReleaseDate='2010-12-01';


-- 11.Write a query to fetch the day of the week and year for this release date 
-- 2010-12-01 13:00:10.        
 
 SELECT
 	M.*,
	TO_CHAR(ReleaseDate, 'Day') AS "Day Of the Week",
	TO_CHAR(ReleaseDate, 'YYYY')::SMALLINT AS "YEAR"
 FROM tblMovies M
 WHERE ReleaseDate IN ('2010-12-01')

 
-- 12.Write a query to convert the given string '20201114' into date and time. 
        
SELECT TO_TIMESTAMP('20201114','YYYYMMDD')::TIMESTAMP
		
-- 13.Display Today's date. 
            
SELECT CURRENT_DATE AS "Todays Date"
			
-- 14.Display Today's date with time. 
 
SELECT CURRENT_TIMESTAMP
 
-- 15.Write a query to add 10 Days 1 Hour 15 Minutes to the current date. 
       
SELECT CURRENT_DATE , CURRENT_DATE + INTERVAL '10 DAYS 1 HOUR 15MINUTES'
	   
-- 16.Write a query to find the details of those actors who contain eight or 
-- more characters in their first name. 
 
 SELECT *
 FROM tblActors
 WHERE LENGTH(FirstName)>=8
 
-- 17.Write a query to join the text 'movie' with the movie_name column. 
 
 SELECT 'movie '||MovieName AS "COLUMN"
 FROm tblMovies;
 
-- 18.Write a query to get the actor id, first name and birthday month of an 
-- actor. 
 
 SELECT 
 	ActorId,
	TO_CHAR(DateOfBirth,'MONTH') AS "Birthday Month"
 FROM tblActors
 
-- 19.Write a query to get the actor id, last name to discard the last three 
-- characters. 
 
 SELECT 
 	ActorId,
 	LastNAme ,
	SUBSTRING(LastName,1,LENGTH(LastName)-3) AS "Discarded LastName"
 FROM tblActors
 
-- 20.Write a query that displays the first name and the character length of 
-- the first name for all directors whose name starts with the letters 'A', 'J' or 'V'. 
-- Give each column an appropriate label. Sort the results by the directors' first 
-- names. 
 
SELECT
 	FirstName,
	LENGTH(FirstName) AS "Character Length"
FROM
	tblDirectors
WHERE
	FirstName SIMILAR TO '[PpQqAa]%' 
ORDER BY
	FirstName;
-- SELECT * FROM tblMovies WHERE MovieName SIMILAR TO '% %';
-- 21.Write a query to display the first word in the movie name if 
-- the movie name contains more than one words. 
 
 SELECT 
 	MOVIENAME, 
	SPLIT_PART(MOVIENAME,' ',1),
	SUBSTRING(MovieName,1,POSITION(' ' IN MovieName)-1)  ,
	REGEXP_MATCH(MovieName,'(.*?) .*')
 FROM tblMovies
 WHERE MovieName ILIKE '% %';
 
--  WHERE MovieName ~* '^(.* )+.*$'
 	
-- Module 9: 
 
-- 22.Write a query to display the actors name with movie name.       

SELECT 
	CONCAT_WS(' ',A.FirstName,A.LastName) AS "ActorName",
	M.MovieName
FROM 
	tblActors A
	INNER JOIN tblMovies M
		ON A.MovieId=M.MovieId

-- 23.Write a query to make a join with three tables movies, actors, and 
-- directors to display the movie name, director name, and actors date of birth. 
 
SELECT 
	M.MovieName,
	D.FirstName||D.LastName AS "Director Name",
	A.DateOfBirth AS "Actors DOB"
FROM
	tblMovies M
	INNER JOIN tblDirectors D
		ON M.DirectorId=D.DirectorId
	INNER JOIN tblActors A
		ON A.MovieId=M.MovieId;
 
-- 24.Write a query to make a join with two tables directors and movies to 
-- display the status of directors who is currently working for the movies above 
-- 1. 

SELECT 
	D.DirectorId,
	D.FirstName||D.LastName AS "DirectorName",
	COUNT(*) AS "STATUS(Working Movies)"
FROM
	tblMovies M
	INNER JOIN tblDirectors D
		ON M.DirectorId=D.DirectorId
GROUP BY
	D.DirectorId,
	D.FirstName||D.LastName
HAVING 
	COUNT(*)>1;

-- 25.Write a query to make a join with two tables movies and actors to get 
-- the movie name and number of actors working in each movie. 

SELECT 
	M.MovieName,
	COUNT(A.ActorId) AS "No Of Actors"
FROM
	tblMovies M
	INNER JOIN tblActors A
		ON A.MovieId=M.MovieId
GROUP BY
	M.MovieName;

-- 26.Write a query to display actor id, actors name (first_name, last_name)  
-- and movie name to match ALL records from the movies table with each 
-- record from the actors table.      

SELECT
	A.ActorId,
	A.Firstname||A.LastName AS "ActorName",
	M.MovieName
FROM
	tblMovies M
	FULL OUTER JOIN tblActors A
		ON A.MovieId=M.MovieId
