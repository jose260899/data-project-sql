-- 1. Crea el esquema de la BBDD.
-- (Ya resuelto ejecutando el script de creación de la BBDD proporcionado; no se incluye consulta específica aquí)

-- 2. Muestra los nombres de todas las películas con una clasificación por edades de 'R'.
-- 2
select f.title  
from film f 
where f.rating = 'R';

-- 3. Encuentra los nombres de los actores que tengan un "actor_id" entre 30 y 40.
-- 3

select concat(a.first_name, ' ', a.last_name ) as full_name 
from actor a 
where a.actor_id between 30 and 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
-- 4 (usamos is not distinct from para evitar tener el null-safe ya que se observamos todos los original_language_id son nulos)

select f.title 
from film f 
where f.language_id  is not distinct from f.original_language_id;

-- 5. Ordena las películas por duración de forma ascendente.
-- 5

select f.title, f.length as duracion 
from film f 
order by f.length;

-- 6. Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido.
-- 6 

--El enunciado pregunta por 'Allen' y no hay concidencias pero por 'ALLEN' si ya que PostgreSQL es key sensitive (en sql server no me pasa esto)

select concat(a.first_name, ' ', a.last_name ) as full_name  
from actor a 
where a.last_name like '%ALLEN%';

-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla "film" y muestra la clasificación junto con el recuento.
-- 7 

select f.rating ,count(*) as total 
from film f
group by f.rating;


-- 8. Encuentra el título de todas las películas que son 'PG-13' o tienen una duración mayor a 3 horas en la tabla film.
-- 8

select f.title  
from film f 
where f.rating = 'PG-13' or f.length > 180;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
-- 9 

select round(variance(f.replacement_cost), 2) as coste_reemplazo 
from film f ;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
-- 10 

select MAX(f.length ) as mayor_duracion, MIN(f.length) as menor_duracion 
from film f;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
-- 11

select r.rental_date, p.amount 
from rental r 
inner join payment p on p.rental_id = r.rental_id
order by r.rental_date  desc
limit 1 offset 2;

-- 12. Encuentra el título de las películas en la tabla "film" que no sean ni 'NC-17' ni 'G' en cuanto a su clasificación.
-- 12

select f.title ,f.rating  
from film f
where f.rating not in ('NC-17', 'G')
order by rating;

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
-- 13

select f.rating , AVG(f.length ) as duracion_media
from film f
group by f.rating;

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
-- 14 

select f.title,f.length  
from film f 
where f.length > 180 
order by f.length; 


-- 15. ¿Cuánto dinero ha generado en total la empresa?
-- 15

select sum(p.amount) as facturacion
from payment p; 

-- 16. Muestra los 10 clientes con mayor valor de id.
-- 16

select c.customer_id  
from customer c 
order by c.customer_id desc
limit 10;


-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título 'Egg Igby'.
-- 17

select concat(a.first_name, ' ', a.last_name ) as full_name
from actor a 
inner join film_actor fa on fa.actor_id = a.actor_id 
inner join film f on fa.film_id = f.film_id 
where f.title = 'EGG IGBY';

-- 18. Selecciona todos los nombres de las películas únicos.
-- 18 

select distinct(f.title )
from film f ;


-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla "film".
-- 19

select f.title, f.length 
from film_category fc
inner join film f on f.film_id = fc.film_id 
inner join category c on c.category_id  = fc.category_id
where c."name" = 'Comedy' and f.length > 180;


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
-- 20

select c."name", AVG(f.length ) as promedio
from film_category fc
inner join film f on f.film_id = fc.film_id 
inner join category c on c.category_id  = fc.category_id
group by c."name"
having AVG(f.length) > 110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
-- 21

select avg(r.return_date - r.rental_date ) as promedio_alquiler 
from rental r; 

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
-- 22

alter table actor add nombre_completo varchar(150);

update actor a set nombre_completo = concat(a.first_name , ' ' , a.last_name );

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
-- 23

select cast(r.rental_date as date) as fecha,count(*) as total
from rental r 
group by fecha
order by total desc;

-- 24. Encuentra las películas con una duración superior al promedio.
-- 24

select title, f.length as duracion
from film f 
where f.length >  (select AVG(f2.length) from film f2 );

-- 25. Averigua el número de alquileres registrados por mes.
-- 25

select to_char(date_trunc('month', r.rental_date ), 'mm-yyyy')  as mes,count(*) as total
from rental r 
group by mes
order by total desc;


-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
-- 26 

