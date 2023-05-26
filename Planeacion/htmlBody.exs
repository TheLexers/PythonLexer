def lex_file(file) do
  py_path = Path.expand(file)
  result_file = "PythonLexerTest.html"
  IO.puts("Reading file: #{py_path}")

  case File.read(py_path) do
    {:ok, text} ->
      format_text = Enum.join(Enum.map(String.split(text, "\n"), &find_token/1), "\n")
      html_fill = html_struct(format_text)
      File.write(result_file, html_fill)
    {:error, reason} ->
      IO.puts("Failed to read file. Reason: #{inspect(reason)}")
  end
end

defp htmlStruct(FormatText) do
  html = ~s(<!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Syntax Highlighter</title>
      <style>
        .keywords { color: green; }
        .comments { color: grey; }
        .operators { color: orange; }
        .numbers { color: purple; }
        .strings { color: green; }
        .brackets { color: orange; }
      </style>
    </head>
    <body>
      <pre><code>#{FormatText}</code></pre>
    </body>
    </html>)

  html
end
