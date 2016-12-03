// My implementation of Lab08.

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
#include "tree.h"
#include "tables.h"

int yylex(void);
void yyerror(char const *s);

LitTable *lt;
SymTable *st;

extern int yylineno;
extern char *yytext;
//Tree *tree;
%}

//%define api.value.type {Tree*} // Type of variable yylval;

%token IF THEN ELSE END REPEAT UNTIL READ WRITE
%token SEMI LPAREN RPAREN
%token ASSIGN
%token INT PUTS STRING

%token NUM
%token ID

%left LT EQ
// Precedence of operators (* and / have higher precedence).
// All four operators are left associative.
%left PLUS MINUS
%left TIMES OVER

// Start symbol for the grammar.
%start program

%%

program:
  stmt_sequence        // { tree = new_subtree("program", 1, $1); }
;

stmt_sequence:
  stmt_sequence stmt    //{ $$ = new_subtree("stmt_sequence", 2, $1, $2); }
| stmt                 // { $$ = new_subtree("stmt_sequence", 1, $1); }
;

stmt:
  if_stmt       //{ $$ = new_subtree("stmt", 1, $1); }
| repeat_stmt   //{ $$ = new_subtree("stmt", 1, $1); }
| assign_stmt   //{ $$ = new_subtree("stmt", 1, $1); }
| read_stmt     //{ $$ = new_subtree("stmt", 1, $1); }
| write_stmt    //{ $$ = new_subtree("stmt", 1, $1); }
| vardecl		//{ $$ = new_subtree("stmt", 1, $1); }
| putsstmt		//{ $$ = new_subtree("stmt", 1, $1); }
;



vardecl:
  INT ID {	int i; if((i = lookup_var(st,yytext)) == -1) add_var(st,yytext,yylineno); else printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d",yylineno,yytext,i); } SEMI	//{ $$ = new_subtree("vardecl", 3, $1, $2, $3); }

putsstmt:
  PUTS STRING SEMI	{ /*$$ = new_subtree("putsstmt", 2, $1, $2);*/ printf("PUTS: %s\n",get_literal(lt,$2)); }

if_stmt:
  IF expr THEN stmt_sequence END                    //{ $$ = new_subtree("if_stmt", 5, $1, $2, $3, $4, $5); }
| IF expr THEN stmt_sequence ELSE stmt_sequence END //{ $$ = new_subtree("if_stmt", 7, $1, $2, $3, $4, $5, $6, $7); }
;

repeat_stmt:
  REPEAT stmt_sequence UNTIL expr   //{ $$ = new_subtree("repeat_stmt", 4, $1, $2, $3, $4); }
;

assign_stmt:
  ID { if(lookup_var(st,yytext) == -1) { printf("SEMANTIC ERROR (%d): variable '%s' was not declared\n",yylineno,yytext); exit(0); } } ASSIGN expr SEMI   //{ $$ = new_subtree("assign_stmt", 4, $1, $2, $3, $4); }
;

read_stmt:
  READ ID { if(lookup_var(st,yytext) == -1) { printf("SEMANTIC ERROR (%d): variable '%s' was not declared\n",yylineno,yytext); exit(0); } } SEMI          //{ $$ = new_subtree("read_stmt", 3, $1, $2, $3); }
;

write_stmt:
  WRITE expr SEMI       //{ $$ = new_subtree("write_stmt", 3, $1, $2, $3); }
;

expr:
  expr LT expr         // { $$ = new_subtree("expr", 3, $1, $2, $3); }
| expr EQ expr          //{ $$ = new_subtree("expr", 3, $1, $2, $3); }
| expr PLUS expr        //{ $$ = new_subtree("expr", 3, $1, $2, $3); }
| expr MINUS expr       //{ $$ = new_subtree("expr", 3, $1, $2, $3); }
| expr TIMES expr       //{ $$ = new_subtree("expr", 3, $1, $2, $3); }
| expr OVER expr        //{ $$ = new_subtree("expr", 3, $1, $2, $3); }
| LPAREN expr RPAREN    //{ $$ = new_subtree("expr", 3, $1, $2, $3); }
| NUM                   //{ $$ = new_subtree("expr", 1, $1); }
| ID                    { if(lookup_var(st,yytext) == -1) { printf("SEMANTIC ERROR (%d): variable '%s' was not declared\n",yylineno,yytext); exit(0); } } //{ $$ = new_subtree("expr", 1, $1); }
;


%%

// Error handling.
void yyerror (char const *s) {
    printf("PARSE ERROR (%d): %s\n", yylineno, s);
}

// Main.
int main() {
    yydebug = 0; // Toggle this variable to enter debug mode.

	lt = create_lit_table();
	st = create_sym_table();

    if (yyparse() == 0) {
        //printf("Parse tree of given expression:\n");
        //print_tree(tree);
        //print_dot(tree);
        //free_tree(tree);
    }

    return 0;
}
