import Config

config Portal, :amqp,
  host: "localhost",
  port: 5672,
  virtual_host: "/",
  username: "guest",
  password: "guest"
