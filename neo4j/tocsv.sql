use sakila;

--Conversão das tabelas para csv
select * from country
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/country.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--With the country in order to link immediatly
select city, country from city
inner join country on city.country_id = country.country_id
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/city.csv'
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
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/address.csv'
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
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/staff.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--exporting stores
select address, city, username, store.store_id from store
inner join staff on store.manager_staff_id = staff.staff_id
inner join address on store.address_id = address.address_id
inner join city on address.city_id = city.city_id
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/stores.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


--exporting costumers. There are no null emails, therefore no stress
select first_name, last_name, email, active, create_date, store_id, address, city from customer
inner join address on customer.address_id = address.address_id
inner join city on address.city_id = city.city_id
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/customers.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--Given the existing dependencies, it would be now better to start with the inventory part of the database
select name from category
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/categories.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--Exporting actors. Existe um ator repetido (Susan Davis), logo será necessário TEMPORÁRIAMENTE incluir o id
select first_name, last_name, actor_id from actor
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/actors.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--Exporting languages
select name from language
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/languages.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

--Export films without category and actor relationships. There are no values in the original_language_id column. I had to enclose in quotes because the special_features column had commas in a lot of entries
select title, description, release_year, rental_duration, rental_rate, film.length, replacement_cost, rating, special_features, lang.name from film
inner join language as lang on film.language_id = lang.language_id
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/films.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

--export film_category. Since title is unique (I checked) we can use it as ID
select title, name from film
inner join film_category on film.film_id = film_category.film_id
inner join category on category.category_id = category.category_id
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/film_category.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

--export film_actors
select title, actor.actor_id from film
inner join film_actor on film.film_id = film_actor.film_id
inner join actor on film_actor.actor_id = actor.actor_id
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/film_actors.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';
