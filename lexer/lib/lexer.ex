defmodule Lexer do
  @moduledoc """
  Functons to highlight the syntax of Python code
  
  ## Authors
  Juan Pablo Ruiz de Chávez Diez de Urdanivia
  
  Joaquín Badillo Granillo
  """

  @type fileIn() :: String.t()
  @type dir() :: String.t()

  @doc """
  Creates a HTML and CSS file inside the directory `dir`
  that highlights the contents of the input file
  `fileIn` using the syntax of Python code.

  The directory will be created where the file is located.
  """
  @spec highlight(fileIn(), dir()) :: :ok | :error
  def highlight(fileIn, dir) do
    py_path = Path.expand(fileIn)
    result_file = ~s(#{Path.dirname(fileIn)}/#{dir}/)
    IO.puts("Reading file: #{py_path}")
  
    case File.read(py_path) do
      {:ok, text} ->
        File.mkdir_p!(dir)
        write_css(result_file <> "style.css")
        data = text
          |> String.split("\n")
          |> Enum.map(&highlight_line(&1, []))
          |> Enum.join("\n")
          |> html_struct()
        File.write(result_file <> "index.html", data)

      {:error, reason} ->
        IO.puts("Failed to read file. Reason: #{inspect(reason)}")
    end
  end

  defp highlight_line("", formatted), do: formatted |> Enum.reverse |> Enum.join("")

  defp highlight_line(line, formatted) do
    case find_token(line) do
      {:ok, [content | [rest | _list]], :space} -> highlight_line(rest, [content | formatted])
      {:ok, [content | [rest | _list]], type} -> highlight_line(rest, ["<span class=\"#{type}\">#{content}</span>" | formatted])
      {:ok, [content | _rest], type} -> highlight_line("", ["<span class=\"#{type}\">#{content}</span>" | formatted])
      {:error, line} -> highlight_line("", ["<span class=\"invalid\">#{line}</span> <span class=\"error\">Invalid syntax</span>" | formatted])
    end
  end

  defp find_token(line) do
    spaces = ~r<^(\s+)>
    keywords = ~r<^(as|assert|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|lambda|None|pass|raise|return|try|while|with|yield)\b>
    strings = ~r<^("[^"]*"|'[^']*')>
    comments = ~r<^(#.*)>
    numbers = ~r<^([+-]?\d+(\.\d+)?(e[+-]?\d+)?)>
    bools = ~r<^(True|False)\b>
    dtypes = ~r<^(str|int|float|complex|list|tuple|range|dict|set|frozenset|bool|bytes|bytearray|memoryview|NoneType)\b>
    operators = ~r[^(\*\*?=?|<<?=?|>>?=?|\^=?|\|=?|&=?|%=?|\/?\/=?|-=?|\+=?|==?|!=?|~|(and|or|is( not)?|(not )?in|not)\b)]
    delimiters = ~r<^[.:,;`\\]>
    brackets= ~r<^[()\[\]{}]>
    ids = ~r<^([a-zA-Z_]\w*)>
    cond do
      # Check Spaces and Identation
      spaces
      |> Regex.run(line) -> 
        {:ok, Regex.split(spaces, line, trim: true, include_captures: true), :space}

      # Check Keywords
      keywords
      |> Regex.run(line) -> 
        {:ok, Regex.split(keywords, line, trim: true, include_captures: true), :keyword}

      # Check Strings
      strings
      |> Regex.run(line) -> 
        {:ok, Regex.split(strings, line, trim: true, include_captures: true), :string}

      # Check Comments
      comments
      |> Regex.run(line) -> 
        {:ok, Regex.split(comments, line, trim: true, include_captures: true), :comment}

      # Check Numbers
      numbers
      |> Regex.run(line) -> 
        {:ok, Regex.split(numbers, line, trim: true, include_captures: true), :number}

      # Check Operators
      operators
      |> Regex.run(line) -> 
        {:ok, Regex.split(operators, line, trim: true, include_captures: true), :operator}

      # Check Delimiters
      delimiters
      |> Regex.run(line) -> 
        {:ok, Regex.split(delimiters, line, trim: true, include_captures: true), :delimiter}

      # Check Brackets
      brackets
      |> Regex.run(line) -> 
        {:ok, Regex.split(brackets, line, trim: true, include_captures: true), :bracket}
      
      # Check Booleans
      bools
      |> Regex.run(line) ->
        {:ok, Regex.split(bools, line, trim: true, include_captures: true), :bool}
      
      # Check Built-In Data Types (Classes)
      dtypes
      |> Regex.run(line) -> 
        {:ok, Regex.split(dtypes, line, trim: true, include_captures: true), :dtype}
      
      # Check Identifiers
      ids
      |> Regex.run(line) -> 
        {:ok, Regex.split(ids, line, trim: true, include_captures: true), :identifier}

      # Base Case (No Match)
      true -> {:error, line}
    end
  end
  
  defp html_struct(formatText), do:
    ~s(<!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Syntax Highlighter</title>
        <link rel="stylesheet" href="./style.css">
      </head>
      <body>
        <pre><code>#{formatText}</code></pre>
      </body>
      </html>)
    
    defp write_css(file) do
      data = 
        ["body { background-color: #0f111a; font-size: 1.2rem; padding 2rem; }",
         ".keyword { color: #c792ea; }",
         ".comment { color: #b6b6b6; }",
         ".operator { color: #ffe68f; }",
         ".number { color: #f78c6c; }",
         ".bool { color: #bdded4; }",
         ".dtype { color: #fce1f7; }",
         ".string { color: #c3e88d; }",
         ".bracket { color: #ffa053; }",
         ".delimiter {color: #89ddff; }",
         ".identifier {color: #82aaff; }",
         ".error {color: #ff5370; font-weight: bold;}",
         ".invalid {color: #ffd5c4; }"]
        |> Enum.join("\n")

      File.write(file, data)
    end
end
