%option outfile="scanner.c"
%option noyywrap
%option nounput
%option noinput
%{
#include "parser.h"
%}
%%
[0-9]+  { yylval = atoi(yytext); return NUMBER; }
"/"     { return SLASH; }
"+"     { return PLUS;  }
"-"     { return MINUS; }
"*"     { return TIMES; }
"("     { return ABRP;  }
")"     { return FECP;  }
"\n"    { return ENTER; }
" "     ; // skip blanks
.       { return yytext[0]; }
