defmodule Hanoi do


  def test() do
    hanoi(3, :a, :b, :c)
  end

  def hanoi(0, _, _, _) do [] end
  def hanoi(n, a, b, c) do
    hanoi(n-1, a, c, b) ++ [{:move, a,c}] ++ hanoi(n-1, b, a, c)
  end


end
