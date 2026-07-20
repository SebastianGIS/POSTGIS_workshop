SELECT name Neighborhood, ST_AREA(geom) AS área , geom --El área de la función ST_AREA() sale en metros cuadrados
FROM nyc_neighborhoods
WHERE name = 'West Village' --Este script saca el área de la neighborhood West Village. 



SELECT * , ST_GeometryType(geom) AS Tipo_geometría, ST_Length(geom) AS Largo
FROM nyc_streets
WHERE name = 'Pelham St'; --Obtener el largo y el tipo de geometría de la feature con nombre Pelham St



SELECT name, ST_AsGeoJSON(geom) AS GeoJSON
FROM nyc_subway_stations
WHERE name = 'Broad St'; --Obtener la representación en geoJSON de la feature con nombre Broad St



SELECT sum(ST_Length(geom))/1000 AS Kilómetros
FROM nyc_streets; -- Total de kilómetros entre todas las calles de NYC



SELECT sum(ST_Area(geom)) / 4047
FROM nyc_neighborhoods
WHERE boroname = 'Manhattan' --Área de Manhattan a acres (se divide longitud entre 4047)



SELECT name, min(ST_X(geom)) AS X
FROM nyc_subway_stations
GROUP BY name
ORDER BY X ASC; --Obtener la estación más hacia el oeste



SELECT ST_Length(geom)
FROM nyc_streets
WHERE name = 'Columbus Cir'; --Longitud



SELECT type AS Tipo_calle, sum(ST_Length(geom)) AS Largo
FROM nyc_streets
GROUP BY type; --Longitud de las calles en NYC agrupadas por tipo}


-- Resumen
-- CÁLCULOS MÉTRICOS BÁSICOS
-- ST_Area(geom): Retorna la superficie de un polígono. La unidad de medida 
-- depende estrictamente del SRID de los datos (en este caso, metros cuadrados).
-- ST_Length(geom): Retorna la longitud de una línea o perímetro de un polígono 
-- en las unidades del SRID (en este caso, metros).

-- OPERACIONES ARITMÉTICAS CON GEOMETRÍAS
-- Las funciones espaciales devuelven números puros, lo que permite operarlos 
-- matemáticamente en la misma consulta:
-- Ej. Pasar metros a kilómetros: ST_Length(geom) / 1000
-- Ej. Pasar metros cuadrados a acres: ST_Area(geom) / 4047

-- EXPORTACIÓN DE FORMATOS WEB
-- ST_AsGeoJSON(geom): Convierte la geometría binaria de la base de datos a una 
-- cadena de texto en formato estructurado GeoJSON. Este formato es el estándar 
-- universal que leerá tu mapa interactivo en el frontend.

-- INTEGRACIÓN DE ESPACIALIDAD CON AGREGACIÓN Y ORDENAMIENTO (SQL CORE)
-- 1. Agregación Espacial (SUM): Permite consolidar longitudes o áreas totales.
--    Ej. sum(ST_Length(geom)) calcula la red vial completa de una categoría.
-- 2. Ordenamiento Geográfico (ORDER BY + MIN/MAX): Permite buscar extremos espaciales.
--    Ej. Buscar el valor mínimo de ST_X(geom) sirve para encontrar el punto 
--    ubicado más hacia el Oeste (coordenada X más baja en el plano cartesiano).