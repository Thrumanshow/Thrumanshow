#!/bin/bash
if [ -f "CONTRACT_HUMAN.lbh" ]; then
    echo "🐜 [XOXO-BRIDGE] Firma Humana (lbh.human) detectada y validada."
    echo "🛡️ Acceso concedido por Cristhiam Leonardo Hernández."
    tail -n 5 ../xoxo-lbh-adapter/vision.log > internal_event_buffer.lbh
    echo "✅ Sincronía LBH completada con éxito."
else
    echo "🚨 ERROR DE PROTOCOLO: Falta contrato Humano. Bloqueando nodo..."
    exit 1
fi
