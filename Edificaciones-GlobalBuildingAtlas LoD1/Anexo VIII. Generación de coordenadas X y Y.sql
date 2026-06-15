--- Cálculo de coordenadas
DO $$
DECLARE
    t text;
BEGIN
    FOREACH t IN ARRAY ARRAY[
        'w110_n30_w105_n25_municipio',
        'w105_n30_w100_n25_municipio',
        'w105_n25_w100_n20_municipio',
        'w105_n20_w100_n15_municipio',
        'w100_n25_w095_n20_municipio',
        'w100_n20_w095_n15_municipio',
        'w095_n20_w090_n15_municipio'
    ]
    LOOP

        EXECUTE format('
            ALTER TABLE %I
            ADD COLUMN x double precision,
            ADD COLUMN y double precision;
        ', t);

        EXECUTE format('
            UPDATE %I
            SET
                x = ST_X(ST_PointOnSurface(geom)),
                y = ST_Y(ST_PointOnSurface(geom));
        ', t);

    END LOOP;
END $$;

---Actualización masiva y validación
DO $$
DECLARE
    t text;
BEGIN
    FOREACH t IN ARRAY ARRAY[
        'w090_n20_w085_n15_municipio',
        'w090_n25_w085_n20_municipio',
        'w095_n15_w090_n10_municipio',
        'w095_n20_w090_n15_municipio',
        'w095_n25_w090_n20_municipio',
        'w100_n20_w095_n15_municipio',
        'w100_n25_w095_n20_municipio',
        'w100_n30_w095_n25_municipio',
        'w105_n20_w100_n15_municipio',
        'w105_n25_w100_n20_municipio',
        'w105_n30_w100_n25_municipio',
        'w105_n35_w100_n30_6372_municipio',
        'w110_n20_w105_n15_municipio',
        'w110_n25_w105_n20_municipio',
        'w110_n30_w105_n25_municipio',
        'w110_n35_w105_n30_municipio',
        'w115_n25_w110_n20_municipio',
        'w115_n30_w110_n25_municipio',
        'w115_n35_w110_n30_municipio',
        'w120_n30_w115_n25_municipio',
        'w120_n35_w115_n30_municipio'
    ]
    LOOP

        EXECUTE format('
            ALTER TABLE %I
            ADD COLUMN IF NOT EXISTS x double precision,
            ADD COLUMN IF NOT EXISTS y double precision;
        ', t);

        EXECUTE format('
            UPDATE %I
            SET
                x = ST_X(ST_PointOnSurface(geom)),
                y = ST_Y(ST_PointOnSurface(geom))
            WHERE x IS NULL OR y IS NULL;
        ', t);

    END LOOP;
END $$;
