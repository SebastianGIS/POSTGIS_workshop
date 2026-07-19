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
