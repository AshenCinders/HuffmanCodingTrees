defmodule Hman.Dispatch do
  @moduledoc """
  Startpoint of program use.
  Takes CLI args, parses and dispatches to correct operation.
  E.g. decode a single file.
  """

  alias Hman.Encode.EncodeFile

  @spec run([binary()]) :: :ok
  def run(args) do
    # IO.inspect(args)

    {switches, _remaining, invalid} = parse(args)

    cond do
      length(invalid) != 0 ->
        handle_invalid_usage()

      # User typed only "./hman"
      length(switches) == 0 ->
        handle_help_usage()

      true ->
        handler_dispatch(switches)
    end
  end

  defp parse(args) do
    OptionParser.parse(args,
      strict: [encode: :string, decode: :string, help: :boolean],
      aliases: [e: :encode, d: :decode, h: :help]
    )
  end

  defp handler_dispatch(switches) do
    case switches do
      [{:encode, path} | _rest] ->
        IO.puts("Encode")
        result = EncodeFile.txt_to_bin(path)
        IO.inspect(result)

      [{:decode, _path} | _rest] ->
        IO.puts("Decode")

      [{:help, _} | _rest] ->
        handle_help_usage()

      _ ->
        handle_invalid_usage()
    end
  end

  defp handle_help_usage() do
    """
    [Help docs]
    hman usage:

    --help       Show this help page
    -h

    --encode     Compress a .txt file into a .bin and an accompanying huffman tree
    -e

    --decode     Uncompress an (hman-created) .bin into a .txt file
    -d
    """
    |> IO.write()
  end

  defp handle_invalid_usage() do
    """
    Invalid arguments :(
    Make sure the flags and order of them are correct
    You can view usage with --help
    """
    |> IO.write()
  end
end
