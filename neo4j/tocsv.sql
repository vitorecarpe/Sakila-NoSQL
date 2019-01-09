use sakila;

--Conversão das tabelas para csv
select * from country
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/country.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--With the country in order to link immediatly
select city, country from city
inner join country on city.country_id = country.country_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/city.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--Antes de exportar as moradas altera as que têm um null inserido de uma forma diferente (apenas 4)
update address
set address2 = ''
where address2 is null;

--exportação das moradas
select address, address2, district, city, postal_code, phone, country from address
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/address.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


--Staff null uniformization
update staff
set picture = ''
where picture is null;

update staff
set password = ''
where password is null;

--exportação de staff (sem store para já). Tem de ser por esta ordem por causa das dependencias
select first_name, last_name, address, city, email, active, username, password, store_id from staff
inner join address on staff.address_id = address.address_id
inner join city on address.city_id = city.city_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/staff.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--exporting stores
select address, city, username, store.store_id from store
inner join staff on store.manager_staff_id = staff.staff_id
inner join address on store.address_id = address.address_id
inner join city on address.city_id = city.city_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/stores.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


--exporting costumers. There are no null emails, therefore no stress
select first_name, last_name, email, active, create_date, store_id, address, city from customer
inner join address on customer.address_id = address.address_id
inner join city on address.city_id = city.city_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/customers.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--Given the existing dependencies, it would be now better to start with the inventory part of the database
select name from category
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/categories.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--Exporting actors. Existe um ator repetido (Susan Davis), logo será necessário TEMPORÁRIAMENTE incluir o id
select first_name, last_name, actor_id from actor
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/actors.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--Exporting languages
select name from language
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/languages.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--Export films without category and actor relationships. There are no values in the original_language_id column. I had to enclose in quotes because the special_features column had commas in a lot of entries
select title, description, release_year, rental_duration, rental_rate, film.length, replacement_cost, rating, special_features, lang.name from film
inner join language as lang on film.language_id = lang.language_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/films.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

--export film_category. Since title is unique (I checked) we can use it as ID
select title, name from film
inner join film_category on film.film_id = film_category.film_id
inner join category on category.category_id = category.category_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/film_category.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

--export film_actors
select title, actor.actor_id from film
inner join film_actor on film.film_id = film_actor.film_id
inner join actor on film_actor.actor_id = actor.actor_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/film_actors.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

--export inventory. It's a many to many relation with a property film_text. Film title is unique. Film title is always equal to the the title in film_text, therefore is redundant. For every film-store relation there is a new line. In neo4j there will be a single relation with a counter instead.
select film.title, store_id, film_text.description, count(*) from inventory
inner join film on inventory.film_id = film.film_id
inner join film_text on inventory.film_id = film_text.film_id
group by film.film_id, store_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/inventory.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

--this proves there is no film-store relation with more than a diferent description
select count(distinct(film_text.description)) as c from inventory 
inner join film on inventory.film_id = film.film_id
inner join film_text on inventory.film_id = film_text.film_id
group by film.film_id, store_id, film_text.description
having c <> 1;

--export rental. With rental_id to make payment relations
select staff.username, film.title, inventory.store_id, customer.first_name, customer.last_name, rental_date, ifnull(return_date,""), rental_id from rental
inner join staff on rental.staff_id = staff.staff_id
inner join inventory on rental.inventory_id = inventory.inventory_id
inner join film on inventory.film_id = film.film_id
inner join customer on rental.customer_id = customer.customer_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/rental.csv'
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

--export payment.
select customer.first_name, customer.last_name, staff.username, rental_id, amount, payment_date, payment_id from payment
inner join customer on payment.customer_id = customer.customer_id
inner join staff on payment.staff_id = staff.staff_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/payment.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

--export payment-rental relation. Necessary due to the existence of null
select payment.payment_id, rental.rental_id from payment
inner join rental on payment.rental_id = rental.rental_id
into outfile '/usr/local/Cellar/neo4j/3.5.0/libexec/import/rental-payment.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

