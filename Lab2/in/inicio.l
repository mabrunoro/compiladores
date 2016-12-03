%{/* Reconhece numeros naturais arbitrarios. */
#include <stdio.h>
void func();
void ferro();
%}
%x      comment
IF      (if)
THEN    (then)
ELSE    (else)
END     (end)
REPEAT  (repeat)
UNTIL   (until)
READ    (read)
WRITE   (write)
PLUS    ("+")
MINUS   ("-")
TIMES   ("*")
OVER    ("/")
EQ      ("=")
LT      ("<")
OP      ("(")
CP      (")")
SEMI    (";")
ASSIGN  (":=")
NUM     [0-9]+
ID      [a-zA-Z]+
cr      ("\n")
%%
"{"					BEGIN(comment);
<comment>[^}\n]*	/* eat up '*'s not followed by '/'s */
<comment>\n			yylineno++;
<comment>"}"		BEGIN(INITIAL);

{SEMI}		func("SEMI");
{IF}		func("IF");
{THEN}		func("THEN");
{ELSE}		func("ELSE");
{END}		func("END");
{REPEAT}	func("REPEAT");
{UNTIL}		func("UNTIL");
{READ}		func("READ");
{WRITE}		func("WRITE");
{PLUS}		func("PLUS");
{MINUS}		func("MINUS");
{TIMES}		func("TIMES");
{OVER}		func("OVER");
{EQ}		func("EQ");
{LT}		func("LT");
{OP}		func("OP");
{CP}		func("CP");
{ASSIGN}	func("ASSIGN");
{NUM}		func("NUM");
{ID}		func("ID");
[ \t]		;
{cr}		{yylineno++;}
.			{ ferro(); }
%%
int main() { yylex(); return 0; }
/* Definindo esta funcao nao precisa compilar com -lfl */
int yywrap() { return 1; }
void func(char* st) { printf("%d: %s -> %s\n",yylineno,yytext,st);}
void ferro() { printf("%d: %s -> %s\n", yylineno, yytext, "UNKNOWN");}
