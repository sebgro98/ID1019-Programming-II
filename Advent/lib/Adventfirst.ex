defmodule Adventfirst do
  def test do
    file_path = "lib/data.txt"
    data = parsefile(file_path)
    sum(data, [], 0)
  end

  def parsefile(file_path) do
    case File.read(file_path) do
      {:ok, contents} ->
        String.split(contents, ["\r\n"])

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end

  def sum([], largest, temp) do
    Enum.reduce(largest, 0, &+/2)
  end

  def sum([h | t], largest, temp) do
    if h == "" do
      if length(largest) < 3 do
        largest = [temp | largest]
        temp = 0
        sum(t, largest, temp)
      else
        largest = checkbiggest(largest, [], temp)
        temp = 0
        sum(t, largest, temp)
      end
    else
      first = String.to_integer(h)
      temp = temp + first
      sum(t, largest, temp)
    end
  end

  def compareLargest([], newlist, _) do
    newlist
  end

  def compareLargest([h | largest], newlist, temp) do
    if h < temp do
      newlist = [temp | newlist]
      temp = h
      compareLargest(largest, newlist, temp)
    else
      newlist = [h | newlist]
      compareLargest(largest, newlist, temp)
    end
  end
end
