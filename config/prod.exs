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

config :logger, level: :info

config :conteur_app, :google,
  api_key: "AIzaSyCKm4l9XKrF-j9ONrRuTu31aKmz826JgH8"

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "517182216420-vrl9ma0f3tdled81f2f8v6f52mm7feqt.apps.googleusercontent.com",
  client_secret: "UXVH2wRMNZhD-DVxH5iMKorY"

