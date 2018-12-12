import mysql.connector
import cx_Oracle

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

mycursor_oracle.execute('select * from test')
data = mycursor_oracle.fetchall()

for x in data:
    print(x)


# mycursor_oracle.execute('select * from departments order by department_id')
# for result in cur:
#     print(result)

mycursor_mysql = connectionMySQL.cursor()

# CITY
mycursor_mysql.execute(
                "select * from city"
            )

city_data = mycursor_mysql.fetchall()


# COUNTRY
mycursor_mysql.execute(
                "select * from country"
            )

country_data = mycursor_mysql.fetchall()


# CUSTOMER
mycursor_mysql.execute(
                "select * from customer"
            )

customer_data = mycursor_mysql.fetchall()


# ADDRESS
mycursor_mysql.execute(
                "select * from address"
            )

address_data = mycursor_mysql.fetchall()


# STAFF
mycursor_mysql.execute(
                "select * from staff"
            )

staff_data = mycursor_mysql.fetchall()


# STORE
mycursor_mysql.execute(
                "select * from store"
            )

store_data = mycursor_mysql.fetchall()


# PAYMENT
mycursor_mysql.execute(
                "select * from payment"
            )

payment_data = mycursor_mysql.fetchall()


# RENTAL
mycursor_mysql.execute(
                "select * from rental"
            )

rental_data = mycursor_mysql.fetchall()


# FILM
mycursor_mysql.execute(
                "select * from film"
            )

film_data = mycursor_mysql.fetchall()

# FILM_CATEGORY
mycursor_mysql.execute(
                "select * from film_category"
            )

film_category_data = mycursor_mysql.fetchall()

# CATEGORY
mycursor_mysql.execute(
                "select * from category"
            )

category_data = mycursor_mysql.fetchall()

# LANGUAGE
mycursor_mysql.execute(
                "select * from language"
            )

language_data = mycursor_mysql.fetchall()

# ACTOR
mycursor_mysql.execute(
                "select * from actor"
            )

actor_data = mycursor_mysql.fetchall()

# FILM_ACTOR
mycursor_mysql.execute(
                "select * from film_actor"
            )

film_actor_data = mycursor_mysql.fetchall()

# INVENTORY
mycursor_mysql.execute(
                "select * from inventory"
            )

inventory_data = mycursor_mysql.fetchall()

# FILM_TEXT
mycursor_mysql.execute(
                "select * from film_text"
            )

film_text_data = mycursor_mysql.fetchall()

# TRIGGERS

  #              "CREATE TRIGGER rental_date BEFORE INSERT ON rental FOR EACH ROW SET NEW.rental_date =CURRENT_TIMESTAMP()"







# FECHO DE CONECÇÃO BDS

mycursor_oracle.close()
connectionOracle.close()

mycursor_mysql.close()
connectionMySQL.close()