defmodule MakeCharmapTest do
  use ExUnit.Case, async: true
  alias Hman.Enc.MakeCharmap
  alias Hman.Enc.MakeWeightings
  alias Hman.Enc.MakeTree

  defp string_to_tree(str) do
    {:ok, tree} =
      str
      |> String.graphemes()
      |> MakeWeightings.weightings_from_graphemes()
      |> MakeTree.new_huffman_tree()

    tree
  end

  describe "tree_to_charmap/1" do
    test "handles smallst possible tree" do
      cmap = MakeCharmap.tree_to_charmap(string_to_tree("ab"))

      assert cmap["a"] == [0]
      assert cmap["b"] == [1]
      assert length(Map.keys(cmap)) == 2
    end

    test "correctly calculates bitlists for larger trees and does not care about alphabet- or string ordering" do
      cmap = MakeCharmap.tree_to_charmap(string_to_tree("aaaaabbbcdddddddddd"))
      keys = Map.keys(cmap)

      assert "a" in keys
      assert "b" in keys
      assert "c" in keys
      assert "d" in keys
      assert length(keys) == 4

      # IO.inspect(cmap)
      assert length(cmap["d"]) <= length(cmap["a"])
      assert length(cmap["a"]) <= length(cmap["b"])
      assert length(cmap["b"]) <= length(cmap["c"])
    end
  end
end
