/* My implementation of Lab08 */

%option outfile="scanner.c"
%option noyywrap
%option nounput
%option noinput

%{
//#include "tree.h"
#include "parser.h"
#include "tables.h"

extern LitTable *lt;
extern SymTable *st;

#define process_token(type) return type
%}

number      [0-9]+
decimal		[0-9]+\.[0-9]+
identifier  [a-zA-Z]+

/* Multi-line comments are handled in the rules section.
   First we need to define a start condition. */
%x          ML_COMMENT

%%
"int"			{ process_token(INT);	}
"real"			{ process_token(REAL);	}
"bool"			{ process_token(BOOL);	}
"string"		{ process_token(STR);	}
"false"			{ process_token(FALSE); }
"true"			{ process_token(TRUE);  }
"print"			{ process_token(PRINT);	}

"+"             { process_token(PLUS); }
"-"             { process_token(MINUS); }
"*"             { process_token(TIMES); }
"/"             { process_token(OVER); }

"="             { process_token(EQ); }
"<"             { process_token(LT); }
">"				{ process_token(GT); }

"("             { process_token(LPAREN); }
")"             { process_token(RPAREN); }
";"             { process_token(SEMI); }
","				{ process_token(COMMA); }

":="            { process_token(ASSIGN); }

\"[^"]+\"		{ yylval = add_literal(lt,yytext);
				  process_token(STRING); }

{number}        { process_token(NUM); }
{decimal}		{ process_token(DEC); }
{identifier}    { process_token(ID); }

[ \t]+          /* eat up whitespace */
"\n"            yylineno++; /* eat up a single line */

"{"                 BEGIN(ML_COMMENT); /* multi-line comments */
<ML_COMMENT>[^}\n]* /* eat anything that’s not a ’}’ */
<ML_COMMENT>"\n"    yylineno++;
<ML_COMMENT>"}"     BEGIN(INITIAL);

                /* Be sure to keep this as the last rule */
.               { printf("SCANNING ERROR (%d): Unknown symbol %s\n", yylineno, yytext);
                  exit(1); }

%%
