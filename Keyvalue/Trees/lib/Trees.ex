defmodule Environment do
   def newList() do
      []
   end

   def addList([], key, value) do [{key, value}] end
   def addList([h | map], key, value) do
     if(elem(h, 0) == key) do
        addList(map, key, value)
     else
        newList= addList(map, key, value)
        [h| newList]
     end
   end

   def lookupList([], key) do :error end
   def lookupList([h | map], key) do
     if(elem(h, 0) == key) do
        elem(h,1)
     else
        lookupList(map, key)
     end
   end

   def removeList([], key) do [] end
   def removeList([h | map], key) do
     if(elem(h, 0) == key) do
        removeList(map, key)
     else
        newList= removeList(map, key)
        [h| newList]
     end
   end


   #we add the first element in the list we want to add and call the function again with
   #the rest of the list and the new list where the first elment of the first list is added. We
   #do this until we have added all the elments and then the furst argument becomes true and it returs the new list
   #with the list added.



   #if we want to append an empty cell then we don't need to do anything then we just return the list.
   #If the second argument with the list cell mathes matches then we take the first elent h and exclude it and take the rest of the elemnts in the list and call the append function again.
   #We do that until we reach the last elemnt and the first argument will mathch because we will be lefted with an element and the rest will be null.
   #Because we call the appent function will the rest of the element and in this case it is null then first atgument will be true and it will just return the list the we want to appent to and add the first element to that list and work our way
   #uppwards until we have added all the elements from the list that we wanted to add.

   # The will cost alot because we will copy all the elment form the list that we wantet to add.
   # we will do the same amount of reccustion that is the lenght of the list that we want to add.
   # the time complexity for the append function will be O(n) which is the length of the first list that we want to append.

   def newTree() do nil end

  def addTree(nil, key, value) do
     {:node, key, value, :nil, :nil}
  end

  def addTree({:node, key, _, left, right}, key, value) do
     {:node, key, value, left, right}
  end

  def addTree({:node, k, v, left, right}, key, value) when key < k do
     {:node, k, v, addTree(left, key, value), right}
  end

  def addTree({:node, k, v, left, right}, key, value) do
     {:node, k, v, left, addTree(right, key, value)}
  end

  #when the tree is empty we just add the value
  def lookupTree(nil, _key) do nil end

  def lookupTree({:node, key, value, _left, _right}, key) do
    {key, value} end

  def lookupTree({:node, k, _, left, _right}, key) when key < k do
    lookupTree(left, key) end

  def lookupTree({:node, _, _, _left, right}, key) do
    lookupTree(right, key) end



  #The the key is less then then the key we want to add then we just move to the left

  def removeTree(nil, _) do :nil end

  def removeTree({:node, key, _, nil, right}, key) do
     right
  end

  def removeTree({:node, key, _, left, nil}, key) do
     left
  end

  def removeTree({:node, key, _, left, right}, key) do
     {key, value, rest} = leftmost(right)
     {:node, key, value, left, rest}
  end

  def removeTree({:node, k, v, left, right}, key) when key < k do
     {:node, k, v, removeTree(left, key), right}
  end

  def removeTree({:node, k, v, left, right}, key) do
     {:node, k, v, left, removeTree(right, key)}
  end

  def leftmost({:node, key, value, nil, rest}) do
     {key, value, rest}
  end

  def leftmost({:node, k, v, left, right}) do
     {key, value, rest} = leftmost(left)
     {key, value, {:node, k, v, rest, right}}
  end




  #When we come to the end of the list we just retrun
  def bench(i, n) do
     seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)

     list = Enum.reduce(seq,  Environment.newList(),  fn(e, list) -> Environment.addList(list, e, :foo) end)
     tree = Enum.reduce(seq,  Environment.newTree(),  fn(e, tree) -> Environment.addTree(tree, e, :foo) end)
     map = Enum.reduce(seq,  Map.new(),  fn(e, map) -> Map.put(map, e, :foo)  end)

     seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)

     {tla, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> Environment.addList(list, e, :foo) end) end)
     {tta, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> Environment.addTree(tree, e, :foo) end) end)
     {tma, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> Map.put(map, e, :foo) end) end)

     {tll, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> Environment.lookupList(list, e) end) end)
     {ttl, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> Environment.lookupTree(tree, e) end) end)
     {tml, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> Map.get(map, e) end) end)

     {tlr, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> Environment.removeList(list, e) end) end)
     {ttr, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> Environment.removeTree(tree, e) end) end)
     {tmr, _} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> Map.delete(map, e) end) end)

     {i, tla, tta, tma, tll, ttl, tml, tlr, ttr, tmr}
   end


  end
