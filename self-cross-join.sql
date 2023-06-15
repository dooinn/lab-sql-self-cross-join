use sakila;


-- 1. Get all pairs of actors that worked together.

select * from film_actor fa1
join film_actor fa2
on fa1.actor_id <> fa2.actor_id
and fa1.film_id = fa2.film_id;

-- alternatively when grouping actors under the same movies
select f.film_id, f.title, group_concat(distinct concat(a.first_name,' ',a.last_name) separator ',') as actors 
from film_actor fa
left join actor a on a.actor_id = fa.actor_id
left join film f on f.film_id = fa.film_id
group by f.film_id;





-- 2. Get all pairs of customers that have rented the same film more than 3 times.


select a.film_id, a.customer_id, b.customer_id, a.film_id
from
    (select r.customer_id, i.film_id 
     from rental r
     left join inventory i on i.inventory_id = r.inventory_id
     left join film f on f.film_id = i.film_id
     group by r.customer_id, i.film_id
     having count(*) > 3) a
join
    (select r.customer_id, i.film_id 
     from rental r
     left join inventory i on i.inventory_id = r.inventory_id
     left join film f on f.film_id = i.film_id
     group by r.customer_id, i.film_id
     having count(*) > 3) b
on a.film_id = b.film_id and a.customer_id <> b.customer_id;




-- alternatively, if gourping customers under movie titles
select i.film_id, f.title, group_concat(distinct r.customer_id separator ', ') as customers
from rental r
left join inventory i on i.inventory_id = r.inventory_id
left join film f on f.film_id = i.film_id
group by i.film_id
having count(distinct r.customer_id) > 3;




-- 3. Get all possible pairs of actors and films.

select distinct(film.title),ac.name from film
cross join
(select distinct(concat(first_name,' ',last_name)) as name from actor) ac




