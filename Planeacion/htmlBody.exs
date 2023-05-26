def LexFile(file) do
  pyPath = Path.expand(file)
  resultFile = "PythonLexerTest.html"
  IO.puts("Reading file: " <> pyPath)

  case File.read(pyPath) do
    {:ok, text} ->
      FormatText =
        text
        |> String.split("\n")
        |> Enum.map(&find_token/1)
        |> Enum.join("\n")

      htmlFill = htmlStruct(FormatText)
      File.write(resultFile, htmlFill)
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
