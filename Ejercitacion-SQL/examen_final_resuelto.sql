#Implemente una consulta sobre la base de datos “Sakila” que liste  los actores, 
#el monto de alquileres cobrados de sus films y el nombre de la pelicula que 
#mas recaudó dentro de las que trabajó ese actor , muéstrelos ordenados por monto de alquileres de mayor a menor.
#El listado tendrá las siguientes columnas:
#1- Nombre del actor
#2- Apellido del actor
#3- Monto cobrado por alquileres de sus films
#4- Nombre de la película mas taquillera entre las que actúa

#El estado actual de los datos es uno de los posibles estados, 
#la consulta debe funcionar correctamente cualquiera sea el estado de los datos,
# puede que sea necesario modificar los datos para probar diferentes posibilidades.

select first_name,last_name,total,title 
from 
(
	select sc0.actor,sc0.last_name, sc0.first_name,sc0.film,sc2.maxrec,sc2.total 
	from
   (
		select a.actor_id actor, a.last_name, a.first_name, fa.film_id film, sum(p.amount) monto 
        from actor a 
		left join film_actor fa on a.actor_id = fa.actor_id
		join inventory i 		on i.film_id = fa.film_id
		join rental r 			on r.inventory_id= i.inventory_id 
		join payment p 			on r.rental_id = p.rental_id
		group by a.actor_id,fa.film_id
	) sc0 																	#BUSCO ACTORES, FILMS Y SU RECAUDACION
join
   (
		select actor, max(monto) maxrec, sum(monto) total 
        from 
       (
			select a.actor_id actor, a.last_name, a.first_name, fa.film_id, sum(p.amount) monto 
            from actor a 
			left join film_actor fa on a.actor_id = fa.actor_id
			join inventory i		on i.film_id = fa.film_id
			join rental r 			on r.inventory_id= i.inventory_id 
			join payment p 			on r.rental_id = p.rental_id
			group by a.actor_id,fa.film_id
		) sc1 																#BUSCO ACTORES, FILMS Y SU RECAUDACION
        group by actor 
	) sc2 																		#BUSCO ACTORES Y SU MAXIMA RECAUDACION
on sc0.actor = sc2.actor and sc0.monto = sc2.maxrec
) sc3  																			#ME QUEDO CON LOS REGISTROS DE ACTORES, FILMS Y SU RECAUDACION																				#QUE COINCIDA EL ACTOR Y LA RECAUDACION CON LA MAXIMA RECAUDACION 
join film on film.film_id = sc3.film

