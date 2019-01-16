-- QUERY 1 - Top 10 dos clientes que mais alugueres efetuaram (por aluguer, não por filme)

SELECT 
	c.customer_id AS ID,
	(c.first_name || ' ' || c.last_name) AS nome,
	COUNT(r.rental_id) AS num_alugueres
FROM customer c
INNER JOIN rental r ON (r.customer_id=c.customer_id)
WHERE c.active=1
GROUP BY c.customer_id, (c.first_name || ' ' || c.last_name)
ORDER BY num_alugueres DESC
FETCH FIRST 10 ROWS ONLY;

-- QUERY 2 - Top 10 dos clientes que mais filmes distintos alugaram (vários alugueres do mesmo filme conta apenas como 1)

SELECT
	c.customer_id AS ID,
	(c.first_name || ' ' || c.last_name) AS nome,
	COUNT(i.film_id) AS num_filmes
FROM customer c
INNER JOIN rental r ON (r.customer_id=c.customer_id)
INNER JOIN inventory i ON (i.inventory_id=r.inventory_id)
WHERE c.active=1
GROUP BY c.customer_id, (c.first_name || ' ' || c.last_name)
ORDER BY num_filmes DESC
FETCH FIRST 10 ROWS ONLY;

-- QUERY 3 - Top 10 dos clientes que mais dinheiro gastaram (soma de todos os pagamentos)

SELECT
	c.customer_id AS ID,
	(c.first_name || ' ' || c.last_name) AS nome,
	SUM(p.amount) AS gastos
FROM customer c
INNER JOIN rental r ON (r.customer_id=c.customer_id)
INNER JOIN payment p ON (p.rental_id=r.rental_id)
WHERE c.active=1
GROUP BY c.customer_id, (c.first_name || ' ' || c.last_name)
ORDER BY gastos DESC
FETCH FIRST 10 ROWS ONLY;

-- QUERY 4 - Top 10 dos filmes mais alugados

SELECT
	f.film_id AS ID,
	(f.title || ' (' || f.release_year || ')') AS filme,
	COUNT(r.rental_id) AS num_alugueres
FROM film f
INNER JOIN inventory i ON (i.film_id=f.film_id)
INNER JOIN rental r ON (r.inventory_id=i.inventory_id)
GROUP BY f.film_id, (f.title || ' (' || f.release_year || ')')
ORDER BY num_alugueres DESC
FETCH FIRST 10 ROWS ONLY;

-- QUERY 5 - Top 10 dos membros do staff que processaram o maior volume de pagamentos (soma do valor de todos os payments processados por esse funcionário)

SELECT
	s.staff_id AS ID,
	(s.first_name || ' ' || s.last_name) AS nome,
	SUM(p.amount) as volume
FROM staff s
INNER JOIN payment p ON (p.staff_id=s.staff_id)
GROUP BY s.staff_id, (s.first_name || ' ' || s.last_name)
ORDER BY volume DESC
FETCH FIRST 10 ROWS ONLY;

-- QUERY 6 - Top 10 dos clientes que mais tempo demoram a devolver os filmes (média)

SELECT 
	c.customer_id AS ID,
	(c.first_name || ' ' || c.last_name) AS nome,
	AVG(r.return_date-r.rental_date) AS demora (dias)
FROM customer c
INNER JOIN rental r ON (r.customer_id=c.customer_id)
WHERE r.return_date IS NOT NULL
  AND c.active=1
GROUP BY c.customer_id, (c.first_name || ' ' || c.last_name)
ORDER BY demora DESC
FETCH FIRST 10 ROWS ONLY;

-- QUERY 7 - Top 10 das lojas com maior número de alugueres lá efetuados

SELECT
	s.store_id AS ID,
	COUNT(r.rental_id) as alugueres
FROM store s
INNER JOIN staff sf ON (sf.store_id=s.store_id)
INNER JOIN rental r ON (r.staff_id=sf.staff_id)
GROUP BY s.store_id
ORDER BY alugueres DESC
FETCH FIRST 10 ROWS ONLY;
