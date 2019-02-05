defmodule MessageProjector.MixProject do
  use Mix.Project

  def project do
    [
      app: :message_projector,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:amqp, :memento],
      extra_applications: [:logger],
      mod: {MessageProjector, [queue: :dead_final]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:amqp, "~> 1.1.0"},
      {:memento, "~> 0.2.1"},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
    ]
  end
end
