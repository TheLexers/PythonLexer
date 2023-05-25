defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "arithmetic expressions" do
    assert Lexer.highlight_line("1 + 2", []) == "<span class=\"number\">1</span> <span class=\"operator\">+</span> <span class=\"number\">2</span>"
    assert Lexer.highlight_line("3 * 2", []) == "<span class=\"number\">3</span> <span class=\"operator\">*</span> <span class=\"number\">2</span>"
    assert Lexer.highlight_line("4 / 2", []) == "<span class=\"number\">4</span> <span class=\"operator\">/</span> <span class=\"number\">2</span>"
    assert Lexer.highlight_line("5 - 2", []) == "<span class=\"number\">5</span> <span class=\"operator\">-</span> <span class=\"number\">2</span>" 
  end
end
