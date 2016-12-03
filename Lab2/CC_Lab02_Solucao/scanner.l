/* My implementation of Lab2 */

/* Options to flex */
%option outfile="scanner.c"
/* Tell flex to don't declare this functions to avoid compilation warnings.
 * They are not necessary for the kind of scanner we need.
**/
%option noyywrap
%option nounput
%option noinput

%{
#include "token.h"

void process_token(TokenType);
void process_error();
%}

number      [0-9]+
identifier  [a-zA-Z]+

/* Multi-line comments are handled in the rules section.
   First we need to define a start condition. */
%x          ML_COMMENT

%%

"if"            { process_token(IF); }
"then"          { process_token(THEN); }
"else"          { process_token(ELSE); }
"end"           { process_token(END); }
"repeat"        { process_token(REPEAT); }
"until"         { process_token(UNTIL); }
"read"          { process_token(READ); }
"write"         { process_token(WRITE); }

"+"             { process_token(PLUS); }
"-"             { process_token(MINUS); }
"*"             { process_token(TIMES); }
"/"             { process_token(OVER); }

"="             { process_token(EQ); }
"<"             { process_token(LT); }

"("             { process_token(LPAREN); }
")"             { process_token(RPAREN); }
";"             { process_token(SEMI); }

":="            { process_token(ASSIGN); }

{number}        { process_token(NUM); }
{identifier}    { process_token(ID); }

[ \t]+          /* eat up whitespace */
"\n"            yylineno++; /* eat up a single line */

"{"                 BEGIN(ML_COMMENT); /* multi-line comments */
<ML_COMMENT>[^}\n]* /* eat anything that’s not a ’}’ */
<ML_COMMENT>"\n"    yylineno++;
<ML_COMMENT>"}"     BEGIN(INITIAL);

.               { process_error(); } /* Be sure to keep this as the last rule */

%%

void process_token(TokenType tk) {
    printf("%d: %s -> %s\n", yylineno, yytext, TOKEN_TYPE_STRING[tk]);
}

void process_error() {
    printf("%d: %s -> %s\n", yylineno, yytext, "UNKNOWN");
}

int main(void) {
    yylex();
    return 0;
}
