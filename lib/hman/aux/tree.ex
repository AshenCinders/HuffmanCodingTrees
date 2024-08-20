defmodule Hman.Aux.Tree do
  @moduledoc """
    Generic recursive 2-child tree structure.
    Each node stores 1 piece of data, nil by default.
    Leaf nodes have its children as nil.

    Use Get for reading / traversing.
    Use Set for writing to the structure.
  """
  defmodule Set do
    def new_node() do
      {nil, nil, nil}
    end

    def new_node(data) do
      {nil, nil, data}
    end

    def new_node(left, right, data) do
      {left, right, data}
    end

    def left(node, child) do
      put_elem(node, 0, child)
    end

    def right(node, child) do
      put_elem(node, 1, child)
    end

    def data(node, data) do
      put_elem(node, 2, data)
    end
  end

  defmodule Get do
    def left(node) do
      elem(node, 0)
    end

    def right(node) do
      elem(node, 1)
    end

    def data(node) do
      elem(node, 2)
    end
  end
  def leaf?(node) do
    cond do
      is_nil(Get.left(node)) and is_nil(Get.right(node)) -> true
      true -> false
    end
  end
end
