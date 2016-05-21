use Mix.Config

config :conteur_app, ConteurApp.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/brunch/bin/brunch", "watch", "--stdin"
    ]
  ],
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

config :conteur_app, ConteurApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "conteurapp_dev",
  hostname: "localhost",
  pool_size: 10

config :conteur_app, :google,
  api_key: "AIzaSyB1eGONIXeyyRws15p1kNzkS446TW8TOBg"

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "517182216420-t69s9ner27919m075k8tki9sd3ti6kvf.apps.googleusercontent.com",
  client_secret: "TARB9FfAvHhOe4wiXTQnQjoY"

