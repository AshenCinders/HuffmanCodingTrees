defmodule Hman.Shared.Binary do
  @moduledoc """
  Provides functions for converting between bitlists [1 | 0],
  and binary data from text files
  (representing text encoded with a Huffman tree).
  """

  @doc """
  Takes a bitlist and creates a byte-aligned binary.
  If the list length mod 8 is not 0, the list will be padded until it is,
  by appedning 0 elements to the end of the list.
  """
  @spec bitlist_to_binary([0 | 1]) :: binary()
  def bitlist_to_binary(lst) do
    left_to_full_byte = (8 - rem(length(lst), 8)) |> rem(8)

    list_end =
      if left_to_full_byte != 0 do
        for _ <- 1..left_to_full_byte, do: 0
      else
        []
      end

    byte_aligned_list = Enum.concat(lst, list_end)
    Enum.into(byte_aligned_list, <<>>, fn bit -> <<bit::1>> end)
  end

  # @spec binary_to_bitlist(binary()) :: [0 | 1]
  # def binary_to_bitlist(bin) do
  # end
end
