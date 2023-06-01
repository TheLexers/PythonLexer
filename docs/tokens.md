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