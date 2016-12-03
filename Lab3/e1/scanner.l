%option outfile="scanner.c"
%option noyywrap
%option nounput
%option noinput
%{
#include "parser.h"
%}
%%
"("     { return ABRP; }
")"     { return FECP; }
"\n"    { return ENTER; }
" "     ; // skip blanks
.       { return yytext[0]; }
