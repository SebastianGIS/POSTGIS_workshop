SELECT count(*)
FROM nyc_streets; -- Forma para saber la cantidad de records en la tabla "nyc_streets"

SELECT count(*)
FROM nyc_streets
WHERE name LIKE 'B%'; -- Forma para saber la cantidad de calles que comienzan con la letra B. % actúa como comodín

SELECT sum(popn_total) AS Población --Acá se le puede dar un nombre customizado a la tabla (un alias)
FROM nyc_census_blocks; -- Suma de la columna "popn_total" de la tabla de census blocks. Es para obtener la población total

SELECT boroname AS distrito , sum(popn_total) AS población
FROM nyc_census_blocks
WHERE boroname = 'The Bronx'
GROUP BY boroname; --Obtener la suma de la población de El Bronx. Acá añado el campo de boroname para que la tabla sea más comprensible

SELECT boroname, COUNT(name)
FROM nyc_neighborhoods
GROUP BY boroname; --Cuántos barrios hay en cada borough. 

SELECT boroname, sum(popn_white) / sum(popn_total) * 100
FROM nyc_census_blocks
GROUP BY boroname; --Porcentaje de blancos para cada borough. 


/*
avg(expression): PostgreSQL aggregate function that returns the average value of a numeric column.

count(expression): PostgreSQL aggregate function that returns the number of records in a set of records.

sum(expression): PostgreSQL aggregate function that returns the sum of records in a set of records. */ 

-- Resumen
-- COUNT(*)
-- Cuenta el número total de registros (filas) que devuelve una consulta en lugar de traer los datos.
-- Uso básico: SELECT count(*) FROM tabla;

-- SUM()
-- Función de agregación que calcula la suma total de todos los valores numéricos en una columna.
-- Uso básico: SELECT sum(columna_numerica) FROM tabla;

-- LIKE y COMODINES (%)
-- Filtra registros buscando patrones de texto específicos dentro de una cadena.
-- El comodín '%' representa cualquier secuencia de caracteres (cero, uno o múltiples).
-- Uso básico: WHERE columna LIKE 'A%'; (Encuentra todos los textos que empiecen con A).

-- AS (ALIAS)
-- Asigna un nombre temporal a una columna o tabla para facilitar su lectura en el resultado final.
-- Uso básico: SELECT funcion(columna) AS nombre_legible FROM tabla;

-- OPERACIONES MATEMÁTICAS BÁSICAS (+, -, *, /)
-- Cálculos aritméticos directamente en la declaración SELECT, ideal para calcular porcentajes combinando funciones.
-- Uso básico: SELECT (sum(columna_a) / sum(columna_b)) * 100 AS porcentaje FROM tabla;