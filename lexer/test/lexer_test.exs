defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "numbers" do
    assert Lexer.highlight_line("1") == "<span class=\"number\">1</span>"
    assert Lexer.highlight_line("+1") == "<span class=\"number\">+1</span>"
    assert Lexer.highlight_line("1.0") == "<span class=\"number\">1.0</span>"
    assert Lexer.highlight_line("-1") == "<span class=\"number\">-1</span>"
    assert Lexer.highlight_line("-1.0") == "<span class=\"number\">-1.0</span>"
    assert Lexer.highlight_line("1e10") == "<span class=\"number\">1e10</span>"
    assert Lexer.highlight_line("1e-10") == "<span class=\"number\">1e-10</span>"
    assert Lexer.highlight_line("1.0e10") == "<span class=\"number\">1.0e10</span>"
    assert Lexer.highlight_line("1.0e-10") == "<span class=\"number\">1.0e-10</span>"
  end

  test "arithmetic expressions" do
    assert Lexer.highlight_line("1 + 2") == 
      ["<span class=\"number\">1</span>",
       " ",
       "<span class=\"operator\">+</span>",
       " ", 
       "<span class=\"number\">2</span>"]
      |> Enum.join("")

    assert Lexer.highlight_line("3 * 2 + 5 / 4") == 
      ["<span class=\"number\">3</span>",
       " ",
       "<span class=\"operator\">*</span>",
       " ",
       "<span class=\"number\">2</span>",
       " ",
       "<span class=\"operator\">+</span>",
       " ",
       "<span class=\"number\">5</span>",
       " ",
       "<span class=\"operator\">/</span>",
       " ",
       "<span class=\"number\">4</span>"]
      |> Enum.join("")
  end

  test "strings" do
    assert Lexer.highlight_line("\"Hello World\"") == 
      "<span class=\"string\">\"Hello World\"</span>"

    assert Lexer.highlight_line("'Hello World'") == 
      "<span class=\"string\">'Hello World'</span>"
    
    assert Lexer.highlight_line("\"'Hello World'\"") == 
      "<span class=\"string\">\"'Hello World'\"</span>"

    assert Lexer.highlight_line("'\"Hello World\"'") == 
      "<span class=\"string\">'\"Hello World\"'</span>"
  end

  test "identifiers" do
    assert Lexer.highlight_line("x = 3") == 
      ["<span class=\"identifier\">x</span>",
       " ",
       "<span class=\"operator\">=</span>",
       " ",
       "<span class=\"number\">3</span>"]
      |> Enum.join("")
  end

  test "keyowrds" do
    assert Lexer.highlight_line("def hello") == 
      ["<span class=\"keyword\">def</span>",
       " ",
       "<span class=\"identifier\">hello</span>"]
      |> Enum.join("")
    
    assert Lexer.highlight_line("def doFactorial(num, a):") ==
      ["<span class=\"keyword\">def</span>",
       " ",
       "<span class=\"identifier\">doFactorial</span>",
       "<span class=\"bracket\">(</span>",
       "<span class=\"identifier\">num</span>",
       "<span class=\"delimiter\">,</span>",
       " ",
       "<span class=\"identifier\">a</span>",
       "<span class=\"bracket\">)</span>",
       "<span class=\"delimiter\">:</span>"]
      |> Enum.join("")
    
    assert Lexer.highlight_line("if x == 3:") == 
      ["<span class=\"keyword\">if</span>",
       " ",
       "<span class=\"identifier\">x</span>",
       " ",
       "<span class=\"operator\">==</span>",
       " ",
       "<span class=\"number\">3</span>",
       "<span class=\"delimiter\">:</span>"]
      |> Enum.join("")
  end

  test "comments" do
    assert Lexer.highlight_line("1 + 2 #This adds 1 and 2") == 
      ["<span class=\"number\">1</span>",
       " ",
       "<span class=\"operator\">+</span>",
       " ",
       "<span class=\"number\">2</span>",
       " ",
       "<span class=\"comment\">#This adds 1 and 2</span>"]
      |> Enum.join("")
  end

  test "invalid" do
    assert Lexer.highlight_line("ßþøł½ it broke") == 
    ["<span class=\"invalid\">ßþøł½ it broke</span>",
     " ", 
     "<span class=\"error\">Invalid syntax</span>"]
    |> Enum.join("")
  end

end