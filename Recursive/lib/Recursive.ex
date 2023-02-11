defmodule Recursive do

def union([], y) do y end
def union([h|t], y) do
  z = union(t, y)
  [h|z]
end

def tailr([], y) do y end
def tailr([h|t], y) do
  z = [h|y]
  tailr(t, z)

end

def sum([]) do 0 end
def sum([n|t]) do
  n + sum(t)
end

def sam([list]) do sam(list, 0) end

def sam([], s) do s end

def sam([n|t], s) do
  sam(t, n+s)

end

def odd([]) do [] end
def odd([h|t]) do
  if rem(h, 2) == 1 do
    [h| odd(t)]
  else
    odd(t)
  end
end

def even([]) do [] end
def even([h|t]) do
  if rem(h, 2) == 0 do
    [h| even(t)]
  else
    even(t)
  end
end

def odd_n_even([]) do {[], []} end
def odd_n_even([h|t]) do
  {o, e} = odd_n_even(t)
  if rem(h, 2) == 1 do
   {[h|o], e}
  else
    {o, [h|e]}
  end
end

def add_n_even(list) do add_n_even(list, [], []) end

def add_n_even([], odd, even) do {odd, even} end
def add_n_even([h|t], odd, even) do
  if rem(h, 2) == 1 do
   add_n_even(t , [h|odd], even)
  else
   add_n_even(t , odd, [h|even])
  end
end


def rev([]) do [] end
def rev([h|t]) do
  rev(t) ++ [h]
end


def rav(list) do rav(list, []) end
def rav([], res) do res end
def rav([h|t], res) do
  rav(t, [h|res])
end

def flat([]) do [] end
def flat([l|t]) do
  l ++ flat(t)
end

def flut(list) do flut(list, []) end
def flut([], res) do res end
def flut([l|t], res) do
  flut(t, res ++ l)
end


end
