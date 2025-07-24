defmodule Huffmancodingtrees.MixProject do
  use Mix.Project

  def project do
    [
      app: :hman,
      version: "0.1.0",
      elixir: "~> 1.17.2",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Can just do "mix" instead of "mix run"
      # default_task: "run",
      default_task: "escript.build",
      docs: [
        main: "HuffmanCodingTrees",
        extras: ["README.md"]
      ],
      escript: [main_module: Hman]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # "mod: {Hman, []}" is what causes the app to start
      # when "mix run" in terminal.
      # Uncomment if running as normal application, comment if with escript.
      # mod: {Hman, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end
end
