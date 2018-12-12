# TODO:
# decidir o schema
# tratar de campos com valores vazios

-> uma collection "store" em que cada documment tem embedded o staff. worth?
-> uma collection "rental"
-> uma collection "payment" 
-> uma collection "inventory" (que tem embedded a film_text)

### remover os vazios
#Antes de exportar as moradas altera as que têm um null inserido de uma forma diferente (apenas 4)
update address
set address2 = null
where address2 = '';



### CUSTOMER tables ###
# export table customer
select customer_id, store_id, concat_ws(' ',first_name,last_name), email, address_id, active, create_date, last_update
from customer
into outfile 'sakila_nosql/csv/customer2.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table address & city & country 
	# apagado address2 por estar sempre vazio
    # removidos IDs de city e country que sao inuteis quando juntamos tabelas
select address_id,address,district,postal_code,phone,ST_AsText(location),
		city, country, address.last_update 
from address, city, country
where city.country_id = country.country_id
and address.city_id = city.city_id
#order by country_id
into outfile 'sakila_nosql/csv/address_city_country2.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';


### INVENTORY tables ###
# export table film & language
	# without original_language
    # with language name
select film_id, title, description, release_year, l.name, 
		rental_duration, rental_rate, length, replacement_cost, rating, special_features, f.last_update
from film as f, language as l
where f.language_id = l.language_id
into outfile 'sakila_nosql/csv/film2.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table category & film_category
select c.name, fc.film_id, c.last_update
from category as c, film_category as fc
where c.category_id = fc.category_id
into outfile 'sakila_nosql/csv/category2.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table actor & film_actor
select concat_ws(' ',first_name,last_name), fa.film_id, a.last_update
from actor as a, film_actor as fa
where a.actor_id = fa.actor_id
into outfile 'sakila_nosql/csv/actor2.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table inventory (maybe remover?)
select * from inventory
into outfile 'sakila_nosql/csv/inventory2.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';


### BUSINESS tables ###
# export table store & staff
select store.store_id, store.manager_staff_id, store.address_id, store.last_update,
		staff.staff_id, concat_ws(' ',first_name,last_name), staff.address_id, staff.email, active, username, password, to_base64(picture)
from store, staff
where store.store_id = staff.store_id
into outfile 'sakila_nosql/csv/store_staff2.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table payment
select * from payment
into outfile 'sakila_nosql/csv/payment2.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table rental
select * from rental
into outfile 'sakila_nosql/csv/rental2.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

