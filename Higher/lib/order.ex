defmodule Order do
  def double([]) do
    0
  end

  def double([h | t]) do
    double(t)
    [h * 2 | double(t)]
  end

  def double_five_animal([], _) do
    []
  end

  def double_five_animal([h | t], arg) do
    case arg do
      :double ->
        list = double_five_animal(t, arg)
        [h * 2 | list]

      :animal ->
        list = double_five_animal(t, arg)

        if h == :dog do
          [:fido | list]
        else
          [h | list]
        end

      :five ->
        list = double_five_animal(t, arg)
        [h + 5 | list]
    end
  end

  # map function fn(x) -> if (x == :dog), do: :fido, else: x end) for animal
  def apply_to_all([], _op) do
    []
  end

  def apply_to_all([h | t], op) do
    [op.(h) | apply_to_all(t, op)]
  end

  def sum([]) do
    0
  end

  def sum([h | t]) do
    h + sum(t)
  end

  # fold right
  def foldr([], acc, _op) do
    acc
  end

  def foldr([h | t], acc, op) do
    op.(h, foldr(t, acc, op))
  end

  # fold left
  def foldl([], acc, _op) do
    acc
  end

  def foldl([h | t], acc, op) do
    foldl(t, op.(h, acc), op)
  end



  def filter([], _) do
    []
  end

  def filter([h | t], op) do
    if op.(h) do
      [h | filter(t, op)]
    else
      filter(t, op)
    end
  end
end
