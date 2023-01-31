defmodule Interpreter do

  @type expr() ::
  {:add, expr(), expr()}
| {:sub, expr(), expr()}
| {:mul, expr(), expr()}
| {:div, expr(), expr()}
| literal()


@type literal() :: {:num, number()}
  | {:var, atom()}
  | {:q, number(), number()}


def eval({:num, k}, _) do k end
def eval({:var, x}, getVar) do Map.get(getVar, x)  end
def eval({:add, x1, x2}, getVar) do add(eval(x1, getVar), eval(x2, getVar)) end
def eval({:sub, x1, x2}, getVar) do sub(eval(x1, getVar), eval(x2, getVar)) end
def eval({:mul, x1, x2}, getVar) do mul(eval(x1, getVar), eval(x2, getVar)) end
def eval({:div, x1, x2}, getVar) do div(eval(x1, getVar), eval(x2, getVar)) end


def add({:q, a, b}, x) do {:q, a * x + b, b } end
def add(x, {:q, a, b}) do {:q, x * b + a, b } end
def add({:q, a, b}, {:q, z, k}) do {:q, a * k + b * z, b * k} end
def add(x, y) do x + y end


def sub({:q, a, b}, x) do {:q, a * x - b, b } end
def sub(x, {:q, a, b}) do {:q, x * b - a, b } end
def sub({:q, a, b}, {:q, z, k}) do {:q, a * k - b * z, b * k} end
def sub(x, y) do x - y end


def mul({:q, a, b}, x) do {:q, a * x, b } end
def mul(x, {:q, a, b}) do {:q, x * a, b } end
def mul({:q, a, b}, {:q, z, k}) do {:q, a * z, b * k} end
def mul(x, y) do x * y end


def divi(x, {:q, a, b}) do {:q, a, x * b } end
def divi({:q, a, b}, {:q, z, k}) do {:q, a * k, b * z} end
def divi({:q, a, b}, x) do {:q, a, x * b } end
def divi(x, y) do
  if(is_float(x/y)) do

  else
    x/y

 end
end
