%{
    #include "CS02_3_bcs.tab.h"
    #include <string.h>

    int lineno =1;
%}

letter          [a-zA-Z]
digit           [0-9]
id              {letter}({letter}|{digit})*
num             {digit}+
relop           "<|>|<=|>=|==|!="

%%

"BcsMain"        { return BCSMAIN; }
"if"             { return IF; } 
"else"           { return ELSE; }
"while"          { return WHILE; }
"int"            { return INT; }
"bool"           { return BOOL; }

"<="             { return LE; }
">="             { return GE; }
"=="             { return EQ; }
"!="             { return NE; }
"<"              { return LT; }
">"              { return GT; }

{num}            { yylval.num = atoi(yytext); return NUM; }
{id}             { yylval.str = strdup(yytext); return ID; }

[ \t\r]+         {            }
"\n"             { lineno++; }

.                { return *yytext; }

%%

int yywrap(void) {
    return 1;
}