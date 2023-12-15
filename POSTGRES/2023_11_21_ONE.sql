-- Creating table Director
CREATE DATABASE db1

CREATE TABLE tblDirectors(
	DirectorId SERIAL PRIMARY KEY,
	FirstName VARCHAR(150) NOT NULL,
	LastName VARCHAR(150) NOT NULL);

CREATE TABLE tblmovies(
	MovieId SERIAL PRIMARY KEY,
	MovieName VARCHAR(100) NOT NULL,
	MovieLength INTEGER NOT NULL,
	MovieLanguage VARCHAR(20) NOT NULL,
	MovieCertificate VARCHAR(3) NOT NULL,
	ReleaseDate DATE NOT NULL,
	DirectorId INTEGER REFERENCES tblDirectors(DirectorId));

CREATE TABLE tblActors(
ActorId SERIAL PRIMARY KEY,
FirstName VARCHAR(150) NOT NULL,
LastName VARCHAR(150) NOT NULL,
Gender CHAR(1) NULL,
DateOfBirth DATE NOT NULL,
MovieId INTEGER REFERENCES tblMovies(MovieId));

INSERT INTO tblDirectors(FirstName, LastName)
VALUES
('Prajwal','Excelsoft'),
('Sagar','Excelsoft'),
('Pavithra','Excelsoft'),
('Pooja','Excelsoft'),
('Anjali','Excelsoft'),
('Bhoomika','Excelsoft');

INSERT INTO tblMovies(MovieName, MovieLength, MovieLanguage, MovieCertificate, ReleaseDate, DirectorId)
VALUES
('Sapta Saagaradaache', 180, 'Kannada', 'UA', '2011-01-01', 2),
('Tiger 3', 180, 'Hindi', 'A', '2023-11-23', 3),
('AptaRakshaka', 190, 'Kannada', 'U', '2015-03-17', 3),
('Girgit', 170, 'Tulu', 'U', '2019-06-13', 4),
('Valatty', 175, 'Malyalam', 'U', '2023-03-29', 5);

INSERT INTO tblActors(FirstName,LastName,Gender,DateOfBirth,MovieId)
VALUES
('Vishnu','Vardhan','M','1980-05-26',3),
('Vimala','Raman','F','1982-03-08',3),
('Rakshit','Shetty','M','1974-04-27',1),
('Rukmini','Vasant','F','1997-11-07',1),
('Salman','Khan','M','1968-04-18',2),
('Kathrina','Kaif','F','1979-10-28',2),
('Roopesh','Shetty','M','1991-10-14',4),
('Ruhani','Shetty','F','1993-08-24',4),
('Roshan','Mathew','M','1991-08-02',5),
('Raveena','Ravi','f','1993-12-24',5);

SELECT * FROM tblDirectors;
SELECT * FROM tblMovies;
movieid|moviename|movielength|movielanguage|moviecertificate|releasedate|directorid
SELECT * FROM tblActors;

--1.Display Movie name, movie language and release date from movies table. 
SELECT
	MovieName, MovieLength, ReleaseDate
FROM
	tblMovies;
	
--2.Display only 'Kannada' movies from movies table. 
SELECT
	*
FROM
	tblMovies
WHERE
	MovieLanguage IN ('Kannada');
	
--3.Display movies released before 1st Jan 2011. 
SELECT
	*
FROM
	tblMovies
WHERE
	ReleaseDate<'2011-01-01';

--4.Display Hindi movies with movie duration more than 150 minutes. 
SELECT
	*
FROM
	tblMovies
WHERE
	MovieLanguage IN ('Hindi')
	AND
	MovieLength>150;

--5.Display movies of director id 3 or Kannada language. 
SELECT
	M.MovieId,
	M.MovieName,
	M.MovieLanguage,
	M.MovieLength,
	M.Releasedate
FROM
	tblMovies M
	INNER JOIN tblDirectors D
		ON 
			M.DirectorId = D.DirectorId
WHERE
	D.DirectorId IN (3)
	OR
	M.MovieLanguage IN ('Kannada')
ORDER BY
	M.ReleaseDate;
	
--6.Display movies released in the year 2023. 
SELECT 
	*
FROM
	tblMovies
WHERE
	EXTRACT(YEAR FROM ReleaseDate) IN (2023);

--7.Display movies that can be watched below 15 years. 
SELECT
	*
FROM
	tblMovies
WHERE
	MovieCertificate IN ('U');

--8.Display movies that are released after the year 2015 
--and directed by directorid 3. 

SELECT
	*
FROM
	tblMovies
WHERE
	ReleaseDate >'2015-12-31'
	AND
	DirectorId IN (3);

--9.Display all other language movies except Hindi language. 

SELECT
	*
FROM
	tblMovies
WHERE
	MovieLanguage NOT IN ('Hindi');

--10.Display movies whose language name ends with 'u'. 

SELECT
	*
FROM
	tblMovies
WHERE
	MovieLanguage ~ '.*[uU]';

--11.Display movies whose language starts with 'm'. 

SELECT
	*
FROM
	tblMovies
WHERE
	MovieLanguage ~'[Mm].*'; 

--12.Display movies with language name that has only 5 characters. 

SELECT
	*
FROM
	tblMovies
WHERE
	MovieLanguage ~ '[A-Za-z]{5}'
	LENGTH(MovieLanguage)=5;

--13.Display the actors who were born before the year 1980. 

SELECT
	*
FROM
	tblActors
WHERE
	DateOfBirth<'1980-01-01';	

--14.Display the youngest actor from the actors table. 

SELECT 
	*
FROM
	tblActors
ORDER BY
	DateOfBirth ASC
OFFSET 0 ROWS
FETCH FIRST 1 ROWS WITH TIES;

--15.Display the oldest actor from the actors table. 

SELECT
	*
FROM
	tblActors
ORDER BY 
	DateOfBirth DESC
OFFSET 0 ROWS
FETCH FIRST 1 ROWS WITH TIES;

--16.Display all the female actresses whose ages are between 30 and 35. 

SELECT
	*
FROM
	tblActors
WHERE
	Gender IN ('F')
	AND
	EXTRACT(YEAR FROM AGE(NOW(),DateOfBirth)) BETWEEN 30 AND 35
--17.Display the actors whose movie ids are in 1 to 5. 

SELECT 
	*
FROM
	tblActors
WHERE MovieId IN (1,2,3,4,5);

--18.Display the longest duration movie from movies table. 

SELECT
	*
FROM
	tblMovies
ORDER BY
	MovieLength DESC
OFFSET 0 ROWS
FETCH FIRST 1 ROWS WITH TIES;

--19.Display the shortest duration movie from movies table. 

SELECT
	*
FROM
	tblMovies
ORDER BY
	MovieLength ASC
OFFSET 0 ROWS
FETCH FIRST 1 ROWS WITH TIES;

--20.Display the actors whose name starts with vowels. 

SELECT
	*
FROM
	tblActors
WHERE
	FirstName ~ '^[aeiouAEIOU].*$';

--21.Display all the records from tblactors by sorting the data based on the fist_name in the 
--ascending order and date of birth in the descending order. 

SELECT 	
	*
FROM
	tblActors
ORDER BY
	FirstName ASC,
	DateOfBirth DESC;

--22.Write a query to  return the data related to movies by arranging the data in ascending order 
--based on the movie_id and also fetch the data from the fifth value to the twentieth value. 

SELECT
	*
FROM
	tblMovies
ORDER BY
	MovieId ASC
OFFSET 4 ROWS
FETCH FIRST 15 ROWS ONLY
