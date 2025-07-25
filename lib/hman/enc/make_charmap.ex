defmodule Hman.Enc.MakeCharmap do
  @moduledoc """
  Make a map for encoding chars to bits.
  Use `tree_to_charmap/1`.
  """

  @typedoc """
  A map used for encoding text to binary.
  Each key is a char, with its accompanying value being an
  ordered list of 0s and 1s denoting its huffman binary value.
  """
  @type charmap() :: %{char() => list(1 | 0)}

  alias Hman.Aux.Tree
  alias Hman.Aux.Stack
  alias Hman.Enc.MakeTree

  # Equivalent check to Stack.empty? but is allowed in guard clause.
  defp gen_charmap(stck, char_map) when elem(stck, 1) == 0 do
    char_map
  end

  defp gen_charmap(stck, char_map) do
    current = Stack.top(stck)

    current_tree = elem(current, 0)
    bit_list = elem(current, 1)

    stck = Stack.pop(stck)

    {stck, char_map} =
      case Tree.leaf?(current_tree) do
        true ->
          c = MakeTree.get_char(current_tree)
          {stck, Map.put(char_map, c, bit_list)}

        false ->
          stck = Stack.push(stck, {Tree.Get.right(current_tree), bit_list ++ [1]})
          {Stack.push(stck, {Tree.Get.left(current_tree), bit_list ++ [0]}), char_map}
      end

    gen_charmap(stck, char_map)
  end

  @doc """
  Generates a charmap().
  Takes a huffman tree as argument.
  Returns map containing chars as keys, with bit-lists (in order) as values.
  """
  @spec tree_to_charmap(MakeTree.huffman_tree()) :: charmap()
  def tree_to_charmap(tree) do
    node_stack = Stack.new_stack()

    node_stack = Stack.push(node_stack, {Tree.Get.right(tree), [1]})
    node_stack = Stack.push(node_stack, {Tree.Get.left(tree), [0]})

    gen_charmap(node_stack, %{})
  end

  @doc """
  Takes a list of chars (single char strings) and extracts each corresponding bitlist.
  The resulting 2-dimensional map is automatically flattned in the process.
  """
  @spec charlist_to_bitlist(list(char()), charmap()) :: [0 | 1]
  def charlist_to_bitlist(list_of_chars, charmap) do
    Enum.flat_map(list_of_chars, fn x -> charmap[x] end)
  end
end
