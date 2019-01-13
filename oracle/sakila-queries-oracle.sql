-- QUERY 1 - top 5 dos clientes que mais alugueres efetuaram (por aluguer, não por filme)

SELECT 
	c.customer_id AS ID,
	(c.first_name || ' ' || c.last_name) AS nome,
	COUNT(r.rental_id) AS num_alugueres
FROM customer c
INNER JOIN rental r ON (r.customer_id=c.customer_id)
GROUP BY c.customer_id, (c.first_name || ' ' || c.last_name)
ORDER BY num_alugueres DESC;