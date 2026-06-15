-- Habilitación de la extensión espacial PostGIS
CREATE EXTENSION postgis;

-- Homologación del nombre de la capa municipal
ALTER TABLE azoteas_municipio_6372
RENAME TO municipios;
