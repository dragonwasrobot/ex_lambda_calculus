defmodule Lambda do
  @moduledoc ~S"""
  An implementation of call-by-value lambda calculus
  using a subset of the Elixir syntax.
  """

  # Variable lookup
  def eval_exp({x, _c, Elixir}, env) when is_atom(x), do: env.(x)

  # Lambda abstraction
  def eval_exp({:fn, _c1, [{:->, _c2, [[{x, _c3, Elixir}], body]}]}, env) do
    fn arg ->
      eval_exp(body, fn y ->
        if x == y do
          arg
        else
          env . (y)
        end
      end)
    end
  end

  # Application
  def eval_exp({{:., _c1, [rator]}, _c2, [rand]}, env) do
    (eval_exp(rator, env)) . (eval_exp(rand, env))
  end

  # A few helpers / adjustments compared to ye olde scheme version

  def eval_exp(n, _env) when is_number(n), do: n

  # if test do consequence else alternative
  def eval_exp({:if, _c, [test, [do: consequence, else: alternative]]}, env) do
    if eval_exp(test, env) do
      eval_exp(consequence, env)
    else
      eval_exp(alternative, env)
    end
  end

  def eval_exp({:==, _c, [left, right]}, env) do
    eval_exp(left, env) == eval_exp(right, env)
  end

  def eval_exp({:+, _c, [left, right]}, env) do
    eval_exp(left, env) + eval_exp(right, env)
  end

  def eval_exp({:-, _c, [left, right]}, env) do
    eval_exp(left, env) - eval_exp(right, env)
  end

  def eval_exp({:*, _c, [left, right]}, env) do
    eval_exp(left, env) * eval_exp(right, env)
  end

  def eval_exp({:/, _c, [left, right]}, env) do
    eval_exp(left, env) * eval_exp(right, env)
  end

end

fact5 = quote do: (
(fn fact ->
  (fn n ->
    ((fact . (fact)) . (n))
  end)
end)
.
(fn fact ->
  (fn n ->
    (if n == 0 do
        1
      else
        n * ((fact . (fact)) . (n - 1))
      end)
  end)
end)
.
(5)
)

initial_env = fn y -> raise "Variable '#{y}' was unbound" end

IO.puts "Calls our very own lambda calculus"
result = Lambda.eval_exp(fact5, initial_env)
IO.puts "Result: fact(5) = #{inspect result}"
