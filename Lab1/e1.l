%{/* Reconhece numeros naturais arbitrarios. */
#include <stdio.h>
%}
digito  [0-9a-fA-F]
numero  (0(x|X){digito}{1,8})
%%
{numero}    { printf("Encontrado numero: %s\n", yytext); }
[^ \t\n]+   { printf("Encontrado nao-numero: %s\n", yytext); }
[ \t\n]     ; /* ignorados */
<<EOF>>     { printf("Fim de dados\n"); return 0; }
%%
int main() { yylex(); return 0; }
/* Definindo esta funcao nao precisa compilar com -lfl */
int yywrap() { return 1; }
