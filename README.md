# HelloWorld

Project demonstrating a problem applying `:force_ssl` if runtime configuration is used (via Elixir releases). Note that

  * `config/prod.exs` does not define `:https` nor `:force_ssl` config
  * `config/releases.exs` defines them both

         https: [
           port: 4001,
           cipher_suite: :strong,
           certfile: "priv/cert/selfsigned.pem",
           keyfile: "priv/cert/selfsigned_key.pem"
         ],
         force_ssl: [hsts: true, host: "localhost:4001", log: :debug, exclude: []]

(normally `host: nil` would be fully sufficient, but here a non-standard port 4001 is used, so `host: "localhost:4001"` had to be provided)

## Building

  * Install dependencies
				```bash
        $ mix deps.get
        ```
  * Generate certificates `mix phx.gen.cert` (if the `phx.gen.cert` target is missing, install it with `mix archive.install hex phx_new 1.4.16`)
				```bash
        $ mix phx.gen.cert # if the `phx.gen.cert` target is missing, install it with `mix archive.install hex phx_new 1.4.16`
        ```
  * Compresses static files
				```bash
        $ mix phx.digest
        ```
  * Release
				```bash
        $ SECRET_KEY_BASE=$(mix phx.gen.secret) MIX_ENV=prod mix release
				```

## Testing the issue

  * Start Phoenix endpoint with:
				```bash
        $ _build/prod/rel/hello_world/bin/hello_world start
				```

  * Display routes

        $ mix phx.routes

        page_path  GET  /                                      HelloWorldWeb.PageController :index
        websocket  WS   /socket/websocket                      HelloWorldWeb.UserSocket

  * Connect `/socket/websocket` route with curl and the server will respond with 301 redirect

        $ curl -s -D- http://localhost:4000/socket/websocket

        HTTP/1.1 301 Moved Permanently
        location: https://localhost:4001/socket/websocket

  * Connect route `/` with curl and, surprisingly, the server responds with 200 OK

        $ curl -s -D- http://localhost:4000

        HTTP/1.1 200 OK

