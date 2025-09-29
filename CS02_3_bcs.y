%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    extern FILE *yyin;
    void yyerror(const char *s);
%}

%union {
    int num;
    char *str;
}

%token <str> ID
%token <num> NUM
%token BCSMAIN IF ELSE WHILE INT BOOL
%token LE GE EQ NE LT GT


%% 

program:
    BCSMAIN '{' declist stmtlist '}' {
        printf("Parsing Successful\n");
        exit(0);
    }
;

declist:
    declist decl 
    | decl
;

decl: 
    type ID ';'
;

type:
    INT
    | BOOL
;

stmtlist:
    stmtlist ';' stmt
    | stmt
;

stmt:
    ID '=' aexpr
    | IF '(' expr ')' '{' stmtlist '}' ELSE '{' stmtlist '}'
    | WHILE '(' expr ')' '{' stmtlist '}'
;

expr:
    aexpr relop aexpr 
    | aexpr
;

relop:
    LT | GT | LE | GE | EQ | NE
;

aexpr:
    aexpr '+' aexpr 
    | term
;

term:
    term '*' factor
    | factor
;

factor:
    ID
    | NUM
;

%%

void yyerror(const char *s) {
    printf("Syntax Error\n");
    exit(1);
}

int main(int argc, char **argv){
    if(argc < 2) {
        fprintf(stderr, "Usage: %s <input-file>\n",argv[0]);
        return 2;
    }
    FILE *f = fopen(argv[1],"r");
    if(!f){
        perror("fopen");
        return 2;
    }
    yyin = f;
    yyparse();
    printf("Syntax Error\n");
    return 1;
}