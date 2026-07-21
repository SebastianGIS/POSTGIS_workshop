SELECT ST_AsText(geom)
FROM nyc_streets
WHERE name = 'Atlantic Commons'; --Valor de la geometría de la calle Atlantic Commons

SELECT name, boroname
FROM nyc_neighborhoods
WHERE ST_Contains(geom, ST_GeomFromText('MULTILINESTRING((586781.7015777241 4504202.153143394,586863.5196448397 4504215.988170098))' , 26918));
/*Calcular en qué neighborhood y borough está Atlantic Commons, para esto se tiene que pasar a la función Contains la calle trasnformada a geometría
desde su forma en texto, y además se añade como parámetro el SRID*/

SELECT name
FROM nyc_streets
WHERE ST_Touches(geom , ST_GeomFromText('MULTILINESTRING((586781.7015777241 4504202.153143394,586863.5196448397 4504215.988170098))' , 26918));

SELECT SUM(popn_total)
FROM nyc_census_blocks
WHERE ST_DWithin(ST_GeomFromText('MULTILINESTRING((586781.7015777241 4504202.153143394,586863.5196448397 4504215.988170098))', 26918) ,geom , 50);
-- Calcula cuantas personas viven (en base al censo) a 50 metros de la calle Atlantic Commons

--RESUMEN

-- CONSTRUCCIÓN DE GEOMETRÍAS AL VUELO DESDE WKT
-- ST_GeomFromText('TIPO(...)', SRID): Permite instanciar una geometría
--   a partir de una cadena de texto en formato WKT pasando el SRID explícito
--   como segundo parámetro (ej. 32719 para UTM Zona 19S).
-- USO PRÁCTICO: Permite usar una geometría fija extraída previamente 
--   como filtro para cruzar contra otras tablas sin necesidad de joins complejos.

-- IDENTIFICACIÓN DE UBICACIÓN (CONTENCIÓN)
-- ST_Contains(geom_poligono, geom_elemento):
-- USO PRÁCTICO: Permite responder a la pregunta "¿En qué barrio, comuna o 
--   distrito se encuentra ubicado este elemento (punto, línea o polígono)?".

-- IDENTIFICACIÓN DE COLINDANCIA O CONECTIVIDAD (CONTACTO)
-- ST_Touches(geom_A, geom_B):
-- USO PRÁCTICO: Permite encontrar elementos adyacentes o conectados. 
--   En redes viales, sirve para hallar qué calles se intersectan/conectan 
--   en los extremos de una vía específica sin atravesar su interior.

-- ANÁLISIS DE ÁREA DE INFLUENCIA Y POBLACIÓN AFECTADA
-- ST_DWithin(geom_origen, geom_destino, distancia_metros):
-- USO PRÁCTICO: Realiza búsquedas por radio de proximidad extremadamente rápidas.
--   Al combinarlo con funciones de agregación como sum(poblacion), permite 
--   calcular el impacto demográfico o territorial a una distancia determinada 
--   (ej. cuánta población vive a menos de 50 metros de un eje vial o proyecto).