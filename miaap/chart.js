io.of("/my-16ultrapro").on("connection", (socket) => {
  socket
    .timeout(5000)
    .to("room1")
    .to(["room2", "room3"])
    .except("thrumanshow")
    .emit("hello", (err, responses) => {
      // ...
    });
});
