// web/socket.js
const io = require("socket.io")(3001, {
  cors: { origin: "*" } // si es desde otro dominio
});

io.of("/my-LHB").on("connection", (socket) => {
  console.log(`Nuevo socket conectado: ${socket.id}`);

  socket
    .timeout(5000)
    .to("room1")
    .to(["room2", "room3"])
    .except("thrumanshow")
    .emit("hello", (err, responses) => {
      if (err) console.error("Error enviando mensaje:", err);
      else console.log("Respuestas recibidas:", responses);
    });

  socket.on("disconnect", () => {
    console.log(`Socket conect: ${socket.id}`);
  });
});
