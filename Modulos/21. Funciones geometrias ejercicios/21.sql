SELECT COUNT(*)
FROM nyc_census_blocks
WHERE ST_Contains(geom , ST_Centroid(geom)) = False; --Obtener los census blocks que no contienen su propio centroide


SELECT ST_UNION(geom), ST_AsText(ST_UNION(geom))
FROM nyc_census_blocks --Unir todos los census_blocks en un único registro

CREATE TABLE nyc_census_blocks_merge AS
SELECT ST_Union(geom) AS geom
  FROM nyc_census_blocks; --Crear tabla a partir de lo anterior

SELECT ST_NumGeometries(geom)
FROM nyc_census_blocks_merge; --Obtener cuántas partes tiene esta geometría

CREATE TABLE brooklyn_dmz AS
  SELECT
    ST_Intersection(
      ST_Buffer(ps.geom, 50),
      ST_Buffer(cg.geom, 50))
    AS geom
  FROM
    nyc_neighborhoods ps,
    nyc_neighborhoods cg
  WHERE ps.name = 'Park Slope'
  AND cg.name = 'Carroll Gardens';

SELECT ST_Area(geom) 
FROM brooklyn_dmz;


--RESUMEN

-- EVALUACIÓN DE ANOMALÍAS GEOMÉTRICAS (CENTROIDES OUT)
-- ST_Contains(geom, ST_Centroid(geom)) = False:
--   Permite detectar polígonos complejos (cóncavos, en forma de "C" u "O") 
--   donde el centro de masa cae fuera de la superficie del polígono.

-- DISSOLVE / FUSIÓN MASIVA DE GEOMETRÍAS (ST_Union como Agregador)
-- ST_Union(geom) utilizado dentro de un SELECT (o con GROUP BY):
--   Funciona como una función de agregación (similar a SUM o COUNT).
--   Fusiona o "disuelve" los límites de miles de polígonos individuales 
--   para convertirlos en una única gran superficie continua.

-- INSPECCIÓN DE ENTIDADES MULTIPARTE
-- ST_NumGeometries(geom):
--   Retorna la cantidad de geometrías individuales contenidas dentro de un 
--   objeto compuesto (MULTIPOLYGON, MULTILINESTRING o GEOMETRYCOLLECTION).
-- USO PRÁCTICO: Permite verificar si la fusión masiva dio como resultado un solo 
--   polígono unificado o un objeto multiparte compuesto por islas desconectadas.

-- DELIMITACIÓN DE ÁREAS DE AMORTIGUAMIENTO Y CONTACTO (BUFFER + INTERSECTION)
-- ST_Intersection(ST_Buffer(geomA, d1), ST_Buffer(geomB, d2)):
--   Patrón avanzado de análisis espacial que calcula de forma exacta el área 
--   donde las franjas de influencia (buffers) de dos entidades distintas colisionan.
-- USO PRÁCTICO EN TU APP: Permite definir zonas de amortiguamiento compartidas 
--   o franjas de restricción entre dos proyectos o variables ambientales cercanas.