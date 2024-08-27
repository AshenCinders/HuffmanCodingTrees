defmodule Hman.Aux.Stack do
  @moduledoc """
  Generic stack data-structure. Use following functions:
  new_stack/0, new_stack/1 for initialising stacks.
  push/2, pop/1 for adding and removing elements from a stack.
  top/1 to get top-most element in the given stack.
  empty?/1 to check if given stack has any elements left.
  """
  alias Hman.Aux.Stack

  @typedoc """
  A stack from the Hman.Aux.Stack module created from calling `new_stack()`
  """
  @type t() :: {list(), number()}

  @spec new_stack() :: Stack.t()
  def new_stack() do
    {[], 0}
  end

  @doc """
  new_stack/1 pushes all elements to the stack in the order of the list.
  """
  @spec new_stack(list()) :: Stack.t()
  def new_stack(ordered_list) do
    {Enum.reverse(ordered_list), length(ordered_list)}
  end

  @spec push(Stack.t(), any()) :: Stack.t()
  def push(stack, data) do
    {[data | elem(stack, 0)], elem(stack, 1) + 1}
  end

  @spec pop(Stack.t()) :: Stack.t()
  def pop(stack) do
    {tl(elem(stack, 0)), elem(stack, 1) - 1}
  end

  @spec top(Stack.t()) :: any()
  def top(stack) do
    hd(elem(stack, 0))
  end

  @spec empty?(Stack.t()) :: boolean()
  def empty?(stack) do
    elem(stack, 1) == 0
  end
end
