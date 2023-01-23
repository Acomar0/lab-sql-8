-- Write a query to display for each store its store ID, city, and country
Use sakila;
select s.store_id, ct.city, cy.country from sakila.store s
JOIN sakila.address a
ON s.address_id = a.address_id
JOIN sakila.city ct
ON a.city_id = ct.city_id
JOIN sakila.country cy
ON ct.country_id = cy.country_id
group by s.store_id;

-- Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(amount) from sakila.store s
JOIN sakila.staff sf
ON s.store_id = sf.store_id
JOIN sakila.payment p
ON sf.staff_id = p.staff_id
group by s.store_id;

-- Which film categories are longest?
select c.name, avg(f.length) as mean_length from sakila.film f
JOIN sakila.film_category fc
ON f.film_id = fc.film_id
JOIN sakila.category c
ON fc.category_id = c.category_id
group by c.name
order by mean_length desc ;

-- Display the most frequently rented movies in descending order
select f.title, count(distinct rental_id) as times_rented from sakila.film f
JOIN sakila.inventory i
ON f.film_id = i.film_id
JOIN sakila.rental r
ON i.inventory_id = r.inventory_id
group by f.title
order by times_rented desc ;

-- List the top five genres in gross revenue in descending order
select c.name as genre, sum( p.amount) as gross_revenue from sakila.category c
JOIN sakila.film_category fc
ON c.category_id = fc.category_id
JOIN sakila.film f
ON fc.film_id = f.film_id
JOIN sakila.inventory i
ON f.film_id = i.film_id
JOIN sakila.rental r
ON i.inventory_id = r.inventory_id

JOIN sakila.payment p
ON r.rental_id = p.rental_id
group by genre
order by gross_revenue desc limit 5;

-- Is "Academy Dinosaur" available for rent from Store 1?
select f.title as title, s.store_id , r.return_date as date_of_return, r.rental_date
from sakila.inventory i
join store s
on  i.store_id = s.store_id
join film f
on  i.film_id = f.film_id
join rental r
on  i.inventory_id = r.inventory_id
where f.title = 'Academy Dinosaur' and s.store_id = 1;

-- Get all pairs of actors that worked together.
SELECT l.actor_id as Actor_1, concat(r1.first_name, ' ', r1.last_name) AS '1st_Actor',
m.actor_id as Actor_2, concat(r2.first_name, ' ', r2.last_name) AS '2nd_Actor'
FROM film_actor AS l
INNER JOIN film_actor AS m
ON l.actor_id < m.actor_id AND l.film_id = m.film_id
INNER JOIN actor AS r1
ON l.actor_id = r1.actor_id
INNER JOIN actor AS r2
ON m.actor_id = r2.actor_id
GROUP BY l.actor_id, m.actor_id
ORDER BY l.actor_id, m.actor_id;

-- Get all pairs of customers that have rented the same film more than 3 times.
SELECT l.customer_id as customer_1, concat(r1.first_name, ' ', r1.last_name) AS '1st_customer',
m.customer_id as customer_2, concat(r2.first_name, ' ', r2.last_name) AS '2nd_customer',
       count(distinct i.film_id) as num_films
FROM customer AS l
JOIN customer AS m
ON l.customer_id < m.customer_id AND l.customer_id = m.customer_id
JOIN customer AS r1
ON l.customer_id = r1.customer_id
JOIN customer AS r2
ON m.customer_id = r2.customer_id
join rental as r
on r2.customer_id = r.customer_id
join inventory AS i ON i.inventory_id = r.inventory_id
join film as f on i.film_id = f.film_id
group by r1.customer_id, r2.customer_id
order by num_films asc;

-- For each film, list actor that has acted in more films.
select f.title as title, concat(a.First_name, ' ', a.Last_name) as Full_name,  COUNT(*) OVER (PARTITION BY f.title) as number_of_films
from actor a
inner join film_actor fa
on fa.actor_id = a.actor_id
inner join film f
on  fa.film_id = f.film_id
group by title, Full_name
order by number_of_films desc;



