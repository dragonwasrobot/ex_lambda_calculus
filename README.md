# Lambda calculus

This is an implementation of the lambda calculus on top of Elixir utilizing Elixir's tuple-based abstract syntax tree (AST) as the base for expressing the basic terms of the lambda calculus:

- variable reference, `x`,
- lambda abstraction, `(λx.t)`, and
- application, `(f x)`.

Right now, this project is mostly an experiment in getting a better understanding of Elixir's AST and basic programming language theory concepts such as the lambda calculus.
