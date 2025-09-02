#!/data/data/com.termux/files/usr/bin/bash
# --- UltraPro16 + barrera.js + Slack + Dashboard Web (One-Paste) ---
# Pega todo esto en Termux y presiona Enter. Luego edita ~/miapp/.env para poner tus credenciales.
set -e
echo -e "\n🚀 INICIANDO INSTALACIÓN ONE-PASTE: UltraPro16 + barrera.js + Slack + Dashboard Web\n" 

# 1) Actualizar sistema
pkg update -y && pkg upgrade -y 

# 2) Instalar utilidades necesarias
pkg install -y nodejs git nano jq curl termux-api 

# 3) Crear carpeta del proyecto
mkdir -p ~/miapp && cd ~/miapp 

# 4) Inicializar npm y dependencias
if [ ! -f package.json ]; then
  npm init -y
fi 

# Instalar dependencias node (express, socket.io, dotenv, nodemailer, node-fetch@2, @slack/web-api)
npm install express socket.io dotenv nodemailer node-fetch@2 @slack/web-api
npm install -g nodemon localtunnel 

# 5) Crear archivo de configuración .env (REEMPLAZA los placeholders)
cat > .env <<'ENV'
# --- EDITA ESTOS VALORES ANTES DE USAR ---
# Slack: puedes usar WEBHOOK o BOT TOKEN. Si usas BOT TOKEN activa scopes chat:write and channels:read.
SLACK_WEBHOOK_URL=      # Ej: https://hooks.slack.com/services/AAA/BBB/CCC
SLACK_BOT_TOKEN=        # Ej: xoxb-xxxxxxxxxx  (opcional si prefieres usar WebClient)
SLACK_CHANNEL=#barrera-log  # canal o ID de canal en Slack 

# Email (opcional): para alertas por correo (Gmail: usa App Password)
SMTP_USER=chrisquionez354@gmail.com
SMTP_PASS=TU_APP_PASSWORD_GMAIL 

# Umbral de alertas (solicitudes/minuto)
THRESHOLD=5 

# Puerto para Node/Express
PORT=3000
ENV 

# 6) Crear barrera.js (registro + Slack notification via WebClient)
cat > barrera.js <<'JSS'
/**
* barrera.js
* - registra intentos en archivo local
* - envía notificación a Slack (webhook o bot token si está configurado)
*
* Uso:
*   const barrera = require('./barrera');
*   barrera(true);
*/
const fs = require('fs');
const path = require('path');
const { WebClient } = require('@slack/web-api');
const fetch = require('node-fetch'); 

const LOG_PATH = path.join(__dirname, 'barrera_log.txt');
const env = (() => {
  try { return require('dotenv').config().parsed || {}; } catch(e) { return {}; }
})(); 

const SLACK_WEBHOOK = env.SLACK_WEBHOOK_URL || process.env.SLACK_WEBHOOK_URL || '';
const SLACK_BOT_TOKEN = env.SLACK_BOT_TOKEN || process.env.SLACK_BOT_TOKEN || '';
const SLACK_CHANNEL = env.SLACK_CHANNEL || process.env.SLACK_CHANNEL || '#general'; 

let slackClient = null;
if (SLACK_BOT_TOKEN) {
  slackClient = new WebClient(SLACK_BOT_TOKEN);
} 

/** escribe log local */
function writeLog(message) {
  const entry = [
    '=== BLOQUEO DE ACCIÓN ===',
    message,
    `Timestamp: ${new Date().toISOString()}`,
    '=========================\n'
  ].join('\n');
  try {
    fs.appendFileSync(LOG_PATH, entry);
  } catch (e) {
    console.error('Error escribiendo log:', e.message);
  }
} 

/** envía a Slack: primero intenta WebClient (bot token), si no prueba webhook */
async function notifySlack(text) {
  const payload = { text };
  try {
    if (slackClient) {
      await slackClient.chat.postMessage({ channel: SLACK_CHANNEL, text });
      console.log('✅ Notificación enviada a Slack (bot token).');
      return;
    }
    if (SLACK_WEBHOOK) {
      const res = await fetch(SLACK_WEBHOOK, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });
      if (res.ok) {
        console.log('✅ Notificación enviada a Slack (webhook).');
        return;
      } else {
        console.error('❌ Slack webhook responded status', res.status);
      }
    }
    console.warn('⚠️ No se configuró Slack (WEBHOOK ni BOT_TOKEN).');
  } catch (err) {
    console.error('❌ Error notificando a Slack:', err.message);
  }
} 

