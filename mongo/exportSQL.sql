##### Export de SQL para CSV #####
## This script allows us to export the tables from Sakila

### README:
## We didn't just export the tables as they existed here
## We analysed the tables and found some information that was unused 
## 	or SQL oriented, and proceeded to not export that to the CSVs
## We also did some merge of tables here in MySQL before exporting,
## mostly for being more convenient and easy to do here before exporting
# Any discarded attributes will be mentioned in their table export

### TODO:
# TODO? tratar de campos com valores vazios

### remover os vazios (exemple)
# Altera elementos nulos para vazio (needed?)
#update address
#set address2 = null
#where address2 = '';


#################### CUSTOMER tables ####################
## Export table customer
select customer_id, store_id, concat_ws(' ',first_name,last_name), email, address_id, active, create_date, last_update
from customer
into outfile 'sakila_nosql/csv/customerAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

## Export table address & city & country 
	# Removed address2: always null
	# Removed some IDs used in the join for being useless in a joined table
# location is a BLOB, that represents coordenates in the globe
select address_id, address, district, postal_code, phone, ST_AsText(location), 
		city, country, address.last_update 
from address, city, country
where city.country_id = country.country_id
and address.city_id = city.city_id
#order by country_id
into outfile 'sakila_nosql/csv/address_city_countryAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

#################### INVENTORY tables ####################
## Export table film & language
	# Removed original_language: always null
select film_id, title, description, release_year, language.name, 
		rental_duration, rental_rate, length, replacement_cost, rating, special_features, film.last_update
from film, language
where film.language_id = language.language_id
into outfile 'sakila_nosql/csv/filmAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

## Export table category ( & film_category)
select c.name, fc.film_id
from category as c, film_category as fc
where c.category_id = fc.category_id
into outfile 'sakila_nosql/csv/categoryAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

## Export table actor ( & film_actor)
select concat_ws(' ',first_name,last_name), fa.film_id
from actor as a, film_actor as fa
where a.actor_id = fa.actor_id
into outfile 'sakila_nosql/csv/actorAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

## Export table inventory
select inventory_id, film_id, store_id from inventory
order by inventory_id
into outfile 'sakila_nosql/csv/inventoryAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

#################### BUSINESS tables ####################
## Export table store
select s.store_id, s.manager_staff_id, concat_ws(' ',staff.first_name,staff.last_name), s.address_id, s.last_update 
from store as s, staff
where s.manager_staff_id = staff.staff_id
into outfile 'sakila_nosql/csv/storeAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

## Export table staff
select staff_id, concat_ws(' ',first_name,last_name), address_id, store_id, email, active, username, password, to_base64(picture), last_update from staff
into outfile 'sakila_nosql/csv/staffAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

## Export table payment & rental
# This table contains rentals and their respective payment
select r.rental_id, r.rental_date, f.film_id, f.title, p.amount, r.return_date, p.payment_date, 
		i.store_id, r.staff_id, r.customer_id
from payment as p, rental as r, inventory as i, film as f
where p.rental_id is not null
and p.rental_id = r.rental_id
and r.inventory_id = i.inventory_id
and i.film_id = f.film_id
order by rental_id
into outfile 'sakila_nosql/csv/rental.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

## Export table other payments
# This table contains special payments, with no association to any Rental
select payment_id, staff_id, customer_id, amount, payment_date from payment
where rental_id is null
into outfile 'sakila_nosql/csv/other_payments.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

