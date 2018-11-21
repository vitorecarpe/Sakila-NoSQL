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
select first_name, last_name, address, city, email, active, username, password from staff
inner join address on staff.address_id = address.address_id
inner join city on address.city_id = city.city_id
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/staff.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

select address, city, username as manager from store
inner join staff on store.manager_staff_id = staff.staff_id
inner join address on store.address_id = address.address_id
inner join city on address.city_id = city.city_id
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/stores.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
