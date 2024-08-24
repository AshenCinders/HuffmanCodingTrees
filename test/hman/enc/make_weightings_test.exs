defmodule MakeWeightingsTest do
  use ExUnit.Case, async: true
  alias Hman.Enc.MakeWeightings

  describe "weightings_from_graphemes/1" do
    test "handles an empty list" do
      assert MakeWeightings.weightings_from_graphemes([]) == []
    end

    test "handles one grapheme" do
      assert MakeWeightings.weightings_from_graphemes(String.graphemes("a")) == [{1, "a"}]
    end

    test "handles multiple occurences of the same letter" do
      assert MakeWeightings.weightings_from_graphemes(String.graphemes("bbbbb")) == [{5, "b"}]
    end

    test "handles multiple different letters and occurences" do
      weights = MakeWeightings.weightings_from_graphemes(String.graphemes("tests"))
      assert {2, "t"} in weights
      assert {1, "e"} in weights
      assert {2, "s"} in weights
      assert length(weights) == 3
    end

    test "handles spaces" do
      weights = MakeWeightings.weightings_from_graphemes(String.graphemes("     "))
      assert {5, " "} in weights
    end
  end
end
