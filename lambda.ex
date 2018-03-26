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

  # A few helper functions to postpone the task of implementing Church Encoding

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

# An implementation of the Factorial function using the "poor man's ycombinator"
# to demonstrate that the lambda calculus interpreter is working as expected.

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

# A simple example of an expression in the lambda calculus using non of the helper functions defined above

# (((λ f . (λ x . (f x))) (λ a . a)) (λ b . b)) ->
# ((λ x . ((λ a . a) x)) (λ b . b)) ->
# ((λ a . a) (λ b . b)) ->
# (λ b . b)

example_fun = quote do: (
  (
    (fn f -> (fn x -> f . (x) end) end)
    .
    (fn a -> a end)
  )
  .
  (fn b -> b end)
)

initial_env = fn y -> raise "Variable '#{y}' was unbound" end

IO.puts "Calls our very own lambda calculus"
IO.puts "eval_exp(fact5)"
fact5_result = Lambda.eval_exp(fact5, initial_env)
IO.puts "Result:"
IO.puts fact5_result

IO.puts "eval_exp(example_fun).(42)"
example_fun_result = Lambda.eval_exp(example_fun, initial_env)
IO.puts "Result:"
IO.puts example_fun_result.(42)
