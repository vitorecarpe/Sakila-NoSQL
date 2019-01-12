
ALTER TABLE city
ADD CONSTRAINT city_country_FK FOREIGN KEY (country_id) REFERENCES country(country_id); -- ON DELETE RESTRICT ON UPDATE CASCADE, isto tbm precisa de trigger...

ALTER TABLE address
ADD CONSTRAINT address_city_FK FOREIGN KEY (city_id) REFERENCES city(city_id); -- ON DELETE RESTRICT ON UPDATE CASCADE, isto tbm precisa de trigger...

ALTER TABLE staff
ADD CONSTRAINT staff_address_FK FOREIGN KEY (address_id) REFERENCES address (address_id), -- ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT staff_store_FK FOREIGN KEY (store_id) REFERENCES store (store_id); -- ON DELETE RESTRICT ON UPDATE CASCADE,

ALTER TABLE store
ADD CONSTRAINT store_staff_FK FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id), -- ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT store_address_FK FOREIGN KEY (address_id) REFERENCES address (address_id); -- ON DELETE RESTRICT ON UPDATE CASCADE,

ALTER TABLE customer
ADD CONSTRAINT customer_address_FK FOREIGN KEY (address_id) REFERENCES address (address_id), -- ON DELETE RESTRICT ON UPDATE CASCADE, isto tbm precisa de trigger...
    CONSTRAINT customer_store_FK FOREIGN KEY (store_id) REFERENCES store (store_id); -- ON DELETE RESTRICT ON UPDATE CASCADE, isto tbm precisa de trigger...

ALTER TABLE film
ADD CONSTRAINT film_language_FK FOREIGN KEY (language_id) REFERENCES language (language_id), -- ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT film_original_language_id FOREIGN KEY (original_language_id) REFERENCES language (language_id); -- ON DELETE RESTRICT ON UPDATE CASCADE

ALTER TABLE film_actor
ADD CONSTRAINT film_actor_actor_FK FOREIGN KEY (actor_id) REFERENCES actor (actor_id), --ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT film_actor_film_FK FOREIGN KEY (film_id) REFERENCES film (film_id); --ON DELETE RESTRICT ON UPDATE CASCADE,

ALTER TABLE film_category
ADD CONSTRAINT film_category_film_FK FOREIGN KEY (film_id) REFERENCES film (film_id), --ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT film_category_category_FK FOREIGN KEY (category_id) REFERENCES category (category_id); --ON DELETE RESTRICT ON UPDATE CASCADE,

ALTER TABLE inventory
ADD CONSTRAINT inventory_store_FK FOREIGN KEY (store_id) REFERENCES store (store_id), --ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT inventory_film_FK FOREIGN KEY (film_id) REFERENCES film (film_id), --ON DELETE RESTRICT ON UPDATE CASCADE,

ALTER TABLE payment
ADD CONSTRAINT payment_rental_FK FOREIGN KEY (rental_id) REFERENCES rental (rental_id), --ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT payment_customer_FK FOREIGN KEY (customer_id) REFERENCES customer (customer_id), --ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT payment_staff_FK FOREIGN KEY (staff_id) REFERENCES staff (staff_id), --ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE rental
ADD CONSTRAINT rental_staff_FK FOREIGN KEY (staff_id) REFERENCES staff (staff_id), --ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT rental_inventory_FK FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id), --ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT rental_customer_FK FOREIGN KEY (customer_id) REFERENCES customer (customer_id), --ON DELETE RESTRICT ON UPDATE CASCADE

    