%option outfile="scanner.c"
%option noyywrap
%option nounput
%option noinput

%{
#include "bt.h"
#include "parser.h"
%}%x      comment
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
{SEMI}    { yylval = new_leaf(SEMI_NODE, 0); return SEMI; }
{IF}      { yylval = new_leaf(IF_NODE, 0); return IF; }
{THEN}    { yylval = new_leaf(THEN_NODE, 0); return THEN; }
{ELSE}    { yylval = new_leaf(ELSE_NODE, 0); return ELSE; }
{END}     { yylval = new_leaf(END_NODE, 0); return END; }
{REPEAT}  { yylval = new_leaf(REPEAT_NODE, 0); return REPEAT; }
{UNTIL}   { yylval = new_leaf(UNTIL_NODE, 0); return UNTIL; }
{READ}    { yylval = new_leaf(READ_NODE, 0); return READ; }
{WRITE}   { yylval = new_leaf(WRITE_NODE, 0); return WRITE; }
{PLUS}    { yylval = new_leaf(PLUS_NODE, 0); return PLUS; }
{MINUS}   { yylval = new_leaf(MINUS_NODE, 0); return MINUS; }
{TIMES}   { yylval = new_leaf(TIMES_NODE, 0); return TIMES; }
{OVER}    { yylval = new_leaf(OVER_NODE, 0); return OVER; }
{EQ}      { yylval = new_leaf(EQ_NODE, 0); return EQ; }
{LT}      { yylval = new_leaf(LT_NODE, 0); return LT; }
{OP}      { yylval = new_leaf(OP_NODE, 0); return OP; }
{CP}      { yylval = new_leaf(CP_NODE, 0); return CP; }
{ASSIGN}  { yylval = new_leaf(ASSIGN_NODE, 0); return ASSIGN; }
{NUM}     { yylval = new_leaf(NUMBER_NODE, atoi(yytext)); return NUMBER; }
{ID}      { yylval = new_leaf(ID_NODE, 0); return ID; }
{ENTER}   { yylineno++;}
" "       ; // skip blanks
.|\n	  { return yytext[0]; }
