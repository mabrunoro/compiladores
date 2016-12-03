
/* Options to bison */
// File name of generated parser.
%output "parser.c"
// Produces a 'parser.h'
%defines "parser.h"
// Give proper error messages when a syntax error is found.
%define parse.error verbose
// Enable LAC (lookahead correction) to improve syntax error handling.
%define parse.lac full

%{
#include <stdio.h>

int yylex(void);
void yyerror(char const *s);
%}

%token NUMBER
// Tell bison the lexemes for these token types so we can use
// them in the grammar rules.
%token IF "if"
%token ELSE "else"
%token OTHER "other"
%token ABRP "("
%token FECP ")"
%token ENTER "\n"

%%

exprs:
  %empty
| exprs expr "\n"
;

expr:
  expr op expr
| NUMBER op NUMBER
| NUMBER
| ABRP expr FECP
;

%%

int main(void) {
  int result = yyparse();
  if (result == 0) printf("Parse successful!\n");
  else printf("Parse failed...\n");
}