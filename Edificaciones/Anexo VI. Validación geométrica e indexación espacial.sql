-- Validación geométrica
SELECT COUNT(*)
FROM w105_n35_w100_n30_6372
WHERE NOT ST_IsValid(geom);

-- Índice espacial para cuadrante
CREATE INDEX idx_w105_n35_w100_n30_6372_geom
ON w105_n35_w100_n30_6372
USING GIST(geom);

-- Índice espacial para municipios
CREATE INDEX idx_municipios_geom
ON municipios
USING GIST(geom);

--Creación masiva de índices espaciales
DO $$
DECLARE
    t text;
BEGIN
    FOREACH t IN ARRAY ARRAY[
        'w090_n20_w085_n15',
        'w090_n25_w085_n20',
        'w095_n15_w090_n10',
        'w095_n25_w090_n20',
        'w100_n30_w095_n25',
        'w110_n20_w105_n15',
        'w110_n25_w105_n20',
        'w110_n35_w105_n30',
        'w115_n25_w110_n20',
        'w115_n30_w110_n25',
        'w115_n35_w110_n30',
        'w120_n30_w115_n25',
        'w120_n35_w115_n30'
    ]
    LOOP

        EXECUTE format('
            CREATE INDEX idx_%I_geom
            ON %I
            USING GIST(geom);
        ', t, t);

    END LOOP;
END $$;
