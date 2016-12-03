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
#include "tables.h"

int yylex(void);
void yyerror(char const *s);
int checktable(char const *s, int *o);
int unifyplus(int i,int j);
int unifyminus(int i,int j);
int unifytimes(int i,int j);
int unifyover(int i,int j);

LitTable *lt;
SymTable *stint, *stbool, *ststr, *streal;

enum {INTTYPE, REALTYPE, STRTYPE, BOOLTYPE};

extern int yylineno;
extern char *yytext;
//Tree *tree;
%}

//%define api.value.type {Tree*} // Type of variable yylval;

%token SEMI LPAREN RPAREN COMMA
%token INT REAL BOOL STR TRUE FALSE
%token ASSIGN PRINT STRING

%left DEC NUM
%token ID

%left LT GT EQ
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
  assign_stmt
| vardecl
| printstmt
;

vardecl:
  INT ID { int i; if((i = checktable(yytext,NULL)) == -1) add_var(stint,yytext,yylineno); else printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d",yylineno,yytext,i); } varlstint SEMI
| REAL ID { int i; if((i = checktable(yytext,NULL)) == -1) add_var(streal,yytext,yylineno); else printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d",yylineno,yytext,i); } varlstreal SEMI
| BOOL ID { int i; if((i = checktable(yytext,NULL)) == -1) add_var(stbool,yytext,yylineno); else printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d",yylineno,yytext,i); } varlstbool SEMI
| STR ID { int i; if((i = checktable(yytext,NULL)) == -1) add_var(ststr,yytext,yylineno); else printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d",yylineno,yytext,i); } varlststr SEMI
;

varlstint:
| COMMA ID { int i; if((i = checktable(yytext,NULL)) == -1) add_var(stint,yytext,yylineno); else printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d",yylineno,yytext,i); } varlstint
;

varlstreal:
| COMMA ID { int i; if((i = checktable(yytext,NULL)) == -1) add_var(streal,yytext,yylineno); else printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d",yylineno,yytext,i); } varlstreal
;

varlstbool:
| COMMA ID { int i; if((i = checktable(yytext,NULL)) == -1) add_var(stbool,yytext,yylineno); else printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d",yylineno,yytext,i); } varlstbool
;

varlststr:
| COMMA ID { int i; if((i = checktable(yytext,NULL)) == -1) add_var(ststr,yytext,yylineno); else printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d",yylineno,yytext,i); } varlststr
;

printstmt:
  PRINT ID { if(checktable(yytext,NULL) == -1) { printf("SEMANTIC ERROR (%d): variable '%s' was not declared\n",yylineno,yytext); exit(0); } else { printf("PRINT: %s\n",/*get_literal(lt,$2)*/yytext); } } SEMI
;

assign_stmt:
  ID { if(checktable(yytext,NULL) == -1) { printf("SEMANTIC ERROR (%d): variable '%s' was not declared\n",yylineno,yytext); exit(0); } } ASSIGN expr SEMI
;

expr:
  expr LT expr			{ $$ = BOOLTYPE; }
| expr GT expr			{ $$ = BOOLTYPE; }
| expr EQ expr			{ $$ = BOOLTYPE; }
| expr PLUS expr		{ $$ = unifyplus($1,$3); }
| expr MINUS expr		{ $$ = unifyminus($1,$3); }
| expr TIMES expr		{ $$ = unifytimes($1,$3); }
| expr OVER expr		{ $$ = unifyover($1,$3); }
| LPAREN expr RPAREN	{ $$ = $2; }
| STRING				{ $$ = STRTYPE; }
| TRUE					{ $$ = BOOLTYPE; yylval = 1; }
| FALSE					{ $$ = BOOLTYPE; yylval = 0; }
| NUM					{ $$ = INTTYPE; }
| DEC					{ $$ = REALTYPE; }
| ID                    { int i;// int tipo;
						  if((i = checktable(yytext,&$$)) == -1) { printf("SEMANTIC ERROR (%d): variable '%s' was not declared\n",yylineno,yytext); exit(0); }					  /*else { $$ = yylval; }*/ }
;


%%

// Error handling.
void yyerror (char const *s) {
    printf("PARSE ERROR (%d): %s\n", yylineno, s);
}

int checktable(const char *s, int *o)
{
	int i;
	i = lookup_var(stint,s);
	if(i > -1)
	{
		if( o != NULL)
			*o = INTTYPE;
		return i;
	}
	i = lookup_var(ststr,s);
	if(i > -1)
	{
		if( o != NULL)
			*o = STRTYPE;
		return i;
	}
	i = lookup_var(stbool,s);
	if(i > -1)
	{
		if( o != NULL)
			*o = BOOLTYPE;
		return i;
	}
	i = lookup_var(streal,s);
	if(i > -1)
	{
		if( o != NULL)
			*o = REALTYPE;
		return i;
	}
	if( o != NULL)
		*o = -1;
	return -1;
}

int unifyplus(int i,int j)
{
	if((i == STRTYPE) || (j == STRTYPE))
		return STRTYPE;
	if((i == REALTYPE) || (j == REALTYPE))
		return REALTYPE;
	if((i == BOOLTYPE) && (j == BOOLTYPE))
		return BOOLTYPE;
	return INTTYPE;
}

int unifyminus(int i,int j)
int unifytimes(int i,int j)
int unifyover(int i,int j)

// Main.
int main() {
    yydebug = 0; // Toggle this variable to enter debug mode.

	lt = create_lit_table();
	stint = create_sym_table();
	stbool = create_sym_table();
	streal = create_sym_table();
	ststr = create_sym_table();

    if (yyparse() == 0) {
        //printf("Parse tree of given expression:\n");
        //print_tree(tree);
        //print_dot(tree);
        //free_tree(tree);
    }

    return 0;
}
