defmodule Hman.Dispatch do
  @moduledoc """
  Startpoint of program use.
  Takes CLI args, parses and dispatches to correct operation.
  E.g. decode a single file.
  """

  alias Hman.Enc.EncodeFile

  @spec run([binary()]) :: :ok
  def run(args) do
    # IO.inspect(args)
    {switches, _remaining, _invalid} =
      OptionParser.parse(args,
        strict: [encode: :string, decode: :string, help: :boolean],
        aliases: [e: :encode, d: :decode, h: :help]
      )

    case switches do
      [{:encode, _path} | _rest] ->
        IO.puts("Encode")

      [{:decode, _path} | _rest] ->
        IO.puts("Decode")

      [{:help, _} | _rest] ->
        IO.puts("TODO help")

      _ ->
        IO.puts("Invalid arguments :(")
        IO.puts("Make sure the flags and order of them are correct")
        IO.puts("You can view usage with --help")
    end
  end
end
