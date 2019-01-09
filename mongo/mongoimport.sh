#!/bin/bash

# import documents
echo " ### INICIO !!!"

# drop database command
echo " >> DROP !!!"
mongo.exe nosql --eval "db.dropDatabase()"

# Tabelas que sao importadas
echo " > IMPORTS !!!"
# Customer
mongoimport.exe --db nosql --type csv --file "./csv/address_city_countryAUX.csv" --fields "address_id","address","district","postal_code","phone","location","city","country","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/customerAUX.csv" --fields "customer_id","store_id","name","email","address_id","active","create_date","last_update"
# Inventory
mongoimport.exe --db nosql --type csv --file "./csv/inventoryAUX.csv" --fields "inventory_id","film_id","store_id"
mongoimport.exe --db nosql --type csv --file "./csv/categoryAUX.csv" --fields "category_name","film_id","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/actorAUX.csv" --fields "actor_name","film_id","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/filmAUX.csv" --fields "film_id","title","description","release_year","language","rental_duration","rental_rate","length","replacement_cost","rating","special_features","last_update"
# Business
mongoimport.exe --db nosql --type csv --file "./csv/other_payments.csv" --fields "payment_id","staff_id","customer_id","amount","payment_date"
mongoimport.exe --db nosql --type csv --file "./csv/payment_rentalAUX.csv" --fields "rental_id","rental_date","film_id","title","amount","return_date","payment_date","inventory_id","staff_id","customer_id"
mongoimport.exe --db nosql --type csv --file "./csv/staffAUX.csv" --fields "staff_id","staff_name","address_id","store_id","email","active","username","password","picture","last_update"
mongoimport.exe --db nosql --type csv --file "./csv/storeAUX.csv" --fields "store_id","manager_id","address_id","last_update"

# Aqui é onde agregamos algumas tabelas, como atributos ou listas embebidas
echo " > JOINS !!!"
########## Agregar address ##########
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
# Agregar address ao staff
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
        'store_id_aux':'\$store_id',
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
    {\$out:'staff'}
])"
# Agregar address ao store
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
        'manager_id_aux':'\$manager_id',
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
    {\$out:'store'}
])"
########################################
# Agregar category e actors ao film
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
### TODO !!!
# TODO Agregar rental ao staff
# TODO Agregar staff e film(nome)


# Apagar tabelas auxiliares
echo " > DELETES !!!"
mongo.exe nosql --eval "db.address_city_countryAUX.drop();
                        db.customerAUX.drop()"
# # mongo.exe nosql --eval "db.inventoryAUX.drop()"
mongo.exe nosql --eval "db.categoryAUX.drop();
                        db.actorAUX.drop()"
mongo.exe nosql --eval "db.filmAUX.drop()"


echo " ### TERMINADO !!!"