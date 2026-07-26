SELECT ST_Distance(
  'SRID=4326;POINT(-118.4079 33.9434)'::geometry, -- Los Angeles (LAX)
  'SRID=4326;POINT(2.5559 49.0083)'::geometry     -- Paris (CDG)
  ); --Mide la distancia entre ambos puntos en grados. Pero el tamaño de los grados al ser variable, hace que esta signifique nada.


SELECT ST_Distance(
  'SRID=4326;POINT(-118.4079 33.9434)'::geography, -- Los Angeles (LAX)
  'SRID=4326;POINT(2.5559 49.0083)'::geography     -- Paris (CDG)
  ); --Al usar el tipo geography, devuelve los cálculos en metros.


SELECT ST_Distance(
  ST_GeographyFromText('LINESTRING(-118.4079 33.9434, 2.5559 49.0083)'), -- LAX-CDG
  ST_GeographyFromText('POINT(-22.6056 63.9850)')                        -- Iceland (KEF)
);