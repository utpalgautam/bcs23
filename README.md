# BCS Language Parser

A lexical analyzer and parser for the BCS (Basic Computer Science) programming language implemented using Flex and Bison.

## Overview

This project implements a compiler frontend for a simple imperative programming language called BCS. The language supports basic programming constructs including variable declarations, arithmetic expressions, conditional statements, and loops.

## Language Features

### Data Types
- `int` - Integer type
- `bool` - Boolean type

### Language Constructs
- **Variable Declarations**: `int var_name;` or `bool var_name;`
- **Assignment Statements**: `variable = expression;`
- **Conditional Statements**: `if (condition) { statements } else { statements }`
- **Loop Statements**: `while (condition) { statements }`
- **Arithmetic Expressions**: Addition (`+`), multiplication (`*`)
- **Relational Operators**: `<`, `>`, `<=`, `>=`, `==`, `!=`

### Program Structure
```
BcsMain
{
    // Variable declarations
    int var1; int var2;
    
    // Statements
    var1 = 10;
    while (var1 > 0) {
        var1 = var1 - 1
    }
}
```

## File Structure

- `CS02_3_bcs.l` - Flex lexical analyzer specification
- `CS02_3_bcs.y` - Bison parser grammar specification
- `CS02_3_valid.bcs` - Sample valid BCS program
- `CS02_3_invalid.bcs` - Sample invalid BCS program for testing
- `makefile` - Build configuration

## Building the Project

### Prerequisites
- GCC compiler
- Flex (lexical analyzer generator)
- Bison (parser generator)
- Make utility

### Build Commands
```bash
make
```

This will:
1. Generate parser from grammar using `bison -d CS02_3_bcs.y`
2. Generate lexer from specification using `flex CS02_3_bcs.l`
3. Compile the parser using `gcc -o parser CS02_3_bcs.tab.c lex.yy.c -lfl`

## Usage

To parse a BCS program file:
```bash
./parser <input-file>
```

Example:
```bash
./parser CS02_3_valid.bcs
```

### Output
- **Success**: "Parsing Successful" (exit code 0)
- **Error**: "Syntax Error" (exit code 1)

## Sample Programs

### Valid Program (`CS02_3_valid.bcs`):
```
BcsMain
{
    int sum; int i; int n;
    n=10;
    i=1; sum=0;
    while(i<n)
    {
        sum=sum+i; 
        i=i+1
    }
}
```

### Testing
```bash
# Test with valid program
./parser CS02_3_valid.bcs

# Test with invalid program
./parser CS02_3_invalid.bcs
```

## Grammar Rules

### Lexical Tokens
- **Keywords**: `BcsMain`, `if`, `else`, `while`, `int`, `bool`
- **Identifiers**: Letter followed by letters/digits
- **Numbers**: Sequence of digits
- **Operators**: `+`, `*`, `=`, `<`, `>`, `<=`, `>=`, `==`, `!=`
- **Delimiters**: `{`, `}`, `(`, `)`, `;`

### Grammar Production Rules
```
program     → BCSMAIN '{' declist stmtlist '}'
declist     → declist decl | decl
decl        → type ID ';'
type        → INT | BOOL
stmtlist    → stmtlist ';' stmt | stmt
stmt        → ID '=' aexpr
            | IF '(' expr ')' '{' stmtlist '}' ELSE '{' stmtlist '}'
            | WHILE '(' expr ')' '{' stmtlist '}'
expr        → aexpr relop aexpr | aexpr
relop       → LT | GT | LE | GE | EQ | NE
aexpr       → aexpr '+' aexpr | term
term        → term '*' factor | factor
factor      → ID | NUM
```

## Clean Up

To remove generated files:
```bash
make clean
```

## Known Issues

- The parser may report shift/reduce conflicts (1 conflict is expected)
- Some compiler warnings about implicit function declarations are normal for Flex/Bison generated code

## Development Notes

- The lexer is case-sensitive
- Whitespace and comments are ignored
- Line numbers are tracked for error reporting
- The parser uses LALR(1) parsing algorithm provided by Bison

## License

This project is for educational purposes as part of BCS coursework.