# HelloWorld

Project demonstrating a problem applying `:force_ssl` configuration with releases. Note that

  * `config/prod.exs` does not define `:https` nor `:force_ssl` config
  * `config/releases.exs` defines them both

         https: [
           port: 4001,
           cipher_suite: :strong,
           certfile: "priv/cert/selfsigned.pem",
           keyfile: "priv/cert/selfsigned_key.pem"
         ],
         force_ssl: [hsts: true, host: nil, log: :debug, exclude: []]

## Building

  * Install dependencies with `mix deps.get`
  * Generate certificates `mix phx.gen.cert` (if t`mix archive.install hex phx_new 1.4.16`
  * Compresses static files `phx.digest`
  * Release `SECRET_KEY_BASE=$(mix phx.gen.secret) MIX_ENV=prod mix release`

## Testing the issue

  * Start Phoenix endpoint with `_build/prod/rel/hello_world/bin/hello_world start`
  * Display routes `mix phx.routes`

        page_path  GET  /                                      HelloWorldWeb.PageController :index
        websocket  WS   /socket/websocket                      HelloWorldWeb.UserSocket

  * Connect `/socket/websocket` route with curl (`curl -s -D- http://localhost:4000/socket/websocket`) and the server will respond with 301 redirect

        HTTP/1.1 301 Moved Permanently
        location: https://localhost:4001/socket/websocket

  * Connect route `/` with curl (`curl -s -D- http://localhost:4000`) and, surprisingly, the server responds with 200 OK

        HTTP/1.1 200 OK

