defmodule Hman.Aux.Tree do
  @moduledoc """
    Generic recursive 2-child tree structure.
    Each node stores 1 piece of data, nil by default.
    Leaf nodes have its children as nil.

    Use Get for reading / traversing.
    Use Set for writing to the structure.
    Use leaf?/1 for checking if a node is a leaf.
  """

  @typedoc """
  A generic 2-child tree created from calling `new_node()`
  """
  @type t() :: {t() | nil, t() | nil, any()}

  defmodule Set do
    @spec new_node() :: Tree.t()
    def new_node() do
      {nil, nil, nil}
    end

    @spec new_node(any()) :: Tree.t()
    def new_node(data) do
      {nil, nil, data}
    end

    @spec new_node(Tree.t(), Tree.t(), any()) :: Tree.t()
    def new_node(left, right, data) do
      {left, right, data}
    end

    @spec left(Tree.t(), any()) :: Tree.t()
    def left(node, child) do
      put_elem(node, 0, child)
    end

    @spec right(Tree.t(), any()) :: Tree.t()
    def right(node, child) do
      put_elem(node, 1, child)
    end

    @spec data(Tree.t(), any()) :: Tree.t()
    def data(node, data) do
      put_elem(node, 2, data)
    end
  end

  defmodule Get do
    @spec left(Tree.t()) :: Tree.t() | nil
    def left(node) do
      elem(node, 0)
    end

    @spec right(Tree.t()) :: Tree.t() | nil
    def right(node) do
      elem(node, 1)
    end

    @spec data(Tree.t()) :: any()
    def data(node) do
      elem(node, 2)
    end
  end

  @spec leaf?(Tree.t()) :: boolean()
  def leaf?(node) do
    cond do
      is_nil(Get.left(node)) and is_nil(Get.right(node)) -> true
      true -> false
    end
  end
end
