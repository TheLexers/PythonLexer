# PythonLexer

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
