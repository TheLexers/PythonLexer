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
    css_file = ~s(#{Path.dirname(fileIn)}/#{dir}/style.css)
    html_file = ~s(#{Path.dirname(fileIn)}/#{dir}/index.html)
  
    try do
      IO.puts(~s<Creating Directory #{dir}>)
      File.mkdir_p!(~s(#{Path.dirname(fileIn)}/#{dir}/))

      IO.puts(~s<Writing CSS file in #{dir}>)
      write_css(css_file)

      IO.puts(~s<Writing HTML file in #{dir}...>)
      html_start(html_file)

      File.stream!(py_path)
      |> Enum.each(&highlight_line(&1, html_file))

      File.write(html_file, "</code></pre>\n\t</body>\n</html>", [:append])
    rescue
      exception ->
        IO.puts("Failed to create file. Reason: #{inspect(exception)}")
    end
  end

  defp highlight_line(line, fileIn) do
    case find_token(line) do
      {:ok, [content | [rest | _list]], type} -> 
        recursive_write(fileIn, content, type, rest)

      {:ok, [content | _rest], type} ->
        File.write(fileIn, ~s(<span class="#{type}">#{content}</span>), [:append])

      {:error, line} -> 
        File.write(fileIn, ~s(<span class="error">Invalid syntax</span> &gt; <span class="invalid">#{line}</span>), [:append])
    end
  end

  defp recursive_write(fileIn, content, type, rest) do
    if type == :space,
      do: File.write(fileIn, content, [:append]),
      else: File.write(fileIn, ~s(<span class="#{type}">#{content}</span>), [:append])

    highlight_line(rest, fileIn)
  end

  defp find_token(line) do
    spaces = ~r<^(\s+)>
    keywords = ~r<^(as|assert|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|lambda|None|pass|raise|return|try|while|with|yield)\b>
    strings = ~r<^("[^"]*"|'[^']*')>
    comments = ~r<^(#.*)>
    numbers = ~r<^([+-]?\d+(\.\d+)?(e[+-]?\d+)?([+-]\d+(\.\d+)?(e[+-]?\d+)?j)?)>
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
  
  defp html_start(fileIn) do
    File.write(fileIn,"<!--  Index file with highlighted text -->\n")

    ["<!DOCTYPE html>\n",
     "<html lang=\"en\">\n",
     "\t<head>\n",
     "\t\t<meta charset=\"UTF-8\">\n",
     "\t\t<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n",
     "\t\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n",
     "\t\t<title>Syntax Highlighter</title>\n",
     "\t\t<link rel=\"stylesheet\" href=\"./style.css\">\n",
     "\t</head>\n",
     "\t<body>\n",
     "\t\t<pre><code>"]
     |> Enum.each(&File.write(fileIn, &1, [:append]))
  end
    
  defp write_css(fileIn) do
    File.write(fileIn,"/* CSS file for syntax highlighting */\n")

    ["body { background-color: #0f111a; font-size: 1.2rem; padding: 0 1.5rem; color: #e0e0e0}",
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
      |> Enum.each(&File.write(fileIn, &1, [:append]))
  end
end
