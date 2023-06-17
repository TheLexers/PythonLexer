# Another meta example
# Syntax Highlighter in Python
# Using a library though
# Joaquin Badillo

import sys
import re
from pygments.lexer import RegexLexer, bygroups
from pygments.token import *
from pygments import highlight
from pygments.formatters import HtmlFormatter

class PythonLexer(RegexLexer):
    name = 'Python'
    aliases = ['python']
    filenames = ['*.py']

    tokens = {
        'root': [
            (r'(#.*)$', Comment),
            (r'(as|assert|break|class|continue|def|del|elif|else|except|finally|for|from|global|if|import|lambda|None|pass|raise|return|self|try|while|with|yield)\b', Keyword),
            (r'"(\\"|[^"])*"', String),
            (r"'(\\'|[^'])*'", String),
            (r'(print|disp)\b', Name.Builtin),
            (r'(int|float|complex|list|tuple|range|dict|set|frozenset|bool|bytes|bytearray|memoryview|NoneType)\b', Keyword.Type),
            (r'[+-]?\d+(\.\d+)?(e[+-]?\d+)?([+-]\d+(\.\d+)?(e[+-]?\d+)?j)?', Number),
            (r'(True|False)\b', Keyword.Constant),
            (r'([.:,;`\\]|->)', Punctuation),
            (r'(\*\*?=?|<<?=?|>>?=?|\^=?|\|=?|&=?|%=?|\/?\/=?|-=?|\+=?|==?|!=?|~|(and|or|is( not)?|(not )?in|not)\b)', Operator),
            (r'[()\[\]{}]', Punctuation),
            (r'[a-zA-Z_]\w*', Name),
            (r'\s+', Text)
        ]
    }

def writeCSS(file):
    with open(file, "w") as f:
        f.write(
            "\n".join([
                "body { background-color: #0f111a; font-size: 1.2rem; padding: 0 1.5rem; color: #e0e0e0}",
                ".k { color: #c792ea; }",
                ".c { color: #b6b6b6; }",
                ".o { color: #ffe68f; }",
                ".m { color: #f78c6c; }",
                ".kc { color: #bdded4; }",
                ".s { color: #c3e88d; }",
                ".p { color: #ffa053; }",
                ".n {color: #82aaff; }",
                ".nb {color: #b2c8f7; }",
                ".err {color: #ffd5c4; text-decoration:#f00 wavy underline;}"
            ])
        )
    return ":ok"

def writeHTML(file):
    with open(file, "w") as f:
        css_file = re.sub(r"\.html$", ".css", file)
        css_file = css_file.split("/")[-1]
        f.write(
            "\n".join([
                "<html>",
                "<head>",
                f"<link rel=\"stylesheet\" href=\"./{css_file}\">",
                "</head>",
                "<body>",
                "<pre>",
                "<code>"
            ])
        )
    return ":ok"

def main(args):
    # Write HTML file
    code = ""
    with open(args[1], "r") as f:
        code = f.read()
    
    formatter = HtmlFormatter()
    lexer = PythonLexer()
    result = highlight(code, lexer, formatter)
    html_file = re.sub(r"\.py$", ".html", args[1])
    css_file = re.sub(r"\.py$", ".css", args[1])
    writeCSS(css_file)
    writeHTML(html_file)
    with open(html_file, "a") as f:
        f.write(result)
        f.write(
            "\n".join([
                "</code>",
                "</pre>",
                "</body>",
                "</html>"
            ])
        )

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python lexer.py <input_file>")
        sys.exit(1)
    
    main(sys.argv)

