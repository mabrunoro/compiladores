%{/* Reconhece numeros naturais arbitrarios. */
#include <stdio.h>
%}
letra   [A-Z]
digito  [0-9]
placa  ({letra}{3}-{digito}{4})
%%
{placa}    { printf("Encontrada placa: %s\n", yytext); }
[^ \t\n]+   { printf("Não-placa: %s\n", yytext); }
[ \t\n]     ; /* ignorados */
<<EOF>>     { printf("Fim de dados\n"); return 0; }
%%
int main() { yylex(); return 0; }
/* Definindo esta funcao nao precisa compilar com -lfl */
int yywrap() { return 1; }
