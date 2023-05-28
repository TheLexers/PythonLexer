# Using reserved words in ids

# Using break-
def breakingLexer():
    return False

# Using def-
def definition():
    return "definition"

# Using is-
isTrue = True

# Using False-
FalseItIs = False

# Using and-
andThis = False

# Using or-
orThis = False

# Using not-
notTrue = False

if __name__ == "__main__":
    print("Will this " + definition() + " break the lexer?")
    print(breakingLexer())