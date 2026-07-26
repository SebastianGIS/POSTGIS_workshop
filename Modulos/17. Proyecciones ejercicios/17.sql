SELECT ST_SRID(geom)
FROM nyc_streets; --Devuelve el SIRD de las geometrías

SELECT sum(ST_Length(geom))
FROM nyc_streets; --Largo de las calles

SELECT *
FROM spatial_ref_sys
WHERE srid = 2831; --Obtener info y WKT del SRID 2831

SELECT sum(ST_Length(ST_Transform(geom, 2831)))
FROM nyc_streets; --Largo de las calles en SRID 2831

SELECT Count(*)
FROM nyc_streets
WHERE ST_Intersects(
  ST_Transform(geom, 4326),
  'SRID=4326;LINESTRING(-74 20, -74 60)'
  );


--RESUMEN
-- CONSULTA Y VALIDACIÓN DE METADATOS
-- ST_SRID(geom): Retorna el código numérico del sistema de referencia de la geometría.
--   Es vital para verificar que dos capas compartan el mismo SRID antes de realizar un JOIN.

-- INSPECCIÓN DE LA TABLA SPATIAL_REF_SYS
-- SELECT * FROM spatial_ref_sys WHERE srid = XXXX;
--   Permite consultar los parámetros cartográficos, la unidad de medida (metros, pies, grados) 
--   y la representación WKT (srtext) de cualquier sistema de referencia registrado en PostGIS.

-- TRANSFORMACIÓN DE COORDENADAS PARA CÁLCULOS DÍNAMICOS
-- ST_Transform(geom, srid_destino): Recalcula matemáticamente las coordenadas.
-- USO PRÁCTICO EN CÁLCULOS:
--   Ej. sum(ST_Length(ST_Transform(geom, 2831)))
--   Permite transformar la geometría a un SRID específico únicamente dentro de la función de cálculo, 
--   obteniendo la medición en las unidades del nuevo sistema sin alterar los datos originales guardados en la tabla.

-- INTERSECCIÓN DINÁMICA CON DIVERGENCIA DE SRID (PATRÓN EWKT)
-- Sintaxis: ST_Intersects(ST_Transform(geom_tabla, 4326), 'SRID=4326;TIPO(...)')
-- CONCEPTO CLAVE (EWKT - Extended Well-Known Text): 
--   Al anteponer 'SRID=4326;' a la cadena de texto de la geometría, le indicas explícitamente 
--   a PostGIS el sistema de referencia de ese objeto al momento de instanciarlo.
-- USO PRÁCTICO: Permite igualar los sistemas de referencia de dos geometrías que provienen 
--   de distintas fuentes (por ejemplo, transformar una capa almacenada en metros a WGS84/4326 
--   para cruzarla con un trazo enviado en coordenadas geográficas desde el mapa del navegador web).