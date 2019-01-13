-- COMANDOS PARA REMOVER AS TABELAS PARA TESTES
drop table customer;
ALTER TABLE staff
DROP CONSTRAINT store_FK;
drop table store;
drop table staff;
drop table actor;
drop table address;
drop table category;
drop table city;
drop table country;


-- NOTAS: 
--
-- verfificar se precisamos de fazer alguma coisa para o caso do ON DELETE RESTRICT
-- (supostamente esta sintax representa o que já é o comportamento normal de uma
-- chave estrangeira, que é não poder eliminar o pai se existirem filhos)
--
-- perguntar se vale a pena implementar o ON UPDATE CASCADE porque na verdade as
-- chaves primárias não devem ser alteradas


CREATE TABLE actor (
  actor_id SMALLINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT actor_PK PRIMARY KEY (actor_id));
CREATE INDEX actor_last_name_IDX ON actor (last_name);
CREATE OR REPLACE TRIGGER actor_timestamp_trigger
    BEFORE UPDATE ON actor
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE category (
  category_id SMALLINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  name VARCHAR(25) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT category_PK PRIMARY KEY (category_id));
CREATE OR REPLACE TRIGGER category_timestamp_trigger
    BEFORE UPDATE ON category
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE country (
  country_id SMALLINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  country VARCHAR(50) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT country_PK PRIMARY KEY (country_id));
CREATE OR REPLACE TRIGGER country_timestamp_trigger
    BEFORE UPDATE ON country
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE city (
  city_id SMALLINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  city VARCHAR(50) NOT NULL,
  country_id SMALLINT NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT city_PK PRIMARY KEY (city_id),
  CHECK(country_id > 0));
CREATE INDEX city_country_id_IDX ON city (country_id);
CREATE OR REPLACE TRIGGER city_timestamp_trigger
    BEFORE UPDATE ON city
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE address (
  address_id SMALLINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id SMALLINT NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT address_PK PRIMARY KEY (address_id),
  CHECK(city_id > 0));
CREATE INDEX address_city_id_IDX ON address (city_id);
CREATE OR REPLACE TRIGGER address_timestamp_trigger
    BEFORE UPDATE ON address
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE staff (
  staff_id SMALLINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id SMALLINT NOT NULL,
  picture BLOB DEFAULT NULL,
  email VARCHAR(50) DEFAULT NULL,
  store_id SMALLINT NOT NULL,
  active NUMBER(1,0) DEFAULT 1,
  username VARCHAR(16) NOT NULL,
  password BLOB DEFAULT NULL, -- O ORACLE NAO ACEITA VARCHAR BINARY... QUE ALTERNATIVAS HÁ??? ************* TESTAR CLOB NA MAQ VIRTUAL ******************
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT staff_PK PRIMARY KEY (staff_id),
  CHECK(staff_id > 0), 
  CHECK(address_id > 0),
  CHECK(store_id > 0));
CREATE INDEX staff_store_id_IDX ON staff (store_id);
CREATE INDEX staff_address_id_IDX ON staff (address_id);
CREATE OR REPLACE TRIGGER staff_timestamp_trigger
    BEFORE UPDATE ON staff
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE store (
  store_id SMALLINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  manager_staff_id SMALLINT NOT NULL,
  address_id SMALLINT NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT store_PK PRIMARY KEY (store_id),
  CHECK(store_id > 0),
  CHECK(manager_staff_id > 0),
  CHECK(address_id > 0));
CREATE INDEX store_manager_staff_id_IDX ON store (manager_staff_id);
CREATE INDEX store_address_id_IDX ON store (address_id);
CREATE OR REPLACE TRIGGER store_timestamp_trigger
    BEFORE UPDATE ON store
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE customer (
  customer_id SMALLINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  store_id SMALLINT NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id SMALLINT NOT NULL,
  active NUMBER(1,0) DEFAULT 1,
  create_date DATE NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT customer_PK PRIMARY KEY (customer_id),
  CHECK(address_id > 0),
  CHECK(store_id > 0));
CREATE INDEX customer_store_id_IDX ON customer (store_id);
CREATE INDEX customer_last_name_IDX ON customer (last_name);
CREATE INDEX customer_address_id_IDX ON customer (address_id);
CREATE OR REPLACE TRIGGER customer_timestamp_trigger
    BEFORE UPDATE ON customer
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE film (
  film_id NUMBER(5,0) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  title VARCHAR(255) NOT NULL,
  description CLOB DEFAULT NULL,
  release_year NUMBER DEFAULT NULL,
  language_id NUMBER(5,0) NOT NULL,
  original_language_id NUMBER(5,0) DEFAULT NULL,
  rental_duration NUMBER(5,0) DEFAULT 3 NOT NULL,
  rental_rate DECIMAL(4,2) DEFAULT 4.99 NOT NULL,
  length NUMBER(5,0) DEFAULT NULL,
  replacement_cost DECIMAL(5,2) DEFAULT 19.99 NOT NULL,
  rating VARCHAR(10) DEFAULT 'G',
  special_features VARCHAR(64) DEFAULT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT film_PK PRIMARY KEY  (film_id),
  CHECK(rating IN ('G','PG','PG-13','R','NC-17')),
  CHECK(language_id > 0),
  CHECK(original_language_id > 0),
  CHECK(rental_duration > 0),
  CHECK(length > 0));
