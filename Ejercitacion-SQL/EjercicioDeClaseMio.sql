/*Para cada combinacion actor/pelicula se muestre
-id actor
-apellido actor
-nombre pelicula
-si el film (o los) es uno/s de/los mas taquilleros(sumas amount) de ese actor, ponerle si, o no caso contrario.
Se debe mostrar todas las combinaciones film_actor presentes, aun aquellas sin alquileres, copias o pagos.
No se deben incluir los actores sin peliculas.*/


select actor, nombre, monto, maximo, case when abc.monto = abc.maximo then 'YES' else 'NO' end as taquillera 
from
(
		select ac.actor_id actor, ac.first_name nombre, ac.last_name apellido, fa.film_id film, sum(pa.amount) monto, a.maximo
		from actor ac
		join film_actor fa	on ac.actor_id = fa.actor_id
		join inventory inv 	on fa.film_id = inv.film_id
		join rental re 		on inv.inventory_id = re.inventory_id
		join payment pa		on re.rental_id = pa.rental_id
		join 
		(
			select sc0.actor actor, max(sc0.monto) maximo
			from
			(
					select ac.actor_id actor, ac.first_name nombre, ac.last_name apellido, fa.film_id film, sum(pa.amount) monto
					from actor ac
					join film_actor fa	on ac.actor_id = fa.actor_id
					join inventory inv 	on fa.film_id = inv.film_id
					join rental re 		on inv.inventory_id = re.inventory_id
					join payment pa		on re.rental_id = pa.rental_id
					group by actor, nombre, apellido, film
			) sc0
			group by actor
		)a
		on a.actor = ac.actor_id
		group by actor, nombre, apellido, film
)abc
