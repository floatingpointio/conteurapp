use Mix.Config

config :conteur_app, ConteurApp.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "conteurapp.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :conteur_app, ConteurApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20,
  ssl: true

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "590221922732-cv0o0e9hvok3r6e7uc2ke0mi04lhl68p.apps.googleusercontent.com",
  client_secret: "SiVaZlI_Y9cJZ-sxuM_ggWG7"

config :logger, level: :info

config :conteur_app, :google,
  api_key: "AIzaSyCKm4l9XKrF-j9ONrRuTu31aKmz826JgH8"
