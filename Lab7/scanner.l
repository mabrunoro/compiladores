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
NUMBER     [0-9]+
ID      [a-zA-Z]+
ENTER   ("\n")
%%
"/*"    BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             yylineno++;
<comment>"*"+"/"        BEGIN(INITIAL);
{SEMI}    { printf("SEMI: %s\n",yytext); return SEMI; }
{IF}      { printf("IF: %s\n",yytext); return IF; }
{THEN}    { printf("THEN: %s\n",yytext); return THEN; }
{ELSE}    { printf("ELSE: %s\n",yytext); return ELSE; }
{END}     { printf("END: %s\n",yytext); return END; }
{REPEAT}  { printf("REPEAT: %s\n",yytext); return REPEAT; }
{UNTIL}   { printf("UNTIL: %s\n",yytext); return UNTIL; }
{READ}    { printf("READ: %s\n",yytext); return READ; }
{WRITE}   { printf("WRITE: %s\n",yytext); return WRITE; }
{PLUS}    { printf("PLUS: %s\n",yytext); return PLUS; }
{MINUS}   { printf("MINUS: %s\n",yytext); return MINUS; }
{TIMES}   { printf("TIMES: %s\n",yytext); return TIMES; }
{OVER}    { printf("OVER: %s\n",yytext); return OVER; }
{EQ}      { printf("EQ: %s\n",yytext); return EQ; }
{LT}      { printf("LT: %s\n",yytext); return LT; }
{OP}      { printf("OP: %s\n",yytext); return OP; }
{CP}      { printf("CP: %s\n",yytext); return CP; }
{ASSIGN}  { printf("ASSIGN: %s\n",yytext); return ASSIGN; }
{NUMBER}  { printf("NUMBER: %s\n",yytext); return NUMBER; }
{ID}      { printf("ID: %s\n",yytext); return ID; }
{ENTER}   { yylineno++;}
[ \t]     ;
.		  { printf("Desconhecido: %s\n",yytext); return yytext[0]; }