/** función pública barrera */
async function registrarIntento(mensaje) {
  writeLog(mensaje);
  console.log('\n' + '=== BLOQUEO DE ACCIÓN ===\n' + mensaje + '\nTimestamp: ' + new Date().toISOString() + '\n=========================\n');
  await notifySlack(`🚨 Acción bloqueada: ${mensaje}`);
} 

function barrera(make) {
  if (make) {
    registrarIntento('decromatiza');
    return false;
  }
  return true;
} 

module.exports = barrera;
JSS 

# 7) Crear servidor principal index.js con dashboard (Socket.IO) y uso de barrera.js
cat > index.js <<'JSE'
/**
* index.js - UltraPro16 central
* - Express + Socket.IO dashboard
* - Usa barrera.js para bloquear/registrar eventos
* - Envía alertas (termux-notification), Slack and Email (if configured)
*/
require('dotenv').config();
const fs = require('fs');
const http = require('http');
const express = require('express');
const { exec } = require('child_process');
const fetch = require('node-fetch');
const nodemailer = require('nodemailer');
const barrera = require('./barrera'); 

const app = express();
const server = http.createServer(app);
const io = require('socket.io')(server, { cors: { origin: "*" } }); 

const PORT = parseInt(process.env.PORT || '3000', 10);
const THRESHOLD = parseInt(process.env.THRESHOLD || '5', 10);
const SLACK_WEBHOOK = process.env.SLACK_WEBHOOK_URL || '';
const SMTP_USER = process.env.SMTP_USER || '';
const SMTP_PASS = process.env.SMTP_PASS || ''; 

let stats = { GET:0, POST:0, PUT:0, DELETE:0, OTHER:0 };
let history = [];
let reqTimestamps = [];
let perMinute = [];
let currentMinute = Math.floor(Date.now()/60000);
let countThisMinute = 0;
let peak = 0;
const MAX_HISTORY = 200; 

if (!fs.existsSync('history.csv')) fs.writeFileSync('history.csv', 'time,method,url\n'); 

const transporter = (SMTP_USER && SMTP_PASS) ? nodemailer.createTransport({
  host: 'smtp.gmail.com', port: 587, secure: false,
  auth: { user: SMTP_USER, pass: SMTP_PASS }
}) : null; 

async function sendSlackWebhook(count) {
  if (!SLACK_WEBHOOK) return;
  try {
    await fetch(SLACK_WEBHOOK, {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({ text: `⚠️ Tráfico alto: ${count} req/min` })
    });
  } catch (e) { console.error('Slack webhook error:', e.message); }
}
function sendEmail(count) {
  if (!transporter) return;
  transporter.sendMail({
    from: `UltraPro <${SMTP_USER}>`,
    to: SMTP_USER,
    subject: `⚠️ Alerta Node.js - ${count} req/min`,
    text: `Se detectaron ${count} solicitudes por minuto en tu servidor.`
  }, (err,info)=>{ if(err) console.error('Email error:', err.message); else console.log('Email sent:', info.response); });
} 

// Middleware: métricas y alertas
app.use((req,res,next) => {
  const method = (req.method || 'OTHER').toUpperCase();
  stats[method] = (stats[method]||0) + 1; 

  const ts = Date.now();
  const iso = new Date(ts).toISOString();
  const log = { time: iso, method, url: req.url };
  history.push(log); if (history.length>MAX_HISTORY) history.shift();
  fs.appendFileSync('history.csv', `${iso},${method},${req.url}\n`); 

  reqTimestamps.push(ts);
  reqTimestamps = reqTimestamps.filter(t => t > ts - 60000);
  peak = Math.max(peak, reqTimestamps.length); 

  // per-minute series
  const nowMin = Math.floor(ts/60000);
  if (nowMin !== currentMinute) {
    perMinute.push({ minute: currentMinute, count: countThisMinute });
    if (perMinute.length > 60) perMinute.shift();
    currentMinute = nowMin;
    countThisMinute = 0;
  }
  countThisMinute++; 

  // colored console log
  const color = method==='GET' ? '\x1b[32m' : method==='POST' ? '\x1b[33m' : method==='PUT' ? '\x1b[34m' : method==='DELETE' ? '\x1b[31m' : '\x1b[37m';
  console.log(color+`📥 ${method} ${req.url} - ${iso}\x1b[0m`); 

  // broadcast metrics to dashboard
  io.emit('metrics:update', {
    stats, last: log, peak, rpm: reqTimestamps.length, perMinute
  }); 

  // termux notification + remote alerts if threshold exceeded
  if (reqTimestamps.length >= THRESHOLD) {
    console.log('\x1b[41m⚠️  Alto tráfico detectado!\x1b[0m');
    try {
      exec(`termux-notification --title "⚠️ Alerta Node.js" --content "Tráfico alto: ${reqTimestamps.length} req/min" --vibrate 500 --sound default`);
    } catch(e){ console.warn('termux-notification missing or failed'); }
    sendSlackWebhook(reqTimestamps.length);
    sendEmail(reqTimestamps.length);
  } 

  next();
}); 

