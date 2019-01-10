#!/bin/bash

# This script uses the CSV files exported in MySQL Workbench,
# and imports then into mongo documents, in the 'nosql' databse

echo " ### INICIO !!!"

### drop database command
# DROPS any possible old files in nosql database
echo " >> DROP !!!"
mongo.exe nosql --eval "db.dropDatabase()"

### Import documents
# Here we import all the documents using the CSVs
echo " > IMPORTS !!!"
# Customer
mongoimport.exe --db nosql --type csv --file "./csv/address_city_countryAUX.csv" --fields "address_id","address","district","postal_code","phone","location","city","country","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/customerAUX.csv" --fields "customer_id","store_id","name","email","address_id","active","create_date","last_update"
# Inventory
mongoimport.exe --db nosql --type csv --file "./csv/inventoryAUX.csv" --fields "inventory_id","film_id","store_id"
mongoimport.exe --db nosql --type csv --file "./csv/categoryAUX.csv" --fields "category_name","film_id"
mongoimport.exe --db nosql --type csv --file "./csv/actorAUX.csv" --fields "actor_name","film_id"
mongoimport.exe --db nosql --type csv --file "./csv/filmAUX.csv" --fields "film_id","title","description","release_year","language","rental_duration","rental_rate","length","replacement_cost","rating","special_features","last_update"
# Business
mongoimport.exe --db nosql --type csv --file "./csv/other_payments.csv" --fields "payment_id","staff_id","customer_id","amount","payment_date"
mongoimport.exe --db nosql --type csv --file "./csv/rental.csv" --fields "rental_id","rental_date","film_id","film_title","amount","return_date","payment_date","store_id","staff_id","customer_id"
mongoimport.exe --db nosql --type csv --file "./csv/staffAUX.csv" --fields "staff_id","staff_name","address_id","store_id","email","active","username","password","picture","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/storeAUX.csv" --fields "store_id","manager_id","manager_name","address_id","last_update"

### Aggregations and small changes
# Here we aggregate some information, using embedded documents and attributes, 
# Done here, because was easier or unavailable in MySQL
echo " > JOINS !!!"
## Agregar address ao customer
mongo.exe nosql --eval "db.customerAUX.aggregate([
    {\$lookup: {
        from: 'address_city_countryAUX',
        localField: 'address_id',
        foreignField: 'address_id',
        as: 'address'
    }},
    {\$unwind:'\$address'},
    {\$project:{
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
## Agregar address ao staff
mongo.exe nosql --eval "db.staffAUX.aggregate([
    {\$lookup: {
        from: 'address_city_countryAUX',
        localField: 'address_id',
        foreignField: 'address_id',
        as: 'address'
    }},
    {\$unwind:'\$address'},
    {\$project:{
        'staff_name':1,
        'store_id':1,
        'email':1,
        'active':1,
        'username':1,
        'password':1,
        'last_update':1,
        'address':{
            'address':1,
            'district':1,
            'postal_code':1,
            'location':1,
            'city':1,
            'country':1,
            'phone':1,
            'last_update':1
        }
    }},
    {\$out:'staffAUX'}
])"
## Agregar address ao store
mongo.exe nosql --eval "db.storeAUX.aggregate([
    {\$lookup: {
        from: 'address_city_countryAUX',
        localField: 'address_id',
        foreignField: 'address_id',
        as: 'address'
    }},
    {\$unwind:'\$address'},
    {\$project:{
        'store_id':1,
        'manager_id':1,
        'manager_name':1,
        'last_update':1,
        'address':{
            'address':1,
            'district':1,
            'postal_code':1,
            'location':1,
            'city':1,
            'country':1,
            'phone':1,
            'last_update':1
        }
    }},
    {\$out:'storeAUX'}
])"

## Agregar category e actors e store(ID) ao film
mongo.exe nosql --eval "db.filmAUX.aggregate([
    {\$lookup: {
        from: 'categoryAUX',
        localField: 'film_id',
        foreignField: 'film_id',
        as: 'category'
    }},
    {\$lookup: {
        from: 'actorAUX',
        localField: 'film_id',
        foreignField: 'film_id',
        as: 'actor'
    }},
    {\$lookup: {
        from: 'inventoryAUX',
        localField: 'film_id',
        foreignField: 'film_id',
        as: 'available_stores'
    }},
    {\$unwind:'\$category'},
    {\$unwind:'\$actor'},
    {\$unwind:'\$available_stores'},
    {\$group:{
        '_id':'\$_id',
        'film_id':{'\$first':'\$film_id'},
        'title':{'\$first':'\$title'},
        'description':{'\$first':'\$description'},
        'release_year':{'\$first':'\$release_year'},
        'language':{'\$first':'\$language'},
        'rental_duration':{'\$first':'\$rental_duration'},
        'rental_rate':{'\$first':'\$rental_rate'},
        'length':{'\$first':'\$length'},
        'replacement_cost':{'\$first':'\$replacement_cost'},
        'rating':{'\$first':'\$rating'},
        'special_features':{'\$first':'\$special_features'},
        'last_update':{'\$first':'\$last_update'},
        'category': {'\$addToSet':'\$category.category_name'},
        'actors': {'\$addToSet':'\$actor.actor_name'},
        'available_stores': {'\$addToSet':'\$available_stores.store_id'}
    }},
    {\$out:'film'}
])"
## Agregar staff e film(ID) ao store
mongo.exe nosql --eval "db.storeAUX.aggregate([
    {\$lookup: {
        from: 'staffAUX',
        localField: 'store_id',
        foreignField: 'store_id',
        as: 'staff'
    }},
    {\$lookup: {
        from: 'inventoryAUX',
        localField: 'store_id',
        foreignField: 'store_id',
        as: 'available_films'
    }},
    {\$unwind:'\$staff'},
    {\$unwind:'\$available_films'},
    {\$group:{
        '_id':'\$_id',
        'store_id':{'\$first':'\$store_id'},
        'manager_id':{'\$first':'\$manager_id'},
        'manager_name':{'\$first':'\$manager_name'},
        'last_update':{'\$first':'\$last_update'},
        'address':{'\$first':'\$address'},
        'staff': {'\$push':'\$actor.actor_name'},
        'available_films': {'\$addToSet':'\$available_films.film_id'}
    }},
    {\$out:'store'}
])"

### Drop AUX documents
# Some of the initial imported tables got changed, or were only auxiliary
# Here we delete any unneeded documents left behind
echo " > DELETES !!!"
mongo.exe nosql --eval "db.address_city_countryAUX.drop();
                        db.customerAUX.drop()"
mongo.exe nosql --eval "db.categoryAUX.drop();
                        db.actorAUX.drop();
                        db.inventoryAUX.drop();
                        db.filmAUX.drop()"
mongo.exe nosql --eval "db.staffAUX.drop();
                        db.storeAUX.drop()"

### Import script finished :D !!!
echo " ### TERMINADO !!!"