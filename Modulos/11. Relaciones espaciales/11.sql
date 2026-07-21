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

-- ST_Within y ST_Contains

-- ST_Distance y ST_DWithin

SELECT ST_Distance(
  ST_GeometryFromText('POINT(0 5)'),
  ST_GeometryFromText('LINESTRING(-2 2, 2 2)'));

-- Resumen

-- EVALUACIÓN DE INTERSECCIÓN Y COINCIDENCIA
-- ST_Intersects(geomA, geomB): Evalúa si dos geometrías comparten CUALQUIER porción de espacio.
--   Es la función más rápida y utilizada. Es lo opuesto a ST_Disjoint.
-- ST_Disjoint(geomA, geomB): Retorna TRUE si las geometrías NO se tocan en absoluto (no comparten espacio).
-- ST_Equals(geomA, geomB): Retorna TRUE si ambas geometrías ocupan exactamente el mismo espacio físico,
--   sin importar la dirección o el orden en que se digitalizaron sus vértices.

-- EVALUACIÓN DE CONTENCIÓN (DENTRO / FUERA)
-- ST_Contains(geomA, geomB): Retorna TRUE si la geometría B está COMPLETAMENTE dentro de la geometría A.
--   (La geometría A "contiene" a B).
-- ST_Within(geomA, geomB): Retorna TRUE si la geometría A está COMPLETAMENTE dentro de la geometría B.
--   (Es la función inversa de ST_Contains: A está "dentro de" B).

-- EVALUACIÓN DE CONTACTO Y SUPERPOSICIÓN
-- ST_Touches(geomA, geomB): Retorna TRUE si las geometrías se tocan solo en sus bordes/límites,
--   pero sus interiores no se cruzan en absoluto (ej. dos predios colindantes).
-- ST_Crosses(geomA, geomB): Retorna TRUE si comparten solo una parte de sus interiores y son de
--   distinta dimensión o se cruzan puntualmente (ej. una calle/línea cruzando un barrio/polígono).
-- ST_Overlaps(geomA, geomB): Retorna TRUE si comparten espacio y son de la MISMA dimensión,
--   pero ninguna contiene por completo a la otra (ej. dos polígonos que se solapan parcialmente).

-- CÁLCULOS Y FILTROS DE DISTANCIA
-- ST_Distance(geomA, geomB): Retorna la distancia mínima cartesiana entre los puntos más cercanos
--   de ambas geometrías (en las unidades del SRID, ej. metros).
-- ST_DWithin(geomA, geomB, radio): Retorna TRUE si la distancia entre A y B es menor o igual al radio.
--   CONSEJO DE RENDIMIENTO: Es muchísimo más rápido usar ST_DWithin(A, B, 200) que generar un buffer 
--   con ST_Buffer y luego filtrar con ST_Intersects, ya que ST_DWithin aprovecha directamente los índices espaciales (GiST).