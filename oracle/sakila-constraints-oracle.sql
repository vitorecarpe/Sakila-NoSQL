
ALTER TABLE city
ADD CONSTRAINT city_country_FK FOREIGN KEY (country_id) REFERENCES country(country_id);

ALTER TABLE address
ADD CONSTRAINT address_city_FK FOREIGN KEY (city_id) REFERENCES city(city_id);

ALTER TABLE staff
ADD CONSTRAINT staff_address_FK FOREIGN KEY (address_id) REFERENCES address (address_id);
ALTER TABLE staff
ADD CONSTRAINT staff_store_FK FOREIGN KEY (store_id) REFERENCES store (store_id);

ALTER TABLE store
ADD CONSTRAINT store_staff_FK FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id);
ALTER TABLE store
ADD CONSTRAINT store_address_FK FOREIGN KEY (address_id) REFERENCES address (address_id);

ALTER TABLE customer
ADD CONSTRAINT customer_address_FK FOREIGN KEY (address_id) REFERENCES address (address_id);
ALTER TABLE customer
ADD CONSTRAINT customer_store_FK FOREIGN KEY (store_id) REFERENCES store (store_id);

ALTER TABLE film
ADD CONSTRAINT film_language_FK FOREIGN KEY (language_id) REFERENCES language (language_id);
ALTER TABLE film
ADD CONSTRAINT film_original_language_id FOREIGN KEY (original_language_id) REFERENCES language (language_id);

ALTER TABLE film_actor
ADD CONSTRAINT film_actor_actor_FK FOREIGN KEY (actor_id) REFERENCES actor (actor_id);
ALTER TABLE film_actor
ADD CONSTRAINT film_actor_film_FK FOREIGN KEY (film_id) REFERENCES film (film_id);

ALTER TABLE film_category
ADD CONSTRAINT film_category_film_FK FOREIGN KEY (film_id) REFERENCES film (film_id);
ALTER TABLE film_category
ADD CONSTRAINT film_category_category_FK FOREIGN KEY (category_id) REFERENCES category (category_id);

ALTER TABLE inventory
ADD CONSTRAINT inventory_store_FK FOREIGN KEY (store_id) REFERENCES store (store_id);
ALTER TABLE inventory
ADD CONSTRAINT inventory_film_FK FOREIGN KEY (film_id) REFERENCES film (film_id);

ALTER TABLE payment
ADD CONSTRAINT payment_rental_FK FOREIGN KEY (rental_id) REFERENCES rental (rental_id);
ALTER TABLE payment
ADD CONSTRAINT payment_customer_FK FOREIGN KEY (customer_id) REFERENCES customer (customer_id);
ALTER TABLE payment
ADD CONSTRAINT payment_staff_FK FOREIGN KEY (staff_id) REFERENCES staff (staff_id);

ALTER TABLE rental
ADD CONSTRAINT rental_staff_FK FOREIGN KEY (staff_id) REFERENCES staff (staff_id);
ALTER TABLE rental
ADD CONSTRAINT rental_inventory_FK FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id);
ALTER TABLE rental
ADD CONSTRAINT rental_customer_FK FOREIGN KEY (customer_id) REFERENCES customer (customer_id);