# Crear el script
cat <<'EOL' > ~/miapp/start_lbh.sh
#!/bin/bash
PROJECT="$HOME/miapp/HormigasAIS-LBH"

# Asegurarse de que existan las carpetas y archivos (opcional si ya están creados)
mkdir -p $PROJECT/src $PROJECT/public $PROJECT/examples

# Instalar dependencias y probar código
cd $PROJECT
npm install
npm test

# Iniciar servidor en segundo plano
nohup npm start &>/dev/null &

# Limpiar pantalla y abrir nueva sesión Termux
clear
termux-open-new-session
EOL

# Dar permisos de ejecución
chmod +x ~/miapp/start_lbh.sh
