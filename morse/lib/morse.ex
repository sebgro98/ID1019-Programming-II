defmodule Morse do
  def base() do
    ".- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... "
  end

  def rolled() do
    ".... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- "
  end

  def encode(data, table) do
    encode_tail(data, table, [])
  end

  def encode_tail([], _, acc), do: '#{Enum.reverse(acc)}'

  def encode_tail([char | rest], table, acc) do
    code = Map.get(table, char, nil)
    case code do
      nil ->
        encode_tail(rest, table, acc)
      _ ->
        encode_tail(rest, table, [code | acc])
    end
  end


  def test() do
   table = codes()
   encode('sebastian', table)

  end

  def tables(nil, _) do
    []
  end

  def tables({:node, :na, left, right}, acc) do
    tables(left, '-' ++ acc) ++ tables(right, '.' ++ acc)
  end

  def tables({:node, num, left, right}, acc) do
    [{num, acc}] ++ tables(left, '-' ++ acc) ++ tables(right, '.' ++ acc)
  end

  def decode([], _, _, acc)  do
    '#{Enum.reverse(acc)}'
  end

  def decode([45| seq], {_, _, left, _}, tree, acc) do
    decode(seq, left, tree, acc)
  end
  def decode([46| seq], {_, _, _, right}, tree, acc) do
    decode(seq, right, tree, acc)
  end
  def decode([32| seq], {_, char, _, _}, tree, acc) do
    decode(seq, tree, tree, [char|acc])
  end

  def decode_table() do
    {:node, :na,
     {:node, 116,
      {:node, 109,
       {:node, 111, {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
        {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
       {:node, 103, {:node, 113, nil, nil},
        {:node, 122, {:node, :na, {:node, 44, nil, nil}, nil}, {:node, 55, nil, nil}}}},
      {:node, 110, {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
       {:node, 100, {:node, 120, nil, nil},
        {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
     {:node, 101,
      {:node, 97,
       {:node, 119, {:node, 106, {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}}, nil},
        {:node, 112, {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}}, nil}},
       {:node, 114, {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
        {:node, 108, nil, nil}}},
      {:node, 105,
       {:node, 117, {:node, 32, {:node, 50, nil, nil}, {:node, :na, nil, {:node, 63, nil, nil}}},
        {:node, 102, nil, nil}},
       {:node, 115, {:node, 118, {:node, 51, nil, nil}, nil},
        {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  def codes() do
    [
      {32, "..--"},
      {37, ".--.--"},
      {44, "--..--"},
      {45, "-....-"},
      {46, ".-.-.-"},
      {47, ".-----"},
      {48, "-----"},
      {49, ".----"},
      {50, "..---"},
      {51, "...--"},
      {52, "....-"},
      {53, "....."},
      {54, "-...."},
      {55, "--..."},
      {56, "---.."},
      {57, "----."},
      {58, "---..."},
      {61, ".----."},
      {63, "..--.."},
      {64, ".--.-."},
      {97, ".-"},
      {98, "-..."},
      {99, "-.-."},
      {100, "-.."},
      {101, "."},
      {102, "..-."},
      {103, "--."},
      {104, "...."},
      {105, ".."},
      {106, ".---"},
      {107, "-.-"},
      {108, ".-.."},
      {109, "--"},
      {110, "-."},
      {111, "---"},
      {112, ".--."},
      {113, "--.-"},
      {114, ".-."},
      {115, "..."},
      {116, "-"},
      {117, "..-"},
      {118, "...-"},
      {119, ".--"},
      {120, "-..-"},
      {121, "-.--"},
      {122, "--.."}
    ]
  end

  def morse() do
    {:node, :na,
     {:node, 116,
      {:node, 109,
       {:node, 111, {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
        {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
       {:node, 103, {:node, 113, nil, nil},
        {:node, 122, {:node, :na, {:node, 44, nil, nil}, nil}, {:node, 55, nil, nil}}}},
      {:node, 110, {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
       {:node, 100, {:node, 120, nil, nil},
        {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
     {:node, 101,
      {:node, 97,
       {:node, 119, {:node, 106, {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}}, nil},
        {:node, 112, {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}}, nil}},
       {:node, 114, {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
        {:node, 108, nil, nil}}},
      {:node, 105,
       {:node, 117, {:node, 32, {:node, 50, nil, nil}, {:node, :na, nil, {:node, 63, nil, nil}}},
        {:node, 102, nil, nil}},
       {:node, 115, {:node, 118, {:node, 51, nil, nil}, nil},
        {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end
end
