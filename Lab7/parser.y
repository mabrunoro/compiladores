
/* Options to bison */
// File name of generated parser.
%output "parser.c"
// Produces a 'parser.h'
%defines "parser.h"
// Give proper error messages when a syntax error is found.
%define parse.error verbose
// Enable LAC (lookahead correction) to improve syntax error handling.
%define parse.lac full

// Enable the trace option so that debugging is possible.
%define parse.trace

%{
#include <stdio.h>

int yylex(void);
void yyerror(char const *s);
%}

%token IF
%token THEN
%token ELSE
%token END
%token REPEAT
%token UNTIL
%token READ
%token WRITE
%token PLUS
%token MINUS
%token TIMES
%token OVER
%token EQ
%token LT
%token OP
%token CP
%token SEMI
%token ASSIGN
%token NUMBER
%token ID
%left LT EQ
%left PLUS MINUS
%left TIMES OVER

%%

program:
  stmtsequence
;

stmtsequence:
  stmtsequence stmt
| stmt
;

stmt:
  ifstmt
| repeatstmt
| assignstmt
| readstmt
| writestmt
;

ifstmt:
  IF expr THEN stmtsequence END
| IF expr THEN stmtsequence ELSE stmtsequence END
;

repeatstmt: REPEAT stmtsequence UNTIL expr ;

assignstmt: ID ASSIGN expr SEMI ;

readstmt: READ ID SEMI ;

writestmt: WRITE expr SEMI ;

expr:
  expr LT expr
| expr EQ expr
| expr PLUS expr
| expr MINUS expr
| expr TIMES expr
| expr OVER expr
| OP expr CP
| NUMBER
| ID
;

%%

int main() {
  yydebug = 1; // Enter debug mode.
  yyparse();
  return 0;
}
