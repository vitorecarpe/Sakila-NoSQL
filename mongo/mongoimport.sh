#!/bin/bash

# drop database command
mongo.exe nosql --eval "db.dropDatabase()"

# import documents
echo "INICIO !!!"
mongoimport.exe --db nosql --type csv --file "./csv/actor.csv" --fields "actor_id","first_name","last_name","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/address.csv" --fields "address_id","address","address2","district","city_id","postal_code","phone","location","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/category.csv" --fields "category_id","name","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/city.csv" --fields "city_id","city","country_id","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/country.csv" --fields "country_id","country","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/customer.csv" --fields "customer_id","store_id","first_name","last_name","email","address_id","active","create_date","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/film.csv" --fields "film_id","title","description","release_year","language_id","original_language_id","rental_duration","rental_rate","length","replacement_cost","rating","special_features","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/inventory.csv" --fields "inventory_id","film_id","store_id","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/language.csv" --fields "language_id","name","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/payment.csv" --fields "payment_id","customer_id","staff_id","rental_id","amount","payment_date","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/rental.csv" --fields "rental_id","rental_date","inventory_id","customer_id","return_date","staff_id","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/staff.csv" --fields "staff_id","first_name","last_name","address_id","picture","email","store_id","active","username","password","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/store.csv" --fields "store_id","manager_staff_id","address_id","last_update"
echo "TERMINADO !!!"