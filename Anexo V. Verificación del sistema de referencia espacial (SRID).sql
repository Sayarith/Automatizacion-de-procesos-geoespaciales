-- Verificación del sistema de referencia de la capa municipal
SELECT ST_SRID(geom)
FROM municipios
LIMIT 1;

-- Verificación del sistema de referencia de los cuadrantes
SELECT ST_SRID(geom)
FROM w105_n35_w100_n30_6372
LIMIT 1;