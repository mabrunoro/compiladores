/* My implementation of Lab10 */

%option outfile="scanner.c"
%option noyywrap
%option nounput
%option noinput

%{
#include "parser.h"
#include "tables.h"

#define process_token(type) return type

void process_int();
void process_real();
void process_str();
void process_id();

extern LitTable *lt;
extern SymTable *st;
%}

int_val      [0-9]+
real_val     [0-9]+"."[0-9]+
str_val      \"[^"]*\"

identifier  [a-zA-Z]+

%%

"int"           { process_token(INT); }
"real"          { process_token(REAL); }
"string"        { process_token(STRING); }
"bool"          { process_token(BOOL); }

"true"          { process_token(TRUE); }
"false"         { process_token(FALSE); }

"print"         { process_token(PRINT); }

"+"             { process_token(PLUS); }
"-"             { process_token(MINUS); }
"*"             { process_token(TIMES); }
"/"             { process_token(OVER); }

"<"             { process_token(LT); }
"<="            { process_token(LE); }
">"             { process_token(GT); }
">="            { process_token(GE); }
"="             { process_token(EQ); }
"!="            { process_token(NEQ); }

":="            { process_token(ASSIGN); }

"("             { process_token(LPAREN); }
")"             { process_token(RPAREN); }
";"             { process_token(SEMI); }
","             { process_token(COMMA); }

{int_val}       { process_int(); process_token(INT_VAL); }
{real_val}      { process_real(); process_token(REAL_VAL); }
{str_val}       { process_str(); process_token(STR_VAL); }

{identifier}    { process_id(); process_token(ID); }

[ \t]+          /* eat up whitespace */
"\n"            yylineno++; /* eat up a single line */

                /* Be sure to keep this as the last rule */
.               { printf("SCANNING ERROR (%d): Unknown symbol %s\n", yylineno, yytext);
                  exit(1); }

%%

void process_int() {
    yylval.aint = atoi(yytext);
}

void process_real() {
     yylval.afloat = atof(yytext);
}

void process_str() {
    yylval.aint = add_literal(lt, yytext);
}

void process_id() {
    // Store at the end, maybe we will delete it later.
    yylval.aint = add_var(st, yytext, yylineno);
}