CREATE INDEX film_title_IDX ON film (title);
CREATE INDEX film_language_id_IDX ON film (language_id);
CREATE INDEX film_original_language_id_IDX ON film (original_language_id);
CREATE OR REPLACE TRIGGER film_timestamp_trigger
    BEFORE UPDATE ON film
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE film_actor (
  actor_id SMALLINT NOT NULL,
  film_id SMALLINT NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT film_actor_PK PRIMARY KEY (actor_id,film_id),
  CHECK(actor_id > 0),
  CHECK(film_id > 0));
CREATE INDEX film_actor_film_id_IDX ON film_actor (film_id);
CREATE OR REPLACE TRIGGER film_actor_timestamp_trigger
    BEFORE UPDATE ON film_actor
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE film_category (
  film_id SMALLINT NOT NULL,
  category_id SMALLINT NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT film_category_PK PRIMARY KEY (film_id,category_id),
  CHECK(film_id > 0),
  CHECK(category_id > 0));
CREATE OR REPLACE TRIGGER film_category_timestamp_trigger
    BEFORE UPDATE ON film_category
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE film_text (
  film_id SMALLINT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description CLOB,
  CONSTRAINT film_text_PK PRIMARY KEY (film_id));

CREATE TABLE inventory (
  inventory_id NUMBER(7,0) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  film_id NUMBER(5,0) NOT NULL,
  store_id NUMBER(3,0) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT inventory_PK PRIMARY KEY (inventory_id),
  CHECK(inventory_id>0),
  CHECK(film_id>0),
  CHECK(store_id>0));
CREATE INDEX inventory_film_id_IDX ON inventory (film_id);
CREATE INDEX inventory_store_film_id_IDX ON inventory (store_id,film_id);
CREATE OR REPLACE TRIGGER inventory_timestamp_trigger
    BEFORE UPDATE ON inventory
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE language (
  language_id NUMBER(5,0) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  name CHAR(20) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT language_PK PRIMARY KEY (language_id),
  CHECK(language_id>0));
CREATE OR REPLACE TRIGGER language_timestamp_trigger
    BEFORE UPDATE ON language
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE payment (
  payment_id NUMBER(5,0) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  customer_id NUMBER(5,0) NOT NULL,
  staff_id NUMBER(3,0) NOT NULL,
  rental_id NUMBER(10,0) DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATE NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT payment_PK PRIMARY KEY (payment_id),
  CHECK(customer_id>0),
  CHECK(staff_id>0));
CREATE INDEX payment_staff_id_IDX ON payment (staff_id);
CREATE INDEX payment_customer_id_IDX ON payment (customer_id);
CREATE OR REPLACE TRIGGER payment_timestamp_trigger
    BEFORE UPDATE ON payment
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/

CREATE TABLE rental (
  rental_id NUMBER(10,0) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
  rental_date DATE NOT NULL,
  inventory_id NUMBER(7,0) NOT NULL,
  customer_id NUMBER(5,0) NOT NULL,
  return_date DATE DEFAULT NULL,
  staff_id NUMBER(3,0) NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT rental_PK PRIMARY KEY (rental_id),
  CHECK(inventory_id>0),
  CHECK(customer_id>0),
  CHECK(staff_id>0));
CREATE INDEX rental_date_inventory_customer_IDX ON rental (rental_date,inventory_id,customer_id);
CREATE INDEX rental_inventory_id_IDX ON rental (inventory_id);
CREATE INDEX rental_customer_id_IDX ON rental (customer_id);
CREATE INDEX rental_staff_id_IDX ON rental (staff_id);
CREATE OR REPLACE TRIGGER rental_timestamp_trigger
    BEFORE UPDATE ON rental
    FOR EACH ROW
    BEGIN
        :new.last_update := current_timestamp;
    END;
/


-- END OF TABLE CREATION














































-- ------------------------------------------------------------------------------------

--
-- Triggers for loading film_text from film
--

DELIMITER ;;
CREATE TRIGGER `ins_film` AFTER INSERT ON `film` FOR EACH ROW BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END;;

CREATE TRIGGER `upd_film` AFTER UPDATE ON `film` FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END;;

