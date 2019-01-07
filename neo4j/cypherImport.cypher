//Loading countries
load csv from "file:///country.csv" as line 
create (m :Country {country : line[1]})

create index on :Country(country)

//Loading cities and relating them to countries
load csv from "file:///city.csv" as line
match (co : Country)
where co.country = line[1]
create 	(c : City {city: line[0]}),
		(c)-[r:BELONGS_TO]->(co)

create index on :City(city)

//Had to be careful because there are cities with the same names in differente countries. The "using periodic commit 100" is required because using match while loading a csv might be to intensive.
using periodic commit 100
load csv from "file:///address.csv" as line
match (ci : City {city : line[3]})-[:BELONGS_TO]->(co : Country {country : line[6]})
create	(ad : Address {	address : line[0],
						address2 : line[1],
                        district : line[2], 
                        postal_code : line[4], 
                        phone : line[5]}),
		(ad)-[r:BELONGS_TO]->(ci)

create index on :Address(address)


//There shouldn't be addresses with the same name in the same city, therefore matching only address and city shouldn't be a problem
load csv from "file:///staff.csv" as line
match (ad :Address {address : line[2]})-[:BELONGS_TO]->(ci :City {city : line[3]})
create(	c : Staff  {first_name: line[0],
					last_name: line[1],
                    email : line[4],
                    active : line[5],
                    username : line[6],
                    password : line[7]}),
		(c)-[:LIVES_IN]->(ad)

create index on :Staff(username)

//Adds stores. Stores must have the ID from original sakila because it would be to complicated to identify them withou them
load csv from "file:///stores.csv" as line
match	(ad:Address {address:line[0]})-[:BELONGS_TO]->(ci :City{city:line[1]})
match	(st :Staff{username:line[2]})
create	(ad)<-[:LOCATED_AT]-(:Store {store_id : line[3]})-[:MANAGED_BY]->(st)

create index on :Store(store_id)

//Creates the WORKING_AT relationships between staff and store
load csv from "file:///staff.csv" as line
match (staff : Staff {username : line[6]})
match (store : Store {store_id : line[8]})
create (staff)-[:WORKS_AT]->(store)

//Adds the customers
load csv from "file:///customers.csv" as line
match (a: Address {address: line[6]})-[:BELONGS_TO]->(c: City {city: line[7]})
match (s:Store{store_id: line[5]})
create (a)<-[:LIVES_IN]-(:Customer {first_name: line[0], last_name: line[1], email: line[2], active: line[3], create_date: line[4]})-[:MEMBER_AT]->(s)

//converts dates from string to datetime
match(r:Customer)
set r.create_date = replace(r.create_date," ","T")
return r

//Creates the categories
load csv from "file:///categories.csv" as line
create (:Category{name:line[0]})

create index on :Category(name)

//Create actors
load csv from "file:///actors.csv" as line
create (:Actor{first_name: line[0], last_name: line[1], actor_id: line[2]})

create index on :Actor(actor_id)
create index on :Actor(first_name, last_name)

//Create languages
load csv from "file:///languages.csv" as line
create (:Language {name: line[0]})

create index on :Language(name)

//Create films
load csv from "file:///films.csv" as line
match (l:Language{name: line[9]})
create (:Film {title: line[0], description: line[1], release_year: line[2], rental_duration: line[3], rental_rate: line[4], length: line[5], replacement_cost: line[6], rating: line[7], special_features: line[8]})-[:LANGUAGE_IS]->(l)

create index on :Films(title)

//Create film->category
load csv from "file:///film_category.csv" as line
match (f: Film {title: line[0]})
match (c: Category {name: line[1]})
create (f)-[:IS_CATEGORY]->(c)

//Create film->actors and the delete actors property "actor-id"
load csv from "file:///film_actors.csv" as line
match (f:Film {title: line[0]})
match (a:Actor {actor_id: line[1]})
create (f)-[:ACTED_BY]->(a)

match (a:Actor)
remove a.actor_id

//Creates inventory. It's a relation between film and store, with a description of the film counting how many films there are
load csv from "file:///inventory.csv" as line
match (f : Film{title : line[0]})
match (s : Store{store_id : line[1]})
create (s)-[:HAS_FILM {how_many: line[3]}]->(f)

//Creates rentals. 
load csv from "file:///rental.csv" as line
match (staff: Staff {username: line[0]})
match (f:Film {title: line[1]})
match (store:Store {store_id: line[2]})
match (c:Customer {first_name: line[3], last_name: line[4]})
create (staff)<-[:MADE_BY]-(r:Rental {rental_date: line[5], return_date: line[6], rental_id: line[7]})-[:RENTED_FILM]->(f),(s)<-[:IN_STORE]-(r)-[:RENTED_BY]->(c)

//Converts the dates to datetime valid strings
match (m : Rental)
set m.rental_date = replace(m.rental_date, " ", "T")

match (m : Rental)
where m.return_date is not null
set m.return_date = replace(m.return_date, " ", "T")

create index on :Rental(rental_id)

//Creates payments 
load csv from "file:///payment.csv" as line
match (c:Customer {first_name: line[0], last_name: line[1]})
match (s:Staff {username: line[2]})
create (c)<-[:PAYED_BY]-(p:Payment{amount: toFloat(line[4]), payment_date: line[5], payment_id: line[6]})-[:MADE_BY]->(s)

//Converts the dates to datetime valid strings
match (m:Payment)
set m.payment_date = replace(m.payment_date, " ", "T")

create index on :Payment(payment_id)

//Creates the relation
load csv from "file:///rental-payment.csv" as line
match (p:Payment {payment_id: line[0]})
match (r:Rental {rental_id : line[1]})
create (p)-[:IS_RENT]->(r)


//Removes the unnecessary ID's
match (p:Payment)
remove p.payment_id

match (p:Rental)
remove p.rental_id
