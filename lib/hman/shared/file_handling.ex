defmodule Hman.Shared.FileHandling do
  @moduledoc """
  Contains wrappers for file operations to abstract away unnecessary errors.
  """

  @doc """
  Wrapper for File.read.
  Any error will be sent as :file_read.
  """
  @spec read_file(Path.t()) :: {:ok, binary()} | {:error, :file_read}
  def read_file(path) do
    case File.read(path) do
      {:ok, data} -> {:ok, data}
      {:error, _reason} -> {:error, :file_read}
    end
  end

  @doc """
  Wrapper for File.write.
  Any error will be sent as :file_write.
  """
  @spec write_file(Path.t(), iodata()) :: {:ok, :write_success} | {:error, :file_write}
  def write_file(path, data) do
    case File.write(path, to_string(data)) do
      :ok -> {:ok, :write_success}
      {:error, _reason} -> {:error, :file_write}
    end
  end
end
