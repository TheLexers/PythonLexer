defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  # Some tests used during development
  # find_token was changed to private
  # highlight/1 is not tested here

  # test "numbers" do
  #   assert Lexer.find_token("1") == {:ok, ["1"], :number}
  #   assert Lexer.find_token("+1") == {:ok, ["+1"], :number}
  #   assert Lexer.find_token("1.0") == {:ok, ["1.0"], :number}
  #   assert Lexer.find_token("-1") == {:ok, ["-1"], :number}
  #   assert Lexer.find_token("-1.0") == {:ok, ["-1.0"], :number}
  #   assert Lexer.find_token("1e10") == {:ok, ["1e10"], :number}
  #   assert Lexer.find_token("1e-10") == {:ok, ["1e-10"], :number}
  #   assert Lexer.find_token("1.0e10") == {:ok, ["1.0e10"], :number}
  #   assert Lexer.find_token("1.0e-10") == {:ok, ["1.0e-10"], :number}
  # end

  # test "arithmetic expressions" do
  #   assert Lexer.find_token("1 + 2") == 
  #     {:ok, ["1", " + 2"], :number}

  #   assert Lexer.find_token("3 * 2 + 5 / 4") == 
  #     {:ok, ["3", " * 2 + 5 / 4"], :number}
    
  #   assert Lexer.find_token("* 2 + 5 / 4") == 
  #     {:ok, ["*", " 2 + 5 / 4"], :operator}
  # end

  # test "strings" do
  #   assert Lexer.find_token("\"Hello World\"") == 
  #     {:ok, ["\"Hello World\""], :string}

  #   assert Lexer.find_token("\"String\" + \" \" + \"Concatenation\"") == 
  #     {:ok, ["\"String\"", " + \" \" + \"Concatenation\""], :string}
  # end

  # test "identifiers" do
  #   assert Lexer.find_token("x = 3") == 
  #     {:ok, ["x", " = 3"], :identifier}
  # end

  # test "keyowrds" do
  #   assert Lexer.find_token("def hello") ==
  #     {:ok, ["def", " hello"], :keyword} 
  # end

  # test "comments" do
  #   assert Lexer.find_token("1 + 2 #This adds 1 and 2") == 
  #     {:ok, ["1", " + 2 #This adds 1 and 2"], :number}
    
  #   assert Lexer.find_token("# This is a comment") == 
  #     {:ok, ["# This is a comment"], :comment}
  # end

  # test "invalid" do
  #   assert Lexer.find_token("ßþøł½ it broke") == 
  #     {:error, "ßþøł½ it broke"}
  # end

end