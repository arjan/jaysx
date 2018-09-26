defmodule Jaysx.MixProject do
  use Mix.Project

  def project do
    [
      app: :jaysx,
      version: File.read!("VERSION"),
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A JSX sigil for Elixir"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    []
  end
end
