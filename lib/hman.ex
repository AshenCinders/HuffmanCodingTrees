defmodule Hman do
  @moduledoc """
  TODO
  """

  use Application
  alias Hman.Dispatch

  # Main is run by command binary produced by escript.
  @spec main([binary()]) :: {:error, any()} | {:ok, pid()}
  def main(args) do
    start(nil, args)
  end

  @spec start(any(), [binary()]) :: {:error, any()} | {:ok, pid()}
  def start(_type, args) do
    # TODO Actual supervisor stuff
    Dispatch.run(args)

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: A.Worker.start_link(arg)
      # {Hman.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hman.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
