defmodule Train do

  def take(_, 0) do [] end

  def take([wagon|rest], n) do
    list = take(rest, n-1)
    [wagon|list]
  end

  def drop(rest, 0) do rest end

  def drop([_|rest], n) do
    list = drop(rest, n-1)
    list
  end

  def append([],train2) do train2 end

  def append([wagon|rest],train2) do
    [wagon|append(rest,train2)]
  end

  def member([], _) do false end

  def member([wagon|rest], wagon2 ) do
    if wagon == wagon2 do
      true
    else
      member(rest, wagon2)
    end
  end

  #returns the first position (1 indexed) of y in the
  #train train. You can assume that y is a wagon in train.
  #y and all wagons after y (i.e. y is not part in either).
  def position([], _) do {:notFound} end
  def position([wagon|rest], wagon2) do
    if wagon == wagon2 do
      1
    else
      1 + position(rest, wagon2)
    end
  end

#return a tuple with two trains, all the wagons before y and
#all wagons after y (i.e. y is not part in either)
  def split(train, wagon) do
    position = position(train, wagon)
    {take(train, position - 1), drop(train, position)}
  end

  def main([], n) do {n, [], []} end
  def main([wagon|rest], n) do
    {n, remain, take} = main(rest, n) ## retrun empty list
    if n == 0 do
      remain = [wagon|remain]
      {n, remain, take}
    else
      take = [wagon|take] #
      n = n - 1
      {n, remain, take}
    end
  end

end
