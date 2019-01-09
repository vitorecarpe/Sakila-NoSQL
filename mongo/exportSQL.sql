# TODO:
# decidir o schema
# tratar de campos com valores vazios

##### Export de SQL para CSV #####
# NOTA> Algumas tabelas foram juntadas por ser mais conveniente fazelo no SQL do que no mongo


### remover os vazios
#Antes de exportar as moradas altera as que têm um null inserido de uma forma diferente (apenas 4)
#update address
#set address2 = null
#where address2 = '';


########## CUSTOMER tables ##########
# export table customer
select customer_id, store_id, concat_ws(' ',first_name,last_name), email, address_id, active, create_date, last_update
from customer
into outfile 'sakila_nosql/csv/customerAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table address & city & country 
	# apagado address2 por estar sempre vazio
    # removidos IDs de city e country por serem inuteis quando juntamos tabelas
select address_id,address,district,postal_code,phone,ST_AsText(location),
		city, country, address.last_update 
from address, city, country
where city.country_id = country.country_id
and address.city_id = city.city_id
#order by country_id
into outfile 'sakila_nosql/csv/address_city_countryAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';


########## INVENTORY tables ##########
# export table film & language
	# without original_language
    # with language name
select film_id, title, description, release_year, l.name, 
		rental_duration, rental_rate, length, replacement_cost, rating, special_features, f.last_update
from film as f, language as l
where f.language_id = l.language_id
into outfile 'sakila_nosql/csv/filmAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table category & film_category
select c.name, fc.film_id, c.last_update
from category as c, film_category as fc
where c.category_id = fc.category_id
into outfile 'sakila_nosql/csv/categoryAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table actor & film_actor
select concat_ws(' ',first_name,last_name), fa.film_id, a.last_update
from actor as a, film_actor as fa
where a.actor_id = fa.actor_id
into outfile 'sakila_nosql/csv/actorAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table inventory
select inventory_id, film_id, store_id from inventory
order by inventory_id
into outfile 'sakila_nosql/csv/inventoryAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';


########## BUSINESS tables ##########
# export table store
select store_id, manager_staff_id, address_id, last_update from store
into outfile 'sakila_nosql/csv/storeAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table staff
select staff_id, concat_ws(' ',first_name,last_name), address_id, store_id, email, active, username, password, to_base64(picture), last_update from staff
into outfile 'sakila_nosql/csv/staffAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table rental
select rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update from rental
order by rental_id
into outfile 'sakila_nosql/csv/rentalAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table payment
select rental_id, amount, payment_date from payment
order by rental_id
into outfile 'sakila_nosql/csv/paymentAUX.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

