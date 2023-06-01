# PythonLexer
## Situacion problema: Resaltador de sintaxis

## Authors

Juan Pablo Ruiz de Chávez Diez de Urdanivia  
Joaquín Badillo Granillo


This repository contains a `mix` project that highlights a file using the syntax of python code; therefore it is intended to be used with Python files.

## Usage

You will need to have Elixir installed in your computer. There are lots of [Installation](https://elixir-lang.org/install.html) methods and you should follow the one that suits your operative system and preferences.

For Ubuntu users I would recommend using `asdf` or `docker` to have control over multiple versions of elixir.

The mix project has a single public function: `highlight/2`. Documentation for this module has been generated with docstrings and ExDoc and it can be found on the `docs` directory. Here you will also find in markdown files the tokens that we decided to highlight, some examples and information regarding the time complexity of the lexer.

If you are unfamiliar with `mix` but you want to use this project just move to the `lexer` directory and run Elixir interactively with the following command

```
$ iex -S mix
```

This command also imports the modules from the `lib` directory therefore you will have access to `Lexer.highlight/2`.

---
## Evidence Description
1. Selecciona un lenguaje de programación que te resulte familiar (por ejemplo, C, C++, C#, Java, JavaScript, Python, Racket, etc.), y determina las categorías léxicas que tiene (por ejemplo, palabras reservadas, operadores, literales, comentarios, etc.)
2. Define una descripción para cada una de las categorías léxicas (tipos de tokens) del lenguaje seleccionado. Puedes usar una máquina de estados o expresiones regulares.
3. Usando el lenguaje funcional indicado por tu profesor implementa un lector de los elementos léxicos de cualquier archivo fuente provisto.
4. El programa debe convertir su entrada en documentos de HTML+CSS que resalten su léxico.
5. Utiliza las convenciones de codificación del lenguaje en el que está implementado tu programa.
6. Reflexiona sobre la solución planteada, los algoritmos implementados y sobre el tiempo de ejecución de estos.
7. Calcula la complejidad de tu algoritmo basada en el número de iteraciones y contrástala con el tiempo estimado en el punto anterior.
8. Plasma en un breve reporte de una página (en formato Markdown) las conclusiones de tu reflexión en los puntos 6 y 7. Agrega además una breve reflexión sobre las implicaciones éticas que el tipo de tecnología que desarrollaste pudiera tener en la sociedad.

<style>
    .keyword { color: #c792ea; }
    .comment { color: #b6b6b6; }
    .operator { color: #ffe68f; }
    .number { color: #f78c6c; }
    .bool { color: #bdded4; }
    .dtype { color: #fce1f7; }
    .string { color: #c3e88d; }
    .bracket { color: #ffa053; }
    .delimiter {color: #89ddff; }
    .identifier {color: #82aaff; }
    .error {color: #ff5370; font-weight: bold;}
    .invalid {color: #ffd5c4; }
</style>


# Python Lexer Tokens

This document describes the different tokens and characters
available in the Python syntax. This keywords or special characters
can all be evaluated in the program found in this repository as they are
painted in a different color for differentiation pourposes.

## Tokens
---
### <span class="keyword">Keywords</span>
|           |           |           |           |           |
|:---------:|:---------:|:---------:|:---------:|:---------:|
| as        | def       | finally   | import    | return    |
| assert    | del       | for       | lambda    | try       |
| break     | elif      | from      | None      | while     |
| class     | else      | global    | pass      | with      |
| continue  | except    | if        | raise     | yield     |

### <span class="string">Strings</span>
Text inside single or double quotes:
* "This is a string"
* 'This is also a string'


### <span class="number">Numbers</span>
* Integers - e.g. 1, 2, 3
* Floating point numbers - e.g. 1.0, 1.5, 0.8
* Scientific notation - e.g. 1e10, -2e5, 8.0e-2
* Complex numbers - e.g. 1+1j, 2.0-2j, -3+4j

### <span class="bool">Booleans</span>
* True
* False

### <span class="operator">Operators</span>

|       |     |    |    |     |     |     |     |     |    |
|:-----:|:---:|:--:|:--:|:---:|:---:|:---:|:---:|:---:|:--:|
| +     | -   | *  | /  | %   | **  | //  | <<  | >>  | &  |
| \|    | ^   | ~  | <  | <=  | >   | >=  | <>  | !=  | == |
| +=    | -=  | *= | /= | //= | %=  | >>= | <<= | **= | ^= |
| &=    | \|= | =  |

### <span class="delimiter">Delimiters</span>

|    |     |    |     |     |     |
|:--:|:---:|:--:|:---:|:---:|:---:|
| ,  | :   | .  | `   | \\   | ;   |


### <span class="bracket">Brackets</span>

|    |     |    |     |     |    |
|:--:|:---:|:--:|:---:|:---:|:---:|
| (  | )   | [  | ]   | {   | }   |

### <span class="dtype">Data Type</span>

Built-in data types by class name

|     -     |     -     |     -     |     -      |     -     |
|:---------:|:---------:|:---------:|:----------:|:---------:|
| str       | int       | float     | complex    | list      |
| tuple     | range     | dict      | set        | frozenset |
| bool      | bytes     | bytearray | memoryview | NoneType  |

### <span class="identifier">Identifier</span>

Variables, constants and function names. These have alphanumeric and underscore characters, although these cannot start with numbers


### <span class="comment">Comments</span>

Anything after a # sign and before a line break

---

## Regular Expressions:

``` 
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
```
---

## Complexity and reflection

Creating a syntax highlighter is always a challenge, but it is a very interesting one. There were different solutions that we could work on in order to solve this problem. The first one was to evaluate the code by using a DFA or state machine, going trhough each character. The other possible solution which was a little bit easier but still very challenging was to analyze the code using different regular expressions. Because of its simplicity and moldability we decided tu use this alternative as our proposal to the solution of the problem.

 The first thing we did was to create a regular expression for each token, and then analyze each single line of the document. As the challenge was to create a syntax highlighter, it was imperative to create functions to initialize both, a CSS and a HTML document. Whithin these documents we would store the different styles in order to color the tokens and also the HTML tags to display the code in a web browser. 

The next step was to analyze each line of the document. Once this final step was done, the only thing left to do was to test our code and make sure that it was optimized and working properly. This last point lead us to a very interesing questions: What is th complexity of our code? 

## Code Complexity

In order to explain the complexity of our code, we will start by analyzing each fragment of the code.

```
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
```

As we can see, the function highlight firstly initialize the variables and expand the paths. These lines have a complexity of O(1) as it is a constant time. The function File.mkdir has also a constant complexity. 

The next two functions 'wirtes_css' and 'html_start' have a complexity of O(n) as they depend on the length of the document that is going to be written. However, if the document is small, the complexity can be considered as constant. Last but not least we have File.write, which also has a a constant complexity. Notice that we are not talking about highlight_line yet since it is going to be explained in the next section.

``` 
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
```
This whole function can be explained as O(n) as it depends on the length of the line that is being analyzed. However it can be also considered as constant if the line is small or "n" will be equal to maximum number of tokens in the line. 

```
defp recursive_write(fileIn, content, type, rest) do
    if type == :space,
      do: File.write(fileIn, content, [:append]),
      else: File.write(fileIn, ~s(<span class="#{type}">#{content}</span>), [:append])

    highlight_line(rest, fileIn)
  end

```

As this function is called recursively and writes content to the created file it can also be judged as the last function taking into consideration that for small documents the complexity can be considered as constant but for bigger documents it will be O(n).

The next functions which are "html_start", "write_css" and "find_token" have a complexity of O(1). They are not written here since their complexity is always constant. The function "find_token" is called by "highlight_line" and "html_start" and "write_css" only create the styles and formats of the generated highlighted file.

Overall, we can say that the complexity of the code will depend on the length of the generated file or the upcoming file to be analyzed. If the file is small, the complexity will be constant but if the file is big, the complexity will be O(n).

## Reflection

Coding is always going to be a tool that can be used for the benefit of the society or for the opposite. As any sort of knowledge, it can be used for good or for bad and it is important to always have an ethical view of the situation of what our code can be used for.

In our case, we have created a syntax highlighter for Python. which as itself it may not be a very useful tool in the version that it is right now. The interesting part of this project is that we have decided to make it open source. This means that anyone can use it and modify it for their own benefit, but also learn from it. this is why we think that humanity caan always evolve for better as long a society is willing to learn, share their knowledge and also help those who need help. 
