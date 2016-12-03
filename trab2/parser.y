
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
#include <stdlib.h>

int yylex(void);
void yyerror(char const *s);
int extern yylineno;
%}

%token INT
%token VOID
%token IF
%token ELSE
%token INPUT
%token OUTPUT
%token RETURN
%token WHILE
%token WRITE
%token PLUS
%token MINUS
%token TIMES
%token OVER
%token LT
%token LE
%token GT
%token GE
%token EQ
%token NEQ
%token ASSIGN
%token SEMI
%token COMMA
%token LPAREN
%token RPAREN
%token LBRACK
%token RBRACK
%token LBRACE
%token RBRACE
%token NUM
%token ID
%token STRING
%left LT EQ
%left PLUS MINUS
%left TIMES OVER

%%

program:
  funcdecllist
;

funcdecllist:
  funcdecllist funcdecl
| funcdecl
;

funcdecl:
  funcheader funcbody
;

funcheader:
  rettype ID LPAREN params RPAREN
;

funcbody:
  LBRACE optvardecl optstmtlist RBRACE
;

optvardecl:
| vardecllist
;

optstmtlist:
| stmtlist
;

rettype:
  INT
| VOID
;

params:
  VOID
| paramlist
;

paramlist:
  paramlist COMMA param
| param
;

param:
  INT ID
| INT ID LBRACK RBRACK
;

vardecllist:
  vardecllist vardecl
| vardecl
;

vardecl:
  INT ID SEMI
| INT ID LBRACK NUM RBRACK SEMI
;

stmtlist:
  stmtlist stmt
| stmt
;

stmt:
  assignstmt
| ifstmt
| whilestmt
| returnstmt
| funccall SEMI
;

assignstmt:
  lval ASSIGN arithexpr SEMI
;

lval:
  ID
| ID LBRACK NUM RBRACK
| ID LBRACK ID RBRACK
;

ifstmt:
  IF LPAREN boolexpr RPAREN block
| IF LPAREN boolexpr RPAREN block ELSE block
;

block:
  LBRACE optstmtlist RBRACE
;

whilestmt:
  WHILE LPAREN boolexpr RPAREN block
;

returnstmt:
  RETURN SEMI
| RETURN arithexpr SEMI
;

funccall:
  outputcall
| writecall
| userfunccall
;

inputcall:
  INPUT LPAREN RPAREN
;

outputcall:
  OUTPUT LPAREN arithexpr RPAREN
;

writecall:
  WRITE LPAREN STRING RPAREN
;

userfunccall:
  ID LPAREN optarglist RPAREN
;

optarglist:
| arglist
;

arglist:
  arglist COMMA arithexpr
| arithexpr
;

boolexpr:
  arithexpr boolop arithexpr
;

boolop:
  LT
| LE
| GT
| GE
| EQ
| NEQ
;

arithexpr:
  arithexpr PLUS arithexpr
| arithexpr MINUS arithexpr
| arithexpr TIMES arithexpr
| arithexpr OVER arithexpr
| LPAREN arithexpr RPAREN
| lval
| inputcall
| userfunccall
| NUM
;

%%

int main() {
 	yydebug = 0; // Enter debug mode.
 	yyparse();
	printf("PARSE SUCESSFUL!\n");
 	return 0;
}

void yyerror(char const *s)
{
	printf("PARSE ERROR (%d): %s\n",yylineno,s);
	exit(0);
}
