/*
 * Author: Marco Thome
 * Date: September 04, 2016
 */

%option outfile="trab1.c"
%option noyywrap
%option nounput
%option noinput
						/* Reconhece código C-minus.							*/
%{
#include <stdio.h>
void func();			/* Função para imprimir lexema seguido de -> e do tipo	*/
void ferro();			/* Função para imprimir UNKNOWN 						*/
%}
						/* Comentários do tipo / *   * /						*/
%x      comment1
						/* Comentários do tipo //								*/
%x		comment2

%%

"/*"					BEGIN(comment1);
<comment1>[^*\n]*		/* pega tudo menos '*'									*/
<comment1>"*"+[^*/\n]*	/* pega '*' não seguidos de '/'							*/
<comment1>\n			yylineno++;
<comment1>"*"+"/"		BEGIN(INITIAL);

"//"					BEGIN(comment2);
<comment2>[^\n]*
<comment2>\n			{ yylineno++; BEGIN(INITIAL); }

"int"					{ func("INT");		}
"void"					{ func("VOID");		}
"if"					{ func("IF");		}
"else"					{ func("ELSE");		}
"input"					{ func("INPUT");	}
"output"				{ func("OUTPUT");	}
"return"				{ func("RETURN");	}
"while"					{ func("WHILE");	}
"write"					{ func("WRITE");	}

"+"						{ func("PLUS");		}
"-"						{ func("MINUS");	}
"*"						{ func("TIMES");	}
"/"						{ func("OVER");		}
"<"						{ func("LT");		}
"<="					{ func("LE");		}
">"						{ func("GT");		}
">="					{ func("GE");		}
"=="					{ func("EQ");		}
"!="					{ func("NEQ");		}
"="						{ func("ASSIGN");	}

";"						{ func("SEMI");		}
","						{ func("COMMA");	}
"("						{ func("LPAREN");	}
")"						{ func("RPAREN");	}
"["						{ func("LBRACK");	}
"]"						{ func("RBRACK");	}
"{"						{ func("LBRACE");	}
"}"						{ func("RBRACE");	}

([0-9]+)				{ func("NUM");		}
([a-zA-Z]+[0-9a-zA-Z]*)	{ func("ID");		}	// IDs podem ter apenas letras e números
("\""[^\"\n]+"\"")		{ func("STRING");	}	

[ \t]					; // ignorados
"\n"					{ yylineno++;		}
.						{ ferro(); 			}

%%

int main() { yylex(); return 0; }
void func(char* st) { printf("%d: %s -> %s\n",yylineno,yytext,st);}
void ferro() { printf("%d: %s -> %s\n", yylineno, yytext, "UNKNOWN");}
