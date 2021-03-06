use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :price_api, PriceApiWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :price_api, PriceApi.Repo,
  adapter: Mongo.Ecto,
  database: "price_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
