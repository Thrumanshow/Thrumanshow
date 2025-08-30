/**
 * index.js - UltraPro16 central
 * - Servidor Express + Socket.IO dashboard
 * - Usa barrera.js para bloquear/registrar eventos
 * - Envía alertas (Termux-notification, Slack y Email)
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

// Configurar transporte de email si se proporcionan credenciales
const transporter = (SMTP_USER && SMTP_PASS) ? nodemailer.createTransport({
  host: 'smtp.gmail.com', port: 587, secure: false,
  auth: { user: SMTP_USER, pass: SMTP_PASS }
}) : null;

// Funciones para alertas
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
  }, (err, info) => { if(err) console.error('Email error:', err.message); else console.log('Email sent:', info.response); });
}

// Middleware: métricas, logs y alertas
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

  // Series per-minute
  const nowMin = Math.floor(ts/60000);
  if (nowMin !== currentMinute) {
    perMinute.push({ minute: currentMinute, count: countThisMinute });
    if (perMinute.length > 60) perMinute.shift();
    currentMinute = nowMin;
    countThisMinute = 0;
  }
  countThisMinute++;

  // Colored console log
  const color = method==='GET' ? '\x1b[32m' : method==='POST' ? '\x1b[33m' : method==='PUT' ? '\x1b[34m' : method==='DELETE' ? '\x1b[31m' : '\x1b[37m';
  console.log(color+`📥 ${method} ${req.url} - ${iso}\x1b[0m`);

  // Broadcast metrics to dashboard
  io.emit('metrics:update', {
    stats, last: log, peak, rpm: reqTimestamps.length, perMinute
  });

  // Termux notification + remote alerts if threshold exceeded
  if (reqTimestamps.length >= THRESHOLD) {
    console.log('\x1b[41m⚠️  Alto tráfico detectado!\x1b[0m');
    try { exec(`termux-notification --title "⚠️ Alerta Node.js" --content "Tráfico alto: ${reqTimestamps.length} req/min" --vibrate 500 --sound default`); } 
    catch(e){ console.warn('termux-notification missing or failed'); }
    sendSlackWebhook(reqTimestamps.length);
    sendEmail(reqTimestamps.length);
  }

  next();
});

// Rutas
app.get('/', (req,res)=> res.send('🚀 UltraPro16 - /dashboard para ver panel web'));
app.use('/dashboard', express.static(__dirname + '/public'));
app.get('/metrics', (req,res) => {
  res.json({ stats, peak, rpm: reqTimestamps.length, perMinute, history: history.slice(-50) });
});

// Ejemplo de ruta usando barrera
app.get('/accion-test', async (req,res) => {
  const allowed = await barrera(true); // Cambia a false si quieres permitir la acción
  if (!allowed) return res.status(403).send('Acción bloqueada por barrera.');
  res.send('Acción permitida.');
});

// Iniciar servidor
server.listen(PORT, () => console.log(`Servidor corriendo en http://localhost:${PORT} (PORT=${PORT})`));

// Guardar métricas per-minute al cerrar
process.on('SIGINT', () => {
  perMinute.push({ minute: currentMinute, count: countThisMinute });
  try { fs.writeFileSync('perMinute.json', JSON.stringify(perMinute)); } catch(e){}
  process.exit(0);
});
