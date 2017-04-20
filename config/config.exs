# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :blogql_elixir,
  ecto_repos: [BlogqlElixir.Repo]

# Configures the endpoint
config :blogql_elixir, BlogqlElixir.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "scSi5q+KIz6a3Jmkx1mcAMrRsyDDbDaS4R1SLg71GmaX6hZ9pRQva3ue9UoiNpOX",
  render_errors: [view: BlogqlElixir.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BlogqlElixir.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS256"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "MyApp",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  secret_key: "Q/pRXuJQoZblGk4AIO9VvoXakzuUpBS91hQVl//3abrtRd/iAobc3CdBkMPDVYgc", # replace this in production
  serializer: BlogqlElixir.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
