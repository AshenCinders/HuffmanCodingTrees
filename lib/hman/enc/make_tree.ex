# getchar get_weight
defmodule Hman.Enc.MakeTree do
  @moduledoc """
  For creating a `MakeTree.huffman_tree()` used for
  encoding and decoding text to/from binary.
  """

  @typedoc """
  A tree structure used for encoding/decoding text to/from binary.
  It follows the same structure as Hman.Aux.Tree.t(), and has its data value
  as a tuple containing a weight and the corresponding char.
  The structure is {number(), :travel_node} for travel nodes, and
  {number(), char()} for leaf nodes.
  """
  @type huffman_tree :: Hman.Aux.Tree.t()

  alias Hman.Aux.Tree

  defmodule Weighting do
    @moduledoc false

    defp weights_to_nodes([], nodes) do
      nodes
    end

    defp weights_to_nodes(weights, nodes) do
      new_node = Tree.Set.new_node(hd(weights))
      weights_to_nodes(tl(weights), [new_node | nodes])
    end

    def weights_to_nodes(lst) do
      weights_to_nodes(lst, [])
    end
  end

  defp insert_sorted_queue(lst, element) do
    {weight, :travel_node} = Tree.Get.data(element)
    index = Enum.find_index(lst, fn x -> get_weight(x) >= weight end)

    index = if is_nil(index), do: length(lst), else: index

    List.insert_at(lst, index, element)
  end

  # Case where lenght < 2 should only happen when only the full tree is in the queue,
  # since each call decrements by 2,
  # and 1 element is always added to queue in the function.

  # Base case.
  defp tree_from_queue(queue) when length(queue) < 2 do
    hd(queue)
  end

  defp tree_from_queue(queue) do
    node1 = hd(queue)
    node2 = hd(tl(queue))

    new_weight =
      get_weight(node1) +
        get_weight(node2)

    tree = Tree.Set.new_node(node1, node2, {new_weight, :travel_node})
    queue = insert_sorted_queue(queue, tree)

    tree_from_queue(tl(tl(queue)))
  end

  @doc """
  Generates a huffman_tree.
  Takes a list of weights and chars, returns an ok-tuple
  with a huffman_tree if more than two elements have been supplied, otherwise
  returns an error-tuple.
  """
  @spec new_huffman_tree([] | list({number(), char()})) :: {:error, :too_few_elements}
  @spec new_huffman_tree(list({number(), char()})) :: {:ok, huffman_tree()}
  def new_huffman_tree(lst) when length(lst) < 2 do
    {:error, :too_few_elements}
  end

  def new_huffman_tree(lst) when length(lst) >= 2 do
    func = &(get_weight(&1) <= get_weight(&2))

    queue =
      Weighting.weights_to_nodes(lst)
      |> Enum.sort(func)

    {:ok, tree_from_queue(queue)}
  end

  @doc """
  Returns the char (if a leaf) or :travel_node of a huffman_tree() node.
  """
  @spec get_char(huffman_tree()) :: char() | :travel_node
  def get_char(node) do
    Tree.Get.data(node)
    |> elem(1)
  end

  @doc """
  Returns the weight number of a huffman_tree() node.
  """
  @spec get_weight(huffman_tree()) :: number()
  def get_weight(node) do
    Tree.Get.data(node)
    |> elem(0)
  end
end
