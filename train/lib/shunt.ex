defmodule Shunt do
  ## gives us instructions on how we should move our trains for best possible way

  def find([], []) do
    []
  end

  def find(xs, [y | ys]) do
    {hs, ts} = Train.split(xs, y)
    tn = length(ts)
    hn = length(hs)
    [{:one, tn + 1}, {:two, hn}, {:one, -(tn + 1)}, {:two, -hn} | find(Train.append(hs, ts), ys)]
  end

  def few(_, []) do
    []
  end



  def few(xs, [y | ys]) do
    [h | t] = xs
    ##whether the next wagon is already in the right position. If so, no moves are needed.
    if h == y do
      few(t, ys)
    else
      {hs, ts} = Train.split(xs, y)
      tn = length(ts)
      hn = length(hs)
      [{:one, tn + 1}, {:two, hn}, {:one, -(tn + 1)}, {:two, -hn} | few(Train.append(hs, ts), ys)]
    end
  end

end
