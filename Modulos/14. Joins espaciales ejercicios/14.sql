SELECT *
FROM nyc_subway_stations AS estaciones
JOIN nyc_neighborhoods AS barrios
ON ST_Contains(barrios.geom ,estaciones.geom)
WHERE barrios.name = 'Little Italy'; --Esta query responde qué estaciones de metro están dentro del barrio llamado "Little Italy"



SELECT DISTINCT barrios.name , barrios.boroname
FROM nyc_subway_stations AS estaciones
JOIN nyc_neighborhoods AS barrios
ON ST_Contains(barrios.geom ,estaciones.geom)
WHERE routes LIKE '%6%'; --Esta query obtiene que barrios pasan por la ruta 6



SELECT SUM(popn_total)
FROM nyc_neighborhoods AS barrios
JOIN nyc_census_blocks AS censo
ON ST_Intersects(barrios.geom , censo.geom)
WHERE name = 'Battery Park'; --Esta query obtiene la población total en el barrio de Battery Park, usando la tabla del censo



SELECT barrios.name AS barrio , SUM(censo.popn_total) AS poblacion_total, SUM(censo.popn_total) / (ST_Area(barrios.geom) / 1000000) AS densidad
FROM nyc_neighborhoods AS barrios
JOIN nyc_census_blocks AS censo
ON ST_Intersects(barrios.geom , censo.geom)
GROUP BY barrio, barrios.geom
ORDER BY densidad DESC --Esta query obtiene los barrios con mayor densidad poblacional en personas/km2.


-- RESUMEN
-- PATRÓN 1: FILTRADO DE ENTIDADES POR SU UBICACIÓN EN UN BARRIO/POLÍGONO
-- Combina un ST_Contains entre polígono y punto con un filtro WHERE en el polígono.
-- USO PRÁCTICO: Extraer infraestructuras (puntos) contenidas en un área delimitada.

-- PATRÓN 2: BÚSQUEDA DE LÍNEAS/RUTAS Y DEDUPLICACIÓN DE RESULTADOS
-- Al hacer JOIN entre puntos/líneas y polígonos, un atributo repetido en los puntos 
-- (ej. varias estaciones de la ruta '6') puede hacer que un barrio aparezca duplicado.
-- USO PRÁCTICO: Se utiliza SELECT DISTINCT para garantizar que cada territorio 
-- aparezca una sola vez en el listado devuelto.

-- PATRÓN 3: CÁLCULOS DERIVADOS DE DENSIDAD
-- Permite calcular indicadores territoriales combinando agregación y métricas de superficie.
-- Fórmula típica: SUM(poblacion) / (ST_Area(geom) / 1000000)
-- NOTA MÉTRICA: Se divide ST_Area entre 1.000.000 para convertir metros cuadrados (m²) 
-- a kilómetros cuadrados (km²), obteniendo la densidad en personas/km².

-- REGLA DE ORO DE AGREGACIÓN Y GROUP BY EN POSTGIS:
-- Cualquier columna no agregada (que no esté envuelta en SUM, COUNT, AVG, etc.) 
-- que aparezca en el SELECT o que sea utilizada dentro de una función espacial 
-- (como ST_Area) DEBE incluirse explícitamente en la cláusula GROUP BY.