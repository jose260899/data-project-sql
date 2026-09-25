# DataProject - Lógica de Consultas SQL

Proyecto del módulo de SQL del curso de Data Analytics. 64 consultas sobre una
BBDD de alquiler de películas (Sakila/Pagila en PostgreSQL, sin la tabla de
usuarios).

## Estructura

- `README.md` - esto
- `esquema_bbdd/` - esquema de la BBDD que nos dieron
- `consultas.sql` - las 64 consultas, cada una con su número y enunciado como comentario

## Cómo lo he hecho

Antes de tirarme a hacer consultas me puse a mirar el esquema un rato, sobre
todo para entender cómo se conectaban las tablas que no son obvias a simple
vista: `rental` no se conecta directo con `film`, hay que pasar por
`inventory` de por medio. Eso me costó un par de veces al principio hasta que
lo pillé.

Luego fui haciendo las consultas en orden, de la 2 a la 64 (la 1 es solo
cargar el script que nos dieron). Empecé por las fáciles (WHERE, ORDER BY) y
fui subiendo a JOINs, subconsultas, GROUP BY/HAVING, vistas y tablas
temporales.

Cada consulta la he probado contra la BBDD de verdad, no solo mirando que no
diera error sino viendo si el resultado tenía sentido (por ejemplo con los
LEFT JOIN, comprobando que salían de verdad las filas sin match).

## Cosas a tener en cuenta al corregir / decisiones que he tomado

- Uso LEFT JOIN solo cuando el enunciado pide explícitamente no perder filas
  (tipo "todas las películas aunque no tengan actor"). El resto INNER JOIN.
- Los filtros sobre COUNT/AVG/SUM van en HAVING, no en WHERE (el WHERE se
  ejecuta antes de que exista el agregado, me dio error varias veces hasta
  que me acostumbré).
- La 22 (columna con nombre completo) la hago con CONCAT en el SELECT, no
  toco la tabla actor de verdad, para no romper el resto de consultas que
  usan first_name/last_name.
- Ojo con la 36: el enunciado pide "renombrar" de verdad, así que ahí sí hay
  un ALTER TABLE RENAME COLUMN. Si se ejecuta el .sql entero de un tirón de
  arriba a abajo, esa consulta rompe todas las que vienen después y usan
  first_name/last_name de actor (45, 46, 47, 48, 54, 55, 56). Lo suyo es
  ejecutar la 36 aparte al final, o deshacer el rename antes de seguir.

## Análisis rápido de los datos

Cargué la BBDD en local y ejecuté varias de las consultas para sacar números
reales, no me los invento:

- Facturación total: 67.416,51 en 16.044 alquileres, 599 clientes, 1000
  películas en catálogo.
- La categoría que más se alquila es Sports (1179 veces), la que menos Music
  (830). No hay una diferencia bestial entre ellas.
- Sports también es la categoría con las películas más largas de media (128
  min vs 115 min de media general), curioso que coincida con la más
  alquilada.
- El cliente que más se ha gastado es Karl Seal, 221,55€ - poco comparado
  con el total, o sea que el gasto está repartido entre todos, no
  concentrado en 4 clientes.
- Solo el 1,1% de los alquileres no tiene fecha de devolución. La duración
  media real de un alquiler es de 5 días.
- Dato random: en la consulta 60 (clientes con 7+ películas distintas
  alquiladas), sale el 100% de los clientes. Lo comprobé porque me pareció
  raro, pero no es un fallo de la consulta, es que el dataset de ejemplo
  está hecho así, casi todo el mundo tiene un historial de alquiler amplio.

## Autor

Jose Antonio Ayala Farell