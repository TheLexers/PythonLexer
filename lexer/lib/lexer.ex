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
  Highlights the syntax of a python file given by the user `fileIn`
  by creating a HTML and CSS file inside a directory called 
  `highlighted` which will be located in the same place as the file.
  """
  @spec highlight(fileIn()) :: :ok | :error
  def highlight(fileIn), 
    do: highlight(fileIn, "highlighted")

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
      IO.puts(~s<Trying to create directory #{dir}>)
      File.mkdir_p(~s(#{Path.dirname(fileIn)}/#{dir}/))
      |> case do
        :ok -> :ok
        {:error, _reason} -> raise "Failed to create directory"
      end

      IO.puts(~s<Writing CSS file in #{dir} directory>)
      create_css(css_file)

      IO.puts(~s<Writing HTML file in #{dir} directory...>)
      create_html(html_file)

      File.stream!(py_path)
      |> Enum.each(&highlight_line(&1, html_file))

      File.write(html_file, "</code></pre>\n\t</body>\n</html>", [:append])
    rescue
      exception ->
        IO.puts("Process Failed. Reason: #{inspect(exception)}")
    end
  end

  defp find_token(line) do
    [{:space, ~r<^(\s+)>},
     {:keyword, ~r<^(as|assert|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|lambda|None|pass|raise|return|self|try|while|with|yield)\b>},
     {:string, ~r<^("[^"]*"|'[^']*')>},
     {:comment, ~r<^(#.*)>},
     {:number, ~r<^([+-]?\d+(\.\d+)?(e[+-]?\d+)?([+-]\d+(\.\d+)?(e[+-]?\d+)?j)?)>},
     {:bool, ~r<^(True|False)\b>},
     {:dtype, ~r<^(str|int|float|complex|list|tuple|range|dict|set|frozenset|bool|bytes|bytearray|memoryview|NoneType)\b>},
     {:delimiter, ~r/^([.:,;`\\]|->)/ },
     {:operator, ~r[^(\*\*?=?|<<?=?|>>?=?|\^=?|\|=?|&=?|%=?|\/?\/=?|-=?|\+=?|==?|!=?|~|(and|or|is( not)?|(not )?in|not)\b)]},
     {:bracket, ~r<^[()\[\]{}]>},
     {:identifier, ~r<^([a-zA-Z_]\w*)>}]
    |> Enum.find(fn {_token, regex} -> Regex.match?(regex, line) end)
    |> case do
      {token, regex} -> {:ok, Regex.split(regex, line, trim: true, include_captures: true), token}
      nil -> {:error, line}
    end
  end

  defp highlight_line(line, fileIn) do
    case find_token(line) do
      {:ok, [content | [rest | _list]], type} -> 
        recursive_write(fileIn, content, type, rest)

      {:ok, [content | _rest], type} ->
        File.write(fileIn, ~s(<span class="#{type}">#{content}</span>), [:append])
      
      {:error, content} -> File.write(fileIn, ~s(<span class="invalid">#{content}</span>), [:append])
    end
  end

  defp recursive_write(fileIn, content, type, rest) do
    if type == :space,
      do: File.write(fileIn, content, [:append]),
      else: File.write(fileIn, ~s(<span class="#{type}">#{content}</span>), [:append])

    highlight_line(rest, fileIn)
  end
  
  defp create_html(fileIn) do
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
    
  defp create_css(fileIn) do
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
      ".invalid {color: #ffd5c4; text-decoration:#f00 wavy underline;}"]
      |> Enum.each(&File.write(fileIn, &1, [:append]))
  end
end
