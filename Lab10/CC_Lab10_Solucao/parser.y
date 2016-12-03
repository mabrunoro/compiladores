// My implementation of Lab10.

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

%code requires{
#include "tables.h"
}

%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.h"

int yylex(void);
void yyerror(char const *s);

int check_var(int i);
void new_var(int i);

Type unify_plus(Type t1, Type t2);
Type unify_other_arith(Type t1, Type t2);
Type unify_comp(Type t1, Type t2);
void check_assign(Type l, Type r);

extern int yylineno;

LitTable *lt;
SymTable *st;

Type last_type;
%}

%union {
    int   aint;
    float afloat;
    Type  atype;
}

%token <aint> INT REAL STRING BOOL
%token <aint> TRUE FALSE
%token <aint> PRINT
%token <aint> LPAREN RPAREN SEMI COMMA
%token <aint> ASSIGN

%token <aint> INT_VAL
%token <afloat> REAL_VAL
%token <aint> STR_VAL
%token <aint> ID

%left <aint> LT LE GT GE EQ NEQ
%left <aint> PLUS MINUS
%left <aint> TIMES OVER

%type <atype> expr

%start program

%%

program:
  stmt_sequence
;

stmt_sequence:
  stmt_sequence stmt
| stmt
;

stmt:
  var_decl
| assign_stmt
| print_stmt
;

var_decl:
  type_decl var_list SEMI
;

type_decl:
  INT       { last_type = INT_TYPE; }
| REAL      { last_type = REAL_TYPE; }
| STRING    { last_type = STR_TYPE; }
| BOOL      { last_type = BOOL_TYPE; }
;

var_list:
  var_list COMMA ID { new_var($3); }
| ID                { new_var($1); }
;

assign_stmt:
  ID ASSIGN expr SEMI   { check_assign(get_type(st, check_var($1)), $3); }
;

print_stmt:
  PRINT expr SEMI
;

expr:
  expr LT expr          { $$ = unify_comp($1, $3); }
| expr LE expr          { $$ = unify_comp($1, $3); }
| expr GT expr          { $$ = unify_comp($1, $3); }
| expr GE expr          { $$ = unify_comp($1, $3); }
| expr EQ expr          { $$ = unify_comp($1, $3); }
| expr NEQ expr         { $$ = unify_comp($1, $3); }
| expr PLUS expr        { $$ = unify_plus($1, $3); }
| expr MINUS expr       { $$ = unify_other_arith($1, $3); }
| expr TIMES expr       { $$ = unify_other_arith($1, $3); }
| expr OVER expr        { $$ = unify_other_arith($1, $3); }
| LPAREN expr RPAREN    { $$ = $2; }
| TRUE                  { $$ = BOOL_TYPE; }
| FALSE                 { $$ = BOOL_TYPE; }
| INT_VAL               { $$ = INT_TYPE; }
| REAL_VAL              { $$ = REAL_TYPE; }
| STR_VAL               { $$ = STR_TYPE; }
| ID                    { $$ = get_type(st, check_var($1)); }
;

%%

// Checking variable declaration and usage.

int check_var(int i) {
    char* name = get_name(st, i);
    int line = get_line(st, i);
    int idx = lookup_var(st, name);
    if (idx == i) {
        printf("SEMANTIC ERROR (%d): variable '%s' was not declared.\n", line, name);
        exit(1);
    }
    // Variable was properly declared, so we have an spurious entry at the end.
    remove_last(st);
    return idx;
}

void new_var(int i) {
    char* name = get_name(st, i);
    int line = get_line(st, i);
    int idx = lookup_var(st, name);

    if (idx != i) {
        printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d.\n",
            line, name, get_line(st, idx));
        exit(1);
    }

    // Variable is new, set its type.
    set_type(st, i, last_type);
}

void type_error(Type t1, Type t2) {
    printf("SEMANTIC ERROR (%d): incompatible types '%s' and '%s' used.\n",
           yylineno, get_text(t1), get_text(t2));
    exit(1);
}

// Type checking.

Type unify_plus(Type t1, Type t2) {
    if (t1 == STR_TYPE || t2 == STR_TYPE) return STR_TYPE;
    if (t1 == REAL_TYPE || t2 == REAL_TYPE) return REAL_TYPE;
    if (t1 == BOOL_TYPE && t2 == BOOL_TYPE) return BOOL_TYPE;
    return INT_TYPE;
}

Type unify_other_arith(Type t1, Type t2) {
    if (t1 == INT_TYPE && t2 == INT_TYPE) return INT_TYPE;
    if ( (t1 == REAL_TYPE  && t2 == REAL_TYPE) ||
         (t1 == INT_TYPE   && t2 == REAL_TYPE) ||
         (t1 == REAL_TYPE  && t2 == INT_TYPE)     ) return REAL_TYPE;
    type_error(t1, t2);
    return STR_TYPE; // Dummy return value to avoid warning. Never reached.
}

Type unify_comp(Type t1, Type t2) {
    // Too lazy to write all cases...
    return BOOL_TYPE;
}

void check_assign(Type l, Type r) {
    if (l == BOOL_TYPE && r != BOOL_TYPE) type_error(l, r);
    if (l == STR_TYPE  && r != STR_TYPE)  type_error(l, r);
    if (l == INT_TYPE  && r != INT_TYPE)  type_error(l, r);
    if (l == REAL_TYPE  && !(r == INT_TYPE || r == REAL_TYPE)) type_error(l, r);
}

// Error handling.
void yyerror (char const *s) {
    printf("PARSE ERROR (%d): %s\n", yylineno, s);
    exit(1);
}

// Main.
int main() {
    yydebug = 0; // Toggle this variable to enter debug mode.

    // Initialization of tables before parsing.
    lt = create_lit_table();
    st = create_sym_table();

    yyparse();

    printf("\n\n");
    print_lit_table(lt); printf("\n\n");
    print_sym_table(st); printf("\n\n");

    free_lit_table(lt);
    free_sym_table(st);

    return 0;
}
