%option outfile="scanner.c"
%option noyywrap
%option nounput
%option noinput

%{/* Reconhece numeros naturais arbitrarios. */
#include <stdio.h>
#include "token.h"
void func();
extern int lval;
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
"/*"    BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             yylineno++;
<comment>"*"+"/"        BEGIN(INITIAL);
{SEMI}    { return SEMI; }
{IF}      { return IF; }
{THEN}    { return THEN; }
{ELSE}    { return ELSE; }
{END}     { return END; }
{REPEAT}  { return REPEAT; }
{UNTIL}   { return UNTIL; }
{READ}    { return READ; }
{WRITE}   { return WRITE; }
{PLUS}    { return PLUS; }
{MINUS}   { return MINUS; }
{TIMES}   { return TIMES; }
{OVER}    { return OVER; }
{EQ}      { return EQ; }
{LT}      { return LT; }
{OP}      { return OP; }
{CP}      { return CP; }
{ASSIGN}  { return ASSIGN; }
{NUM}     { lval = atoi(yytext); return NUM; }
{ID}      { return ID; }
{cr}      { return ENTER; /*yylineno++;*/}
[ \t]     ;
.		  { return yytext[0]; }
