#!/data/data/com.termux/files/usr/bin/bash
# ------------------------------
# run16.sh - Inicia UltraPro16 (16UltraPro) con robustez
# ------------------------------

REPO_DIR=~/16UltraPro
LOG_FILE="$REPO_DIR/run16.log"

# Verificar existencia del directorio y archivos
if [ ! -d "$REPO_DIR" ]; then
  echo "❌ No se encontró el directorio $REPO_DIR"
  exit 1
fi

if [ ! -f "$REPO_DIR/index.js" ]; then
  echo "❌ No se encontró index.js en $REPO_DIR"
  exit 1
fi

if ! command -v node &>/dev/null; then
  echo "❌ Node.js no está instalado"
  exit 1
fi

cd "$REPO_DIR"

# Notificación de inicio en Termux (si existe)
if command -v termux-notification &>/dev/null; then
  termux-notification --title "🚀 UltraPro16 iniciado" \
    --content "Puerto: ${PORT:-3000} | Umbral: ${THRESHOLD:-5} req/min" \
    --sound default --vibrate 500
fi

echo "==============================="
echo "🚀 Iniciando UltraPro16 - 16UltraPro"
echo "==============================="
echo "Puerto: ${PORT:-3000} | Umbral: ${THRESHOLD:-5} req/min"
echo "Logs: $LOG_FILE"
echo ""

# Función para cerrar servidor correctamente
function cleanup() {
  echo "🛑 Deteniendo servidor UltraPro16..."
  kill $PID 2>/dev/null
  wait $PID 2>/dev/null
  echo "$(date +"%Y-%m-%d %H:%M:%S") - Servidor detenido" >> "$LOG_FILE"
  if command -v termux-notification &>/dev/null; then
    termux-notification --title "🛑 UltraPro16 detenido" --content "PID: $PID" --sound default
  fi
  exit 0
}

trap cleanup SIGINT SIGTERM

# Ejecutar Node.js y redirigir stdout/stderr al log
node index.js >>"$LOG_FILE" 2>&1 &
PID=$!

echo "$(date +"%Y-%m-%d %H:%M:%S") - Servidor iniciado con PID $PID" >> "$LOG_FILE"
echo "Servidor corriendo con PID $PID"
echo ""
echo "Para detener servidor: Ctrl+C o kill $PID"
echo "Dashboard local: http://localhost:${PORT:-3000}/dashboard"
echo "Opcional: exponer dashboard a Internet con Localtunnel:"
echo "npx localtunnel --port ${PORT:-3000}"
echo ""

# Mantener el script activo mientras el servidor corre
wait $PID
