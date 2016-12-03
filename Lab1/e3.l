%{/* Reconhece numeros naturais arbitrarios. */
#include <stdio.h>
%}
digito  [0-9]
numero2 ({digito}{2})
numero4  ({digito}{4})
telefone  ("+"55" "?"("{numero2}")"" "?9?{numero4}-{numero4})
%%
{telefone}    { printf("Encontrado telefone: %s\n", yytext); }
[^ \t\n]+   { printf("Não-telefone: %s\n", yytext); }
[ \t\n]     ; /* ignorados */
<<EOF>>     { printf("Fim de dados\n"); return 0; }
%%
int main() { yylex(); return 0; }
/* Definindo esta funcao nao precisa compilar com -lfl */
int yywrap() { return 1; }
