defmodule MakeCharmapTest do
  use ExUnit.Case, async: true
  alias Hman.Encode.MakeCharmap
  alias Hman.Encode.MakeWeightings
  alias Hman.Encode.MakeTree

  defp string_to_tree(str) do
    {:ok, tree} =
      str
      |> String.graphemes()
      |> MakeWeightings.weightings_from_graphemes()
      |> MakeTree.new_htree()

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

  describe "charlist_to_bitlist/2" do
    test "produces a correct bitlist" do
      charmap = %{"a" => [1, 0, 1, 0], "b" => [0, 0, 0], "c" => [1, 1, 1, 1, 1]}
      charlist = ["b", "b", "a", "c", "a"]
      expect = [0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0]
      assert expect == MakeCharmap.charlist_to_bitlist(charlist, charmap)
    end
  end
end
