-- 1.- Como primer paso se crea una base de datos

-- 2.- Creamos la extensión espacial
CREATE EXTENSION postgis;

/*
   3.- Se cargan las capas mediante la consola de CMD para convirterlas en tabla,
       con las siguientes instrucciones.
   Para el geopakage:
ogr2ogr -f "PostgreSQL" PG:"host=localhost dbname=(NOMBRE DE LA BD) user=postgres password=****" "C:RUTA DEL GEOPAKAGE .gpkg" -nln Mexico1a1mll -lco GEOMETRY_NAME=geom

   Para el CSV:
ogr2ogr -overwrite -f "PostgreSQL" PG:"host=localhost dbname=(NOMBRE DE LA BD) user=postgres password=****" "RUTA DEL ARCHVIO CSV SHF_BASE_VARIABLES_SELECTAS.csv" -nln shf_base_variables_selectas -oo X_POSSIBLE_NAMES=Lon2 -oo Y_POSSIBLE_NAMES=Lat2 -a_srs EPSG:4326 -lco GEOMETRY_NAME=geom

NOTA: DENTRO DE LA INSTRUCCIÓN PARA CARGAR EL CSV A LA BD ESTA EL PARAMETRO DE PROYECCIÓN Y EN ESTA OCASIÓN SE OCUPO LA EPSG:4326
*/

-- 4.- Verificar cuentos registros tiene cada tabla
SELECT COUNT(*) FROM mexico1a1mll;
SELECT COUNT(*) FROM shf_base_variables_selectas;

-- 5.- Verificar geometrias en ambas tablas
SELECT ST_SRID(geom) FROM mexico1a1mll LIMIT 1;
SELECT ST_SRID(geom) FROM shf_base_variables_selectas LIMIT 1;

-- 6.- Creación de indices espaciales, la cual reduce el tiempo dentro de la comparativa
CREATE INDEX IF NOT EXISTS shf_base_variables_selectas_geom_idx
ON shf_base_variables_selectas
USING GIST (geom);

CREATE INDEX IF NOT EXISTS mexico1a1mll_geom_idx
ON mexico1a1mll
USING GIST (geom);

-- 7.- Analiza las tablas y libera espacio
ANALYZE shf_base_variables_selectas;
ANALYZE mexico1a1mll;


-- 8.- Analisis, para la comparación de puntos dentro de la zona de estudio

    /*  Elimina la tabla en caso de existir para no generar valores incorrectos,
	    si no existe, omite en automatico este paso*/
DROP TABLE IF EXISTS shf_limpio;

    /*  Crea una nueva tabla, donde se guardaran los registros que sí esten
	    dentro de la zona de estudio, para posteriormente guardar el producto en
		un archivo geopackage*/
CREATE TABLE shf_limpio AS
SELECT p.*
FROM shf_base_variables_selectas p
JOIN mexico1a1mll m
ON ST_Intersects(p.geom, m.geom);

-- 9.- Revisamos los registros para comparar y ver cuantos registros quedaban fuera
SELECT COUNT(*) FROM shf_limpio;
SELECT COUNT(*) FROM shf_base_variables_selectas;

-- 10.- Creamos índice para la nueva tabla
CREATE INDEX shf_limpio_geom_idx
ON shf_limpio
USING GIST (geom);
-- 11.- Analizamos y limpiamos almacenamiento de la nueva tabla
ANALYZE shf_limpio;

/*
   12.- Como paso final se manda la instrucción por consola CMD para guardar
        la tabla final como un archivo .geopackage
ogr2ogr -overwrite -f GPKG "C-RUTA DEL ARCHIVO SHF_LIMPIO.gpkg" PG:"host=localhost dbname=(NOMBRE DE LA BD) user=postgres password=****" shf_limpio
*/