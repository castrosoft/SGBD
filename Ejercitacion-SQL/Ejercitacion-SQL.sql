#SELECCIONAR LOS ACTORES QUE ACTUARON AL MENOS EN UNA PELICULA QUE DURE MENOS DE 70 min
select actor.first_name,actor.last_name 
from actor 
where 70 > ANY	(
					select fi.length 
                    from film fi
                    join film_actor fa on fi.film_id = fa.film_id
					where fa.actor_id = fa.actor_id
				)


#SELECCIONAR LOS 5 ACTORES QUE MAS TIEMPO ACTUARON 
#SUMANDO LA DURACION DE TODAS SUS PELICULAS
select actor.first_name,actor.last_name, duracion_total
from actor, 
			(	
				select sum(length) duracion_total,actor_id 
				from film join film_actor on film.film_id = film_actor.film_id
				group by actor_id
			) len
where actor.actor_id =  len.actor_id
order by duracion_total desc
limit 5

#SELECCIONAR LA/S PELICULA/S EN LA QUE ACTUARON MAS ACTORES
select max(a.cantActores) maximo
from
(
	select fa.film_id, count(fa.actor_id) cantActores
	from film_actor fa
	group by fa.film_id
)a


#GENERAR UN LISTADO DE TODOS LOS ACTORES, CANTIDAD DE PELICULAS QUE ACTUARON, 
#CANTIDAD DE CATEGORIAS, MONTO RECAUDADO 
#(INCLUIR TODOS LOS ACTORES)
select a.actor, a.cantPeliculas, b.cantCategorias, c.montoRecaudado
from
(
	select ac.actor_id actor, count(fa.film_id) cantPeliculas
	from actor ac
	join film_actor fa on ac.actor_id = fa.actor_id
	group by actor
)a
join
(
	select ac.actor_id actor, count(distinct fc.category_id) cantCategorias
	from actor ac
	join film_actor fa on ac.actor_id = fa.actor_id
	join film_category fc on fa.film_id = fc.film_id
	group by actor
) b on a.actor = b.actor
join
(
	select ac.actor_id actor, count(pa.amount) montoRecaudado
	from actor ac
	join film_actor fa on ac.actor_id = fa.actor_id
	join inventory inv on fa.film_id = inv.film_id
	join rental re on inv.inventory_id = re.inventory_id
	join payment pa on re.rental_id = pa.rental_id
	group by actor
) c on b.actor = c.actor

#MOSTRAR LOS ACTORES QUE ACTUARON EN LA/S PELICULA/S MAS LARGA/S
select fa.actor_id, fa.film_id, ac.first_name, ac.last_name
from film_actor fa
join
(
	select  fi.film_id
	from film fi
	where fi.length = (select max(fi.length) from film fi) #Peliculas mas largas
    order by fi.film_id 
)a on fa.film_id = a.film_id
join actor ac on fa.actor_id = ac.actor_id


#Seleccionar  todos  los  clientes  (apellido  y  nombre)cuyo  pagos  promedios  historicos
#sean  mayores  que  los  pagos  promedios  de  todoslos  clientes
select cu.first_name nombre, cu.last_name apellido, a.pagPromXCliente, a.cliente
from customer cu
join
(
	select avg(pa.amount) pagPromXCliente, pa.customer_id cliente
	from payment pa
	group by cliente
) a
on cu.customer_id = a.cliente
where  pagPromXCliente > (select avg(pa.amount) pagPromTodos	from payment pa)

#Seleccionar  los  actores  (apellido  y  nombre)cuyas  peliculas  
#hayan  sido  rentadas  al  menos una  vez  en  el  mes  de  mayo
select  first_name,last_name  
from  actor  a  
join  film_actor  fa  on a.actor_id = fa.actor_id
join  inventory  i  on i.film_id = fa.film_id
join  rental  r  on i.inventory_id = r.inventory_id
where month(r.rental_date) =  5
group  by a.actor_id


#Seleccionar  el/los  actor/es  que  participo  en  peliculas de  todos  las  categorias
select ac.actor_id, ac.first_name, ac.last_name, count(distinct fc.category_id) cant
from actor ac
join film_actor fa 		on ac.actor_id = fa.actor_id
join film_category fc 	on fa.film_id = fc.film_id
group by ac.actor_id, ac.first_name, ac.last_name
having cant = (select count(*) from category)

#Seleccionar  los  clientes  que  deben  retornar  videos
select cu.customer_id, cu.first_name, cu.last_name, count(*) cantNoDev
from rental re
join customer cu on cu.customer_id = re.customer_id
where re.return_date is null 
#and adddate(re.rental_date, fi.rental_duration) < now()
group by cu.customer_id, cu.first_name, cu.last_name

#Mostrar  cuantos  clientes  devovieron  un  video  por  fecha
select  date(return_date), count(customer_id)  cant_alq  
from  rental
where  return_date  is not null
group  by  date(return_date)

#Mostar  los  alquileres  que  se  entregaron  fuera  de  termino,  
#mostrando  nombre  y  apellido del  cliente,  nombre  de  la  pelicula,  y  dias  de  demora


#Actores, Cant de Alq Totales, Monto total, Cant de alq NO devueltos
select a.apellido, a.nombre, b.cantAlqTotales, c.MontoTotal, d.cantNoDev
from
(
	select customer_id, last_name apellido, first_name nombre
	from customer
)a
join
(
	select customer_id, count(*) cantAlqTotales
	from rental
	group by customer_id
)b on a.customer_id = b.customer_id
join
(
	select re.customer_id, sum(pa.amount) MontoTotal
	from rental re
	join payment pa on re.rental_id = pa.rental_id
	group by re.customer_id
)c on b.customer_id = c.customer_id
join
(
	select cu.customer_id, count(*) cantNoDev
	from rental re
	join customer cu on cu.customer_id = re.customer_id
	where re.return_date is null
	group by cu.customer_id
)d on c.customer_id = d.customer_id



