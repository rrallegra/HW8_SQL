
USE sakila;
Select * from actor;

-- 1a Display first and last names of all actors from the table actor

Select first_name, last_name from actor;

-- 1b Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name

SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name' from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?

Select actor_id, first_name, last_name from actor
where first_name = 'Joe'; 

-- 2b. Find all actors whose last name contain the letters GEN

SELECT * FROM actor 
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order

SELECT last_name, first_name FROM actor 
WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China

SELECT country_id, country FROM country 
WHERE country IN ( "Afghanistan", "Bangladesh", "China" );

-- 3a. Add a middle_name column to the table actor. 
-- Position it between first_name and last_name. 

ALTER TABLE actor add column middle_name VARCHAR(25) after first_name;

-- 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the middle_name column to blobs.

ALTER TABLE actor modify column middle_name BLOB;

-- 3c. Now delete the middle_name column

ALTER TABLE actor drop column middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, count(last_name) as 'Count' from actor
group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

SELECT last_name, count(*) as 'Count' from actor
group by last_name
Having Count > 2;

-- 4c Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
-- the name of Harpo's second cousin's husband's yoga teacher. 
-- Write a query to fix the record.

select first_name, last_name from actor
where last_name = 'Williams';

UPDATE actor set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'Williams';

select first_name, last_name from actor
where last_name = 'Williams';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. 
-- Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 
-- BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! 
-- (Hint: update the record using a unique identifier.)

UPDATE actor set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name = 'Williams';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

DESCRIBE sakila.address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and addres

SELECT staff.first_name, staff.last_name, address.address
FROM staff 
LEFT JOIN address 
ON staff.address_id = address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.

SELECT s.first_name, s.last_name, SUM(p.amount) AS 'total_amount'
FROM staff s 
LEFT JOIN payment p  
ON s.staff_id = p.staff_id
WHERE p.payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY s.first_name, s.last_name;

-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. 
-- Use inner join.

SELECT f.title, COUNT(a.actor_id) AS '#_of_actors'
FROM film f 
LEFT JOIN film_actor a 
ON f.film_id = a.film_id
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT title, count(*) as 'count' from film
WHERE title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name.

SELECT c.first_name, c.last_name, SUM(p.amount) AS 'total_paid'
FROM customer c LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name; 

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared 
-- in popularity. Use subqueries to display the titles of movies starting with the letters 
-- K and Q whose language is English.

SELECT title FROM film 
WHERE (title LIKE 'K%' OR title LIKE 'Q%') AND 
language_id=(SELECT language_id FROM language 
WHERE name='English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name FROM actor
WHERE actor_id 
IN (SELECT actor_id FROM film_actor WHERE film_id 
IN (SELECT film_id FROM film WHERE title='ALONE TRIP')); 

-- 7c. ou want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

SELECT customer.first_name, customer.last_name, customer.email, country.country FROM customer 
INNER JOIN address ON (customer.address_id = address.address_id)
INNER JOIN city ON (address.city_id=city.city_id)
INNER JOIN country ON (city.country_id=country.country_id) 
WHERE country.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target 
-- all family movies for a promotion. Identify all movies categorized as family films.

SELECT f.title, c.name from film f 
INNER JOIN film_category fc on (f.film_id=fc.film_id)
INNER JOIN category c on (fc.category_id=c.category_id)
WHERE c.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(f.film_id) AS 'Total_Rentals'
FROM  film f
INNER JOIN inventory i ON (f.film_id= i.film_id)
INNER JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY f.title ORDER BY Total_Rentals DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(p.amount) FROM payment p
INNER JOIN staff s 
ON (p.staff_id=s.staff_id)
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT store.store_id, city.city, country.country FROM store
INNER JOIN address ON (store.address_id=address.address_id)
INNER JOIN city ON (address.city_id=city.city_id)
INNER JOIN country ON (city.country_id=country.country_id);

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT c.name AS Top_Five_Genres, SUM(p.amount) AS Gross_Revenue 
FROM category c
INNER JOIN film_category fc ON (c.category_id=fc.category_id)
INNER JOIN inventory i ON (fc.film_id=i.film_id)
INNER JOIN rental r ON (i.inventory_id=r.inventory_id)
INNER JOIN payment p ON (r.rental_id=p.rental_id) 
GROUP BY c.name ORDER BY Gross_Revenue DESC LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing 
-- the Top five genres by gross revenue. Use the solution from the problem above to 
-- create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW TopFive AS 
SELECT c.name AS Top_Five_Genres, SUM(p.amount) AS Gross_Revenue FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross_Revenue DESC LIMIT 5; 

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM TopFive;

-- 8c. You find that you no longer need the view top_five_genres. 
-- Write a query to delete it.

DROP VIEW TopFive;
