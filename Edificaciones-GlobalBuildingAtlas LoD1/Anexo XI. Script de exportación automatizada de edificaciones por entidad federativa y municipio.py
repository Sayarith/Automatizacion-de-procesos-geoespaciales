import os
import pandas as pd
import geopandas as gpd
from sqlalchemy import create_engine

# CONEXIÓN A POSTGRESQL
usuario = "postgres"
password = "***"
host = "localhost"
puerto = "5432"
database = "Nombre de la BD"

engine = create_engine(
    f"postgresql+psycopg2://{usuario}:{password}@{host}:{puerto}/{database}"
)

# CARPETA DE SALIDA
salida_base = r"C:\Users\RUTA COMPLETA A LA CARPETA DE SALIDA"

os.makedirs(salida_base, exist_ok=True)

# DICCIONARIO DE ESTADOS
estados = {
    "01": "Aguascalientes",
    "02": "BajaCalifornia",
    "03": "BajaCaliforniaSur",
    "04": "Campeche",
    "05": "Coahuila",
    "06": "Colima",
    "07": "Chiapas",
    "08": "Chihuahua",
    "09": "CiudadDeMexico",
    "10": "Durango",
    "11": "Guanajuato",
    "12": "Guerrero",
    "13": "Hidalgo",
    "14": "Jalisco",
    "15": "Mexico",
    "16": "Michoacan",
    "17": "Morelos",
    "18": "Nayarit",
    "19": "NuevoLeon",
    "20": "Oaxaca",
    "21": "Puebla",
    "22": "Queretaro",
    "23": "QuintanaRoo",
    "24": "SanLuisPotosi",
    "25": "Sinaloa",
    "26": "Sonora",
    "27": "Tabasco",
    "28": "Tamaulipas",
    "29": "Tlaxcala",
    "30": "Veracruz",
    "31": "Yucatan",
    "32": "Zacatecas"
}

# OBTENER MUNICIPIOS ÚNICOS
query_municipios = """
SELECT DISTINCT
    cvegeo,
    cve_ent,
    cve_mun,
    nomgeo
FROM edificios_nacional
ORDER BY cvegeo;
"""

municipios = pd.read_sql(query_municipios, engine)

print(f"\nMunicipios encontrados: {len(municipios)}\n")

# RECORRER MUNICIPIOS
for _, row in municipios.iterrows():

    cvegeo = row["cvegeo"]
    cve_ent = str(row["cve_ent"]).zfill(2)
    nom_estado = estados.get(cve_ent, "Desconocido")

    print("\n===================================")
    print(f"Estado: {cve_ent}_{nom_estado}")
    print(f"Municipio: {cvegeo}")
    print("===================================")

    # CREAR CARPETA DEL ESTADO
    carpeta_estado = os.path.join(
        salida_base,
        f"{cve_ent}_{nom_estado}"
    )

    os.makedirs(carpeta_estado, exist_ok=True)

    # QUERY DEL MUNICIPIO
    query = f"""
    SELECT
        ROW_NUMBER() OVER () AS fid,
        cvegeo,
        cve_ent,
        cve_mun,
        nomgeo,
        source,
        id,
        height,
        var,
        region,
        area,
        x,
        y,
        geom
    FROM edificios_nacional
    WHERE cvegeo = '{cvegeo}';
    """

    try:

        gdf = gpd.read_postgis(
            query,
            engine,
            geom_col="geom"
        )

        if gdf.empty:
            print("  - Sin datos")
            continue

        # DEFINIR CRS
        gdf = gdf.set_crs(epsg=6372)

        # RUTA DE SALIDA
        salida_gpkg = os.path.join(
            carpeta_estado,
            f"mun_{cvegeo}.gpkg"
        )

        print(f"Exportando -> {salida_gpkg}")

        # EXPORTAR
        gdf.to_file(
            salida_gpkg,
            driver="GPKG"
        )

    except Exception as e:
        print(f"ERROR en municipio {cvegeo}")
        print(e)

print("EXPORTACIÓN FINALIZADA")
