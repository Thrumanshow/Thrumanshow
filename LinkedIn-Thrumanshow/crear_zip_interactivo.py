#!/data/data/com.termux/files/usr/bin/python3
import shutil
import os

print("📦 Script de creación de ZIP para Termux")

# Preguntar el nombre de la carpeta a comprimir
repo_folder = input("Ingresa el nombre de la carpeta a comprimir: ").strip()

# Verificar si la carpeta existe
if not os.path.exists(repo_folder):
    print(f"❌ Error: la carpeta '{repo_folder}' no existe en este directorio.")
    exit(1)

# Preguntar el nombre del archivo ZIP
zip_name = input("Ingresa el nombre que quieres para el archivo ZIP (sin .zip): ").strip()

# Crear el ZIP
shutil.make_archive(zip_name, 'zip', repo_folder)

# Mostrar mensaje de éxito
print(f"✅ Archivo ZIP creado: {zip_name}.zip en el directorio actual ({os.getcwd()})")
