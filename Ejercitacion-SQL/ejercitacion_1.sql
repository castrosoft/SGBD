#Los clientes que mas pagaron alquileres por staff
select *
from(
		select pa.staff_id, pa.customer_id, sum(pa.amount) pagos
        from payment pa
        group by pa.staff_id, pa.customer_id
	)s
where(staff_id, pagos) in(
							select staff_id, max(pagos)
                            from(
									select pa.staff_id, pa.customer_id, sum(pa.amount) pagos
                                    from payment pa
                                    group by pa.staff_id, pa.customer_id
								)a
							group by staff_id
						 )
    