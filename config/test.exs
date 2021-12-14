import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :zero_phoenix, ZeroPhoenix.Repo,
  username: "postgres",
  password: "postgres",
  database: "zero_phoenix_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :zero_phoenix, ZeroPhoenixWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "8ry+7zZ8q3QB18RmDZ5xP/oe8nprdfMp5ht1id/FocOspw/oi0EggAilESNuG5Y0",
  server: false

# In test we don't send emails.
config :zero_phoenix, ZeroPhoenix.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
