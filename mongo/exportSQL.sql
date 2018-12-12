# TODO:
# decidir o schema
# tratar de campos com valores vazios

quanto ao schema, o que me parece melhor é:
-> uma collection "customers" em que cada document tem apenas embedded o address 
	(e a tabela da city e country passam a ser apenas um atributo do address). address separado
-> uma collection "store" em que cada documment tem embedded o staff. worth?
-> uma collection "rental"
-> uma collection "payment" 
-> uma collection "inventory" (que tem embedded a film_text)
-> uma collection "film" (passam a ser atributo dele a category e a language desaparecendo as suas tabelas), 
	com os atores embedded;

### remover os vazios
#Antes de exportar as moradas altera as que têm um null inserido de uma forma diferente (apenas 4)
update address
set address2 = null
where address2 = '';



### CUSTOMER tables ###
# export table customer
select customer_id, store_id, concat_ws(' ',first_name,last_name), email, address_id, active, create_date, last_update
from customer
into outfile 'sakila_nosql/csv/customer.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table union of address & city & country 
	# apagado address2 por estar sempre vazio
    # removidos IDs de city e country que sao inuteis quando juntamos tabelas
select address_id,address,district,postal_code,phone,ST_AsText(location),
		city, country, address.last_update 
from address, city, country
where city.country_id = country.country_id
and address.city_id = city.city_id
#order by country_id
into outfile 'sakila_nosql/csv/address_city_country.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';


### BUSINESS tables ###
# export table store & staff
select store.store_id, store.manager_staff_id, store.address_id, store.last_update,
		staff.staff_id, concat_ws(' ',first_name,last_name), staff.address_id, staff.email, active, username, password, to_base64(picture)
from store, staff
where store.store_id = staff.store_id
into outfile 'sakila_nosql/csv/store_staff.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table payment
select * from payment
into outfile 'sakila_nosql/csv/payment.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table rental
select * from rental
into outfile 'sakila_nosql/csv/rental.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';


### INVENTORY tables ###
# export table film

# export table 

# export table 

# export table 



