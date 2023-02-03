defmodule Env do
  # any values
  @type value :: any()
  # the variable is represented as an atom
  @type key :: atom()
  # the env is of a key, and a value
  @type env :: [{key, value}]

  def new() do
    []
  end

  def add(key, value, env) do
    [{key, value, env}]
  end

  def lookup([], _) do
    nil
  end

  def lookup(key, [h | env]) do
    if(elem(h, 0) == key) do
      {elem(h, 0), elem(h, 1)}
    else
      lookup(key, env)
    end
  end

  def remove(_, []) do
    []
  end

  def remove(key, [h | env]) do
    if(elem(h, 0) == key) do
      remove(key, env)
    else
      list = remove(key, env)
      [h | list]
    end
  end

  def closure(keyss, env) do
    List.foldr(keyss, [], fn(key, acc) ->
      case acc do
        :error ->
          :error

        cls ->
          case lookup(key, env) do
            {key, value} ->
              [{key, value} | cls]

            nil ->
              :error
          end
      end
    end)
  end

  def args(pars, args, env) do
    List.zip([pars, args]) ++ env
  end

end
