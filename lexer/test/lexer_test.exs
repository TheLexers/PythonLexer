defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "greets the world" do
    assert Lexer.hello() == :world
  end
end
