#!/data/data/com.termux/files/usr/bin/bash
# ------------------------------
# Panel de control TTY - UltraPro16
# ------------------------------
# Requiere que index.js, barrera.js y patch_hibrido.js estén en ~/miapp

cd ~/miapp || { echo "❌ No se encontró ~/miapp"; exit 1; }

echo ""
echo "==============================="
echo "   🟦 UltraPro16 - Panel TTY 🟦"
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