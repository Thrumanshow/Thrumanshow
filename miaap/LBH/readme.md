# Lenguaje Binario HormigasAIS (LBH)

Este proyecto permite **codificar y decodificar texto** usando el Lenguaje Binario HormigasAIS (LBH).

## Instalación

```bash
git clone https://github.com/tu-usuario/HormigasAIS-LBH.git
cd ~/miapp

```

@@
+# Ejecución en Termux
+
+Para levantar el servidor LBH en Termux dentro de la carpeta local `~/miapp/LBH`:
+
+```bash
+# Navegar al proyecto
+cd ~/miapp/LBH
+
+# Instalar dependencias
+npm install
+
+# Ejecutar el servidor en segundo plano y guardar logs
+nohup npm start > lb.log 2>&1 &
+
+# Verificar que está corriendo
+ps aux | grep node
+tail -f lb.log
+
+# Abrir el dashboard web
+termux-open-url http://localhost:3000
+```
+
+> 💡 Nota: Este procedimiento mantiene el repositorio limpio y permite que la ejecución continúe en segundo plano sin bloquear Termux.
