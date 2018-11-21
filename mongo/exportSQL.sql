-- gostava que funcionasse no windows
select country_id, country, last_update 
into outfile 'country.csv' 
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' from country;