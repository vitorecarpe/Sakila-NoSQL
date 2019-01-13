import mysql.connector
import cx_Oracle
import io
import binascii

# CONECÇÃO AO MYSQL
connectionMySQL = mysql.connector.connect(
    host="localhost",
    user="nosql",
    passwd="",
    database="sakila"
)

#CONECÇÃO AO ORACLE                   username/password
connectionOracle = cx_Oracle.connect('nosql/nosql@localhost:1521/orcl')
mycursor_oracle = connectionOracle.cursor()

mycursor_mysql = connectionMySQL.cursor()


# RENTAL
print("-- EXPORTING RENTAL TABLE")
mycursor_mysql.execute(
                "select * from rental"
            )

rental_data_rows = mycursor_mysql.fetchall()

for row in rental_data_rows:
    print("insert into rental(rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update) values ('" +  str(row[0]) + "', " + "TO_DATE('" + str(row[1]) + "', 'yyyy/mm/dd hh24:mi:ss'), '" + str(row[2]) + "', '" + str(row[3]) + "', " + "TO_DATE('" + str(row[4]) + "', 'yyyy/mm/dd hh24:mi:ss'), '" + str(row[5]) + "', " + "TO_DATE('" + str(row[6]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into rental(rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update) values ('" +  str(row[0]) + "', " + "TO_DATE('" + str(row[1]) + "', 'yyyy/mm/dd hh24:mi:ss'), '" + str(row[2]) + "', '" + str(row[3]) + "', " + "TO_DATE('" + str(row[4]) + "', 'yyyy/mm/dd hh24:mi:ss'), '" + str(row[5]) + "', " + "TO_DATE('" + str(row[6]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()

# FILM_CATEGORY
print("-- EXPORTING FILM_CATEGORY TABLE")
mycursor_mysql.execute(
                "select * from film_category"
            )

film_category_data_rows = mycursor_mysql.fetchall()

for row in film_category_data_rows:
    print("insert into film_category(film_id, category_id, last_update) values ('" + str(row[0]) + "', '" + str(row[1]) + "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into film_category(film_id, category_id, last_update) values ('" + str(row[0]) + "', '" + str(row[1]) + "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()


# LANGUAGE
print("-- EXPORTING LANGUAGE TABLE")
mycursor_mysql.execute(
                "select * from language"
            )

language_data_rows = mycursor_mysql.fetchall()

for row in language_data_rows:
    print("insert into language(language_id, name, last_update) values ('" +  str(row[0]) + "', '" + str(row[1]) + "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into language(language_id, name, last_update) values ('" +  str(row[0]) + "', '" + str(row[1]) + "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()

# INVENTORY
print("-- EXPORTING INVENTORY TABLE")
mycursor_mysql.execute(
                "select * from inventory"
            )

inventory_data_rows = mycursor_mysql.fetchall()

for row in inventory_data_rows:
    print("insert into inventory(inventory_id, film_id, store_id, last_update) values ('" +  str(row[0]) + "', '" + str(row[1]) + "', '" + str(row[2]) + "', TO_DATE('" + str(row[3]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into inventory(inventory_id, film_id, store_id, last_update) values ('" +  str(row[0]) + "', '" + str(row[1]) + "', '" + str(row[2]) + "', TO_DATE('" + str(row[3]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()

# ACTOR
print("-- EXPORTING ACTOR TABLE")
mycursor_mysql.execute(
                "select * from actor"
            )

actor_data_rows = mycursor_mysql.fetchall()

for row in actor_data_rows:
    print("insert into actor(actor_id, first_name, last_name, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '" + str(row[2]) + "', TO_DATE('" + str(row[3]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into actor(actor_id, first_name, last_name, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '" + str(row[2]) + "', TO_DATE('" + str(row[3]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()

# CATEGORY
print("-- EXPORTING CATEGORY TABLE")
mycursor_mysql.execute(
                "select * from category"
            )

category_data_rows = mycursor_mysql.fetchall()

for row in category_data_rows:
    print("insert into category(category_id, name, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into category(category_id, name, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()

# COUNTRY
print("-- EXPORTING COUNTRY TABLE")
mycursor_mysql.execute(
                "select * from country"
            )

country_data_rows = mycursor_mysql.fetchall()

for row in country_data_rows:
    print("insert into country(country_id, country, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into country(country_id, country, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()

# CITY
print("-- EXPORTING CITY TABLE")
mycursor_mysql.execute(
                "select * from city"
            )

city_data_rows = mycursor_mysql.fetchall()

for row in city_data_rows:
    print("insert into city(city_id, city, country_id, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '" + str(row[2]) +"', TO_DATE('" + str(row[3]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into city(city_id, city, country_id, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '" + str(row[2]) +"', TO_DATE('" + str(row[3]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()

# ADDRESS                   
print("-- EXPORTING ADDRESS TABLE")
mycursor_mysql.execute(
                "select * from address"
            )

address_data_rows = mycursor_mysql.fetchall()

for row in address_data_rows:
    print("insert into address(address_id, address, district, city_id, postal_code, phone, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '"  + str(row[3]) + "', '" + str(row[4]) + "', '" + str(row[5]) + "', '" + str(row[6]) + "', TO_DATE('" + str(row[8]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into address(address_id, address, district, city_id, postal_code, phone, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '"  + str(row[3]) + "', '" + str(row[4]) + "', '" + str(row[5]) + "', '" + str(row[6]) + "', TO_DATE('" + str(row[8]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()

# STORE
print("-- EXPORTING STORE TABLE")
mycursor_mysql.execute(
                "select * from store"
            )

store_data_rows = mycursor_mysql.fetchall()

for row in store_data_rows:
    print("insert into store(store_id, manager_staff_id, address_id, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '"  + str(row[2]) +  "', TO_DATE('" + str(row[3]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into store(store_id, manager_staff_id, address_id, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '"  + str(row[2]) +  "', TO_DATE('" + str(row[3]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()

# FILM_TEXT
print("-- EXPORTING FILM_TEXT TABLE")
mycursor_mysql.execute(
                "select * from film_text"
            )

film_text_data_rows = mycursor_mysql.fetchall()

for row in film_text_data_rows:
    print("insert into film_text(film_id, title, description) values ('" + str(row[0]) + "', '" + str(row[1]) + "', '" + str(row[2]) + "');")
    mycursor_oracle.execute("insert into film_text(film_id, title, description) values ('" + str(row[0]) + "', '" + str(row[1]) + "', '" + str(row[2]) + "')")
connectionOracle.commit()








# CUSTOMER
print("-- EXPORTING CUSTOMER TABLE")
mycursor_mysql.execute(
                "select * from customer"
            )

customer_data_rows = mycursor_mysql.fetchall()

for row in customer_data_rows:
    print("insert into customer(customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '"  + str(row[2]) + "', '" + str(row[3]) + "', '" + str(row[4]) + "', '" + str(row[5]) + "', '" + str(row[6]) + "', TO_DATE('" + str(row[7]) + "', 'yyyy/mm/dd hh24:mi:ss')" + ", TO_DATE('" + str(row[8]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into customer(customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '"  + str(row[2]) + "', '" + str(row[3]) + "', '" + str(row[4]) + "', '" + str(row[5]) + "', '" + str(row[6]) + "', TO_DATE('" + str(row[7]) + "', 'yyyy/mm/dd hh24:mi:ss')" + ", TO_DATE('" + str(row[8]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()










# FILM
print("-- EXPORTING FILM TABLE")
mycursor_mysql.execute(
                "select * from film"
            )
i = 0
aux = []
film_data_rows = mycursor_mysql.fetchall()

for row in film_data_rows:
    aux = " ,".join(row[11])
    print("insert into film(film_id, title, description, release_year, language_id, rental_rate, length, replacement_cost, rating, special_features, last_update) values ('" +  str(row[0]) + "', '" + str(row[1]) + "', '" + str(row[2]) + "', '" + str(row[3]) + "', '" + str(row[4]) + "', '" + str(row[7]) + "', '" + str(row[8]) + "', '" + str(row[9]) + "', '" + str(row[10]) + "', '" + str(aux) + "', TO_DATE('" + str(row[12]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into film(film_id, title, description, release_year, language_id, rental_rate, length, replacement_cost, rating, special_features, last_update) values ('" +  str(row[0]) + "', '" + str(row[1]) + "', '" + str(row[2]) + "', '" + str(row[3]) + "', '" + str(row[4]) + "', '" + str(row[7]) + "', '" + str(row[8]) + "', '" + str(row[9]) + "', '" + str(row[10]) + "', '" + str(aux) + "', TO_DATE('" + str(row[12]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()

# FILM_ACTOR
print("-- EXPORTING FILM_ACTOR TABLE")
mycursor_mysql.execute(
                "select * from film_actor"
            )

film_actor_data_rows = mycursor_mysql.fetchall()

for row in film_actor_data_rows:
    print("insert into film_actor(actor_id, film_id, last_update) values ('" + str(row[0]) + "', '" + str(row[1]) +  "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    mycursor_oracle.execute("insert into film_actor(actor_id, film_id, last_update) values ('" + str(row[0]) + "', '" + str(row[1]) +  "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
connectionOracle.commit()












# ******************* PROBLEMAS COM O PYTHON **********************************************



# PAYMENT (NESTE CASO, TEMOS DE MANDAR OS COMANDOS SQL PARA UM FICHEIRO, IR A CONSOLA DO ORACLE, COLAR E EXECUTAR)
#                                                       DEVIDO A LIMITAÇÕES DO PYTHON
print("-- EXPORTING PAYMENT TABLE")
mycursor_mysql.execute(
                "select * from payment"
            )

payment_data_rows = mycursor_mysql.fetchall()

for row in payment_data_rows:
    print("insert into payment(payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update) values ('" +  str(row[0]) + "', '" + str(row[1]) + "', '" + str(row[2]) + "', '" + str(row[3]) + "', '" + str(row[4]).replace('.',',') + "', " + "TO_DATE('" + str(row[5]) + "', 'yyyy/mm/dd hh24:mi:ss'), " + "TO_DATE('" + str(row[6]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
    #mycursor_oracle.execute("insert into payment(customer_id, staff_id, rental_id, amount, payment_date, last_update) values ('" + str(row[1]) + "', '" + str(row[2]) + "', '" + str(row[3]) + "', '" + str(str(row[4]).replace('.',',')) + "', " + "TO_DATE('" + str(row[5]) + "', 'yyyy/mm/dd hh24:mi:ss'), " + "TO_DATE('" + str(row[6]) + "', 'yyyy/mm/dd hh24:mi:ss'))")


# STAFF  (NESTE CASO, TEMOS DE MANDAR OS COMANDOS SQL PARA UM FICHEIRO, IR A CONSOLA DO ORACLE, COLAR E EXECUTAR)
#                                                       DEVIDO A LIMITAÇÕES DO PYTHON
mycursor_mysql.execute(
                "select * from staff"
            )

staff_data_rows = mycursor_mysql.fetchall()

mycursor_oracle.setinputsizes(ac_sign=cx_Oracle.BLOB)

for row in staff_data_rows:
    if type(row[4]) is bytes and type(row[9]) is bytearray:
        print("insert into staff(staff_id, first_name, last_name, address_id, email, store_id, active, username, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '"  + str(row[2]) + "', '" + str(row[3]) + "', '" + str(row[5]) + "', '" + str(row[6])  + "', '" + str(row[7]) + "', '" + str(row[8]) + "', TO_DATE('" + str(row[10]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
        #mycursor_oracle.execute("insert into staff(first_name, last_name, address_id, email, store_id, active, username, last_update) values ('" +  str(row[1]) + "', '"  + str(row[2]) + "', '" + str(row[3]) + "', '" + str(row[5]) + "', '" + str(row[6])  + "', '" + str(row[7]) + "', '" + str(row[8]) + "', TO_DATE('" + str(row[10]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
    else:
        print("insert into staff(staff_id, first_name, last_name, address_id, email, store_id, active, username, last_update) values ('" +  str(row[0]) + "', '" +  str(row[1]) + "', '"  + str(row[2]) + "', '" + str(row[3]) + "', '" + str(row[5]) + "', '" + str(row[6])  + "', '" + str(row[7]) + "', '" + str(row[8]) +  "', TO_DATE('" + str(row[10]) + "', 'yyyy/mm/dd hh24:mi:ss'));")
        #mycursor_oracle.execute("insert into staff(first_name, last_name, address_id, email, store_id, active, username, last_update) values ('" +  str(row[1]) + "', '"  + str(row[2]) + "', '" + str(row[3]) + "', '" + str(row[5]) + "', '" + str(row[6])  + "', '" + str(row[7]) + "', '" + str(row[8]) +  "', TO_DATE('" + str(row[10]) + "', 'yyyy/mm/dd hh24:mi:ss'))")



# FECHO DE CONECÇÃO BDS

connectionOracle.commit()

mycursor_oracle.close()
connectionOracle.close()

mycursor_mysql.close()
connectionMySQL.close()