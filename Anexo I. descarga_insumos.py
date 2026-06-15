import os
import requests
from qgis.core import (
    QgsVectorLayer,
    QgsProject,
    QgsVectorFileWriter
)
# RUTA
dest_dir="/Users/RUTADESALIDA/atlas"
os.makedirs(dest_dir, exist_ok=True)
# URL BASE
base_url = "https://data.source.coop/tge-labs/globalbuildingatlas-lod1"
archivos = [
    "w090_n20_w085_n15",
    "w090_n25_w085_n20",
    "w095_n15_w090_n10",
    "w095_n20_w090_n15",
     "w095_n25_w090_n20",
     "w100_n20_w095_n15",
     "w100_n25_w095_n20",
     "w100_n30_w095_n25",
     "w105_n20_w100_n15",
     "w105_n25_w100_n20",
     "w105_n30_w100_n25",
     "w105_n35_w100_n30",
     "w110_n20_w105_n15",
     "w110_n25_w105_n20",
     "w110_n30_w105_n25",
     "w110_n35_w105_n30",
     "w115_n25_w110_n20",
     "w115_n30_w110_n25",
     "w115_n35_w110_n30",
     "w120_n30_w115_n25",
     "w120_n35_w115_n30"
]
#  DESCARGA
def descargar(url, path):
    r = requests.get(url, stream=True)
    if r.status_code != 200:
        raise Exception(f"HTTP {r.status_code}")
    with open(path, "wb") as f:
        for chunk in r.iter_content(1024):
            f.write(chunk)
# PROCESO
for archivo in archivos:
    print("\n==============================")
    print("paquete", archivo)
    url = f"{base_url}/{archivo}"
    ruta = os.path.join(dest_dir, archivo)
    # DESCARGA
    if not os.path.exists(ruta):
        print("Descargando...")
        try:
            descargar(url, ruta)
        except Exception as e:
            print("Error descarga:", e)
            continue
    # VALIDACIÓN BÁSICA
    if os.path.getsize(ruta) < 1000:
        print("Archivo corrupto (muy pequeño)")
        continue
    print("Archivo válido")
    # CARGA CON GDAL (CLAVE)
    uri = ruta
    layer = QgsVectorLayer(uri, archivo, "ogr")
    if not layer.isValid():
        print("No se pudo leer con GDAL/QGIS")
        continue
    print("Capa cargada")
    # AGREGAR A QGIS
    QgsProject.instance().addMapLayer(layer)
    # EXPORTAR A GPKG
    salida = os.path.join(dest_dir, archivo.replace(".parquet", ".gpkg"))
    QgsVectorFileWriter.writeAsVectorFormat(
        layer,
        salida,
        "UTF-8",
        layer.crs(),
        "GPKG"
    )
    print("Exportado:", salida)
print("\n PROCESO FINALIZADO")