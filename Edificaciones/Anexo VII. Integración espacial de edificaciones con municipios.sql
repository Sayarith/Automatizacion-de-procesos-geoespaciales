--- Ejemplo de unión espacial
CREATE TABLE w105_n35_w100_n30_6372_municipio AS
SELECT
    m.cvegeo,
    m.cve_ent,
    m.cve_mun,
    m.nomgeo,
    e.*
FROM municipios m
JOIN w105_n35_w100_n30_6372 e
ON ST_Intersects(
    m.geom,
    ST_PointOnSurface(e.geom)
);


---Verificación de registros generados
SELECT COUNT(*)
FROM w105_n35_w100_n30_6372_municipio;


---Automatización para múltiples cuadrantes
DO $$
DECLARE
    t text;
BEGIN
    FOREACH t IN ARRAY ARRAY[
        'w110_n30_w105_n25',
        'w105_n30_w100_n25',
        'w105_n25_w100_n20',
        'w105_n20_w100_n15',
        'w100_n25_w095_n20',
        'w100_n20_w095_n15',
        'w095_n20_w090_n15'
    ]
    LOOP

        EXECUTE format('
            CREATE TABLE %I_municipio AS
            SELECT
                m.cvegeo,
                m.cve_ent,
                m.cve_mun,
                m.nomgeo,
                e.*
            FROM municipios m
            JOIN %I e
            ON ST_Intersects(
                m.geom,
                ST_PointOnSurface(e.geom)
            );
        ', t, t);

    END LOOP;
END $$;
