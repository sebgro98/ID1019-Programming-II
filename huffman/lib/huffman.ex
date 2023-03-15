defmodule Huffman do
  #def sample do
   # 'the quick brown fox jumps over the lazy dog
    #this is a sample text that we will use when we build
    #up a table we will only handle lower case letters and
    #no punctuation symbols the frequency will of course not
    #represent english but it is probably not that far off'
  #end

  #def text() do
   # 'this is something that we should encode'
  #end

  def be do
    file_path = "lib/kallocain.txt"
    bench(file_path, 200000)
  end

  def test do
    #sample = sample()
    #tree = tree(sample)
    #encode = encode_table(tree)
    #decode = decode_table(tree)
    #text = text()
    #seq = encode(text, encode)
    #decode(seq, decode)
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def freq(list) do
    Enum.reduce(list, [], fn element, acc ->
      update(acc, {element, 1})
    end)
  end

  def update([], {element, count}) do
    [{element, count}]
  end

  def update([{element, n} | t], {element, count}) do
    [{element, n + count} | t]
  end

  def update([h | t], freq) do
    [h | update(t, freq)]
  end

  def huffman(freq) do
    sorted = Enum.sort(freq, fn {_, x}, {_, y} -> x < y end)
    huffman_tree(sorted)
  end

  def huffman_tree([{tree, _}]), do: tree

  def huffman_tree([{a, af}, {b, bf} | rest]) do
    huffman_tree(insert({{a, b}, af + bf}, rest))
  end

  def insert({a, af}, []), do: [{a, af}]

  def insert({a, af}, [{b, bf} | rest]) when af < bf do
    [{a, af}, {b, bf} | rest]
  end

  def insert({a, af}, [{b, bf} | rest]) do
    [{b, bf} | insert({a, af}, rest)]
  end

  def encode_table(tree) do
    Enum.sort(codes(tree, []), fn {_, x}, {_, y} -> length(x) < length(y) end)
  end

  def codes({a, b}, sofar) do
    as = codes(a, [0 | sofar])
    bs = codes(b, [1 | sofar])
    as ++ bs
  end

  def codes(a, code) do
    [{a, Enum.reverse(code)}]
  end

  def encode([], _), do: []

  def encode([char | rest], table) do
    {_, code} = List.keyfind(table, char, 0)
    code | encode(rest, table)
  end

  def decode_table(tree), do: codes(tree, [])

  def decode([], _), do: []

  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)

    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}

      nil ->
        decode_char(seq, n + 1, table)
    end
  end

  def bench(file, n) do
    {text, b} = read(file, n)
    c = length(text)
    {tree, t2} = time(fn -> tree(text) end)
    {encode, t3} = time(fn -> encode_table(tree) end)
    s = length(encode)
    {decode, _} = time(fn -> decode_table(tree) end)
    {encoded, t5} = time(fn -> encode(text, encode) end)
    e = div(length(encoded), 8)
    r = Float.round(e / b, 3)
    {_, t6} = time(fn -> decode(encoded, decode) end)

    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

  # Measure the execution time of a function.
  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end

 # Get a suitable chunk of text to encode.
  def read(file, n) do
   {:ok, fd} = File.open(file, [:read, :utf8])
    binary = IO.read(fd, n)
    File.close(fd)

    length = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, chars, rest} ->
        {chars, length - byte_size(rest)}
      chars ->
        {chars, length}
    end
  end
end
