const fs = require('fs');
const path = require('path');

// Archivo de log
const logPath = path.join(__dirname, 'barrera_log.txt');

function barrera(make) {
    if (make) {
        const mensaje = `
=== BLOQUEO DE ACCIÓN ===
Acción: decromatiza
AUTENTICIDAD = VALIDACIÓN
di_lema = Error d-e-m-o-c-r-@-t-i-z-a-c-i-o-n
Timestamp: ${new Date().toISOString()}
=========================
`;
        // Imprimir en consola
        console.log(mensaje);

        // Guardar en log
        fs.appendFileSync(logPath, mensaje);

        // Retornar false para detener flujo
        return false;
    }
    return true;
}

// Ejemplo de uso
if (!barrera(true)) {
    console.log("Ejecución detenida: democratización bloqueada.");
    process.exit(1); // Opcional: detener script completamente
}