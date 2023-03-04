defmodule Day16b do

  def input() do

     #File.stream!("lib/day16.csv") |>
     sample() |>
      parse() |>
    Enum.to_list()
  end

  def task_a(t) do # t = time
    start = :AA # start valve
    map = input() # get map
    map = Map.new(map) # convert to map
    valves = Enum.map((Enum.filter(map, fn({_,{rate,_}}) -> rate != 0 end)), fn({valve, _}) -> valve end) # all valves with rate != 0
    {max, _, path} = dynamic(start, t, valves, [], 0, map, Map.new(), []) # calculate result
    {max, Enum.reverse(path)} # return path in reverse order
  end

  def dynamic(valve, t, [], open, rate, _, mem, path) do # we have no more valves to open
    total = rate * t # we have no more valves to open

    mem = Map.put(mem, {valve, t, open}, {total,path}) # store result in mem
    {total, mem, path} # return result
  end
  def dynamic(valve, t, valves, open, rate, map, mem, path) do # we have valves to open

    case mem[{valve, t, open}] do # check if we already have a result for this
      nil -> # we have not calculated this before
	{max, mem, path} = search(valve, t, valves, open, rate, map, mem, path) # calculate result
	mem = Map.put(mem, {valve, t, open}, {max,path}) # store result in mem
	{max, mem, path} # return result
      {max, path} -> # we have a result in mem
	{max, mem, path} # return result from mem
    end
  end


  ##  if t > 0 , valves =/= [] i.e. we still have a choice
  ##      - open valve if possible
  ##      - move through any of tunnels
  ##
  def search(valve, 0, _valves, _open, _rate, _map, mem, path) do # we have no more time
    {0, mem, path} # return 0
  end

  def search(valve, t, valves, open, rate, map, mem, path) do # we have time and valves to open
    {rt, tunnels} = map[valve] # get rate and tunnels for valve

    {mx, mem, pathx} = if Enum.member?(valves, valve) and (rt != 0) do # if we can open the valve
      ## open the valve is one option
      removed = List.delete(valves, valve) # remove valve from list of valves to open
      {mx, mem, pathx} = dynamic(valve, t-1, removed, insert(open, valve), rate+rt, map, mem, [valve|path]) # open valve
      mx = mx + rate # add rate for moving through tunnel
      {mx, mem, pathx} # return result
    else
      ## if we can not open the valve we could just stay
      {rate*t, mem, path} # return result
    end

    Enum.reduce(tunnels, {mx, mem, pathx}, # try all tunnels
      fn(nxt, {mx, mem, pathx}) -> # try tunnel to nxt
        ## moving to nxt
	{my, mem, pathy} = dynamic(nxt, t-1, valves, open, rate, map, mem, path) # move to nxt
	my = my + rate # add rate for moving through tunnel
	if (my > mx) do # if
	  ## moving to nxt was better
	  {my, mem, pathy} # return result
	else
	  {mx, mem, pathx} # return result
	end
      end)
  end

  ## open valves in order

  def insert([], valve) do [valve] end # insert valve in open list
  def insert([v|rest], valve) when v < valve do  [v|insert(rest, valve)] end # insert valve in open list
  def insert(open, valve) do  [valve|open] end # insert valve in open list


  def parse(input) do
    Stream.map(input, fn(row) ->
      [valve, rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_, valve | _ ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      [_,_,_,_, _| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, &String.to_atom(String.trim(&1,",")))
      {valve, {rate, valves}}
    end)
  end


  def sample() do
    ["Valve AA has flow rate=0; tunnels lead to valves DD, II, BB",
     "Valve BB has flow rate=13; tunnels lead to valves CC, AA",
     "Valve CC has flow rate=2; tunnels lead to valves DD, BB",
     "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE",
     "Valve EE has flow rate=3; tunnels lead to valves FF, DD",
     "Valve FF has flow rate=0; tunnels lead to valves EE, GG",
     "Valve GG has flow rate=0; tunnels lead to valves FF, HH",
     "Valve HH has flow rate=22; tunnel leads to valve GG",
     "Valve II has flow rate=0; tunnels lead to valves AA, JJ",
     "Valve JJ has flow rate=21; tunnel leads to valve II"]
  end



end
