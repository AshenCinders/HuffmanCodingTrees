defmodule Hman do
  @moduledoc """
  TODO
  """

  use Application

  # no clue why this is needed
  def start() do
    IO.puts("Starting up no args")
  end

  def start(_type, _args) do
    IO.puts("Starting up")
    # TODO

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: A.Worker.start_link(arg)
      # {A.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: A.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

Hman.start()
