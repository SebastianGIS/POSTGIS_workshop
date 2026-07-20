CREATE TABLE geometries (name varchar, geom geometry);

INSERT INTO geometries VALUES
  ('Point', 'POINT(0 0)'),
  ('Linestring', 'LINESTRING(0 0, 1 1, 2 1, 2 2)'),
  ('Polygon', 'POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'),
  ('PolygonWithHole', 'POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(1 1, 1 2, 2 2, 2 1, 1 1))'),
  ('Collection', 'GEOMETRYCOLLECTION(POINT(2 0),POLYGON((0 0, 1 0, 1 1, 0 1, 0 0)))');

SELECT name, ST_AsText(geom) FROM geometries;

/* Este es un script de ejemplo, lo que hace es crear una tabla llamada "geometries", luego inserta 5 geometrías. Un punto,
una línea, un polígono, un polígono con agujeros y una colección, finalmente se seleccionan los campos. */

SELECT * FROM geometry_columns; --Da una lista de todas las features y sus detalles básicos.

-- ------------------------

SELECT name, ST_GeometryType(geom), ST_NDims(geom), ST_SRID(geom) 
FROM geometries;

/* 
	ST_GeometryType() devuelve el tipo de geometría
	ST_NDims() devuelve el número de dimensiones de la geometría
	ST_SRID() devuelve el identificador de la referencia espacial de la geometría
*/


SELECT ST_AsText(geom)
FROM geometries
WHERE name = 'Point'; --Selecciona el punto de geometries

/* 
	ST_X(geometry) returns the X ordinate
	ST_Y(geometry) returns the Y ordinate
*/

SELECT ST_X(geom), ST_Y(geom)
FROM geometries
WHERE name = 'Point';

SELECT name, ST_AsText(geom)
FROM nyc_subway_stations
LIMIT 1; --Obtenemos una geometría asociada a un punto de la tabla nyc_subway_stations

SELECT ST_AsText(geom)
FROM geometries
WHERE name = 'Linestring'; --Geometría asociada a una línea

/* Algunas funciones útiles asociadas a líneas

	ST_Length(geometry) returns the length of the linestring
	ST_StartPoint(geometry) returns the first coordinate as a point
	ST_EndPoint(geometry) returns the last coordinate as a point
	ST_NPoints(geometry) returns the number of coordinates in the linestring

*/

SELECT ST_AsText(geom)
FROM geometries
WHERE name LIKE 'Polygon%'; --Geometría asociada a polígonos


/* Funciones útiles asociadas a polígonos

	ST_Area(geometry) returns the area of the polygons
	ST_NRings(geometry) returns the number of rings (usually 1, more if there are holes)
	ST_ExteriorRing(geometry) returns the outer ring as a linestring
	ST_InteriorRingN(geometry,n) returns a specified interior ring as a linestring
	ST_Perimeter(geometry) returns the length of all the rings

*/

-- Collections (estos son como las features con multiparts)
SELECT name, ST_AsText(geom)
FROM geometries
WHERE name = 'Collection'; --Geometría asociada a colecciones

/* Las geometrías se guardan en un formato que solo PostGIS puede leer, para que estas puedan ser exportadas y leídas por otros
programas/apps, hay que realizar conversiones, en este sentido, hay varias funciones para conversiones a formatos como WKT, GeoJSON, KML, etc. */


-- Resumen

-- TIPOS DE GEOMETRÍAS RELEVANTES
-- POINT(X Y): Un único par de coordenadas.
-- LINESTRING(X1 Y1, X2 Y2...): Una secuencia de puntos conectados.
-- POLYGON((X1 Y1..., X1 Y1)): Una figura cerrada. El primer y último punto coinciden.
-- POLYGON((Exterior),(Interior)): Polígono con agujero (el 2do anillo resta área).
-- GEOMETRYCOLLECTION(...): Mezcla de múltiples tipos de geometría en un solo registro.

-- METADATOS Y VISTAS DEL SISTEMA
-- geometry_columns: Vista global del sistema que cataloga todas las tablas 
-- con columnas espaciales, mostrando su tipo de geometría, dimensiones y SRID.

-- FUNCIONES DE PROPIEDADES GENERALES
-- ST_AsText(geom): Convierte el binario interno de PostGIS a formato de texto WKT legible.
-- ST_GeometryType(geom): Retorna el tipo de objeto (ej. ST_Point, ST_Polygon).
-- ST_NDims(geom): Indica las dimensiones espaciales (2D, 3D con Z, o 4D con Z y M).
-- ST_SRID(geom): Retorna el identificador del Sistema de Referencia Espacial.

-- FUNCIONES ESPECÍFICAS PARA PUNTOS
-- ST_X(geom) / ST_Y(geom): Extraen la coordenada longitudinal o latitudinal de un punto.

-- FUNCIONES ESPECÍFICAS PARA LÍNEAS
-- ST_Length(geom): Calcula la longitud de la línea en las unidades del SRID.
-- ST_StartPoint(geom) / ST_EndPoint(geom): Retornan el primer y último vértice como puntos.
-- ST_NPoints(geom): Cuenta la cantidad total de vértices que componen la línea.

-- FUNCIONES ESPECÍFICAS PARA POLÍGONOS
-- ST_Area(geom): Calcula la superficie total encerrada (restando los agujeros si existen).
-- ST_Perimeter(geom): Calcula la longitud sumada de todos sus anillos (exterior + interiores).
-- ST_NRings(geom): Cuenta el número de anillos (1 si es sólido, >1 si tiene agujeros).
-- ST_ExteriorRing(geom): Extrae solo el borde externo como una línea (Linestring).
-- ST_InteriorRingN(geom, n): Extrae el anillo interior número 'n' como una línea.
