import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: ZeroPhoenix.Finch

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.

# Configures prom_ex
config :zero_phoenix, ZeroPhoenix.PromEx,
  disabled: false,
  manual_metrics_start_delay: :no_delay,
  drop_metrics_groups: [],
  grafana: [
    host: System.get_env("GRAFANA_HOST", raise("GRAFANA_HOST is required")),
    auth_token: System.get_env("GRAFANA_TOKEN", raise("GRAFANA_TOKEN is required")),
    folder_name: "zero-to-graphql-using-elixir",
    upload_dashboards_on_start: true,
    annotate_app_lifecycle: true
  ],
  metrics_server: [
    protocol: :http,
    path: "/metrics",
    port: 4021,
    pool_size: 5,
    cowboy_opts: []
    auth_strategy: :bearer,
    auth_token: "<YOUR_AUTH_TOKEN_HERE>",
  ]
