-- Funciones

-- ST_Equals
SELECT name, geom
FROM nyc_subway_stations
WHERE name = 'Broad St';

SELECT name
FROM nyc_subway_stations
WHERE ST_Equals(
  geom,
  '0101000020266900000EEBD4CF27CF2141BC17D69516315141');

-- ST_Intersects , ST_Disjoint, ST_Crosses ST_Overlaps

SELECT name, ST_AsText(geom)
FROM nyc_subway_stations
WHERE name = 'Broad St'; 


SELECT name, boroname
FROM nyc_neighborhoods
WHERE ST_Intersects(geom, ST_GeomFromText('POINT(583571 4506714)',26918));


-- ST_Touches

