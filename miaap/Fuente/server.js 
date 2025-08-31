const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const { encodeLBH, decodeLBH, expandLBH } = require('./lbh');

const app = express();
const server = http.createServer(app);
const io = new Server(server);

app.use(express.static('public'));

io.on('connection', (socket) => {
  console.log('Cliente conectado');

  socket.on('encode', (msg) => {
    const code = encodeLBH(msg);
    socket.emit('encoded', code);
  });

  socket.on('decode', (code) => {
    const msg = decodeLBH(code);
    socket.emit('decoded', msg);
  });

  socket.on('expand', ({ code, symbol }) => {
    expandLBH(code, symbol);
    socket.emit('expanded', { code, symbol });
  });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => console.log(`Servidor LBH en puerto ${PORT}`));
