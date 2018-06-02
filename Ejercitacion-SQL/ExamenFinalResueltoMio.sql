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

         
select sc2.nombre, sc2.apellido, sc2.total, fi.title FilmMasTaq
from
(        
		select sc1.actor, sc0.apellido, sc0.nombre, sc0.film, sc1.max_rec, sc1.total
		from
		(
						select ac.actor_id actor, ac.last_name apellido, ac.first_name nombre, fa.film_id film, sum(pa.amount) monto
						from actor ac
						join film_actor fa	on ac.actor_id = fa.actor_id
						join inventory inv	on fa.film_id = inv.film_id
						join rental re		on inv.inventory_id = re.inventory_id
						join payment pa		on re.rental_id = pa.rental_id
						group by actor, apellido, nombre, film
		) sc0
		join 
		(
						select actor, max(monto) max_rec, sum(monto) total  
						from
						(		
								
								select ac.actor_id actor, ac.last_name apellido, ac.first_name nombre, fa.film_id film, sum(pa.amount) monto
								from actor ac
								join film_actor fa	on ac.actor_id = fa.actor_id
								join inventory inv	on fa.film_id = inv.film_id
								join rental re		on inv.inventory_id = re.inventory_id
								join payment pa		on re.rental_id = pa.rental_id
								group by actor, apellido, nombre, film
						) sc0
						group by actor
		)sc1
		on sc0.actor = sc1.actor and sc0.monto = sc1.max_rec
) sc2
join film fi on sc2.film = fi.film_id
order by sc2.total desc
