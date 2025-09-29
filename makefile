all: parser

CS02_3_bcs.tab.c  CS02_3_bcs.tab.h: CS02_3_bcs.y
	bison -d CS02_3_bcs.y

lex.yy.c: CS02_3_bcs.l CS02_3_bcs.tab.h
	flex CS02_3_bcs.l

parser: CS02_3_bcs.tab.c lex.yy.c
	gcc -o parser CS02_3_bcs.tab.c lex.yy.c -lfl

clean:
	rm -f parser CS02_3_bcs.tab.c CS02_3_bcs.tab.h lex.yy.c

.PHONY: all clean