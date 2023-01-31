defmodule Lists do

  def newList() do [] end

  def addList([], key, value) do[{key, value}] end
  def addList([h | map], key, value) do
    if(elem(h, 0) == key) do
      addList(map, key, value)
  else
      list = addList(map, key, value)
    [h | list]
  end
end

def lookupList([], _) do :nil end

def lookupList([h | map], key) do
  if(elem(h, 0) == key) do
    elem(h,1)
    else
      lookupList(map, key)
  end
end

def removeList([], _) do [] end

def removeList([h | map], key) do
  if(elem(h, 0) == key) do
    removeList(map, key)
else
    list = removeList(map, key)
    [h| list]
end
end

end