select AVG(p.amount ) as promedio, stddev(p.amount) as desviacion_estandar, variance(p.amount) as varianza
from payment p;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
-- 27

select f.title, f.rental_rate, (select avg(p.rental_rate ) from film p ) as promedio
from film f 
where f.rental_rate > (select avg(p.rental_rate ) from film p )

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
--28

select fa.actor_id 
from film_actor fa 
group by fa.actor_id 
having count(fa.actor_id) > 40


-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
--29

select f.film_id, f.title, count(i.inventory_id ) as stock
from film f 
left join inventory i on i.film_id = f.film_id 
group by f.film_id, f.title 

-- 30. Obtener los actores y el número de películas en las que ha actuado.
--30

select a.actor_id ,a.first_name, count(fa.film_id) as totalPeliculas
from actor a
left join film_actor fa on fa.actor_id = a.actor_id 
group by a.actor_id ,a.first_name 

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
--31

select f.film_id ,f.title, a.actor_id, a.first_name 
from film f 
left join film_actor fa on fa.film_id = f.film_id 
left join actor a on fa.actor_id = a.actor_id 
order by f.film_id 


-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
--32

select a.actor_id , a.first_name , f.title as pelicula
from actor a 
left join film_actor fa on fa.actor_id = a.actor_id 
left join film f on f.film_id = fa.film_id 
order by a.actor_id 

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
-- 33

select f.film_id , f.title, r.rental_id , r.rental_date 
from film f 
full join inventory i on i.film_id = f.film_id 
full join rental r on r.inventory_id = i.inventory_id 
order by f.film_id 


-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
--34

select c.customer_id ,c.first_name, (select sum(p2.amount) from payment p2 where p2.customer_id = c.customer_id ) as dineroGastado
from customer c 
group by c.customer_id 
order by dinerogastado desc
limit 5

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
--35

select * from actor a where a.first_name = 'Johnny'

-- 36. Renombra la columna "first_name" como Nombre y "last_name" como Apellido.
--36

SELECT first_name AS Nombre, last_name AS Apellido FROM actor

ALTER TABLE actor RENAME COLUMN first_name TO Nombre;
ALTER TABLE actor RENAME COLUMN last_name  TO Apellido;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
--37

select min(a.actor_id ) from actor a ;
select max(a.actor_id ) from actor a;

-- 38. Cuenta cuántos actores hay en la tabla "actor".
--38

select count(*) as totalActores from actor a 

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
--39

select * 
from actor a 
order by a.last_name asc

-- 40. Selecciona las primeras 5 películas de la tabla "film".
--40

select * from film f 
order by f.film_id 
limit 5

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
--41

select a.first_name, count(*) as total
from actor a
group by a.first_name
order by total desc
limit 1;


-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
--42

select r.rental_id, r.rental_date , c.customer_id ,c.first_name  
from rental r 
inner join customer c on c.customer_id = r.customer_id 

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
--43

select c.customer_id, c.first_name, r.rental_id, r.rental_date  
from customer c 
left join rental r on r.customer_id = c.customer_id 

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
--44
/*
 * Esta consulta no tiene sentido porque estás emparejando cada película con
 * todas las categorías existentes, tenga o no relación real con ellas.
 * La relación verdadera entre película y categoría ya está definida en film_category, asi que 
 * el cross join solamente genera combinciones sin sentido de negocio
 * */
select f.title, c.name as categoria
from film f
cross join category c;

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
--45
-- 45

select distinct a.actor_id, concat(a.first_name , ' ' , a.last_name ) as Nombre
from actor a 
inner join film_actor fa on fa.actor_id = a.actor_id 
inner join film f on f.film_id = fa.film_id 
inner join film_category fc  on fc.film_id  = f.film_id 
inner join category c on c.category_id = fc.category_id 
where c."name" = 'Action'
order by a.actor_id 

-- 46. Encuentra todos los actores que no han participado en películas.
--46

select a.actor_id ,a.first_name 
from actor a 
left join film_actor fa on fa.actor_id = a.actor_id 
where fa.actor_id  is null

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
--47
select  count(fa.actor_id ) as totalPeliculas, a.actor_id, concat(a.first_name , ' ' , a.last_name ) as Nombre
from actor a 
inner join film_actor fa on fa.actor_id = a.actor_id 
group by a.actor_id 
order by totalpeliculas 

-- 48. Crea una vista llamada "actor_num_peliculas" que muestre los nombres de los actores y el número de películas en las que han participado.
--48

