defmodule Hman.Enc.EncodeFile do
  alias Hman.Shared.Types
  alias Hman.Shared.Binary
  alias Hman.Enc.MakeWeightings
  alias Hman.Enc.MakeTree
  alias Hman.Enc.MakeCharmap

  # Abstracts away different file errors to simplify error handling.
  # The verbosity the default functions give is as of writing unnecessary.
  @spec read_file(Path.t()) :: {:ok, binary()} | {:error, :file_read}
  defp read_file(path) do
    case File.read(path) do
      {:ok, data} -> {:ok, data}
      {:error, _reason} -> {:error, :file_read}
    end
  end

  @spec write_file(Path.t(), iodata()) :: {:ok, :write_success} | {:error, :file_write}
  defp write_file(path, data) do
    case File.write(path, to_string(data)) do
      :ok -> {:ok, :write_success}
      {:error, _reason} -> {:error, :file_write}
    end
  end

  # returns ok/error tuple from huffman fn
  @spec graphemes_to_tree([String.grapheme()]) ::
          {:ok, MakeTree.huffman_tree()} | {:error, atom()}
  defp graphemes_to_tree(lst) do
    lst
    |> MakeWeightings.weightings_from_graphemes()
    |> MakeTree.new_huffman_tree()
  end

  @spec graphemes_to_binary([String.grapheme()], MakeTree.huffman_tree()) :: binary()
  def graphemes_to_binary(grapheme_lst, tree) do
    cmap = MakeCharmap.tree_to_charmap(tree)
    bitlist = MakeCharmap.charlist_to_bitlist(to_charlist(grapheme_lst), cmap)
    Binary.bitlist_to_binary(bitlist)
  end

  defp path_for_tree(text_path) do
    text_path
    |> Path.dirname()
    |> Path.join("tree.txt")
  end

  defp path_for_binary(text_path) do
    date_time_str =
      System.os_time()
      |> DateTime.from_unix(:second)

    text_path
    |> Path.basename(".txt")
    |> Path.join("#{date_time_str}.bin")
  end

  @spec txt_to_bin(String.t()) ::
          {:error, Types.encode_error()} | {:ok, :encode_success}
  def txt_to_bin(path_with_file) do
    # Only use File.close if using File.open, otherwise should close by itself.
    # NOTE: janky autoformatting in with clauses.
    with {:ok, text} <- read_file(path_with_file),
         grapheme_list = String.graphemes(text),
         # Get huffman tree.
         {:ok, tree} <- graphemes_to_tree(grapheme_list),
         # Store tree.
         # TODO: Look at storing tree in main output file in future.
         tree_path = path_for_tree(path_with_file),
         {:ok, :write_success} <- write_file(tree_path, inspect(tree)),
         # Generate and store binary.
         binary = graphemes_to_binary(grapheme_list, tree),
         bin_path = path_for_binary(path_with_file),
         {:ok, :write_success} = write_file(bin_path, binary) do
      {:ok, :encode_success}
    else
      {:error, type} -> {:error, type}
    end
  end
end

# TODO note for decode
# IO.inspect(Code.eval_string(inspect({{nil, nil, {1, "a"}}, {nil, nil, {1, "b"}}, {2, :travel_node}})))
# IO.inspect(inspect({{nil, nil, {1, "a"}}, {nil, nil, {1, "b"}}, {2, :travel_node}}))
