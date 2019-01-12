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

# mycursor_oracle.execute('select * from test')
# data = mycursor_oracle.fetchall()

# for x in data:
#     print(x)


# mycursor_oracle.execute('select * from departments order by department_id')
# for result in cur:
#     print(result)

mycursor_mysql = connectionMySQL.cursor()

# # ACTOR
# print("EXPORTING ACTOR TABLE")
# mycursor_mysql.execute(
#                 "select * from actor"
#             )

# actor_data_rows = mycursor_mysql.fetchall()

# for row in actor_data_rows:
#     mycursor_oracle.execute("insert into actor(first_name, last_name, last_update) values ('" +  str(row[1]) + "', '" + str(row[2]) + "', TO_DATE('" + str(row[3]) + "', 'yyyy/mm/dd hh24:mi:ss'))")

# # CATEGORY
# print("EXPORTING CATEGORY TABLE")
# mycursor_mysql.execute(
#                 "select * from category"
#             )

# category_data_rows = mycursor_mysql.fetchall()

# for row in category_data_rows:
#         mycursor_oracle.execute("insert into category(name, last_update) values ('" +  str(row[1]) + "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'))")

# # COUNTRY
# print("EXPORTING COUNTRY TABLE")
# mycursor_mysql.execute(
#                 "select * from country"
#             )

# country_data_rows = mycursor_mysql.fetchall()

# for row in country_data_rows:
#         mycursor_oracle.execute("insert into country(country, last_update) values ('" +  str(row[1]) + "', TO_DATE('" + str(row[2]) + "', 'yyyy/mm/dd hh24:mi:ss'))")

# # CITY
# print("EXPORTING CITY TABLE")
# mycursor_mysql.execute(
#                 "select * from city"
#             )

# city_data_rows = mycursor_mysql.fetchall()

# for row in city_data_rows:
#         mycursor_oracle.execute("insert into city(city, country_id, last_update) values ('" +  str(row[1]) + "', '" + str(row[2]) +"', TO_DATE('" + str(row[3]) + "', 'yyyy/mm/dd hh24:mi:ss'))")

# ADDRESS                   
# print("EXPORTING ADDRESS TABLE")
# mycursor_mysql.execute(
#                 "select * from address"
#             )

# address_data_rows = mycursor_mysql.fetchall()

# for row in address_data_rows:
#     mycursor_oracle.execute("insert into address(address, district, city_id, postal_code, phone, last_update) values ('" +  str(row[1]) + "', '"  + str(row[3]) + "', '" + str(row[4]) + "', '" + str(row[5]) + "', '" + str(row[6]) + "', TO_DATE('" + str(row[8]) + "', 'yyyy/mm/dd hh24:mi:ss'))")

# STAFF    ****************************************** faltam os binários ************************************************************
mycursor_mysql.execute(
                "select * from staff"
            )

staff_data_rows = mycursor_mysql.fetchall()

for row in staff_data_rows:
    #print(row[4])
    if type(row[4]) is bytes and type(row[9]) is bytearray:
        print(type(row[9])) 
        #mycursor_oracle.execute("insert into staff(first_name, last_name, address_id, picture, email, store_id, active, username, password, last_update) values ('" +  str(row[1]) + "', '"  + str(row[2]) + "', '" + str(row[3]) + "', '" + row[4].getValue() + "', '" + str(row[5]) + "', '" + str(row[6])  + "', '" + str(row[7]) + "', '" + str(row[8]) + "', '" + row[9].getValue() + "', TO_DATE('" + str(row[10]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
        #aux = row[4].decode("unicode")
    else:
        mycursor_oracle.execute("insert into staff(first_name, last_name, address_id, email, store_id, active, username, last_update) values ('" +  str(row[1]) + "', '"  + str(row[2]) + "', '" + str(row[3]) + "', '" + str(row[5]) + "', '" + str(row[6])  + "', '" + str(row[7]) + "', '" + str(row[8]) +  "', TO_DATE('" + str(row[10]) + "', 'yyyy/mm/dd hh24:mi:ss'))")
    #aux = bytes(row[4])
    #aux = binascii.b2a_qp(aux, quotetabs=False, istext=True, header=False)
    #print(row[3])
    #mycursor_oracle.execute("insert into staff(first_name, last_name, address_id, picture, email, store_id, active, username, password, last_uodate) values ('" +  str(row[1]) + "', '"  + str(row[2]) + "', '" + str(row[3]) + "', hextoraw('" + (row[4]) + "'), '" + str(row[5]) + "', '" + str(row[6])  + "', '" + str(row[7]) + "', '" + str(row[8]) + "', hextoraw('" + (row[9]) + "'), TO_DATE('" + str(row[10]) + "', 'yyyy/mm/dd hh24:mi:ss'))")




















# # CUSTOMER
# mycursor_mysql.execute(
#                 "select * from customer"
#             )

# customer_data = mycursor_mysql.fetchall()


# # STORE
# mycursor_mysql.execute(
#                 "select * from store"
#             )

# store_data = mycursor_mysql.fetchall()


# # PAYMENT
# mycursor_mysql.execute(
#                 "select * from payment"
#             )

# payment_data = mycursor_mysql.fetchall()


# # RENTAL
# mycursor_mysql.execute(
#                 "select * from rental"
#             )

# rental_data = mycursor_mysql.fetchall()


# # FILM
# mycursor_mysql.execute(
#                 "select * from film"
#             )

# film_data = mycursor_mysql.fetchall()

# # FILM_CATEGORY
# mycursor_mysql.execute(
#                 "select * from film_category"
#             )

# film_category_data = mycursor_mysql.fetchall()

# # LANGUAGE
# mycursor_mysql.execute(
#                 "select * from language"
#             )

# language_data = mycursor_mysql.fetchall()

# # FILM_ACTOR
# mycursor_mysql.execute(
#                 "select * from film_actor"
#             )

# film_actor_data = mycursor_mysql.fetchall()

# # INVENTORY
# mycursor_mysql.execute(
#                 "select * from inventory"
#             )

# inventory_data = mycursor_mysql.fetchall()

# # FILM_TEXT
# mycursor_mysql.execute(
#                 "select * from film_text"
#             )

# film_text_data = mycursor_mysql.fetchall()







# FECHO DE CONECÇÃO BDS

connectionOracle.commit()

mycursor_oracle.close()
connectionOracle.close()

mycursor_mysql.close()
connectionMySQL.close()