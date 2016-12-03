%option outfile="scanner.c"
%option noyywrap
%option nounput
%option noinput

%{/* Reconhece numeros naturais arbitrarios. */
#include <stdio.h>
#include "token.h"
void func();
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
ENTER   ("\n")
%%
"/*"    BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             yylineno++;
<comment>"*"+"/"        BEGIN(INITIAL);
{SEMI}    { printf("SEMI: %s\n",yytext); }
{IF}      { printf("IF: %s\n",yytext); }
{THEN}    { printf("THEN: %s\n",yytext); }
{ELSE}    { printf("ELSE: %s\n",yytext); }
{END}     { printf("END: %s\n",yytext); }
{REPEAT}  { printf("REPEAT: %s\n",yytext); }
{UNTIL}   { printf("UNTIL: %s\n",yytext); }
{READ}    { printf("READ: %s\n",yytext); }
{WRITE}   { printf("WRITE: %s\n",yytext); }
{PLUS}    { printf("PLUS: %s\n",yytext); }
{MINUS}   { printf("MINUS: %s\n",yytext); }
{TIMES}   { printf("TIMES: %s\n",yytext); }
{OVER}    { printf("OVER: %s\n",yytext); }
{EQ}      { printf("EQ: %s\n",yytext); }
{LT}      { printf("LT: %s\n",yytext); }
{OP}      { printf("OP: %s\n",yytext); }
{CP}      { printf("CP: %s\n",yytext); }
{ASSIGN}  { printf("ASSIGN: %s\n",yytext); }
{NUM}     { printf("NUM: %s\n",yytext); }
{ID}      { printf("ID: %s\n",yytext); }
{ENTER}   { yylineno++;}
[ \t]     ;
.		  { printf("%s\n",yytext); }
<<EOF>>		{return 0;}

%%

int main()
{
	yylex();
	return 0;
}