CREATE TRIGGER `del_film` AFTER DELETE ON `film` FOR EACH ROW BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END;;
DELIMITER ;

--
-- View structure for view `customer_list`
--

CREATE VIEW customer_list AS
	SELECT
		cu.customer_id AS ID,
		CONCAT(cu.first_name, _utf8' ', cu.last_name) AS name,
		a.address AS address,
		a.postal_code AS `zip code`,
		a.phone AS phone,
		city.city AS city,
		country.country AS country,
		IF(cu.active, _utf8'active',_utf8'') AS notes,
		cu.store_id AS SID
	FROM customer AS cu
		JOIN address AS a ON cu.address_id = a.address_id
		JOIN city ON a.city_id = city.city_id
		JOIN country ON city.country_id = country.country_id;

--
-- View structure for view `film_list`
--

CREATE VIEW film_list AS
	SELECT
		film.film_id AS FID,
		film.title AS title,
		film.description AS description,
		category.name AS category,
		film.rental_rate AS price,
		film.length AS length,
		film.rating AS rating,
		GROUP_CONCAT(CONCAT(actor.first_name, _utf8' ', actor.last_name) SEPARATOR ', ') AS actors
	FROM category
		LEFT JOIN film_category ON category.category_id = film_category.category_id
		LEFT JOIN film ON film_category.film_id = film.film_id
        JOIN film_actor ON film.film_id = film_actor.film_id
		JOIN actor ON film_actor.actor_id = actor.actor_id
	GROUP BY film.film_id, category.name;

--
-- View structure for view `nicer_but_slower_film_list`
--

CREATE VIEW nicer_but_slower_film_list AS
	SELECT
		film.film_id AS FID,
	   	film.title AS title,
	   	film.description AS description,
	   	category.name AS category,
	   	film.rental_rate AS price,
	   	film.length AS length,
	   	film.rating AS rating,
       	GROUP_CONCAT(CONCAT(CONCAT(UCASE(SUBSTR(actor.first_name,1,1)),
	   		LCASE(SUBSTR(actor.first_name,2,LENGTH(actor.first_name))),_utf8' ',
	   		CONCAT(UCASE(SUBSTR(actor.last_name,1,1)),
	   		LCASE(SUBSTR(actor.last_name,2,LENGTH(actor.last_name)))))) SEPARATOR ', ') AS actors
	FROM category
		LEFT JOIN film_category ON category.category_id = film_category.category_id
		LEFT JOIN film ON film_category.film_id = film.film_id
        JOIN film_actor ON film.film_id = film_actor.film_id
		JOIN actor ON film_actor.actor_id = actor.actor_id
	GROUP BY film.film_id, category.name;

--
-- View structure for view `staff_list`
--

CREATE VIEW staff_list AS
	SELECT
		s.staff_id AS ID,
		CONCAT(s.first_name, _utf8' ', s.last_name) AS name,
		a.address AS address,
		a.postal_code AS `zip code`,
		a.phone AS phone,
		city.city AS city,
		country.country AS country,
		s.store_id AS SID
	FROM staff AS s 
	JOIN address AS a ON s.address_id = a.address_id
	JOIN city ON a.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id;

--
-- View structure for view `sales_by_store`
--

CREATE VIEW sales_by_store AS
	SELECT
		CONCAT(c.city, _utf8',', cy.country) AS store,
		CONCAT(m.first_name, _utf8' ', m.last_name) AS manager,
		SUM(p.amount) AS total_sales
	FROM payment AS p
	INNER JOIN rental AS r ON p.rental_id = r.rental_id
	INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
	INNER JOIN store AS s ON i.store_id = s.store_id
	INNER JOIN address AS a ON s.address_id = a.address_id
	INNER JOIN city AS c ON a.city_id = c.city_id
	INNER JOIN country AS cy ON c.country_id = cy.country_id
	INNER JOIN staff AS m ON s.manager_staff_id = m.staff_id
	GROUP BY s.store_id
	ORDER BY cy.country, c.city;

--
-- View structure for view `sales_by_film_category`
--
-- Note that total sales will add up to >100% because
-- some titles belong to more than 1 category
--

CREATE VIEW sales_by_film_category AS
	SELECT
		c.name AS category,
		SUM(p.amount) AS total_sales
	FROM payment AS p
	INNER JOIN rental AS r ON p.rental_id = r.rental_id
	INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
	INNER JOIN film AS f ON i.film_id = f.film_id
	INNER JOIN film_category AS fc ON f.film_id = fc.film_id
	INNER JOIN category AS c ON fc.category_id = c.category_id
	GROUP BY c.name
	ORDER BY total_sales DESC;

--
-- View structure for view `actor_info`
--

