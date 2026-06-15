--- Verificación de estructura de columnas
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name IN (
    'w090_n20_w085_n15_municipio',
    'w090_n25_w085_n20_municipio',
    'w095_n15_w090_n10_municipio'
)
ORDER BY table_name, ordinal_position;

---Creación de tablas homologadas
DO $$
DECLARE
    t text;
BEGIN
    FOREACH t IN ARRAY ARRAY[
        'w090_n20_w085_n15',
        'w090_n25_w085_n20',
        'w095_n15_w090_n10'
    ]
    LOOP

        EXECUTE format('
            DROP TABLE IF EXISTS %I_final;

            CREATE TABLE %I_final AS
            SELECT
                fid,
                cvegeo,
                cve_ent,
                cve_mun,
                nomgeo,
                geom,
                source,
                id,
                height,
                var,
                region,
                area,
                x,
                y
            FROM %I_municipio;
        ', t, t, t);

    END LOOP;
END $$;

---Integración nacional
CREATE TABLE edificios_nacional AS

SELECT * FROM w090_n20_w085_n15_final
UNION ALL
SELECT * FROM w090_n25_w085_n20_final
UNION ALL
SELECT * FROM w095_n15_w090_n10_final
UNION ALL
SELECT * FROM w095_n20_w090_n15_final
UNION ALL
SELECT * FROM w095_n25_w090_n20_final
UNION ALL
SELECT * FROM w100_n20_w095_n15_final
UNION ALL
SELECT * FROM w100_n25_w095_n20_final
UNION ALL
SELECT * FROM w100_n30_w095_n25_final
UNION ALL
SELECT * FROM w105_n20_w100_n15_final
UNION ALL
SELECT * FROM w105_n25_w100_n20_final
UNION ALL
SELECT * FROM w105_n30_w100_n25_final
UNION ALL
SELECT * FROM w105_n35_w100_n30_6372_final
UNION ALL
SELECT * FROM w110_n20_w105_n15_final
UNION ALL
SELECT * FROM w110_n25_w105_n20_final
UNION ALL
SELECT * FROM w110_n30_w105_n25_final
UNION ALL
SELECT * FROM w110_n35_w105_n30_final
UNION ALL
SELECT * FROM w115_n25_w110_n20_final
UNION ALL
SELECT * FROM w115_n30_w110_n25_final
UNION ALL
SELECT * FROM w115_n35_w110_n30_final
UNION ALL
SELECT * FROM w120_n30_w115_n25_final
UNION ALL
SELECT * FROM w120_n35_w115_n30_final;
