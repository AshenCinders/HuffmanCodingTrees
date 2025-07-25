defmodule Hman.Encode.MakeWeightings do
  @moduledoc """
  For creating a list containing tuples with weight
  (the number of occurences a character) and the char itself.
  """

  defp count_chars([], result) do
    result
  end

  defp count_chars(lst, result) do
    char = hd(lst)

    result =
      case Enum.find_index(result, fn x -> elem(x, 1) == char end) do
        nil ->
          [{1, char} | result]

        index ->
          {weight, char} = Enum.at(result, index)
          List.replace_at(result, index, {weight + 1, char})
      end

    count_chars(tl(lst), result)
  end

  defp count_chars(lst) do
    count_chars(lst, [])
  end

  @doc """
  Takes a grapheme list as argument
  and returns a list with tuples containing weight with chars.
  """
  @spec weightings_from_graphemes(list(String.grapheme())) :: list({number(), char()})
  def weightings_from_graphemes(lst) do
    count_chars(to_charlist(lst))
  end
end
