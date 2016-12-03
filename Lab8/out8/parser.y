
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
#include "bt.h"

int yylex(void);
void yyerror(char const *s);

BT *tree;
%}

%define api.value.type {BT*} // Type of variable yylval;

%token NUMBER
%token IF
%token THEN
%token ELSE
%token END
%token REPEAT
%token UNTIL
%token READ
%token WRITE
%token OP
%token CP
%token SEMI
%token ASSIGN
%token ID
%left LT EQ
%left PLUS MINUS
%left TIMES OVER

%%

program: stmtsequence ;

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
| NUM
| ID
;

expr:
  NUMBER        { $$ = $1; }
| expr LT expr { $$ = new_node(PLUS_NODE, $1, $3); }
| expr EQ expr { $$ = new_node(MINUS_NODE, $1, $3); }
| expr PLUS expr { $$ = new_node(TIMES_NODE, $1, $3); }
| expr MINUS expr { $$ = new_node(OVER_NODE, $1, $3); }
;

%%

int main() {
    yydebug = 0; // Toggle this variable to enter debug mode.

    if (yyparse() == 0) {
        //printf("AST of given expression:\n");
        //print_tree(tree);
        print_dot(tree);
        free_tree(tree);
    }

    return 0;
}
