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