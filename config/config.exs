import Config

config :lapin, :connections, [
  [
    module: Portal.AMQP,
    consumers: [ack: true],
    producers: [ack: true],
    host: "localhost",
    port: 5672,
    virtual_host: "/",
    username: "guest",
    password: "guest"
  ]
]
