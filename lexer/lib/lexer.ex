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

  If no directory is given it will use "highlighted" as
  the name of the directory

  The directory will be created where the file is located.
  """
  @spec highlight(fileIn(), dir()) :: :ok | :error
  def highlight(fileIn, dir \\ "highlighted") do
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

  @doc """
  Finds all python files in the given directory, creates a thread for each one
  and highlights the syntax of their contents in their respective thread.

  Finally, it creates a CSS file to color the tokens.
  """
  @spec highlight_parallel(dir()) :: :ok | :error 
  def highlight_parallel(dir \\ ".") do
    try do
      # Find python files and highlight syntax in parallel
      File.ls(dir)
      |> case do
        {:ok, files} -> files
        {:error, _reason} -> raise "Failed to read directory"
      end
      |> Enum.filter(&Regex.match?(~r|.py$|, &1))
      |> Enum.map(&Task.async(fn -> do_highlight_parallel(&1, dir) end))
      |> Enum.map(&Task.await(&1, :infinity))

      # Write CSS once
      css_file = ~s(#{dir}/style.css)
      create_css(css_file)
      |> case do
        :ok -> :ok
        true -> raise "Failed to create css file"
      end
    
    rescue
      exception ->
        IO.puts("Error: #{inspect(exception)}")
    end
  end

  defp do_highlight_parallel(fileIn, dir) do
    file = ~s|#{dir}/#{fileIn}|
    html_file = Regex.replace(~r|.py$|, file, ".html")
    create_html(html_file)
    |> case do
      :ok -> :ok
      {:error, _reason} -> raise "Failed to create html file"
    end

    File.stream!(file)
    |> Enum.each(&highlight_line(&1, html_file))

    File.write(html_file, "</code></pre>\n\t</body>\n</html>", [:append])
  end

  @doc """
  Finds all python files in the given directory and highlights the syntax of their 
  contents sequentially

  Finally, it creates a CSS file to color the tokens.
  """
  def highlight_sequential(dir) do
    try do
        # Find python files and highlight syntax sequentially
        File.ls(dir)
        |> case do
          {:ok, files} -> files
          {:error, _reason} -> raise "Failed to read directory"
        end
        |> Enum.filter(&Regex.match?(~r|.py$|, &1))
        |> Enum.each(&do_highlight_sequential(&1, dir))
        
        # Write CSS once
        css_file = ~s(#{dir}/style.css)
        create_css(css_file)
        |> case do
          :ok -> :ok
          true -> raise "Failed to create css file"
        end
      
      rescue
        exception ->
          IO.puts("Error: #{inspect(exception)}")
    end
  end

  defp do_highlight_sequential(fileIn, dir) do
    file = ~s|#{dir}/#{fileIn}|
    html_file = Regex.replace(~r|.py$|, file, ".html")
    create_html(html_file)
    |> case do
      :ok -> :ok
      {:error, _reason} -> raise "Failed to create html file"
    end

    File.stream!(file)
    |> Enum.each(&highlight_line(&1, html_file))

    File.write(html_file, "</code></pre>\n\t</body>\n</html>", [:append])
  end

  @doc """
  Uses the given directory to run both the sequential and parallel highlighting 
  functions in `iters` iterations.

  Each execution time is written in the standard output and the accumulated
  times are saved as state and then used to find the average performance and
  speedup 
  """
  def benchmark(dir \\ "examples/parallel", iters \\ 10) do
    IO.puts("|\tSequential\t|\tParallel\t|")
    {acc_1, acc_p} = do_benchmark(dir, {0, 0}, iters)
    {acc_1 / iters, acc_p / iters, acc_1 / acc_p} 
  end

  # Utility function to time sequential and parallel executions
  defp do_benchmark(_dir, acc, 0), 
    do: acc

  defp do_benchmark(dir, {acc_1, acc_p}, iters) do
    t1 = :timer.tc(fn -> Lexer.highlight_sequential(dir) end) 
      |> elem(0)
      |> Kernel./(1_000_000)

    tp = :timer.tc(fn -> Lexer.highlight_parallel(dir) end) 
      |> elem(0)
      |> Kernel./(1_000_000)
    
    IO.puts(~s(|\t#{t1} \t|\t#{tp} \t|))

    do_benchmark(dir, {acc_1 + t1, acc_p + tp}, iters - 1)
  end

  defp find_token(line) do
    [{:space, ~r<^(\s+)>},
     {:keyword, ~r<^(as|assert|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|lambda|None|pass|raise|return|self|try|while|with|yield)\b>},
     {:string, ~r<^"(\\"|[^"])*">},
     {:string, ~r<^'(\\'|[^'])*'>},
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
    # Sanitize content for HTML
    safe_content = if Regex.match?(~r|<[^<>]*>|, content) do
      content 
      |> String.replace(~r|(<)|, "&lt;")
      |> String.replace(~r|(>)|, "&gt;")
    else
      content
    end
    Regex.split(~r|<[^<>]*>|, content, include_captures: true)
    if type == :space,
      do: File.write(fileIn, content, [:append]),
      else: File.write(fileIn, ~s(<span class="#{type}">#{safe_content}</span>), [:append])

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

    :ok
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
    
    :ok
  end

end
