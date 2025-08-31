import { encodeLBH, decodeLBH, expandLBH } from '../src/lbh.js';

console.log("=== Test básico LBH ===");

const texto = "Hola Mundo";
const codificado = encodeLBH(texto);
console.log("Texto original:", texto);
console.log("Codificado LBH:", codificado);

const decodificado = decodeLBH(codificado);
console.log("Decodificado:", decodificado);

console.log("\n=== Test expansión LBH ===");
expandLBH("73", "~");
const textoExpandido = "Hola~";
console.log("Texto con expansión:", textoExpandido);
console.log("Codificado LBH:", encodeLBH(textoExpandido));
console.log("Decodificado:", decodeLBH(encodeLBH(textoExpandido)));
