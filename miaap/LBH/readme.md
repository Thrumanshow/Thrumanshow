# Lenguaje Binario HormigasAIS (LBH)

Este proyecto permite **codificar y decodificar texto** usando el Lenguaje Binario HormigasAIS (LBH).

## Instalación

```bash
cd ~/miapp
git clone --filter=blob:none --sparse https://github.com/Thrumanshow/Thrumanshow.git
cd Thrumanshow
git sparse-checkout set miaap/LBH
cd miaap/LBH


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
+termux-open-url [about:blank#locked](http://localhost:127.0.0.1~/miapp/LBH)
```
---

cd ~/miapp
git clone --filter=blob:none --sparse https://github.com/Thrumanshow/Thrumanshow.git
cd Thrumanshow
git sparse-checkout set miaap/LBH
cd miaap/LBH
mkdir -p public
# Copiar el index.html nuevo al lugar correcto
cp /[Thrumanshow/miapp/LBH/index.html public/index.html](http://localhost:127.0.0.1~/miapp/LBH)
