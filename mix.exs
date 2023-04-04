defmodule ZeroPhoenix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :zero_phoenix,
      version: "3.5.3",
      elixir: "~> 1.14.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: [
        "test.watch": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ZeroPhoenix.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "dev/support", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "dev/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.16"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.8.3"},
      {:postgrex, "~> 0.16.5"},
      {:phoenix_live_dashboard, "~> 0.6.5"},
      {:swoosh, "~> 1.8.0"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:telemetry_poller, "~> 1.0.0"},
      {:gettext, "~> 0.20.0"},
      {:jason, "~> 1.3.0"},
      {:plug_cowboy, "~> 2.5.2"},
      {:absinthe, "~> 1.7.1"},
      {:absinthe_plug, "~> 1.5.8"},
      {:cors_plug, "~> 3.0.3"},
      {:credo, "~> 1.6.7", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:ecto_psql_extras, "~> 0.7.4"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
