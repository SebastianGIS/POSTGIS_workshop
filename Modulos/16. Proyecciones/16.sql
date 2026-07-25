SELECT ST_SRID(geom) FROM nyc_streets LIMIT 1; --Sirve para confirmar el SRID de una tabla

SELECT * FROM spatial_ref_sys WHERE srid = 32719; 

--RESUMEN
-- CONSULTA DE METADATOS DE PROYECCIÓN
-- ST_SRID(geom): Devuelve el código numérico (EPSG) asignado a una geometría.
-- SELECT * FROM spatial_ref_sys WHERE srid = 32719;
--   Consulta la tabla del sistema que contiene las definiciones cartográficas 
--   de todos los SRID conocidos (parámetros de proyección, elipsoides, unidades).

-- DIFERENCIA CRÍTICA: ST_SetSRID VS. ST_Transform

-- 1. ST_SetSRID(geom, srid) -> ASIGNA O CAMBIA LA ETIQUETA (SIN RECALCULAR)
--   Solo cambia la "etiqueta" del SRID en los metadatos de la geometría; NO modifica 
--   las coordenadas numéricas (X, Y).
-- USO PRÁCTICO: Se usa cuando importas datos sin proyección asignada (SRID 0) 
--   pero sabes con certeza en qué coordenadas reales se encuentran.
--   ¡CUIDADO!: Si usas ST_SetSRID para intentar convertir grados a metros, 
--   corromperás la ubicación espacial del dato.

-- 2. ST_Transform(geom, srid) -> RECALCULA LAS COORDENADAS (PROYECCIÓN REAL)
--   Toma las coordenadas actuales de la geometría y las RECALCULA matemáticamente 
--   para convertirlas a las coordenadas equivalentes en el sistema de destino.
-- USO PRÁCTICO: Convertir datos web en grados (WGS84 / SRID 4326) a un sistema 
--   métrico proyectado (ej. UTM Zona 19S / SRID 32719) para realizar buffers o mediciones exactas.

--CONCEPTOS CLAVE
-- 1. Coordenadas Geográficas (SRID 4326 - WGS84):
--    - Unidades: Grados decimales (-70.65, -33.45).
--    - Uso: Estándar universal para visualizar en la web (Leaflet, OpenLayers, archivos KML/KMZ).
--    - Limitación: NO sirve para medir distancias en metros directamente (ST_Buffer(geom, 200) 
--      aquí crearía un buffer de 200 grados, cubriendo casi todo el planeta).

-- 2. Coordenadas Proyectadas / Planas (ej. SRID 32719 - UTM 19S Chile):
--    - Unidades: Metros.
--    - Uso: Análisis métrico exacto (superficies, distancias, buffers de 200m).
--    - Flujo típico en tu Backend: 
--      A. Recibir KML en SRID 4326 (Grados).
--      B. Convertir a SRID 32719 con ST_Transform (Metros).
--      C. Aplicar ST_Buffer(200) o intersecciones.
--      D. Convertir de nuevo el resultado a SRID 4326 con ST_Transform para enviarlo al Frontend.