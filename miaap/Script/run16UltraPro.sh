#!/data/data/com.termux/files/usr/bin/bash
# ------------------------------
# Propiedad de .human 
# run16.sh - Ultra Master Thrumanshow
# Innovador: Thrumanshow | 16UltraPro robusto, parametrizable y control de recursos
# ------------------------------

# ------------------------------
# ARGUMENTOS OPCIONALES
# ------------------------------
PORT=${1:-3000}           # Primer argumento -> Puerto (default 3000)
THRESHOLD=${2:-5}         # Segundo argumento -> Umbral req/min (default 5)
NODE_RESOURCES=${3:-auto} # Tercer argumento -> Nivel de recursos (auto, low, medium, high)
GPUS=${4:-none}           # Cuarto argumento -> Selección de GPUs, ej: 0,1,2
ENV_NAME=${5:-env16UltraPro} # Nombre del entorno virtual/sandbox opcional

# ------------------------------
# Directorio del repositorio y archivo de log
# ------------------------------
REPO_DIR=~/16UltraPro
LOG_FILE="$REPO_DIR/run16.log"

# Guardar directorio original
ORIG_DIR=$(pwd)

# ------------------------------
# Función: Verificar existencia de directorio y archivos esenciales
# ------------------------------
function check_files() {
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
}

check_files

# ------------------------------
# Crear y activar sandbox/entorno virtual (opcional, estilo Python)
# ------------------------------
if [ ! -d "$ENV_NAME" ]; then
  echo "[1/3] Creando entorno virtual/sandbox: $ENV_NAME"
  mkdir -p "$ENV_NAME"
  # Podrías instalar Node.js local aquí si quisieras un entorno aislado
fi

echo "[2/3] Activando entorno: $ENV_NAME"
export NODE_PATH="$PWD/$ENV_NAME/lib/node_modules:$NODE_PATH"

# ------------------------------
# Configuración de recursos
# ------------------------------
echo "[3/3] Configurando recursos: $NODE_RESOURCES"
case "$NODE_RESOURCES" in
  low) NODE_OPTIONS="--max-old-space-size=512" ;;
  medium) NODE_OPTIONS="--max-old-space-size=2048" ;;
  high) NODE_OPTIONS="--max-old-space-size=4096" ;;
  auto|*) NODE_OPTIONS="--max-old-space-size=1024" ;;
esac
export NODE_OPTIONS

# Variables estilo CUDA_VISIBLE_DEVICES para GPUs (simulación)
export CUDA_VISIBLE_DEVICES="$GPUS"

# ------------------------------
# Cambiar al directorio del repositorio
# ------------------------------
cd "$REPO_DIR" || exit

# ------------------------------
# Notificación de inicio en Termux
# ------------------------------
if command -v termux-notification &>/dev/null; then
  termux-notification --title "🚀 UltraPro16 iniciado" \
    --content "Puerto: $PORT | Umbral: $THRESHOLD | Recursos: $NODE_RESOURCES | GPUs: $GPUS" \
    --sound default --vibrate 500
fi

echo "==============================="
echo "🚀 Iniciando UltraPro16 - 16UltraPro"
echo "==============================="
echo "Puerto: $PORT | Umbral: $THRESHOLD | Recursos: $NODE_RESOURCES | GPUs: $GPUS"
echo "Logs: $LOG_FILE"
echo "Innovador: Thrumanshow"
echo ""

# ------------------------------
# Función para cerrar servidor correctamente
# ------------------------------
function cleanup() {
  echo "🛑 Deteniendo servidor UltraPro16..."
  kill $PID 2>/dev/null
  wait $PID 2>/dev/null
  echo "$(date +"%Y-%m-%d %H:%M:%S") - Servidor detenido" >> "$LOG_FILE"
  if command -v termux-notification &>/dev/null; then
    termux-notification --title "🛑 UltraPro16 detenido" --content "PID: $PID" --sound default
  fi
  cd "$ORIG_DIR"
  exit 0
}

trap cleanup SIGINT SIGTERM

# ------------------------------
# Ejecutar Node.js con parámetros
# ------------------------------
node index.js --port "$PORT" --threshold "$THRESHOLD" >>"$LOG_FILE" 2>&1 &
PID=$!

echo "$(date +"%Y-%m-%d %H:%M:%S") - Servidor iniciado con PID $PID" >> "$LOG_FILE"
echo "Servidor corriendo con PID $PID"
echo ""
echo "Para detener servidor: Ctrl+C o kill $PID"
echo "Dashboard local: http://localhost:$PORT/dashboard"
echo "Opcional: exponer dashboard a Internet con Localtunnel:"
echo "npx localtunnel --port $PORT"
echo ""

# ------------------------------
# Mantener script activo mientras el servidor corre
# ------------------------------
wait $PID

# Volver al directorio original al finalizar
cd "$ORIG_DIR"
