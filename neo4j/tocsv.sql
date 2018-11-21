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


select * from customer
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/customers.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
