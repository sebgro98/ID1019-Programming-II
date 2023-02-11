defmodule High do
  def test() do
    deck = [
      {:card, :heart, 5},
      {:card, :heart, 7},
      {:card, :spade, 2},
      {:card, :club, 3},
      {:card, :diamond, 4}
    ]

    sort(deck, fn c1, c2 -> lt(c1, c2) end)
  end

  def lt({:card, s, v1}, {:card, s, v2}) do
    v1 < v2
  end

  def lt({:card, :club, _}, _) do
    true
  end

  def lt({:card, :diamond, _}, {:card, :heart, _}) do
    true
  end

  def lt({:card, :diamond, _}, {:card, :spade, _}) do
    true
  end

  def lt({:card, :heart, _}, {:card, :spade, _}) do
    true
  end

  def lt({:card, _, _}, {:card, _, _}) do
    false
  end

  def sort([], _) do
    []
  end

  def sort([n], _) do
    [n]
  end

  def sort(list, op) do
    {a, b} = split(list)
    merge(sort(a, op), sort(b, op), op)
  end

  def split([]) do
    {[], []}
  end

  def split([c]) do
    {[c], []}
  end

  def split([c1, c2 | t]) do
    {s1, s2} = split(t)
    {[c1 | s1], [c2, s2]}
  end

  def merge([], b, _) do
    b
  end

  def merge(a, [], _) do
    a
  end

  def merge([c1 | r1] = s1, [c2 | r2] = s2, op) do
    if op.(c1, c2) do
      [c1 | merge(r1, s2, op)]
    else
      [c2 | merge(s1, r2, op)]
    end
  end

  # [1,2,3,4]

  # foldl (4 + (3 +(2 + (1 + 0)))) Starts here, starts adding right away

  # foldr (1 + (2 + (3 +(4+0)))) Starts here, starts adding once you reches the bottom and on the way back up.

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

  def appendr(lst) do
    f = fn e, a -> e ++ a end
    foldr(lst, [], f)
  end

  def appendl(lst) do
    f = fn e, a -> a ++ e end
    foldl(lst, [], f)
  end

  # returns how many elements there are in the list.
  def gurka(lst) do
    f = fn _, a -> a + 1 end
    foldr(lst, 0, f)
  end

  # reverse the list.
  def tomat(lst) do
    f = fn h, a -> a ++ [h] end
    foldr(lst, [], f)
  end

  def morot(lst) do
    f = fn h, a -> [h | a] end
    foldl(lst, [], f)
  end

  # return the list for each element x for example x * x will multiply the elements with it self.
  def map([], _op) do
    []
  end

  def map([h | t], op) do
    [op.(h) | map(t, op)]
  end

  # return a list of all elements x for which x is true
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

  def infinity() do
    fn -> infinity(0) end
  end

  def infinity(n) do
    [n | fn -> infinity(n + 1) end]
  end

  def fib() do
    fn -> fib(1, 1) end
  end

  def fib(f1, f2) do
    [f1 | fn -> fib(f2, f1 + f2) end]
  end

  def sumr({:range, from, from}) do
    from
  end

  def sumr({:range, from, to}) do
    from + sumr({:range, from + 1, to})
  end

  # cont is continue
  def sum(range) do
    reduce(range, {:cont, 0}, fn (x, acc) -> {:cont, x + acc} end)
  end

  def prod(range) do
    reduce(range, {:cont, 1}, fn (x, acc) -> {:cont, x * acc} end)
  end

  #take a range and take out n elements, using reduce where we cont if we didn't get to n otherwise we halt.
  #s is the amount of elemts we have seen as of now where x is the next element.
  def take(range, n) do
    reduce(range, {:cont, {:sofar, 0, []}}, fn (x, {:sofar, s, acc}) ->
      s = s + 1
      if s >= n do
        {:halt, [x | acc]}
      else
        {:cont, {:sofar, s, ([x | acc])}}
      end
    end)
  end

  # if from <= to then we will keep going else return acc
  def reduce({:range, from, to}, {:cont, acc}, fun) do
    if from <= to do
      reduce({:range, from + 1, to}, fun.(from, acc), fun)
    else
      {:done, acc}
    end
  end

  def reduce(range, {:suspend, acc}, fun) do
    {:suspended, acc, fn (cmd) -> reduce(range, cmd, fun) end}
  end

  def reduce(_, {:halt, acc}, _) do
    {:halted, acc}
  end

  def head(range) do
    reduce(range, {:cont, :na}, fn (x, _) -> {:suspend, x} end)
  end
end
