--Spatial joins pueden responder preguntas en una sola query
SELECT
  subways.name AS subway_name,
  neighborhoods.name AS neighborhood_name,
  neighborhoods.boroname AS borough
FROM nyc_neighborhoods AS neighborhoods
JOIN nyc_subway_stations AS subways
ON ST_Contains(neighborhoods.geom, subways.geom)
WHERE subways.name = 'Broad St';



SELECT
  neighborhoods.name AS neighborhood_name,
  Sum(census.popn_total) AS population,
  100.0 * Sum(census.popn_white) / Sum(census.popn_total) AS white_pct,
  100.0 * Sum(census.popn_black) / Sum(census.popn_total) AS black_pct
FROM nyc_neighborhoods AS neighborhoods
JOIN nyc_census_blocks AS census
ON ST_Intersects(neighborhoods.geom, census.geom)
WHERE neighborhoods.boroname = 'Manhattan'
GROUP BY neighborhoods.name
ORDER BY white_pct DESC; --Este código responde a la pregunta de: ¿Cuál es la población y los porcentajes por raza de los neighborhood de Manhattan?

--RESUMEN

-- CONCEPTO GENERAL DE SPATIAL JOIN
-- Combina filas de dos o más tablas basándose en la relación geográfica de sus geometrías.
-- Sintaxis básica:
--   SELECT columnas
--   FROM tabla_A
--   JOIN tabla_B ON FUNCION_ESPACIAL(tabla_A.geom, tabla_B.geom);

-- CASO DE USO 1: ASIGNACIÓN DE ATRIBUTOS POR UBICACIÓN (ST_Contains / ST_Within)
-- Permite transferir la información de una capa de polígonos (ej. barrios) 
-- a elementos puntuales o lineales que residen dentro de ella (ej. estaciones de metro).
-- USO PRÁCTICO: Responder "¿A qué distrito o zona pertenece cada infraestructura?".

-- CASO DE USO 2: AGREGACIÓN ESPACIAL (ST_Intersects + GROUP BY + SUM/AVG)
-- Permite consolidar datos numéricos de pequeñas unidades territoriales (ej. bloques censales) 
-- hacia unidades territoriales más grandes (ej. barrios o comunas).
-- USO PRÁCTICO: Calcular estadísticas demográficas, ambientales o prediales
-- acumuladas para una zona determinada combinando ST_Intersects con GROUP BY.

-- CONSIDERACIÓN TÉCNICA (EFECTO BORDE EN INTERSECCIONES)
-- Al usar ST_Intersects entre polígonos que se solapan parcialmente (como bloques censales 
-- cruzando el límite de un barrio), un mismo bloque puede intersectar con dos barrios distintos.
-- Para análisis de mayor precisión métrica, se pueden usar técnicas de intersección exacta 
-- o usar el centroide del bloque (ST_Centroid(census.geom)) en el ST_Within para evitar duplicar 
-- conteos de población.