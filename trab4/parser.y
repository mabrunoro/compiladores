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
#include <stdio.h>
#include "tree.h"
}

%{
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
#include "table.h"
#include "interpreter.h"

int yylex(void);
void yyerror(char const *s);
void perro();

extern int yylineno;
//extern char *yytext;

extern int litpos;		// posição da string reconhecida na tabela (ID,INT,etc)

tree *arv;
littab *lt;
symtab *st;
funtab *ft;
scotab *sct;

int ltipo;
int lpos;
int fpos; // posição da tabela de funções para adicionar o nó da função
int nparam;
int scop;
int lposb;
int vpos; // posição da variável na tabela
int numero;

%}

%define api.value.type {tree*}

%token INT
%token VOID
%token IF
%token ELSE
%token INPUT
%token OUTPUT
%token RETURN
%token WHILE
%token WRITE
%token PLUS
%token MINUS
%token TIMES
%token OVER
%token LT
%token LE
%token GT
%token GE
%token EQ
%token NEQ
%token ASSIGN
%token SEMI
%token COMMA
%token LPAREN
%token RPAREN
%token LBRACK
%token RBRACK
%token LBRACE
%token RBRACE
%token NUM
%token ID
%token STRING
%left LT EQ
%left PLUS MINUS
%left TIMES OVER

%start program

%%

program:
  funcdecllist			{ arv = $1; }
;

funcdecllist:
  funcdecllist funcdecl		{ $$ = $1; addchild($1,$2); /*$$ = newsubtree(FUNCDECLLIST,fpos,2,$1,$2);*/ }
| funcdecl					{ $$ = newsubtree(FUNCDECLLIST,fpos,1,$1); }
;

funcdecl:
  funcheader funcbody		{ tree *aux = newsubtree(FUNCDECL,fpos,2,$1,$2);
                          setfunnode(ft,fpos,aux);
                          $$ = aux; }
;

funcheader:
  rettype ID { lpos = litpos; nparam = 0; } LPAREN { scop = addscope(sct,scop); } params RPAREN
	{
		int aux = lookupfunsimple(ft,lpos);
		if(aux == -1)
		{
			fpos = addfun(ft,ltipo,lpos,yylineno,nparam);
			$$ = newsubtree(FUNCHEADER,fpos,3,$1,newnode(IDN,lpos),$6);
		}
		else
		{
			printf("SEMANTIC ERROR (%d): function '%s' already declared at line %d.\n",yylineno,getfunname(ft,lt,aux),getfunline(ft,aux));
			exit(0);
		}
	}
;

funcbody:
  LBRACE optvardecl optstmtlist RBRACE	{ scop = supscope(sct,scop); $$ = newsubtree(FUNCBODY,fpos,2,$2,$3); }
;

optvardecl:
				{ $$ = NULL; }
| vardecllist	{ $$ = $1; /*newsubtree(OPTVARDECL,-1,1,$1);*/ }
;

optstmtlist:
				{ $$ = NULL; }
| stmtlist		{ $$ = $1; /*newsubtree(OPTSTMTLIST,-1,1,$1);*/ }
;

rettype:
  INT			{ ltipo = 0; $$ = newsubtree(RETTYPE,INT,0); }
| VOID			{ ltipo = 4; $$ = newsubtree(RETTYPE,VOID,0); }
;

params:
  VOID			{ $$ = newsubtree(PARAMS,0,0); }
| paramlist		{ $$ = newsubtree(PARAMS,nparam,1,$1); }
;

paramlist:
  paramlist COMMA param		{ $$ = $1; nparam++; addchild($1,$3); /*newsubtree(PARAMLIST,-1,2,$1,$3);*/ }
| param						{ nparam++; $$ = newsubtree(PARAMLIST,-1,1,$1); }
;

param:
  INT ID					{ vpos = addvar(st,litpos,yylineno,0,scop); $$ = newsubtree(PARAM,vpos,0); }
| INT ID LBRACK RBRACK		{ vpos = addvar(st,litpos,yylineno,0,scop); $$ = newsubtree(PARAM,vpos,0); }
;

vardecllist:
  vardecllist vardecl		{ $$ = $1; addchild($1,$2); }
