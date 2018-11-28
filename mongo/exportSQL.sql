# TODO:
# decidir o schema


### remover os vazios
#Antes de exportar as moradas altera as que têm um null inserido de uma forma diferente (apenas 4)
update address
set address2 = null
where address2 = '';



### CUSTOMER tables ###
# remover
# export table customer
select * from customer
into outfile 'sakila_nosql/csv/customer.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table address
select * from address
into outfile 'sakila_nosql/csv/address.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# export table union of city & country
select city.city_id, city.city, country.country_id, country.country, country.last_update 
from city, country
where city.country_id = country.country_id
into outfile 'sakila_nosql/csv/city_country.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';


### LOBO STUFF - considerar juntar
#exportação das moradas
select address, address2, district, city, postal_code, phone, country from address
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/address.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';



### BUSINESS tables ###
# export table staff
select * from staff
into outfile 'sakila_nosql/csv/staff.csv'
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

# export table store
select * from store
into outfile 'sakila_nosql/csv/store.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';


### INVENTORY tables ###
# export table film

# export table 

# export table 

# export table 




##### testing #####
select * from city;
select * from country;