CREATE DEFINER=CURRENT_USER SQL SECURITY INVOKER VIEW actor_info
AS
SELECT
a.actor_id,
a.first_name,
a.last_name,
GROUP_CONCAT(DISTINCT CONCAT(c.name, ': ',
		(SELECT GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ')
                    FROM sakila.film f
                    INNER JOIN sakila.film_category fc
                      ON f.film_id = fc.film_id
                    INNER JOIN sakila.film_actor fa
                      ON f.film_id = fa.film_id
                    WHERE fc.category_id = c.category_id
                    AND fa.actor_id = a.actor_id
                 )
             )
             ORDER BY c.name SEPARATOR '; ')
AS film_info
FROM sakila.actor a
LEFT JOIN sakila.film_actor fa
  ON a.actor_id = fa.actor_id
LEFT JOIN sakila.film_category fc
  ON fa.film_id = fc.film_id
LEFT JOIN sakila.category c
  ON fc.category_id = c.category_id
GROUP BY a.actor_id, a.first_name, a.last_name;

--
-- Procedure structure for procedure `rewards_report`
--

DELIMITER //

CREATE PROCEDURE rewards_report (
    IN min_monthly_purchases TINYINT UNSIGNED
    , IN min_dollar_amount_purchased DECIMAL(10,2) UNSIGNED
    , OUT count_rewardees INT
)
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
COMMENT 'Provides a customizable report on best customers'
proc: BEGIN

    DECLARE last_month_start DATE;
    DECLARE last_month_end DATE;

    /* Some sanity checks... */
    IF min_monthly_purchases = 0 THEN
        SELECT 'Minimum monthly purchases parameter must be > 0';
        LEAVE proc;
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        SELECT 'Minimum monthly dollar amount purchased parameter must be > $0.00';
        LEAVE proc;
    END IF;

    /* Determine start and end time periods */
    SET last_month_start = DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH);
    SET last_month_start = STR_TO_DATE(CONCAT(YEAR(last_month_start),'-',MONTH(last_month_start),'-01'),'%Y-%m-%d');
    SET last_month_end = LAST_DAY(last_month_start);

    /*
        Create a temporary storage area for
        Customer IDs.
    */
    CREATE TEMPORARY TABLE tmpCustomer (customer_id SMALLINT UNSIGNED NOT NULL PRIMARY KEY);

    /*
        Find all customers meeting the
        monthly purchase requirements
    */
    INSERT INTO tmpCustomer (customer_id)
    SELECT p.customer_id
    FROM payment AS p
    WHERE DATE(p.payment_date) BETWEEN last_month_start AND last_month_end
    GROUP BY customer_id
    HAVING SUM(p.amount) > min_dollar_amount_purchased
    AND COUNT(customer_id) > min_monthly_purchases;

    /* Populate OUT parameter with count of found customers */
    SELECT COUNT(*) FROM tmpCustomer INTO count_rewardees;

    /*
        Output ALL customer information of matching rewardees.
        Customize output as needed.
    */
    SELECT c.*
    FROM tmpCustomer AS t
    INNER JOIN customer AS c ON t.customer_id = c.customer_id;

    /* Clean up */
    DROP TABLE tmpCustomer;
END //

DELIMITER ;

DELIMITER $$

CREATE FUNCTION get_customer_balance(p_customer_id INT, p_effective_date DATETIME) RETURNS DECIMAL(5,2)
    DETERMINISTIC
    READS SQL DATA
BEGIN

       #OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       #THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       #   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       #   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       #   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       #   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED

  DECLARE v_rentfees DECIMAL(5,2); #FEES PAID TO RENT THE VIDEOS INITIALLY
  DECLARE v_overfees INTEGER;      #LATE FEES FOR PRIOR RENTALS
  DECLARE v_payments DECIMAL(5,2); #SUM OF PAYMENTS MADE PREVIOUSLY

  SELECT IFNULL(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

  SELECT IFNULL(SUM(IF((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) > film.rental_duration,
        ((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) - film.rental_duration),0)),0) INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;


  SELECT IFNULL(SUM(payment.amount),0) INTO v_payments
    FROM payment

    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

  RETURN v_rentfees + v_overfees - v_payments;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE film_in_stock(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT FOUND_ROWS() INTO p_film_count;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE film_not_in_stock(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id);

     SELECT FOUND_ROWS() INTO p_film_count;
END $$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION inventory_held_by_customer(p_inventory_id INT) RETURNS INT
READS SQL DATA
BEGIN
  DECLARE v_customer_id INT;
  DECLARE EXIT HANDLER FOR NOT FOUND RETURN NULL;

  SELECT customer_id INTO v_customer_id
  FROM rental
  WHERE return_date IS NULL
  AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END $$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION inventory_in_stock(p_inventory_id INT) RETURNS NUMBER(1,0)
READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    #AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    #FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END $$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


