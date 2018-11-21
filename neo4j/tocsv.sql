--Conversão das tabelas para csv
select * from country
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/country.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

select city, country from city --With the country in order to link immediatly
inner join country on city.country_id = country.country_id
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/city.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

select * from customer
into outfile '/usr/local/Cellar/neo4j/3.4.5/libexec/import/customers.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
