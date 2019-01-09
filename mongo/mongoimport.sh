#!/bin/bash

# drop database command
mongo.exe nosql --eval "db.dropDatabase()"

# import documents
echo " # INICIO !!!"
# tabelas individuais automaticas do MySQL
# mongoimport.exe --db nosql --type csv --file "./csv/actor.csv" --fields "actor_id","first_name","last_name","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/address.csv" --fields "address_id","address","address2","district","city_id","postal_code","phone","location","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/category.csv" --fields "category_id","name","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/city.csv" --fields "city_id","city","country_id","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/country.csv" --fields "country_id","country","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/customer.csv" --fields "customer_id","store_id","first_name","last_name","email","address_id","active","create_date","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/film.csv" --fields "film_id","title","description","release_year","language_id","original_language_id","rental_duration","rental_rate","length","replacement_cost","rating","special_features","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/inventory.csv" --fields "inventory_id","film_id","store_id","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/language.csv" --fields "language_id","name","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/payment.csv" --fields "payment_id","customer_id","staff_id","rental_id","amount","payment_date","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/rental.csv" --fields "rental_id","rental_date","inventory_id","customer_id","return_date","staff_id","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/staff.csv" --fields "staff_id","first_name","last_name","address_id","picture","email","store_id","active","username","password","last_update"
# mongoimport.exe --db nosql --type csv --file "./csv/store.csv" --fields "store_id","manager_staff_id","address_id","last_update"

echo " > IMPORTS !!!"
# Tabelas que sao importadas
mongoimport.exe --db nosql --type csv --file "./csv/customerAUX.csv" --fields "customer_id","store_id","name","email","address_id","active","create_date","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/address_city_countryAUX.csv" --fields "address_id","address","district","postal_code","phone","location","city","country","last_update"

mongoimport.exe --db nosql --type csv --file "./csv/filmAUX.csv" --fields "film_id","title","description","release_year","language","rental_duration","rental_rate","length","replacement_cost","rating","special_features","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/categoryAUX.csv" --fields "category_name","film_id","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/actorAUX.csv" --fields "actor_name","film_id","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/inventoryAUX.csv" --fields "film_id","store_id"


echo " > JOINS !!!"
# Aqui é onde agregamos algumas tabelas, como atributos embebidos

##### Agregar address #####
# Agregar address ao customer
mongo.exe nosql --eval "db.customerAUX.aggregate([
    {\$lookup: {
        from: 'address_city_countryAUX',
        localField: 'address_id',
        foreignField: 'address_id',
        as: 'address'
    }},
    {\$unwind:'\$address'},
    {\$project:{
        '_id':0,
        'customer_id':1,
        'store_id':1,
        'name':1,
        'email':1,
        'active':1,
        'create_date':1,
        'address':{
            'address':1,
            'district':1,
            'postal_code':1,
            'location':1,
            'city':1,
            'country':1,
            'phone':1,
            'last_update':1
        },
        'last_update':1
    }},
    {\$out:'customer'}
])"
### TODO !!!
# TODO Agregar address ao staff
# TODO Agregar address ao store
##############################

# Agregar category e actors ao film
    # TODO adicionar o ID da store onde existe
mongo.exe nosql --eval "db.filmAUX.aggregate([
    {\$lookup: {
        from: 'categoryAUX',
        localField: 'film_id',
        foreignField: 'film_id',
        as: 'category'
    }},
    {\$unwind:'\$category'},
    {\$lookup: {
        from: 'actorAUX',
        localField: 'film_id',
        foreignField: 'film_id',
        as: 'actor'
    }},
    {\$project:{
        '_id':0,
        'film_id':1,
        'title':1,
        'description':1,
        'release_year':1,
        'language':1,
        'rental_duration':1,
        'rental_rate':1,
        'length':1,
        'replacement_cost':1,
        'rating':1,
        'special_features':1,
        'category':{
            'category_name':1
        },
        'actor':{
            'actor_name':1
        },
        'last_update':1
    }},
    {\$out:'film'}
])"

### TODO !!!
# TODO Agregar payment e film(nome) ao rental
# TODO Agregar rental ao staff
# TODO Agregar staff e film(nome)


echo " # TERMINADO !!!"