// Routes
app.get('/', (req,res)=> res.send('🚀 UltraPro16 - /dashboard para ver panel web'));
app.use('/dashboard', express.static(__dirname + '/public'));
app.get('/metrics', (req,res) => {
  res.json({ stats, peak, rpm: reqTimestamps.length, perMinute, history: history.slice(-50) });
}); 

// Example route that uses barrera
app.get('/accion-test', (req,res) => {
  // Simula llamada que podría ser bloqueada por la barrera
  const allowed = barrera(true); // si quieres simular allow usa false
  if (!allowed) return res.status(403).send('Acción bloqueada por barrera.');
  res.send('Acción permitida.');
}); 

// Start
server.listen(PORT, () => console.log(`Servidor corriendo en http://localhost:${PORT} (PORT=${PORT})`));
process.on('SIGINT', () => {
  perMinute.push({ minute: currentMinute, count: countThisMinute });
  try { fs.writeFileSync('perMinute.json', JSON.stringify(perMinute)); } catch(e){}
  process.exit(0);
});
JSE 

# 8) Crear UI pública (dashboard) con Chart.js + Socket.IO
mkdir -p public
cat > public/index.html <<'HTML'
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>UltraPro16 Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="/socket.io/socket.io.js"></script>
<style>
  body{font-family:system-ui,Arial;background:#071029;color:#e6eef8;margin:0;padding:16px}
  .wrap{max-width:1100px;margin:0 auto}
  .kpis{display:flex;gap:12px;margin-bottom:12px}
  .card{flex:1;background:#0f2340;padding:12px;border-radius:10px;border:1px solid #18304b}
  .title{font-size:14px;color:#a8c2e8}
  .big{font-size:28px;font-weight:800}
  .grid{display:grid;grid-template-columns:2fr 1fr;gap:12px}
  .logs{height:260px; overflow:auto; background:#041226;padding:10px;border-radius:8px;border:1px solid #12243b;font-family:monospace}
  .badge{display:inline-block;padding:4px 8px;border-radius:999px;margin-right:6px;font-size:12px;color:#fff}
  .GET{background:#2f8a3f}.POST{background:#b38a1f}.PUT{background:#176b96}.DELETE{background:#a83232}.OTHER{background:#666}
  a{color:#89baff}
</style>
</head>
<body>
<div class="wrap">
  <h1>🚀 UltraPro16 — Dashboard (tiempo real)</h1>
  <div class="kpis">
    <div class="card"><div class="title">RPM (requests/min)</div><div id="rpm" class="big">0</div></div>
    <div class="card"><div class="title">Pico RPM</div><div id="peak" class="big">0</div></div>
    <div class="card"><div class="title">Total solicitudes</div><div id="total" class="big">0</div></div>
    <div class="card"><div class="title">Umbral</div><div id="th" class="big">-</div></div>
  </div> 

  <div class="grid">
    <div class="card">
      <div class="title">Solicitudes por método</div>
      <canvas id="byMethod"></canvas>
      <div style="margin-top:8px" id="last">Última: —</div>
    </div>
    <div class="card">
      <div class="title">Últimos eventos</div>
      <div class="logs" id="logs"></div>
    </div>
  </div> 

  <div style="margin-top:12px" class="card">
    <div class="title">Solicitudes por minuto (serie)</div>
    <canvas id="perMinute"></canvas>
  </div>
</div> 

<script>
const socket = io();
const elRPM=document.getElementById('rpm'), elPeak=document.getElementById('peak'), elTotal=document.getElementById('total'), elTh=document.getElementById('th');
const elLogs=document.getElementById('logs'), elLast=document.getElementById('last');
const byCtx=document.getElementById('byMethod').getContext('2d');
const pmCtx=document.getElementById('perMinute').getContext('2d'); 

const byChart=new Chart(byCtx,{type:'bar',data:{labels:['GET','POST','PUT','DELETE','OTHER'],datasets:[{label:'Acumulado',data:[0,0,0,0,0],backgroundColor:['#2f8a3f','#b38a1f','#176b96','#a83232','#666']}]},options:{animation:false}}); 

const pmChart=new Chart(pmCtx,{type:'line',data:{labels:[],datasets:[{label:'RPM',data:[],fill:true,borderColor:'#89baff',backgroundColor:'rgba(137,186,255,0.08)'}]},options:{animation:false,scales:{y:{beginAtZero:true}}}}); 

function addLog(l){
  const d=document.createElement('div');
  d.innerHTML=`<span class="badge ${l.method}">${l.method}</span> ${new Date(l.time).toLocaleTimeString()} — <b>${l.url}</b>`;
  elLogs.prepend(d);
  while(elLogs.childElementCount>50) elLogs.removeChild(elLogs.lastChild);
}
function setBy(stats){
  const order=['GET','POST','PUT','DELETE','OTHER'];
  const vals=order.map(k=>stats[k]||0);
  byChart.data.datasets[0].data=vals; byChart.update();
  elTotal.textContent=vals.reduce((a,b)=>a+b,0);
}
function setPer(arr){
  pmChart.data.labels=arr.map(x=>new Date(x.minute*60000).toLocaleTimeString());
  pmChart.data.datasets[0].data=arr.map(x=>x.count);
  pmChart.update();
}
async function bootstrap(){
  const r=await fetch('/metrics'); const d=await r.json();
  setBy(d.stats); setPer(d.perMinute||[]); elRPM.textContent=d.rpm||0; elPeak.textContent=d.peak||0; elTh.textContent=Number(new URLSearchParams(location.search).get('t')||'5');
  (d.history||[]).reverse().forEach(addLog);
  if(d.history && d.history.length){ const last=d.history[d.history.length-1]; elLast.innerHTML=`<span class="badge ${last.method}">${last.method}</span> ${new Date(last.time).toLocaleTimeString()} — <b>${last.url}</b>`;}
}
bootstrap(); 

socket.on('metrics:update', payload=>{
  if (payload.stats) setBy(payload.stats);
  if (payload.perMinute) setPer(payload.perMinute);
  elRPM.textContent = payload.rpm;
  elPeak.textContent = payload.peak;
  if (payload.last) { addLog(payload.last); elLast.innerHTML=`<span class="badge ${payload.last.method}">${payload.last.method}</span> ${new Date(payload.last.time).toLocaleTimeString()} — <b>${payload.last.url}</b>`; }
});
</script>
</body>
</html>
HTML 

# 9) Crear run script que arranca nodemon y localtunnel (muestra URL)
cat > run16.sh <<'SH'
#!/data/data/com.termux/files/usr/bin/bash
cd ~/miapp
pkill node || true
echo "🔥 Iniciando UltraPro16 (nodemon index.js)..."
nodemon index.js &
sleep 2
echo "🌐 Lanzando localtunnel para puerto 3000 (ctrl+c para detener la sesión de lt)"
lt --port 3000
SH
chmod +x run16.sh 

# 10) Crear panel.sh (TTY panel opcional — muestra URL y recomendaciones)
cat > panel.sh <<'SH'
#!/data/data/com.termux/files/usr/bin/bash
cd ~/miapp
echo "Para abrir el dashboard web: ejecuta ./run16.sh y abre /dashboard en el navegador (http://localhost:127.0.0.1~/miapp/LBH)/dashboard"
echo "También puedes ver métricas desde /metrics (JSON)."
exec bash
SH
chmod +x panel.sh 

# 11) Mensaje final con instrucciones mínimas
echo -e "\n✅ INSTALACIÓN COMPLETA (archivos creados en ~/miapp):"
echo " - .env   -> configura SLACK/SMTP/THRESHOLD/PORT"
echo " - index.js, barrera.js, run16.sh, panel.sh"
echo " - public/index.html -> dashboard web (Chart.js + Socket.IO)"
echo ""
echo "➡️ Pasos siguientes (recomendado):"
echo " 1) Edita ~/miapp/.env y completa SLACK_WEBHOOK_URL o SLACK_BOT_TOKEN y SMTP_PASS si quieres correo."
echo "    nano ~/miapp/.env"
echo " 2) Inicia el servicio y genera URL pública (localtunnel):"
echo "    cd ~/miapp && ./run16.sh"
echo " 3) Abre el dashboard:  http://localhost:127.0.0.1~/miapp/LBH/dashboard  (o la URL que localtunnel te dé)/dashboard"
echo ""
echo "Ejemplo rápido para probar alertas (ejecuta mientras run16.sh corre):"
echo "  for i in \$(seq 1 8); do curl -s http://localhostlocalhost:127.0.0.1~/miapp/LBH/ >/dev/null; sleep 1; done"
echo\n""
