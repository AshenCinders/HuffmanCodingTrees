defmodule MakeTreeTest do
  use ExUnit.Case, async: true
  alias Hman.Enc.MakeTree
  alias Hman.Enc.MakeWeightings
  alias Hman.Aux.Tree

  describe("new_huffman_tree/1") do
    test "returns error if less than 2 elements" do
      weights = MakeWeightings.weightings_from_graphemes(String.graphemes("a"))
      assert MakeTree.new_huffman_tree(weights) == {:error, :too_few_elements}

      assert MakeTree.new_huffman_tree(String.graphemes("")) == {:error, :too_few_elements}
    end

    test "returns valid tree from 2 elements" do
      weights = MakeWeightings.weightings_from_graphemes(String.graphemes("ab"))
      {:ok, tree} = MakeTree.new_huffman_tree(weights)
      assert Tree.Get.data(tree) == {2, :travel_node}
      assert Tree.Get.data(Tree.Get.left(tree)) == {1, "a"}
      assert Tree.Get.data(Tree.Get.right(tree)) == {1, "b"}
    end

    test "calculates char count correctly" do
      weights = MakeWeightings.weightings_from_graphemes(String.graphemes("cccdddddddddd"))
      {:ok, tree} = MakeTree.new_huffman_tree(weights)
      assert MakeTree.get_weight(tree) == 13

      left_data = Tree.Get.data(Tree.Get.left(tree))
      assert left_data == {3, "c"}
      right_data = Tree.Get.data(Tree.Get.right(tree))
      assert right_data == {10, "d"}
    end

    test "counts total chars of long string" do
      long_string =
        "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book."

      weights = MakeWeightings.weightings_from_graphemes(String.graphemes(long_string))
      {:ok, tree} = MakeTree.new_huffman_tree(weights)
      assert MakeTree.get_weight(tree) == 297
    end
  end

  describe "get_char/1" do
    test "gets correct values for a 3-node tree" do
      {:ok, tree} =
        "21"
        |> String.graphemes()
        |> MakeWeightings.weightings_from_graphemes()
        |> MakeTree.new_huffman_tree()

      assert MakeTree.get_char(tree) == :travel_node

      left = Tree.Get.left(tree)
      assert MakeTree.get_char(left) == "2"

      right = Tree.Get.right(tree)
      assert MakeTree.get_char(right) == "1"
    end
  end

  describe "get_weight/1" do
    test "gets correct weight for a 3-node tree" do
      {:ok, tree} =
        "hggg"
        |> String.graphemes()
        |> MakeWeightings.weightings_from_graphemes()
        |> MakeTree.new_huffman_tree()

      assert MakeTree.get_weight(tree) == 4

      left = Tree.Get.left(tree)
      assert MakeTree.get_weight(left) == 1

      right = Tree.Get.right(tree)
      assert MakeTree.get_weight(right) == 3
    end
  end
end
