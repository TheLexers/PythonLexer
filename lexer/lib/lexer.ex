defmodule Lexer do
  @moduledoc """
  Documentation for `Lexer`.
  """

  # def highlight(fileIn, fileOut) do
  #

  def highlight_line("", formatted), do: formatted |> Enum.reverse |> Enum.join("") 

  def highlight_line(line, formatted) do
    case find_token(line) do
      {[content | [rest | _list]], :space} -> highlight_line(rest, [content | formatted])
      {[content | [rest | _list]], type} -> highlight_line(rest, ["<span class=\"#{type}\">#{content}</span>" | formatted])
      {[content | _rest], type} -> highlight_line("", ["<span class=\"#{type}\">#{content}</span>" | formatted])
    end
  end

  defp find_token(line) do
    space = ~r<^(\s+)> 
    keywords = ~r<^(as|assert|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|lambda|pass|raise|return|try|while|with|yield)> 
    strings = ~r<^(".*"|'.*')>
    comments = ~r<^(#.*\n)>
    numbers = ~r<^(\d+(\.\d+){0,1}(e[+-]{0,1}\d+){0,1})>
    operators = ~r[^(\*\*{0,1}={0,1}|<<{0,1}={0,1}|>>{0,1}={0,1}|\^={0,1}|\|={0,1}|&={0,1}|%={0,1}|\/{0,1}\/={0,1}|-={0,1}|\+={0,1}|=={0,1}|!={0,1}|~|and|or|is( not){0,1}|(not ){0,1}in|not)]
    delimiters = ~r<^(\.|\:|,|;|`)>
    brackets= ~r<^(\(|\)|\{|\}|\[|\])>
    ids = ~r<^([a-zA-Z_]\w*)>
    cond do
      # Check Spaces and Identation
      space
      |> Regex.run(line) -> {Regex.split(space, line, trim: true, include_captures: true), :space}

      # Check Keywords
      keywords 
      |> Regex.run(line) -> {Regex.split(keywords, line, trim: true, include_captures: true), :keyword}

      # Check Strings
      strings
      |> Regex.run(line) -> {Regex.split(strings, line, trim: true, include_captures: true), :string}

      # Check Comments
      comments 
      |> Regex.run(line) -> {Regex.split(comments, line, trim: true, include_captures: true), :comment}

      # Check Numbers
      numbers 
      |> Regex.run(line) -> {Regex.split(numbers, line, trim: true, include_captures: true), :number}

      # Check Operators
      operators 
      |> Regex.run(line) -> {Regex.split(operators, line, trim: true, include_captures: true), :operator}

      # Check Delimiters
      delimiters 
      |> Regex.run(line) -> {Regex.split(delimiters, line, trim: true, include_captures: true), :delimiter}

      # Check Brackets
      brackets
      |> Regex.run(line) -> {Regex.split(brackets, line, trim: true, include_captures: true), :bracket}

      # Check Identifiers
      ids
      |> Regex.run(line) -> {Regex.split(ids, line, trim: true, include_captures: true), :identifier}
    end
  end
end