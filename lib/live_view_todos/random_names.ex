defmodule LiveViewTodos.RandomNames do
  @vowels ~w(a e i o u)
  @consonants ~w(b c d f g h j k l m n p q r s t v w x y z)

  def generate_random_name(length \\ 6) do
    name = Enum.join(generate_random_syllables(length))
    String.capitalize(name)
  end

  defp generate_random_syllables(length) when length > 0 do
    syllable = generate_syllable()
    [syllable | generate_random_syllables(length - 1)]
  end

  defp generate_random_syllables(0), do: []

  defp generate_syllable() do
    vowel = Enum.random(@vowels)
    consonant = Enum.random(@consonants)
    "#{consonant}#{vowel}"
  end
end
