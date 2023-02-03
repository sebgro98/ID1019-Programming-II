defmodule Eager do
  @type atm :: {:atm, atom}
  @type variable :: {:var, atom}
  @type ignore :: :ignore
  @type cons(t) :: {:cons, t, t}

  # Pattern matching
  @type pattern :: atm | variable | ignore | cons(pattern)

  @type lambda :: {:lambda, [atom], [atom], seq}
  @type apply :: {:apply, expr, [expr]}
  @type case :: {:case, expr, [clause]}
  @type clause :: {:clause, pattern, seq}

  @type expr :: atm | variable | lambda | apply | case | cons(expr)

  # Sequences
  @type match :: {:match, pattern, expr}
  @type seq :: [expr] | [match | seq]

  # Expressions are evaluated to structures.
  @type closure :: {:closure, [atom], seq, env}
  @type str :: atom | [str] | closure

  # An environment is a key-value of variableiable to structure.
  @type env :: [{atom, str}]

  def test() do
    # eval = {:cons, {:var, :x}, {:atm, :b}}
    # sta = [{:x, :a}]
  end

  def eval_expr({:atm, id}, _) do
    {:ok, id}
  end

  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil ->
        :error

      {_, str} ->
        {:ok, str}
    end
  end

  def eval_expr({:cons, h, t}, env) do
    case eval_expr(h, env) do
      :error ->
        :error

      {:ok, hs} ->
        case eval_expr(t, env) do
          :error ->
            :error

          {:ok, ts} ->
            {:ok, {hs, ts}}
        end
    end
  end

  # FOR CLS
  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error

      {:ok, str} ->
        eval_cls(cls, str, env)
    end
  end

  # FOR LAMBDA
  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
      :error ->
        :error

      closure ->
        {:ok, {:closure, par, seq, closure}}
    end
  end

  # FOR APPLY
  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error

      {:ok, {:closure, par, seq, closure}} ->
        case eval_args(args, env) do
          :error ->
            :error

          {:ok, strs} ->
            env = Env.args(par, strs, closure)
            eval_seq(seq, env)
        end
    end
  end


  def eval_match(:ignore, _, env) do
    {:ok, env}
  end

  # If the atom we send is the same as the one in the env give back the env
  def eval_match({:atm, id}, id, env) do
    {:ok, env}
  end

  # ^ means that we want to use the existing varible and not a new one, in this case str is value
  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil ->
        {:ok, Env.add(id, str, env)}

      {_, ^str} ->
        {:ok, env}

      {_, _} ->
        :fail
    end
  end

  # we send hp and tp and want to match hp with hs and tp with ts
  def eval_match({:cons, hp, tp}, {hs, ts}, env) do
    case eval_match(hp, hs, env) do
      :fail ->
        :fail

      {:ok, env} ->
        eval_match(tp, ts, env)
    end
  end

  def eval_match(_, _, _) do
    :fail
  end

  def eval_scope(pattern, env) do
    Env.remove(extract_vars(pattern), env)
  end

  def eval_seq([exp], env) do
    eval_expr(exp, env)
  end

  def eval_seq([{:match, ptr, exp} | seq], env) do
    case eval_expr(exp, env) do
      :error ->
        :error

      {:ok, str} ->
        env = eval_scope(ptr, exp)

        case eval_match(ptr, str, env) do
          :fail ->
            :error

          {:ok, env} ->
            eval_seq(seq, env)
        end
    end
  end

  def extract_vars(pattern) do
    extract_vars(pattern, [])
  end

  def extract_vars({:atm, _}, vars) do
    vars
  end

  def extract_vars(:ignore, vars) do
    vars
  end

  def extract_vars({:var, var}, vars) do
    [var | vars]
  end

  def extract_vars({:cons, head, tail}, vars) do
    extract_vars(tail, extract_vars(head, vars))
  end

  def eval_cls([], _, _, _) do
    :error
  end

  def eval_cls([{:clause, ptr, seq} | cls], str, env) do
    case eval_match(ptr, str, eval_scope(ptr, env)) do
      :fail ->
        eval_cls(cls, str, env)

      {:ok, env} ->
        eval_seq(seq, env)
    end
  end

  def eval_args(args, env) do
    eval_args(args, env, [])
  end

  def eval_args([], _, strs) do {:ok, Enum.reverse(strs)}  end
  def eval_args([expr | exprs], env, strs) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, str} ->
        eval_args(exprs, env, [str|strs])
    end
  end


end
