defmodule Hman.Enc.MakeWeightings do
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
      case Enum.find_index(result, fn x -> x == char end) do
        nil ->
          [{1, char} | result]

        index ->
          {weight, char} = Enum.at(result, index)
          List.insert_at(result, index, {weight + 1, char})
      end

    count_chars(tl(lst), result)
  end

  defp count_chars(lst) do
    count_chars(lst, [])
  end

  @doc """
  Takes a grapheme list as agument
  and returns a list with tuples containing weight with chars.
  """
  @spec weightings_from_graphemes(list(char())) :: list({number(), char()})
  def weightings_from_graphemes(lst) do
    count_chars(lst)
  end
end
