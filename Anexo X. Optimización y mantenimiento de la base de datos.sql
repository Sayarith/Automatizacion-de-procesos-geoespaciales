--- Índices sobre atributos geoestadísticos
CREATE INDEX idx_edif_cveent
ON edificios_nacional(cve_ent);

CREATE INDEX idx_edif_cvegeo
ON edificios_nacional(cvegeo);

--- Procesos de mantenimiento
VACUUM FULL;
ANALYZE edificios_nacional;

--- Consultas de validación
SELECT COUNT(*)
FROM edificios_nacional;

SELECT DISTINCT cve_ent
FROM edificios_nacional
ORDER BY cve_ent;

SELECT COUNT(*)
FROM edificios_nacional
WHERE cvegeo = '14100';

SELECT COUNT(*)
FROM edificios_nacional
WHERE cve_ent = '14';

--- Evaluación de rendimiento
EXPLAIN ANALYZE
SELECT *
FROM edificios_nacional
WHERE cvegeo = '14100';