SELECT title, replacement_cost FROM film
WHERE replacement_cost > 
(SELECT avg(replacement_cost) FROM film);

SELECT f1.title, f1.replacement_cost
FROM film AS f1
INNER JOIN film AS f2
WHERE f1.replacement_cost > avg(f2.replacement_cost);

--
select c.first_name || ' ' || c.last_name as name, c.activebool, co country, a.district
from customer c, address a, city ci, country co
where c.address_id = a.address_id
and a.city_id = ci.city_id 
and ci.country_id = co.country_id
and country like '%United States%'
and activebool = 'true'
order by district

