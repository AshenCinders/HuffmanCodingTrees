defmodule Hman.Shared.Types do
  @type encode_error() :: :file_read | :file_write | :too_few_elements

  # | decode_error() | cli_error
  @type project_error() :: encode_error()
end
