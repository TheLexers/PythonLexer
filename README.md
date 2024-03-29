# PythonLexer

## Authors

Juan Pablo Ruiz de Chávez Diez de Urdanivia  
Joaquín Badillo Granillo


This repository contains a `mix` project that highlights a file using the syntax of python code; therefore it is intended to be used with Python files.

## Requirements
You will need to have Elixir installed in your computer. There are lots of [Installation](https://elixir-lang.org/install.html) methods and you should follow the one that suits your operative system and preferences.

For Ubuntu users we would recommend using `asdf` or `docker` to have control over multiple versions of elixir.

## Usage

The mix project has 2 public functions: `highlight/2` and `highlight/1`. Documentation for this module has been generated with docstrings and ExDoc and it can be found on the `docs` directory. Here you will also find in markdown files the tokens that we decided to highlight, some examples and information regarding the time complexity of the lexer.

If you are unfamiliar with `mix` but you want to use this project just move to the `lexer` directory and run Elixir interactively with the following command

```
$ iex -S mix
```

This command also imports the modules from the `lib` directory therefore you will have access to the public functions of the `Lexer` module.

To a highlight a file with a path `path/to/file.py` and get the results in the directory `dir` you can run the following command:
```
iex> Lexer.highlight("path/to/file.py", "dir")
```
The directory will be created in the same place as the file. The `dir` argument is optional and if it is not given the results will be saved in the `lexer` directory.

You can also decide to highlight the file without providing a directory, this will try to create a default directory called `highlighted` in the same place as the file.
```
iex> Lexer.highlight("path/to/file.py")
```
Some examples of code already passed through this function can be found on the `/lexer/examples` directory.

### Note

You might also need to install some dependencies in order to run the project. If this is the case you can use the following command in the `lexer` directory:

```
mix deps.get
```
The only dependency is ExDoc, which is used to generate the documentation that is shown in the GitHub Pages.

---

<!-- <style>
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

  GitHub blocks style tags -->


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

Color code: #c792ea;

### <span class="string">Strings</span>
Text inside single or double quotes:
* "This is a string"
* 'This is also a string'

Color code: #c3e88d;

### <span class="number">Numbers</span>
* Integers - e.g. 1, 2, 3
* Floating point numbers - e.g. 1.0, 1.5, 0.8
* Scientific notation - e.g. 1e10, -2e5, 8.0e-2
* Complex numbers - e.g. 1+1j, 2.0-2j, -3+4j

Color code: #f78c6c;

### <span class="bool">Booleans</span>
* True
* False

Color code: #bdded4;

### <span class="operator">Operators</span>

|       |     |    |    |     |     |     |     |     |    |
|:-----:|:---:|:--:|:--:|:---:|:---:|:---:|:---:|:---:|:--:|
| +     | -   | *  | /  | %   | **  | //  | <<  | >>  | &  |
| \|    | ^   | ~  | <  | <=  | >   | >=  | <>  | !=  | == |
| +=    | -=  | *= | /= | //= | %=  | >>= | <<= | **= | ^= |
| &=    | \|= | =  |

Color code: #ffe68f;

### <span class="delimiter">Delimiters</span>

|    |     |    |     |     |     |     |
|:--:|:---:|:--:|:---:|:---:|:---:|:---:|
| ,  | :   | .  | `   | \\  | ;   | ->  |

Color code: #89ddff;


### <span class="bracket">Brackets</span>

|    |     |    |     |     |    |
|:--:|:---:|:--:|:---:|:---:|:---:|
| (  | )   | [  | ]   | {   | }   |

Color code: #ffa053;

### <span class="dtype">Data Type</span>

Built-in data types by class name

|     -     |     -     |     -     |     -      |     -     |
|:---------:|:---------:|:---------:|:----------:|:---------:|
| str       | int       | float     | complex    | list      |
| tuple     | range     | dict      | set        | frozenset |
| bool      | bytes     | bytearray | memoryview | NoneType  |

Color code: #fce1f7;

### <span class="identifier">Identifier</span>

Variables, constants and function names. These have alphanumeric and underscore characters, although these cannot start with numbers

Color code: #82aaff;

### <span class="comment">Comments</span>

Anything after a # sign and before a line break

Color code: #b6b6b6;

---

## Regular Expressions:

```elixir 
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

First let's find the time complexities of some helper functions that we will use in the `Lexer` module. 

```elixir
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
```
Let $k$ be the length of the longest regular expression match. We can see here that we are trying to match the line provided with each regular expression. Since there is a constant number of regular expressions the complexity of the `Enum.find/2` procedure will be $O(k)$, moreover since we are looking for matches at the beginning of the string most of them will terminate early. Finally, if we are able to match we split the line using the regular expression, which has a complexity of $O(k)$, and return the result. If we are not able to match we return an error. Thus the overall complexity of this function is $O(k)$, since the split only occurs after we finished finding the match. We can see what's the longest match, and it is the comment expression; which has a complexity of $O(m)$, where $m$ is the length of the line. Since it has to go through all the characters in the line, thus this will be the complexity of the `find_token/1` function.

```elixir 
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

Now looking at the `highlight_line/2` function we can see that we call the `find_token/1` procedure on the line and try to match its results to different patters. Checking patterns takes constant time, and the `find_token/1` function has a complexity of $O(m)$, but what about the `recursive_write/4` function? Let us derive its complexity.


```elixir
defp recursive_write(fileIn, content, type, rest) do
    if type == :space,
      do: File.write(fileIn, content, [:append]),
      else: File.write(fileIn, ~s(<span class="#{type}">#{content}</span>), [:append])

    highlight_line(rest, fileIn)
  end

```
Recursive write is a simple function that will write the content to the file if the type is a space, otherwise it will write the content with the corresponding HTML tag. However, it will also call the `highlight_line/2` function with the rest of the line. Writing to the file will be as expensive as the amount of characters to write, therefore it will have a complexity of $O(k)$ since that was the longest match. The new call to `highlight_line/2` will have a smaller list and thus the longest expression that could match will be smaller let us call this value $k_{1} < k$. This calls will continue until the line is empty, creating a decreasing sequence $\langle k, k_{1}, k_{2}, \dots, 0 \rangle$. Notice that in the worst scenario it will read the whole line, but then the function would terminate immediately with an $O(m)$ complexity. But now let us consider the case where the recursive calls always divides the size of the input by some value $b \leq m$, then if $T(m)$ is the complexity of this function, we can write the following recurence relation:
$$T(m) = T\left(\frac{m}{b}\right) + O(m)$$
Since it will call itself again with a smaller complexity. The function that is added in the end is due to the fact that it will have a complexity of at most $m$ in each call when writing the contents (which in more general cases is a merging procedure). In fact this is a divide and conquer algorithm since each regular expression match divides the string in 2 parts, one will be written taking $O(m)$ time (the big oh notation hides the fact that the time taken is proportional to $m - \frac{m}{b}$ since it writes whatever was divided), the other part will be used recursively. Intuitively we can see that we are just making constant computational efforts of writing the content and then dividing the string by that content, which in the end leads to writing the whole string: $O(m)$.

Formally, using the Master Theorem (found in Cormen's Introduction to Algorithms), we can see that the complexity of this function will indeed be $O(m)$. This follows from the fact that any recurrence of the form $T(n)=aT(n/b)+f(n),$ with
$f(n)=\Omega(n^{\log_{b}a+\epsilon})$ for some constat $\epsilon > 0$ and for which $af(n/b)\leq cf(n)$ with some constant $c<1$ and all sufficiently large $n$, will have a complexity $T(n)=\Theta(f(n))$ (Theorem 4.1. Introduction to Algorithms). We know that this is the case since we can deduce the coefficients. In this case $a=1$, thus $n^{\log_{b}a+\epsilon} = n^{\log_{b}^{1 + \epsilon}}$, and using $\epsilon = b - 1$ gives the same complexity as the function $f$. Finally we can simply choose $b=c$ to solve the inequality. 

Looking at the main and public function `highlight/2`, once we derived the time complexity of the `highlight_line/2` function we can finally show that the overall time complexity is $O(nm)$, why is this the case?

```elixir
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
```

As we can see, the function highlight firstly initialize the variables and expand the paths. These lines have a complexity of $O(1)$ as it is a constant time. The function File.mkdir has also a constant complexity. 

The next two functions 'create_css' and 'create_html' have a complexity of $O(1)$, since these functions create static files that we have hard coded with HTML tags and CSS styles and thus they will always take the same time to execute. 

Let us define the number of lines in the file as $n$ and the maximum number of characters in a line as $m$ (as used previously). Then, the `File.stream!` function which will read line by line the text file provided, as send the characters read to the `highlight_line/2` function. Reading the characters takes linear time $O(m)$ and as we just showed `highlight_line/2` has the same complexity, thus for each line we are reading through the stream we are taking time linear in $m$. There are $n$ of this lines by our definition and therefore the overall time complexity of piping the results of the stream is $O(nm)$. Finally we write some static data to the HTML file again, taking constant time and the process ends. This means that the overall time compelxity is $O(nm)$.

## Parallel programming and concurrency

Parallel programming is of enormous importance in today's computing context as it enables the efficient utilization of multiple processors or cores to tackle complex tasks concurrently, hence significantly enhancing the speed and performance the code. By dividing a program into smaller, independent tasks that can be executed simultaneously, parallel programming makes a program considerably faster and more optimized. Because of this, we decided to implement a parallel version of our lexer, which we will call `highlight_parallel`. This function will take the same arguments as the `highlight` function, but it will use the `Task.async` module to run the `do_highlight_parallel` function in parallel as showed in the following code:

```elixir
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

```
### Usage

To use this function you will need to run the following command in the `iex` terminal, first execute in the root of the mix project (`PythonLexer/lexer`):

```
iex -S mix
```
Then you can run the following command to highlight the files in the `PythonLexer/lexer/examples/parallel` directory:

```
iex> Lexer.highlight_parallel("./examples/parallel")
```
This will create a html for each python file in the directory and a css file with the styles. The files will be created in the same directory and will have the same name but with different extensions.

There is also a function that does the same (highlight the contents of all the files in a directory) but it does it sequentially. This function is `highlight_sequential/1` and it can be used in the same way as the parallel function. The only difference is that it will use a single thread.

## Parallel complexity

If we consider the case were $k$ files are being highlighted sequentially, then the time complexity of the function is $O(knm)$, where $n$ is the number of lines in the biggest files and $m$ is the number of characters. This follows from the previous demonstration of the complexity of the `highlight/2` function, which takes $O(nm)$ time and therefore when trying to read multiple files the complexity will be the same as the longest file.

Interestingly, `highlight_parallel` has the same asymptotic time complexity as the sequential function. Since the number of threads that can be executed simultaneously is fixed by the system being used, and constants are dropped in big oh notation. 

However, the fact that the asymptotic time complexity is the same doesn't mean that the execution times will be equal. For instance if we try to highlight 8 files in a computer with 8 cores, the difference in the execution times of the sequential and parallel implementations should differ and depending on the size of the files the change in that time might become very significant.

On the other hand if the files are sufficiently small it may be slower for the parallel function to execute. This is because the time it takes to create a new process and all the operations managed by the system to run the process may be greater than the time it takes to highlight the file. In this case the sequential function would be faster. However notice that this only occurs with "small" files, and therefore the time to execute is expected to be small.

## Benchmarking the Performance

A benchmark function was created in order to compare the performance of the sequential and parallel functions. The results can be found in the following table or in the `img` folder of this repository.

| Run       | Sequential time (s) | Parallel time (s)   |
|:---------:|:-------------------:|:-------------------:|
| 1.        | 7.927765            | 5.490092            |
| 2.        | 7.537254            | 5.775834            |
| 3.        | 7.880397            | 5.608249            |
| 4.        | 7.612272            | 5.791548            |
| 5.        | 7.606539            | 5.756286            |
| 6.        | 7.496936            | 5.824183            |
| 7.        | 7.475266            | 5.91838             |
| 8.        | 7.704623            | 6.032369            |
| 9.        | 7.720456            | 5.48416             |
| 10.       | 7.929119            | 5.769395            |

The speedup, $S$, which is the ratio of the sequential time to the parallel time, was calculated with the following formula: $S = \frac{\sum_{i=0}^{N} T_{s_i}}{\sum_{i=0}^{N} T_{p_i}}$, where $T_{s_{i}}$ is the execution time of the sequential algorithm in the $i^{\mathrm{th}}$ iteration and $T_{p_i}$ is the time of the parallel algorithm in the $i^{\mathrm{th}}$ iteration. This is equivalent to dividing the average execution times of the sequential and parallel algorithms. 

As shown by the table we used 10 iterations, and we also benchmarked the implementations with a computer that has 8 cores. This resulted in a speed of: $1.338380490222399 $, which means that the parallel function is around 1.33 times faster than the sequential function, or in other words, the parallel function is 33% faster than the sequential function. The speedup is not as high as we expected, but this is probably due to the fact that the files used for the benchmarking were relatively small and the overhead of creating a new process and managing the threads was big enough to make the functions have similar running times.

It is also important to mention that, as both functions recieve more and larger files, the speedup will increase and the overall performance of the parallel function will be better and noticeable. As a matter of fact one of the files was particularly heavy: `examples/parallel/03_large-file.py` and it took 4.75 seconds alone; which is about 80% of the execution time in the parallel function.See the image below, second execution `iex(2)>`

![Benchmark](./img/benchmark.png)

This shows that the other 7 files added about 3 seconds to the sequential function and therefore there running times are small enough for the parallel function to just wait for this single file to finish.


## Reflection

Coding is always going to be a tool that can be used for the benefit of the society or for the opposite. As any sort of knowledge, it can be used for good or for bad and it is important to always have an ethical view of the situation of what our code can be used for.

In our case, we have created a syntax highlighter for Python. This program by itself may not be a very useful tool in the version that it is right now, we are aware that there are way more powerful lexers out there; but the interesting part of this project is that we have decided to make it open source by making a public repository in GitHub. This means that anyone can use it and modify it for their own benefit, but we have also taken the time to document it correctly so that people can learn from it, the time complexity section on this file could also be helpful for some. This is why we think that humanity caan always evolve for better as long a society is willing to learn, share their knowledge and also help those who need help. From an ethical point of view we believe that making knowledge accesible is not only correct but also necessary for the development of our society and we are glad to contribute to this cause.

### Concurrency

As it becomes harder to improve computer hardware, the need for better software becomes more important. This is why concurrency is a very important topic in computer science. It allows us to run different parts of an algorithm separately and when this processes are slow enough the results can be very significant. This is why we decided to implement a parallel version of our lexer.

Concurrency has a lot of difficulties, but using the functional paradigm allows us to have a better control over the state of the program thanks to immutability. Moreover, Elixir makes the use of the Erlang Virtual Machine (BEAM) more accessible which is a very powerful piece of technology as it allows for processes to be very cheap.
