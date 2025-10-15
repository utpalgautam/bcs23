%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    extern FILE *yyin;
    void yyerror(const char *s);

    FILE *output_file;
    int temp_count=0;

    char* new_temp() {
        char *temp = (char *)malloc(10);
        sprintf(temp, "t%d", temp_count++);
        return temp;
    }

    void emit(const char *res,const char *arg1, const char *op, const char *arg2) {
        if(op != NULL)
            fprintf(output_file, "%s = %s %s %s\n", res, arg1, op, arg2);
        else
            fprintf(output_file, "%s = %s\n", res, arg1);
    }
%}

%union {
    int num;
    char *str;
}

%token <str> ID
%token <num> NUM
%token BCSMAIN IF ELSE WHILE INT BOOL
%token LE GE EQ NE LT GT

%type <str> aexpr term factor

%% 

program:
    BCSMAIN '{' declist stmtlist '}' {
        printf("Parsing Successful\n");
        printf("3-address code written to output.txt\n");
        fclose(output_file);
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
    ID '=' aexpr {
        emit($1, $3, NULL, NULL);
    }
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
    aexpr '+' aexpr {
        $$ = new_temp();
        emit($$, $1, "+", $3);
    }
    | term {
        $$ = $1;
    }
;

term:
    term '*' factor {
        $$ = new_temp();
        emit($$, $1, "*", $3);
    }
    | factor {
        $$ = $1;
    }
;

factor:
    ID {
        $$ = strdup($1);
    }
    | NUM {
        $$ = (char*)malloc(20);
        sprintf($$, "%d", $1);
    }
;

%%

void yyerror(const char *s) {
    printf("Syntax Error\n");
    if(output_file) fclose(output_file);
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
    output_file = fopen("output.txt", "w");
    if(!output_file){
        perror("Failed to create output files");
        fclose(f);
        return 2;
    }
    yyin = f;
    yyparse();
    printf("Syntax Error\n");
    fclose(output_file);
    return 1;
}