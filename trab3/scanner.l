/*
 * Author: Marco Thome
 * Date: September 04, 2016
 */

%option outfile="scanner.c"
%option noyywrap
%option nounput
%option noinput
						/* Reconhece código C-minus.						*/
%{
#include "table.h"
//#include "tree.h"
#include "parser.h"
void ferro();			/* Função para imprimir UNKNOWN 					*/
#define _POSIX_SOURCE 1
extern littab* lt;

//char *yytext;
int litpos;

%}
						/* Comentários do tipo / *   * /					*/
%x      comment1
						/* Comentários do tipo //							*/
%x		comment2

%%

"/*"					BEGIN(comment1);
<comment1>[^*\n]*		/* pega tudo menos '*'								*/
<comment1>"*"+[^*/\n]*	/* pega '*' não seguidos de '/'						*/
<comment1>\n			yylineno++;
<comment1>"*"+"/"		BEGIN(INITIAL);

"//"					BEGIN(comment2);
<comment2>[^\n]*
<comment2>\n			{ yylineno++; BEGIN(INITIAL); }

"int"					{ litpos = addliteral(lt,"int"); return INT; }
"void"					{ litpos = addliteral(lt,"void"); return VOID; }
"if"					{ return IF;		}
"else"					{ return ELSE;		}
"input"					{ return INPUT;		}
"output"				{ return OUTPUT;	}
"return"				{ return RETURN;	}
"while"					{ return WHILE;		}
"write"					{ return WRITE;		}

"+"						{ return PLUS;		}
"-"						{ return MINUS;		}
"*"						{ return TIMES;		}
"/"						{ return OVER;		}
"<"						{ return LT;		}
"<="					{ return LE;		}
">"						{ return GT;		}
">="					{ return GE;		}
"=="					{ return EQ;		}
"!="					{ return NEQ;		}
"="						{ return ASSIGN;	}

";"						{ return SEMI;		}
","						{ return COMMA;		}
"("						{ return LPAREN;	}
")"						{ return RPAREN;	}
"["						{ return LBRACK;	}
"]"						{ return RBRACK;	}
"{"						{ return LBRACE;	}
"}"						{ return RBRACE;	}

([0-9]+)				{ return NUM;		}
([a-zA-Z]+[0-9a-zA-Z]*)	{ litpos = addliteral(lt,yytext); return ID; }	// IDs podem ter apenas letras e números
("\""[^\"\n]+"\"")		{ litpos = addliteral(lt,yytext); return STRING; }

[ \t]					; // ignorados
"\n"					{ yylineno++;		}
.						{ ferro(); 			}

%%

void ferro() { printf("SCANNING ERROR (%d): Unknown symbol %s\n",yylineno,yytext); exit(0); }
