# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :price_api,
  ecto_repos: [PriceApi.Repo]

# Configures the endpoint
config :price_api, PriceApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wZI/XqLlj9ylrTXkK09OWS1URvBSRIEXyaoEkkNLUEydJcverqHYFlNl+z6cmuln",
  render_errors: [view: PriceApi.ErrorView, accepts: ~w(json)],
  pubsub: [name: PriceApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
