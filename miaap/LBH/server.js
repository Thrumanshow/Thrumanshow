
~ $ #!/bin/bash
~ $ echo == HormigasAIS LBH: Script en ejecución ==
== HormigasAIS LBH: Script en ejecución ==
~ $ #!/data/data/com.termux/files/usr/bin/bash
servidor en segundo plano y redirigir logs
nohup node server.js > "$LOG_FILE" 2>&1 & 

PID=$!
echo "Servidor LBH iniciado con PID $PID"
echo "Logs: $LOG_FILE"
echo "Dashboard disponible en: http://localhost:127.0.0.1"~ $ # runLBH.sh - Inicia el servidor LBH en segundo plano
~ $
~ $ PROJECT_DIR=~/miapp/LBH
~ $ LOG_FILE="$PROJECT_DIR/lbh.log"
~ $
~ $ cd "$PROJECT_DIR"
~/miapp/LBH $
~/miapp/LBH $ # Ejecutar el servidor en segundo plano y redirigir logs
~/miapp/LBH $ nohup node server.js > "$LOG_FILE" 2>&1 &
[1] 24976
~/miapp/LBH $
~/miapp/LBH $ PID=$!
~/miapp/LBH $ echo "Servidor LBH iniciado con PID $PID"
Servidor LBH iniciado con PID 24976
~/miapp/LBH $ echo "Logs: $LOG_FILE"
Logs: /data/data/com.termux/files/home/miapp/LBH/lbh.log
~/miapp/LBH $ echo "Dashboard disponible en: http://localhost:3000"
Dashboard disponible en: http://localhost:3000
[1]+  Exit 1                     nohup node server.js > "$LOG_FILE" 2>&1
~/miapp/LBH $ chmod +x runLBH.sh
~/miapp/LBH $ ./runLBH.sh
📦 Verificando dependencias... 

up to date, audited 123 packages in 8s 

19 packages are looking for funding
  run `npm fund` for details 

found 0 vulnerabilities
termux-notification: too many arguments
===============================
🚀 Servidor LBH iniciado
PID: 1331
Logs: /data/data/com.termux/files/home/miapp/LBH/lb.log
Dashboard local: http://localhost:3000/
Para detener: Ctrl+C o kill 1331
===============================
~/miapp/LBH $
~/miapp/LBH $ #!/data/data/com.termux/files/usr/bin/bash
-v termux-notification &>/dev/null; then
    termux-notification --title "🛑 LBH detenido" --content "PID: $PID"
  fi
  exit 0
} 

trap cleanup SIGINT SIGTERM 

# Ejecutar Node.js en segundo plano y guardar PID
nohup node server.js >>"$LOG_FILE" 2>&1 &
PID=$! 

# No~/miapp/LBH $ # ------------------------------
~/miapp/LBH $ # runLBH.sh - Inicia LBH Server en Termux con automatización
======" 

# Abrir automáticamente el da~/miapp/LBH $ # ------------------------------
~/miapp/LBH $
~/miapp/LBH $ PROJECT=~/miapp/LBH
~/miapp/LBH $ LOG_FILE="$PROJECT/lb.log"
~/miapp/LBH $ PORT=${PORT:-3000}
~/miapp/LBH $
~/miapp/LBH $ # Verificar que Node.js está instalado
~/miapp/LBH $ if ! command -v node &>/dev/null; then
>   echo "❌ Node.js no está instalado. Instala con: pkg install nodejs"
>   exit 1
> fi
~/miapp/LBH $
~/miapp/LBH $ # Ir al directorio del proyecto
~/miapp/LBH $ cd "$PROJECT" || { echo "❌ No se encontró el directorio $PROJECT"; exit 1; }
~/miapp/LBH $
~/miapp/LBH $ # Instalar dependencias si no existen node_modules
~/miapp/LBH $ if [ ! -d "node_modules" ]; then
>   echo "📦 Instalando dependencias Node.js..."
>   npm install
> fi
📦 Instalando dependencias Node.js... 

up to date, audited 123 packages in 6s 

19 packages are looking for funding
  run `npm fund` for details 

found 0 vulnerabilities
~/miapp/LBH $
~/miapp/LBH $ echo "==============================="
===============================
~/miapp/LBH $ echo "🚀 Iniciando servidor LBH"
🚀 Iniciando servidor LBH
~/miapp/LBH $ echo "==============================="
===============================
~/miapp/LBH $ echo "Logs: $LOG_FILE"
Logs: /data/data/com.termux/files/home/miapp/LBH/lb.log
~/miapp/LBH $ echo "" 

~/miapp/LBH $
~/miapp/LBH $ # Función para detener servidor correctamente~/miapp/LBH $ cleanup() {
>   echo "🛑 Deteniendo servidor LBH..."
>   kill $PID 2>/dev/null
>   wait $PID 2>/dev/null
>   echo "$(date +"%Y-%m-%d %H:%M:%S") - Servidor detenido" >> "$LOG_FILE"
>   if command -v termux-notification &>/dev/null; then
>     termux-notification --title "🛑 LBH detenido" --content "PID: $PID"
>   fi
>   exit 0
> }
~/miapp/LBH $
~/miapp/LBH $ trap cleanup SIGINT SIGTERM
~/miapp/LBH $
~/miapp/LBH $ # Ejecutar Node.js en segundo plano y guardar PID
~/miapp/LBH $ nohup node server.js >>"$LOG_FILE" 2>&1 &
[1] 29828
~/miapp/LBH $ PID=$!
~/miapp/LBH $
~/miapp/LBH $ # Notificación de inicio
~/miapp/LBH $ if command -v termux-notification &>/dev/null; then
>   termux-notification --title "🚀 LBH iniciado" --content "Puerto: $PORT | PID: $PID"
> fi
^O
0
