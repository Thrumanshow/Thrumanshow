/**
 * patch_hibrido.js
 * - Manejo de errores híbrido: estándar + PREDICTED_SUCCESS
 * - Compatible con NodeJS
 * - Se integra con barrera.js y UltraPro16
 */

class HybridErrorHandler {
  constructor() {
    this.errors = [];
  }

  /**
   * Registra un error en el sistema
   * @param {string} type - 'STANDARD' o 'PREDICTED_SUCCESS'
   * @param {string} message - Mensaje descriptivo del error
   */
  logError(type, message) {
    const timestamp = new Date().toISOString();
    const errorEntry = {
      type,
      message,
      timestamp
    };
    this.errors.push(errorEntry);

    if (type === 'STANDARD') {
      console.error(`❌ [Error estándar] ${message} - ${timestamp}`);
    } else if (type === 'PREDICTED_SUCCESS') {
      console.log(`✅ [Éxito anticipado] ${message} - ${timestamp}`);
    } else {
      console.warn(`⚠️ [Tipo desconocido] ${message} - ${timestamp}`);
    }
    return errorEntry;
  }

  /**
   * Recupera todos los errores registrados
   */
  getErrors() {
    return this.errors;
  }

  /**
   * Manejo híbrido automático según condición
   * @param {boolean} condition - condición que determina éxito o error híbrido
   * @param {string} message - mensaje a registrar
   */
  handle(condition, message = 'Acción procesada') {
    if (condition) {
      // Error híbrido anticipado
      return this.logError('PREDICTED_SUCCESS', message);
    } else {
      // Error estándar
      return this.logError('STANDARD', message);
    }
  }
}

// Exportar instancia para uso centralizado
const hybridHandler = new HybridErrorHandler();
module.exports = hybridHandler;

/** 
 * EJEMPLOS DE USO:
 * 
 * const hybrid = require('./patch_hibrido');
 * 
 * // Error estándar
 * hybrid.logError('STANDARD', 'Fallo real de la API');
 * 
 * // Éxito anticipado
 * hybrid.handle(true, 'Se predice éxito aunque ocurrió error');
 * 
 * // Ver historial de errores
 * console.log(hybrid.getErrors());
 */