| vardecl					{  $$ = newsubtree(VARDECLLIST,-1,1,$1); }
;

vardecl:
  INT ID { int aux = lookupvar(st,litpos,scop);
	  		if(aux == -1) vpos = addvar(st,litpos,yylineno,0,scop);
			else
			{
				printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d.\n",yylineno,getvarname(st,lt,aux),getvarline(st,aux));
				exit(0);
			}
		 } SEMI	{ $$ = newsubtree(VARDECL,vpos,0); }
| INT ID { int aux = lookupvar(st,litpos,scop);
			if(aux == -1) addvar(st,litpos,yylineno,0,scop);
			else
			{
				printf("SEMANTIC ERROR (%d): variable '%s' already declared at line %d.\n",yylineno,getvarname(st,lt,aux),getvarline(st,aux));
				exit(0);
			}
		 } LBRACK NUM RBRACK SEMI	{ $$ = newsubtree(VARDECL,INT,0); }
;

stmtlist:
  stmtlist stmt		{ $$ = $1; addchild($1,$2); /*newsubtree(STMTLIST,-1,2,$1,$2);*/ }
| stmt				{ $$ = newsubtree(STMTLIST,-1,1,$1); }
;

stmt:
  assignstmt		{ $$ = $1; }
| ifstmt			{ $$ = $1; }
| whilestmt			{ $$ = $1; }
| returnstmt		{ $$ = $1; }
| funccall SEMI		{ $$ = $1; }
;

assignstmt:
  lval ASSIGN arithexpr SEMI	{ $$ = newsubtree(ASSIGNSTMT,-1,2,$1,$3); }
;

lval:
  ID	{ if((vpos = lookupvar(st,litpos,scop)) == -1)
	  		{
				printf("SEMANTIC ERROR (%d): variable '%s' was not declared.\n",yylineno,getliteral(lt,litpos));
				exit(0);
			}
			else
				$$ = newsubtree(LVAL,vpos,0);
		}
| ID LBRACK { if(lookupvar(st,litpos,scop) == -1)
				{
					printf("SEMANTIC ERROR (%d): variable '%s' was not declared.\n",yylineno,getliteral(lt,litpos));
					exit(0);
				}
			} NUM RBRACK	{ $$ = newsubtree(LVAL,-1,0); }
| ID LBRACK { if(lookupvar(st,litpos,scop) == -1)
				{
					printf("SEMANTIC ERROR (%d): variable '%s' was not declared.\n",yylineno,getliteral(lt,litpos));
					exit(0);
				}
			} ID { if(lookupvar(st,litpos,scop) == -1)
					{
						printf("SEMANTIC ERROR (%d): variable '%s' was not declared.\n",yylineno,getliteral(lt,litpos));
						exit(0);
					}
				 } RBRACK	{ $$ = newsubtree(LVAL,-1,0); }
;

ifstmt:
  IF LPAREN boolexpr RPAREN block { $$ = newsubtree(IFSTMT,-1,2,$3,$5); }
| IF LPAREN boolexpr RPAREN block ELSE block { $$ = newsubtree(IFSTMT,-1,3,$3,$5,$7); }
;

block:
  LBRACE { scop = addscope(sct,scop); } optstmtlist { scop = supscope(sct,scop); } RBRACE		{ $$ = newsubtree(BLOCK,-1,1,$3); }
;

whilestmt:
  WHILE LPAREN boolexpr RPAREN block { $$ = newsubtree(WHILESTMT,-1,2,$3,$5); }
;

returnstmt:
  RETURN SEMI				{ $$ = newsubtree(RETURNSTMT,-1,0); }
| RETURN arithexpr SEMI		{ $$ = newsubtree(RETURNSTMT,-1,1,$2); }
;

funccall:
  outputcall		{ $$ = $1; /*newsubtree(FUNCCALL,-1,1,$1);*/ }
| writecall			{ $$ = $1; /*newsubtree(FUNCCALL,-1,1,$1);*/ }
| userfunccall		{ $$ = $1; /*newsubtree(FUNCCALL,-1,1,$1);*/ }
;

