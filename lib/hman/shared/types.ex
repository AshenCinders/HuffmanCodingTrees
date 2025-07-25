defmodule Hman.Shared.Types do
  @typedoc """
  A tree structure used for encoding/decoding text to/from binary.
  It follows the same structure as Hman.Aux.Tree.t(), and has its data value
  as a tuple containing a weight and the corresponding char.
  The data in the structure is {number(), :travel_node} for travel nodes, and
  {number(), char()} for leaf nodes.
  """
  @type htree :: Hman.Aux.Tree.t()

  @type encode_error() :: :file_read | :file_write | :too_few_elements

  # | decode_error() | cli_error
  @type project_error() :: encode_error()
end
