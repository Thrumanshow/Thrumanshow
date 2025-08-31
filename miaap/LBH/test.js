const { encodeLBH, decodeLBH } = require('../src/lbh');

// Ejemplo de texto a codificar
const texto = "miapp1.";
const codigo = encodeLBH(texto);
console.log("Texto → LBH:", codigo);

// Decodificación
const decodificado = decodeLBH(codigo);
console.log("LBH → Texto:", decodificado);
