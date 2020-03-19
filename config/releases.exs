import Config

config :hello_world, HelloWorldWeb.Endpoint,
  server: true,
  url: [host: "localhost", port: 4001],
  http: [port: 4000],
  https: [
    port: 4001,
    cipher_suite: :strong,
    certfile: "priv/cert/selfsigned.pem",
    keyfile: "priv/cert/selfsigned_key.pem"
  ],
  force_ssl: [hsts: true, host: "localhost:4001", log: :debug, exclude: []]
