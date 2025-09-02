#!/bin/bash
# =========================================
# Script técnico para ejecutar runLBH.sh
# =========================================

# Guardar el directorio actual
ORIG_DIR=$(pwd)

# Subir un nivel en la estructura de directorios
cd ..

# Definir la ruta del CV
CV_FILE="cv_cristhiam_quinonez.pdf"

# Ejecutar el script runLBH.sh con el CV como argumento
# Ajusta los flags según lo que tu script soporte
./runLBH.sh -CV="$CV_FILE" -model_file="_mm_full-3000.pth"

# Regresar al directorio original
cd "$ORIG_DIR"

# Mensaje de finalización
echo "== runLBH.sh ejecutado con $CV_FILE =="