# GENERAR CAMPO "area" Y CALCULAR ÁREA EN m²
# Compatible con capas en EPSG:6372
# Ejecutar en la Consola Python de QGIS

from qgis.PyQt.QtCore import QVariant
from qgis.core import QgsField
# Obtener capa activa
layer = iface.activeLayer()
# Validar selección
if not layer:
    print("No hay una capa seleccionada.")
elif layer.geometryType() != 2:
    print("La capa no es de tipo polígono.")
else:
    nombre_campo = "area"
    # Entrar en modo edición
    layer.startEditing()
    # Crear campo si no existe
    nombres_campos = [field.name() for field in layer.fields()]
    if nombre_campo not in nombres_campos:
        layer.dataProvider().addAttributes([
            QgsField(nombre_campo, QVariant.Double, "double", 20, 2)
        ])
        layer.updateFields()
        print("Campo 'area' creado.")
    # Obtener índice del campo
    idx = layer.fields().indexFromName(nombre_campo)
    # Calcular área
    for feature in layer.getFeatures():
        geom = feature.geometry()
        # Área en m²
        area_m2 = geom.area()
        # Actualizar valor
        layer.changeAttributeValue(
            feature.id(),
            idx,
            round(area_m2, 2)
        )
    # Guardar cambios
    layer.commitChanges()
    print("Áreas calculadas correctamente en m².")