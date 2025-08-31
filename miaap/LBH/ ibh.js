// src/lbh.js
// Lenguaje Binario HormigasAIS (LBH) - Codificación y decodificación bidireccional
// Autor: Cristhiam Quiñonez (Thrumanshow)

// Diccionario HormigasAIS extendido
const LBH = {
  "01":"A","02":"B","03":"C","04":"D","05":"E","06":"F","07":"G","08":"H","09":"I","10":"J",
  "11":"K","12":"L","13":"M","14":"N","15":"O","16":"P","17":"Q","18":"R","19":"S","20":"T",
  "21":"U","22":"V","23":"W","24":"X","25":"Y","26":"Z",
  "27":"a","28":"b","29":"c","30":"d","31":"e","32":"f","33":"g","34":"h","35":"i","36":"j",
  "37":"k","38":"l","39":"m","40":"n","41":"o","42":"p","43":"q","44":"r","45":"s","46":"t",
  "47":"u","48":"v","49":"w","50":"x","51":"y","52":"z",
  "53":"0","54":"1","55":"2","56":"3","57":"4","58":"5","59":"6","60":"7","61":"8","62":"9",
  "63":".","64":",","65":"!","66":"?","67":"@","68":"#","69":"$","70":"%","71":"&","72":"*",
  "00":" " // espacio
};

// Diccionario inverso para codificación rápida
const LBH_REVERSE = {};
for (let key in LBH) {
  LBH_REVERSE[LBH[key]] = key;
}

// Codifica texto → LBH
function encodeLBH(text) {
  return text.split("").map(char => LBH_REVERSE[char] || "").join("");
}

// Decodifica LBH → texto
function decodeLBH(code) {
  let pairs = code.match(/.{2}/g) || [];
  return pairs.map(pair => LBH[pair] || "").join("");
}

// Permite agregar nuevos símbolos al diccionario (extensible)
const LBH_EXT = {};
function expandLBH(code, symbol) {
  if (!LBH_EXT[code] && !LBH[code]) {
    LBH_EXT[code] = symbol;
    LBH_REVERSE[symbol] = code;
    console.log(`Símbolo '${symbol}' agregado al código '${code}'`);
  } else {
    console.log(`El código '${code}' ya existe`);
  }
}

// Exportamos funciones para otros scripts
module.exports = { encodeLBH, decodeLBH, expandLBH };