create view actor_num_peliculas as 
select  count(fa.actor_id ) as totalPeliculas, a.actor_id, concat(a.first_name , ' ' , a.last_name ) as Nombre
from actor a 
inner join film_actor fa on fa.actor_id = a.actor_id 
group by a.actor_id 
order by totalpeliculas 

select * from actor_num_peliculas anp 
-- 49. Calcula el número total de alquileres realizados por cada cliente.
--49. Calcula el número total de alquileres realizados por cada cliente.

select count(r.rental_id ) as totalAlquileres,c.customer_id  ,c.first_name 
from customer c 
inner join rental r on r.customer_id = c.customer_id 
group by c.customer_id ,c.first_name 
order by totalalquileres 


-- 50. Calcula la duración total de las películas en la categoría 'Action'.
--50
select sum(f.length) as duracion_total
from film f
inner join film_category fc on fc.film_id = f.film_id
inner join category c on c.category_id = fc.category_id
where c.name = 'Action';

-- 51. Crea una tabla temporal llamada "cliente_rentas_temporal" para almacenar el total de alquileres por cliente.
--51
create temp table cliente_rentas_temporal as
select count(r.rental_id ) as totalAlquileres,c.customer_id  ,c.first_name 
from customer c 
inner join rental r on r.customer_id = c.customer_id 
group by c.customer_id ,c.first_name 
order by totalalquileres 

SELECT * FROM cliente_rentas_temporal;


-- 52. Crea una tabla temporal llamada "peliculas_alquiladas" que almacene las películas que han sido alquiladas al menos 10 veces.
--52
DROP TABLE IF EXISTS peliculas_alquiladas;
create temp table peliculas_alquiladas as
select count(r.rental_id) as totalPelis, f.film_id, f.title
from film f
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
group by f.film_id, f.title
having count(r.rental_id)> 9;

select * from peliculas_alquiladas;

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre 'Tammy Sanders' y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
-- 53
SELECT f.title
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
INNER JOIN film f ON f.film_id = i.film_id
WHERE CONCAT(c.first_name, ' ', c.last_name) = 'Tammy Sanders'
  AND r.return_date IS NULL
ORDER BY f.title;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría 'Sci-Fi'. Ordena los resultados alfabéticamente por apellido.
-- 54
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
INNER JOIN film_actor fa ON fa.actor_id = a.actor_id
INNER JOIN film_category fc ON fc.film_id = fa.film_id
INNER JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name;

-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película 'Spartacus Cheaper' se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
-- 55
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
INNER JOIN film_actor fa ON fa.actor_id = a.actor_id
INNER JOIN film f ON f.film_id = fa.film_id
INNER JOIN inventory i ON i.film_id = f.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM rental r2
    INNER JOIN inventory i2 ON i2.inventory_id = r2.inventory_id
    INNER JOIN film f2 ON f2.film_id = i2.film_id
    WHERE f2.title = 'Spartacus Cheaper'
)
ORDER BY a.last_name;

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría 'Music'.
-- 56
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film_category fc ON fc.film_id = fa.film_id
    INNER JOIN category c ON c.category_id = fc.category_id
    WHERE c.name = 'Music'
);

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
-- 57
SELECT DISTINCT f.title
FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.return_date IS NOT NULL
  AND r.return_date - r.rental_date > INTERVAL '8 days';

-- 58. Encuentra el título de todas las películas que son de la misma categoría que 'Animation'.
-- 58
SELECT DISTINCT f.title
FROM film f
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Animation';

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título 'Dancing Fever'. Ordena los resultados alfabéticamente por título de película.
-- 59
SELECT title
FROM film
WHERE length = (SELECT length FROM film WHERE title = 'Dancing Fever')
ORDER BY title;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
-- 60
SELECT c.first_name, c.last_name
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name;

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
-- 61
SELECT c.name AS categoria, COUNT(r.rental_id) AS total_alquileres
FROM rental r
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
INNER JOIN film_category fc ON fc.film_id = i.film_id
INNER JOIN category c ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY total_alquileres DESC;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
-- 62
SELECT c.name AS categoria, COUNT(f.film_id) AS total_peliculas
FROM film f
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category c ON c.category_id = fc.category_id
WHERE f.release_year = 2006
GROUP BY c.name;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
-- 63
SELECT s.first_name, s.last_name, st.store_id
FROM staff s
CROSS JOIN store st;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
-- 64
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS peliculas_alquiladas
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;