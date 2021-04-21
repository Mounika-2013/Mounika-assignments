--—1. Show all customers whose last names start with T. Order them by first name from A-Z
SELECT *
FROM CUSTOMER
WHERE LAST_NAME LIKE 'T%'
ORDER BY FIRST_NAME;


--2. Show all rentals returned from 5/28/2005 to 6/1/2005
SELECT *
FROM RENTAL
WHERE RETURN_DATE BETWEEN '05-28-2005' AND ’06-01-2005';

--3. How would you determine which movies are rented the most?
SELECT TITLE,
	COUNT(TITLE) AS RENTS
FROM FILM AS F
INNER JOIN INVENTORY USING (FILM_ID)
INNER JOIN RENTAL USING(INVENTORY_ID)
GROUP BY TITLE
ORDER BY RENTS DESC;

--4. Show how much each customer spent on movies (for all time) . Order them from least to most.
SELECT FIRST_NAME,
	LAST_NAME,
	SUM(P.AMOUNT) AS PAY
FROM CUSTOMER AS C
INNER JOIN PAYMENT AS P USING (CUSTOMER_ID)
GROUP BY FIRST_NAME,
	LAST_NAME
ORDER BY PAY;

5. --Which actor was in the most movies in 2006 (based on this dataset)? Be sure to alias the actor name and count as a more descriptive name. Order the results from most to least.
SELECT COUNT(*), a.first_name || ' ' || a.last_name as name, release_year
FROM actor AS a
INNER JOIN film_actor
USING (actor_id)
INNER JOIN film
USING (film_id)
WHERE release_year='2006'
GROUP BY release_year, (a.first_name || ' ' || a.last_name)
ORDER BY count DESC;

--6. Used Explain in front of SELECT for answered query on question 5. Output explained the cost, 
maximum time and no.of rows executed for Keywords like COUNT (aggregate function), group by keyword, sort, Joins. 
Out of all these, joins consumed less cost, less time to execute on more number of rows. 
Ex: For Count - cost:267.43, Max time consumed: 269.35, rows executed: 128 where as for joins: Cost:6.50, Max Time:105.76, rows:5462

Compared to 4 and 5 queries - As the number of rows executed is less in query 5, it consumed less than query 4. 

EXPLAIN
SELECT COUNT(*),
	A.FIRST_NAME || ' ' || A.LAST_NAME AS NAME,
	RELEASE_YEAR
FROM ACTOR AS A
INNER JOIN FILM_ACTOR USING (ACTOR_ID)
INNER JOIN FILM USING (FILM_ID)
WHERE RELEASE_YEAR = '2006'
GROUP BY RELEASE_YEAR, (A.FIRST_NAME || ' ' || A.LAST_NAME)
ORDER BY COUNT DESC;


--7. What is the average rental rate per genre?
SELECT name AS name_genre, AVG(rental_rate) AS avg_rental_rate
FROM category 
JOIN film_category
USING (category_id)
JOIN film
USING (film_id)
GROUP BY name;

--Week-6: 8. How many films were returned late? Early? On time?
 SELECT CASE
											WHEN F.RENTAL_DURATION > DATE_PART('day',

																																								RETURN_DATE - RENTAL_DATE) THEN 'Returned Early'
											WHEN F.RENTAL_DURATION < DATE_PART('day',

																																								RETURN_DATE - RENTAL_DATE) THEN 'Returned Late'
											WHEN R.RETURN_DATE IS NULL THEN 'Not Returned'
											ELSE 'On time'
							END AS RETURN_COLUMN,
	COUNT(*) AS RETURN_COUNT
FROM FILM AS F
JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL AS R ON R.INVENTORY_ID = I.INVENTORY_ID
GROUP BY RETURN_COLUMN;
--Week-6: 9. What categories are the most rented and what are their total sales?
 SELECT C.NAME,
	SUM(P.AMOUNT) AS TOTAL_AMOUNT,
	COUNT(R.RENTAL_ID) AS RENTAL_COUNT
FROM CATEGORY AS C
JOIN FILM_CATEGORY USING (CATEGORY_ID)
JOIN FILM AS F USING (FILM_ID)
JOIN INVENTORY AS I USING (FILM_ID)
JOIN RENTAL AS R USING (INVENTORY_ID)
JOIN PAYMENT AS P USING (RENTAL_ID)
GROUP BY C.NAME
ORDER BY RENTAL_COUNT DESC;

--Week-6: 10. Create a view for 8 and a view for 9. Be sure to name them appropriately.
--view for 9th question
-- View creates a virtual table for the queried data, that contains rows and columns from different tables in a DB. 
CREATE VIEW DVD_VIEW AS
SELECT C.NAME,
	SUM(P.AMOUNT) AS TOTAL_AMOUNT,
	COUNT(R.RENTAL_ID) AS RENTAL_COUNT
FROM CATEGORY AS C
JOIN FILM_CATEGORY USING (CATEGORY_ID)
JOIN FILM AS F USING (FILM_ID)
JOIN INVENTORY AS I USING (FILM_ID)
JOIN RENTAL AS R USING (INVENTORY_ID)
JOIN PAYMENT AS P USING (RENTAL_ID)
GROUP BY C.NAME
ORDER BY RENTAL_COUNT DESC;

-- view for 8th question
CREATE VIEW RENTAL_VIEW AS
SELECT CASE
											WHEN F.RENTAL_DURATION > DATE_PART('day',

																																								RETURN_DATE - RENTAL_DATE) THEN 'Returned Early'
											WHEN F.RENTAL_DURATION < DATE_PART('day',

																																								RETURN_DATE - RENTAL_DATE) THEN 'Returned Late'
											WHEN R.RETURN_DATE IS NULL THEN 'Not Returned'
											ELSE 'On time'
							END AS RETURN_COLUMN,
	COUNT(*) AS RETURN_COUNT
FROM FILM AS F
JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL AS R ON R.INVENTORY_ID = I.INVENTORY_ID
GROUP BY RETURN_COLUMN;