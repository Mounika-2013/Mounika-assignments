--1. Create a new column called “status” in the rental table that uses a case statement to i
--ndicate if a film was returned late, early, or on time.
SELECT RENTAL_DURATION,
	RETURN_DATE,
	RENTAL_DATE,
	CASE
					WHEN RENTAL_DURATION > DATE_PART('day',

																																RETURN_DATE - RENTAL_DATE) THEN 'returned late'
					WHEN RENTAL_DURATION = DATE_PART('day',

																																RETURN_DATE - RENTAL_DATE) THEN 'returned on Time'
					ELSE 'Returned late'
	END AS STATUS
FROM RENTAL AS R
JOIN INVENTORY AS I ON R.INVENTORY_ID = I.INVENTORY_ID
JOIN FILM AS F ON F.FILM_ID = I.FILM_ID;

2.--Show the total payment amounts for people who live in Kansas City or Saint Louis.

SELECT CITY,
	SUM(AMOUNT) AS PAYMENT
FROM PAYMENT AS P
JOIN CUSTOMER AS C ON P.CUSTOMER_ID = C.CUSTOMER_ID
JOIN ADDRESS AS A ON C.ADDRESS_ID = A.ADDRESS_ID
JOIN CITY ON A.CITY_ID = CITY.CITY_ID
WHERE CITY = 'Kansas City'
				OR CITY = 'Saint Louis'
GROUP BY CITY;


--3.  How many film categories are in each category? 
--Why do you think there is a table for category and a table for film category?
SELECT C.NAME,
	COUNT(F.FILM_ID)
FROM CATEGORY AS C
JOIN FILM_CATEGORY AS FC ON C.CATEGORY_ID = FC.CATEGORY_ID
JOIN FILM AS F ON F.FILM_ID = FC.FILM_ID
GROUP BY C.NAME;

SELECT * FROM film; there are 1000 rows i.e., 1000 films are categorized into 16. 
Film_category table contains two primary keys(film_id and category_id) one from film and other from category. 
This table is acting as a junction table between them in order to avoid dupicate data. 


4. --Show a roster for the staff that includes their email, address, city, and country (not ids)
SELECT FIRST_NAME,
	LAST_NAME,
	EMAIL,
	ACTIVE,
	USERNAME,
	PASSWORD
FROM STAFF;

5.-- Show the film_id, title, and length for 
--the movies that were returned from May 15 to 31, 2005
SELECT F.FILM_ID,
	TITLE,
	LENGTH
FROM FILM AS F
JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL AS R ON R.INVENTORY_ID = I.INVENTORY_ID
WHERE CAST(RETURN_DATE AS date) BETWEEN '2005-05-15'AND '2005-05-31'
ORDER BY FILM_ID;


SELECT FILM_ID,
	TITLE,
	LENGTH
FROM FILM
WHERE FILM_ID in
								(SELECT DISTINCT(I.FILM_ID)
									FROM RENTAL AS R
									INNER JOIN INVENTORY AS I ON I.INVENTORY_ID = R.INVENTORY_ID
									WHERE CAST(RETURN_DATE AS date) BETWEEN '2005-05-15'AND '2005-05-31');


6. --Write a subquery to show which movies are rented 
--below the average price for all movies. 
SELECT TITLE,
	RENTAL_RATE
FROM FILM
WHERE RENTAL_RATE <
								(SELECT AVG(RENTAL_RATE)
									FROM FILM);




--7. Write a join statement to show which moves are 
--rented below the average price for all movies.
SELECT TITLE,
	RENTAL_RATE
FROM FILM AS F1
JOIN
				(SELECT AVG(RENTAL_RATE) AS AVG_RENTAL_RATE
					FROM FILM) AS F2 ON F1.RENTAL_RATE < F2.AVG_RENTAL_RATE
ORDER BY RENTAL_RATE DESC;



--8.Perform an explain plan on 6 and 7, and describe 
--what you’re seeing and important ways they differ.
EXPLAIN
SELECT TITLE,
	RENTAL_RATE
FROM FILM
WHERE RENTAL_RATE <
								(SELECT AVG(RENTAL_RATE)
									FROM FILM);

EXPLAIN
SELECT TITLE,
	RENTAL_RATE
FROM FILM AS F1
JOIN
				(SELECT AVG(RENTAL_RATE) AS AVG_RENTAL_RATE
					FROM FILM) AS F2 ON F1.RENTAL_RATE < F2.AVG_RENTAL_RATE
ORDER BY RENTAL_RATE DESC;

Question 6 consumed less runtime compared to question 7. 
Nested loops in question 7 took extra processing time. 
And observed there is no difference in run time for aggregate fuction.

--9. With a window function, write a query that shows the film, 
--its duration, and what percentile the duration fits into. 
--This may help https://mode.com/sql-tutorial/sql-window-functions/#rank-and-dense_rank 
SELECT TITLE,
	LENGTH,
	NTILE(100) OVER(ORDER BY length DESC) AS percentile
	FROM film 
	ORDER BY percentile;


--10. Sql extracts data from different tables. Not designed to analysis or manipulate data as python does 
with data analysis libraries like pandas. 

Python follows programmatic approach where we query the database and write data operational , 
manipulation logics using loops and conditions to get the output. 
Here we are querying the database to get the output and further processing is done using row by 
row procedural approach. 

In sql, the query fetches a data set in table formate using joins, subqueries, conditional statements. 
Doesn’t have to explicitly mention what joins need to be done internally or how to apply filter logics against rows etc. These jobs are handled by set based approach, 
where user doesn’t have to specify "how to do” these jobs explicitly. 


--Bonus: Find the relationship that is wrong in the data model. 
Explain why its wrong.
 As per schema the relation between address and store looks incorrect. 
 An address can have one store alloted to it. But as per schema it is zero to many relation, which looks incorrect to me. 
 








