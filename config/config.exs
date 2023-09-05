# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :zero_phoenix,
  ecto_repos: [ZeroPhoenix.Repo]

# Configures the endpoint
config :zero_phoenix, ZeroPhoenixWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: ZeroPhoenixWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ZeroPhoenix.PubSub,
  live_view: [signing_salt: "C+FqzhZ3"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :zero_phoenix, ZeroPhoenix.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures mix_test_watch
if Mix.env() == :dev do
  config :mix_test_watch,
    clear: true,
    tasks: [
      "test",
      "credo"
    ]
end

# Configures prom_ex
config :zero_phoenix, ZeroPhoenix.PromEx,
  disabled: false,
  manual_metrics_start_delay: :no_delay,
  drop_metrics_groups: [],
  grafana: [
    host: System.get_env("GRAFANA_HOST", "http://localhost:3000"),
    username: System.get_env("GF_SECURITY_ADMIN_USER", "admin"),
    password: System.get_env("GF_SECURITY_ADMIN_PASSWORD", "admin"),
    folder_name: "zero-to-graphql-using-elixir",
    upload_dashboards_on_start: true,
    annotate_app_lifecycle: true
  ],
  metrics_server: [
    protocol: :http,
    path: "/metrics",
    port: 4021,
    pool_size: 5,
    cowboy_opts: [],
    auth_strategy: :none
  ]

# config :zero_phoenix, ZeroPhoenix.PromEx,
#   grafana_datasource_id: System.get_env("GRAFANA_DATASOURCE_ID", "Local Prometheus")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