inputcall:
  INPUT LPAREN RPAREN	{ $$ = newsubtree(INPUTCALL,-1,0); }
;

outputcall:
  OUTPUT LPAREN arithexpr RPAREN	{ $$ = newsubtree(OUTPUTCALL,-1,1,$3); }
;

writecall:
  WRITE LPAREN STRING RPAREN		{ $$ = newsubtree(WRITECALL,-1,1,newnode(STRINGN,litpos)); }
;

userfunccall:
  ID { lposb = litpos; nparam = 0;
	  	if(lookupfunsimple(ft,lposb) == -1)
		{
			printf("SEMANTIC ERROR (%d): function '%s' was not declared.\n",yylineno,getliteral(lt,lposb));
			exit(0);
		}
	 } LPAREN optarglist RPAREN	{ if(lookupfun(ft,lposb,nparam) == -1)
		 							{
										int aux = lookupfunsimple(ft,lposb);
										printf("SEMANTIC ERROR (%d): function '%s' was called with %d arguments but declared with %d parameters.\n",yylineno,getfunname(ft,lt,aux),nparam,getfunparam(ft,aux));
										exit(0);
									}
									else
										$$ = newsubtree(USERFUNCCALL,lposb,1,$4);
								}
;

optarglist:
				{ $$ = NULL; }
| arglist		{ $$ = $1; /*newsubtree(OPTARGLIST,-1,1,$1);*/ }
;

arglist:
  arglist COMMA arithexpr	{ nparam++; $$ = $1; addchild($1,$3); /*newsubtree(ARGLIST,-1,2,$1,$3);*/ }
| arithexpr					{ nparam++; $$ = newsubtree(ARGLIST,-1,1,$1); }
;

boolexpr:
  arithexpr boolop arithexpr	{ $$ = newsubtree(BOOLEXPR,-1,3,$1,$2,$3); }
;

boolop:
  LT		{ $$ = newsubtree(BOOLOP,0,0); }
| LE		{ $$ = newsubtree(BOOLOP,1,0); }
| GT		{ $$ = newsubtree(BOOLOP,2,0); }
| GE		{ $$ = newsubtree(BOOLOP,3,0); }
| EQ		{ $$ = newsubtree(BOOLOP,4,0); }
| NEQ		{ $$ = newsubtree(BOOLOP,5,0); }
;

arithexpr:
  arithexpr PLUS arithexpr			{ $$ = newsubtree(ARITHEXPR,0,2,$1,$3); }
| arithexpr MINUS arithexpr			{ $$ = newsubtree(ARITHEXPR,1,2,$1,$3); }
| arithexpr TIMES arithexpr			{ $$ = newsubtree(ARITHEXPR,2,2,$1,$3); }
| arithexpr OVER arithexpr			{ $$ = newsubtree(ARITHEXPR,3,2,$1,$3); }
| LPAREN arithexpr RPAREN			  { $$ = newsubtree(ARITHEXPR,-1,1,$2); }
| lval								          { $$ = $1; }
| inputcall                     { $$ = $1; }
| userfunccall						      { $$ = $1; }
| NUM                           { $$ = newsubtree(NUMN,numero,0); }
;

%%

int main() {
 	yydebug = 0; // Enter debug mode.
	lt = createlittab();
	st = createsymtab();
	ft = createfuntab();
	sct = createscotab();
	scop = 0;

 	if(yyparse() == 0)
	{
		//printdot(arv);
		/*printtree(arv);
		printf("PARSE SUCESSFUL!\n");*/
    
    inipilha();
    stdin = fopen(ctermid(NULL), "r");
    execast(arv,ft,st,lt);
    finpilha();
	}
	/*printlittab(lt);
	printsymtab(st,sct,lt);
	printfuntab(ft,lt);*/

	freetree(arv);
	freefuntab(ft);
	freesymtab(st);
	freelittab(lt);
	freescotab(sct);

 	return 0;
}

void yyerror(char const *s)
{
	printf("PARSE ERROR (%d): %s\n",yylineno,s);
	exit(0);
}

void perro()
{
	printlittab(lt);
	printsymtab(st,sct,lt);
	printfuntab(ft,lt);
	exit(0);
}
