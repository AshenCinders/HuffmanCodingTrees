defmodule BinaryTest do
  use ExUnit.Case, async: true
  alias Hman.Shared.Binary

  describe "bitlist_to_binary/1" do
    test "encodes an empty bitlist to 1 zeroed, byte" do
      bin = Binary.bitlist_to_binary([])
      assert :binary.decode_unsigned(bin) == 0
    end

    test "encodes a small bitlist divisible by 8" do
      bin = Binary.bitlist_to_binary([1, 0, 0, 0, 0, 1, 0, 0])
      assert :binary.decode_unsigned(bin) == 132
    end

    test "encodes a bitlist with a single bit to a binary by appending zeroes" do
      bin = Binary.bitlist_to_binary([1])
      assert :binary.decode_unsigned(bin) == 128
    end

    test "encondes a non-aligned bitlist to a binary, correctly" do
      # 20 1s.
      lst = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      bin = Binary.bitlist_to_binary(lst)
      assert :binary.decode_unsigned(bin) == 16_777_200
    end
  end
end
