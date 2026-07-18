SELECT name FROM nyc_neighborhoods; -- Selecciona de la tabla nyc_neighborhoods todos los registros, solo el campo nombre

SELECT * FROM nyc_neighborhoods; -- Selecciona todos los registros de esa tabla, además de todos los campos

SELECT name FROM nyc_neighborhoods
WHERE name = 'Rossville'; -- Selecciona solo el/los registros donde nombre es Rossville

SELECT avg(char_length(name)) , stddev(char_length(name))
  FROM nyc_neighborhoods
  WHERE boroname = 'Brooklyn'; -- Esto obtiene el promedio y la desviación estandar de los nombres de los barrios en donde el boroname es "Brooklyn"

SELECT boroname, avg(char_length(name)), stddev(char_length(name))
  FROM nyc_neighborhoods
  GROUP BY boroname; --Lo mismo que arriba, pero acá están agrupados por boroname

-- Resumen
-- SELECT
-- Define qué columnas se van a extraer y mostrar en el resultado.
-- Uso básico: SELECT columna1, columna2 FROM nombre_tabla;
-- Uso global: SELECT * FROM nombre_tabla; (El asterisco trae todas las columnas).

-- WHERE
-- Filtra los registros de la tabla según una o más condiciones.
-- Uso básico: WHERE columna = 'valor_buscado';

-- FUNCIONES ESCALARES Y DE AGREGACIÓN
-- Realizan cálculos sobre los datos obtenidos.
-- char_length(columna): Cuenta el número de caracteres de una cadena de texto.
-- avg(columna): Calcula el promedio aritmético de un conjunto de valores numéricos.
-- stddev(columna): Calcula la desviación estándar de un conjunto de valores numéricos.

-- GROUP BY
-- Agrupa las filas que tienen los mismos valores en una o más columnas.
-- Se utiliza obligatoriamente cuando combinas columnas normales con funciones 
-- de agregación (como avg, sum, count) para definir el criterio de agrupación.
-- Uso básico: GROUP BY columna_categoria;