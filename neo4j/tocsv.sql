--Conversão das tabelas para csv
select 'country_id', 'country', 'last_update'
union all
select * from country
into outfile '/tmp/country.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

select 'city_id', 'city', 'country_id', 'last_update'
union all
select * from city
into outfile '/tmp/city.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

select 'costumer_id', 'store_id', 'first_name', 'last_name', 'email', 'address_id', 'active', 'create_date', 'last_update'
union all
select * from customer
into outfile '/tmp/customers.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
