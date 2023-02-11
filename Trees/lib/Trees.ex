defmodule Trees do

  ## :nil {:cons, head, tail}

  def append(:nil, y) do y end
  def append({:cons, head, tail}, y) do
    {:cons, head, append(tail, y )}
  end


  def new() do {:queue, [], []} end

  def add([], elem) do [elem] end
  def add([h|t], elem) do
    [h| add(t, elem)]
  end

  def remove([]) do :error end
  def remove([elem | rest]) do {:ok, elem, rest} end


end
