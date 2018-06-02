#1) Se listen todos los clientes (customer) con su nombre y apellido, y sus direcciones, las direcciones deberan mostrar los campos "address" y "address", el nombre de la ciudad y el pais.
select cu.first_name, cu.last_name, ad.address, ci.city, co.country
from customer cu join address ad on cu.address_id = ad.address_id
				 join city ci on ad.city_id = ci.city_id
				 join country co on co.country_id = ci.country_id;
                 
#2) Mostrar el listado del punto 1 ordenado por ciudad y pais
select cu.first_name Nombre, cu.last_name Apellido, ad.address Address, ci.city City, co.country Country
from customer cu join address ad on cu.address_id = ad.address_id
				 join city ci on ad.city_id = ci.city_id
				 join country co on co.country_id = ci.country_id
order by Country, City                 

#3) Mostrar el listado del punto anterior agregando una columna con la cantidad de alquileres (rental) por cliente.
	select cu.first_name Nombre, cu.last_name Apellido, ad.address Address, ci.city City, co.country Country, count(re.customer_id) CantAlq
	from customer cu 
    join address ad 	on cu.address_id = ad.address_id
    join city ci 		on ad.city_id = ci.city_id
    join country co 	on co.country_id = ci.country_id
    join rental re 		on re.customer_id = cu.customer_id
    join payment pa 	on pa.rental_id = re.rental_id
	group by cu.customer_id	
    order by Country, City 
   
#4) Mostrar el listado del pto. anterior agregando una columna con el total de pagos hecho por cada cliente, (no tomar en cuenta el atributo "customer_id" de la tabla "payments")
	select cu.first_name Nombre, cu.last_name Apellido, ad.address Address, ci.city City, co.country Country, count(re.customer_id) CantAlq, sum(pa.amount) TotalPagos
	from customer cu 
    join address ad 	on cu.address_id = ad.address_id
    join city ci 		on ad.city_id = ci.city_id
    join country co 	on co.country_id = ci.country_id
    join rental re 		on re.customer_id = cu.customer_id
    join payment pa 	on pa.rental_id = re.rental_id
	group by cu.customer_id	
    order by Country, City 

#5) Mostrar el listado del punto anterior dejando solo aquellos registros que correspondan a alquileres realizados durante el mes de mayo.
	select cu.first_name Nombre, cu.last_name Apellido, ad.address Address, ci.city City, co.country Country, count(re.customer_id) CantAlq, sum(pa.amount) TotalPagos
	from customer cu 
    join address ad 	on cu.address_id = ad.address_id
    join city ci 		on ad.city_id = ci.city_id
    join country co 	on co.country_id = ci.country_id
    join rental re 		on re.customer_id = cu.customer_id
    join payment pa 	on pa.rental_id = re.rental_id
    where month(re.rental_date) = 5
	group by cu.customer_id	
    order by Country, City 

#6) Mostrar el listado del punto anterior mostrando solo los clientes de ese listado que gastaron mas de 10 pesos.
	select cu.first_name Nombre, cu.last_name Apellido, ad.address Address, ci.city City, co.country Country, count(re.customer_id) CantAlq, sum(pa.amount) TotalPagos
	from customer cu 
    join address ad 	on cu.address_id = ad.address_id
    join city ci 		on ad.city_id = ci.city_id
    join country co 	on co.country_id = ci.country_id
    join rental re 		on re.customer_id = cu.customer_id
    join payment pa 	on pa.rental_id = re.rental_id
    where month(re.rental_date) = 5	#and sum(pa.amount) > 10
    group by cu.customer_id	
    having TotalPagos > 10
    order by Country, City 

#7) Mostrar el listado del punto anterior mostrando solo los 10 clientes de ese listado que mas gastaron.
	select cu.first_name Nombre, cu.last_name Apellido, ad.address Address, ci.city City, co.country Country, count(re.customer_id) CantAlq, sum(pa.amount) TotalPagos
	from customer cu 
    join address ad 	on cu.address_id = ad.address_id
    join city ci 		on ad.city_id = ci.city_id
    join country co 	on co.country_id = ci.country_id
    join rental re 		on re.customer_id = cu.customer_id
    join payment pa 	on pa.rental_id = re.rental_id
    where month(re.rental_date) = 5	#and sum(pa.amount) > 10
    group by cu.customer_id	
    having TotalPagos > 10  
    order by TotalPagos desc, Country, City
    limit 10








