defmodule CarloTest do
  use ExUnit.Case
  doctest Carlo

  test "greets the world" do
    assert Carlo.hello() == :world
  end
end
