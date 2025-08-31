#!/data/data/com.termux/files/usr/bin/bash
# ------------------------------
# Panel de control TTY - 16UltraPro (dinámico)
# ------------------------------

# Detecta automáticamente la ruta base del repo
BASE_DIR="$HOME/16UltraPro"

if [ ! -d "$BASE_DIR" ]; then
  echo "❌ No se encontró el directorio $BASE_DIR"
  exit 1
fi

cd "$BASE_DIR" || { echo "❌ Error accediendo a $BASE_DIR"; exit 1; }

echo ""
echo "==============================="
echo "   🟦 16UltraPro - Panel TTY 🟦"
echo "==============================="
echo ""
echo "1️⃣  Iniciar el servidor con métricas y dashboard:"
echo "     ./run16.sh"
echo ""
echo "2️⃣  Abrir el dashboard web:"
echo "     - Local: http://localhost:3000/dashboard"
echo "     - Localtunnel: copia la URL que aparece tras ejecutar run16.sh"
echo ""
echo "3️⃣  Ver métricas en JSON:"
echo "     http://localhost:3000/metrics"
echo ""
echo "4️⃣  Revisar logs de barrera y errores híbridos:"
echo "     - barrera.js -> barrera_log.txt"
echo "     - patch_hibrido.js -> historial con hybridHandler.getErrors()"
echo ""
echo "5️⃣  Editar configuración de credenciales:"
echo "     nano .env"
echo ""
echo "6️⃣  Detener servidor:"
echo "     Ctrl + C en la terminal donde corre run16.sh"
echo ""
echo "==============================="
exec bash
