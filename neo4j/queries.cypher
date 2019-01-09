//Top 5 dos clientes mais filmes alugaram

match (c:Customer)<-[:RENTED_BY]-(r:Rental)
return c, count(r)
order by count(r) desc
limit 5;

//Top 5 dos clientes que mais filmes unicos alugaram
match (c:Customer)<-[:RENTED_BY]-(r:Rental)-[:RENTED_FILM]->(f:Film)
return c, count(distinct f)
order by count(distinct f) desc
limit 5;

//Top 5 dos clientes que gastaram mais dinheiro
match (c:Customer)<-[:PAYED_BY]-(p:Payment)
return c, sum(p.amount)
order by sum(p.amount) desc
limit 5

//Top 5 filmes mais alugados
match (f:Film)<-[a:RENTED_FILM]-(r:Rental)
return f, count(a)
order by count(a) desc
limit 5

//Top 5 funcionarios dinheiro aluguer
match (s:Staff)<-[:MADE_BY]-(p:Payment)
return s, sum(p.amount)
order by sum(p.amount) desc
limit 5

//Clientes mais demorados a devolver POR ACABAR
match (c:Customer)<-[:RENTED_BY]-(r:Rental)
where exists(r.return_date)
with c, avg(duration.between(datetime(r.rental_date), datetime(r.return_date))) as avg_dur
return c, avg_dur
order by avg_dur desc
limit 5

//Top 5 das lojas com maior número de alugueres(pagamentos) lá efetuados
match (s:Store)<-[:WORKS_AT]-(c:Staff)<-[:MADE_BY]-(p:Payment)
return s,count(p)
order by count(p)
limit 5

