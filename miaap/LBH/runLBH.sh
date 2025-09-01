#!/data/data/com.termux/files/usr/bin/bash
# runLBH.sh - Inicia el servidor LBH en segundo plano

PROJECT_DIR=~/miapp/LBH
LOG_FILE="$PROJECT_DIR/lbh.log"

cd "$PROJECT_DIR"

# Ejecutar el servidor en segundo plano y redirigir logs
nohup node server.js > "$LOG_FILE" 2>&1 &

PID=$!
echo "Servidor LBH iniciado con PID $PID"
echo "Logs: $LOG_FILE"
echo "Dashboard disponible en: http://localhost:3000"
