SELECT ST_Intersects(geom, ST_Centroid(geom)) AS centroid_inside,
       ST_Intersects(geom, ST_PointOnSurface(geom)) AS pos_inside
FROM (VALUES
    ('POLYGON ((30 0, 30 10, 10 10, 10 40, 30 40, 30 50, 0 50, 0 0, 0 0, 30 0))'::geometry)
  ) AS t(geom);

--ST_Centroid --> Retorna un punto que se encuentra aproximadamente en el centro de masa de la geometría que va como input
--ST_PointOnSurface --> Retorna un punto garantizado que se encuentra dentro del input

CREATE TABLE liberty_island_zone AS
SELECT ST_Buffer(geom,500)::geometry(Polygon,26918) AS geom
FROM nyc_census_blocks
WHERE blkid = '360610001001001'; --ST_Buffer


SELECT ST_AsText(ST_Intersection(
  ST_Buffer('POINT(0 0)', 2),
  ST_Buffer('POINT(3 0)', 2)
)); --ST_Intersection


SELECT ST_AsText(ST_Union(
  ST_Buffer('POINT(0 0)', 2),
  ST_Buffer('POINT(3 0)', 2)
)); --ST_Union

/* Lista de funciones
ST_Centroid(geometry): Returns a point geometry that represents the center of mass of the input geometry.

ST_PointOnSurface(geometry): Returns a point geometry that is guaranteed to be in the interior of the input geometry.

ST_Buffer(geometry, distance): For geometry: Returns a geometry that represents all points whose distance from this Geometry is less than or equal to distance. Calculations are in the Spatial Reference System of this Geometry. For geography: Uses a planar transform wrapper.

ST_Intersection(geometry A, geometry B): Returns a geometry that represents the shared portion of geomA and geomB. The geography implementation does a transform to geometry to do the intersection and then transform back to WGS84.

ST_Union(): Returns a geometry that represents the point set union of the Geometries.

ST_AsText(text): Returns the Well-Known Text (WKT) representation of the geometry/geography without SRID metadata.

substring(string [from int] [for int]): PostgreSQL string function to extract substring matching SQL regular expression.

sum(expression): PostgreSQL aggregate function that returns the sum of records in a set of records. */


-- RESUMEN

-- PUNTOS REPRESENTATIVOS: CENTROIDES VS. PUNTOS EN SUPERFICIE
-- ST_Centroid(geom): Retorna el centro de masa geométrico del objeto.
--   ¡ATENCIÓN EN POLÍGONOS CON FORMA DE 'C' U 'O'!: El centroide matemático 
--   puede caer en el "vacío" (fuera del polígono).
-- ST_PointOnSurface(geom): Retorna un punto GARANTIZADO de estar DENTRO del polígono.
-- USO PRÁCTICO EN TU APP: Usa siempre ST_PointOnSurface si necesitas etiquetar o 
--   ubicar un texto/marcador en el mapa sobre un polígono irregular.

-- GENERACIÓN DE ÁREAS DE INFLUENCIA (BUFFERS)
-- ST_Buffer(geom, distancia): Crea una nueva geometría poligonal expansiva a una 
--   distancia determinada en las unidades del SRID (ej. metros).
-- USO PRÁCTICO EN TU APP: Es la función exacta para el botón "Analizar". Toma el KML 
--   del usuario y genera el polígono de 200 metros: ST_Buffer(geom_proyecto, 200).
-- PERSTISTENCIA CON CREATE TABLE AS: Permite guardar directamente el resultado del 
--   buffer en una tabla nueva con su correspondiente casting explícito ::geometry(Polygon, SRID).

-- OPERACIONES BOOLEANAS CORTANTES (INTERSECCIÓN Y UNIÓN)
-- ST_Intersection(geomA, geomB): Retorna la GEOMETRÍA EXACTA de la zona donde A y B se cruzan 
--   (corta y extrae el retazo de superposición).
--   DIFERENCIA CON ST_Intersects: ST_Intersects devuelve TRUE/FALSE; ST_Intersection 
--   devuelve la FORMA GEOMÉTRICA resultante.
-- USO PRÁCTICO EN TU APP: Permite mostrarle al usuario en el mapa la figura recortada 
--   del área afectada (ej. "se intersectaron 15 hectáreas de esta zona de protección").

-- ST_Union(geomA, geomB) / ST_Union(geom): Fusiona o disuelve múltiples geometrías en una sola.
-- USO PRÁCTICO: Permite disolver o unir varios predios o lotes continuos en un solo gran 
--   polígono unificado antes de hacer el análisis territorial.

-- MANIPULACIÓN DE TEXTO EN POSTGRESQL
-- substring(string [from inicio] [for longitud]): Función nativa de texto en SQL 
--   útil para limpiar o extraer fragmentos de códigos prediales, KMLs o cadenas WKT.