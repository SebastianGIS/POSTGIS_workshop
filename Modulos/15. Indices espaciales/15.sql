DROP INDEX nyc_census_blocks_geom_idx; --Borra un índice}


CREATE INDEX nyc_census_blocks_geom_idx --Crea un índice
  ON nyc_census_blocks --En esta tabla
  USING GIST (geom); --USING GIST -->Usa una estructura de índices genérica

SELECT count(blocks.blkid)
 FROM nyc_census_blocks blocks
 JOIN nyc_subway_stations subways
 ON ST_Contains(blocks.geom, subways.geom)
 WHERE subways.name LIKE 'B%'; --Comparar cuanto se demora la query con y sin índice (48 ms vs 164 ms)

 /* Las funciones más uasadas como ST_Intersects, ST_Contains o ST_DWithin incluyen un filtro por índice automático,
 pero hay otras funciones que no, como ST_Relate. */

ANALYZE nyc_census_blocks; /*Es importante correr ANALYZE en tablas que se vayan actualizando frecuentemente, como por ejemplo
al eliminar o agregar muchos registros, esto mantendrá las estadísticas de la tabla e índices al día*/

VACUUM ANALYZE nyc_census_blocks; --VACUUM recupera espacio, es útil usarlo junto a ANALYZE después de grandes cargas/delete de datos

--RESUMEN
-- CONCEPTO DE ÍNDICE ESPACIAL (GIST - Generalized Search Tree)
-- Un índice GiST no organiza los datos alfabéticamente o numéricamente, sino que 
-- construye un árbol jerárquico de "cajas delimitadoras" (Bounding Boxes / BBOX / R-Tree).
-- Permite descartar de un solo golpe el 99% del territorio que no se cruza 
-- con el área de interés antes de hacer el cálculo geométrico preciso.

-- CREACIÓN Y BORRADO DE ÍNDICES ESPACIALES
-- CREATE INDEX nombre_indice ON tabla USING GIST (columna_geom);
--   Crea el índice espacial. Es una regla obligatoria en producción para toda 
--   columna geométrica que vaya a ser usada en JOINs o filtros WHERE.
-- DROP INDEX nombre_indice;
--   Elimina el índice de la base de datos.

-- INDEX AUTO-INDEXING (USO AUTOMÁTICO DE ÍNDICES)
-- Las funciones espaciales más comunes (ST_Intersects, ST_Contains, ST_Within, ST_DWithin) 
-- incluyen internamente un filtro explícito que aprovecha el índice GiST automáticamente.
-- NOTA: Algunas funciones avanzadas o de construcción pura (como ST_Relate) NO aprovechan 
-- el índice de forma automática; para esas, se debe filtrar primero usando la caja delimitadora (&&).

-- MANTENIMIENTO DE LA BASE DE DATOS (ANALYZE & VACUUM)
-- ANALYZE tabla;
--   Actualiza las estadísticas internas que el optimizador de consultas (Query Planner) 
--   utiliza para decidir la ruta más rápida de ejecución. Se debe correr después de cargas 
--   masivas o modificaciones intensivas de datos.
-- VACUUM ANALYZE tabla;
--   Recupera el espacio físico en disco ocupado por registros eliminados o actualizados 
--   (tuples muertos) y actualiza las estadísticas al mismo tiempo. Crucial en procesos ETL.