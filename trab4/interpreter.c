
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "interpreter.h"

int *pilha;
// int pos;
int chamada;

int fp;
int sp;
int pcount;	// auxiliar para contagem e associação de parâmetros

funtab *ft;
symtab *st;
littab *lt;

void inipilha()
{
	// posmax = 0;
	chamada = 0;
	fp = 0;
	sp = 0;
	pilha = (int *)malloc(STACKSIZE * (sizeof(int)));
}

void finpilha()
{
	free(pilha);
	// posmax = 0;
}

int push(int i)
{
	// printf("push: %d\n",i);
	pilha[sp] = i;
	return sp++;
}

int pop()
{
	return pilha[--fp];
}

void store(int var,int i)
{
	// printf("%d, %d\n",var,i);
	pilha[fp+getvaroffset(st,var)] = i;
	// printf("Guardado!\n");
}

int recover(int var)
{
	return pilha[fp+getvaroffset(st,var)];
}

int runast(tree *astree) {
	switch(getkind(astree))
	{
		case PROGRAM:
			return runprogramnode(astree);
			break;

		case FUNCDECLLIST:
			return runfuncdecllistnode(astree);
			break;

		case FUNCDECL:
			return runfuncdeclnode(astree);
			break;

		case FUNCHEADER:
			return runfuncheadernode(astree);
			break;

		case FUNCBODY:
			return runfuncbodynode(astree);
			break;

		case OPTVARDECL:
			return runoptvardeclnode(astree);
			break;

		case OPTSTMTLIST:
			return runoptstmtlistnode(astree);
			break;

		case RETTYPE:
			return runrettypenode(astree);
			break;

		case PARAMS:
			return runparamsnode(astree);
			break;

		case PARAMLIST:
			return runparamlistnode(astree);
			break;

		case PARAM:
			return runparamnode(astree);
			break;

		case VARDECLLIST:
			return runvardecllistnode(astree);
			break;

		case VARDECL:
			return runvardeclnode(astree);
			break;

		case STMTLIST:
			return runstmtlistnode(astree);
			break;

		case STMT:
			return runstmtnode(astree);
			break;

		case ASSIGNSTMT:
			return runassignstmtnode(astree);
			break;

		case LVAL:
			return runlvalnode(astree);
			break;

		case IFSTMT:
			return runifstmtnode(astree);
			break;

		case BLOCK:
			return runblocknode(astree);
			break;

		case WHILESTMT:
			return runwhilestmtnode(astree);
			break;

		case RETURNSTMT:
			return runreturnstmtnode(astree);
			break;

		case FUNCCALL:
			// return runfunccallnode(astree);
			break;

		case INPUTCALL:
			return runinputcallnode(astree);
			break;

		case OUTPUTCALL:
			return runoutputcallnode(astree);
			break;

		case WRITECALL:
			return runwritecallnode(astree);
			break;

		case USERFUNCCALL:
			return runuserfunccallnode(astree);
			break;

		case OPTARGLIST:
			return runoptarglistnode(astree);
			break;

		case ARGLIST:
			return runarglistnode(astree);
			break;

		case BOOLEXPR:
			return runboolexprnode(astree);
			break;

		case BOOLOP:
			return runboolopnode(astree);
			break;

		case ARITHEXPR:
			return runarithexprnode(astree);
			break;

		case IDN:
			return runidnnode(astree);
			break;

		case STRINGN:
			return runstringnnode(astree);
			break;

		case NUMN:
			return runnumnnode(astree);
			break;
	}
	return -1;
  printf("Root: %p\n", astree);
}

int runprogramnode(tree* node)
{
	runast(getchild(node));
	return -1;
}

int runfuncdecllistnode(tree* node)
{
	tree *i;
	for(i = getchild(node); getbrother(i) != NULL; i = getbrother(i))
		runast(i);
	chamada = 1;
	runast(i);
	return -1;
}

int runfuncdeclnode(tree* node)
{
	if(chamada == 0)
		return -1;
	else
		runast(getbrother(getchild(node)));
	return -1;
}

int runfuncheadernode(tree* node)
{
	// associa variáveis de entrada com offset
	runast(getbrother(getbrother(getchild(node))));
	return -1;
}

int runfuncbodynode(tree* node)
{
	tree *i;
	for(i = getchild(node); i != NULL; i = getbrother(i))
		runast(i);
	return -1;
}

int runoptvardeclnode(tree* node)
{
	tree *i;
	for(i = getchild(node); i != NULL; i = getbrother(i))
		runast(i);
	return -1;
}

int runoptstmtlistnode(tree* node)
{
	tree *i;
	for(i = getchild(node); i != NULL; i = getbrother(i))
		runast(i);
	return -1;
}

int runrettypenode(tree* node)
{
	return -1;
}

int runparamsnode(tree* node)
{
	if(gettval(node)==0)
		return -1;
	runast(getchild(node));
	return -1;
}

int runparamlistnode(tree* node)
{
	pcount = 0;
	tree *i;
	for(i = getchild(node); i != NULL; i = getbrother(i))
		runast(i);
	return -1;
}

int runparamnode(tree* node)
{
	setvaroffset(st,gettval(node),pcount++);
	return -1;
}

int runvardecllistnode(tree* node)
{
	tree *i;
	for(i = getchild(node); i != NULL; i = getbrother(i))
		runast(i);
	return -1;
}

int runvardeclnode(tree* node)
{
	int posvar = gettval(node);
	int tipvar = getvartype(st,posvar);
	if(tipvar == 0)	// número
		setvaroffset(st,posvar,push(0));
	else
	{
		setvaroffset(st,posvar,sp);
		int i;
		for(i = 0; i < tipvar; i++)
			push(0);
	}
	return -1;
}

int runstmtlistnode(tree* node)
{
	tree *i;
	for(i = getchild(node); i != NULL; i = getbrother(i))
		runast(i);
	return -1;
}

int runstmtnode(tree* node)
{
	if(getchild(node) != NULL)
		runast(getchild(node));
	return -1;
}

int runassignstmtnode(tree* node)
{
	if((getchild(node)==NULL) || (getbrother(getchild(node))==NULL))
	{
		printf("Erro assign!\n");
		exit(0);
	}
	else
	{
		int i, j;
		i = runast(getchild(node));
		j = runast(getbrother(getchild(node)));
		// printf("%d, %d\n",i,j);
		store(i,j);
		// printf("%d = %s,%d\n",i,getvarname(st,lt,i),j);
		// printf("\t%d\n",recover(i));
		return j;
	}
}

int runlvalnode(tree* node)
{
	return (gettval(node));
}

int runifstmtnode(tree* node)
{
	if((getchild(node)==NULL)||(getbrother(getchild(node))==NULL))
	{
		printf("Erro if!\n");
		exit(0);
	}
	else
	{
		int i = runast(getchild(node));
		// printf("%s: %d\n",getvarname(st,lt,i),recover(i));
		// exit(0);
		if(i == 1)
			runast(getbrother(getchild(node)));
		else if(getbrother(getbrother(getchild(node)))!=NULL)
			runast(getbrother(getbrother(getchild(node))));
	}
	return -1;
}

int runblocknode(tree* node)
{
	tree *i;
	for(i = getchild(node); i != NULL; i = getbrother(i))
		runast(i);
	return -1;
}

int runwhilestmtnode(tree* node)
{
	if((getchild(node) == NULL) || (getbrother(getchild(node)) == NULL))
	{
		printf("Erro while!\n");
		exit(0);
	}
	else
	{
		int i = runast(getchild(node));
		while(i == 1)
		{
			if(getchild(node) == NULL)
			{
				printf("Erro while child!\n");
				exit(0);
			}
			else
				runast(getbrother(getchild(node)));
			i = runast(getchild(node));
		}
	}
	return -1;
}

int runreturnstmtnode(tree* node)
{
	if(gettval(node)==0)
		return -1;
	int aux = runast(getchild(node));

	if(getkind(getchild(node))==LVAL)
		aux = recover(aux);

	// printf("return: %d\n",aux);
	pilha[fp-1] = aux;
	return aux;
}

int runfunccallnode(tree* node)
{
	chamada = 1;
	chamada = 0;
	return -1;
}

int runinputcallnode(tree* node)
{
	int i;
	printf("input: ");
	scanf("%d",&i);
	return i;
}

int runoutputcallnode(tree* node)
{
	if(getchild(node)==NULL)
	{
		printf("Erro output!\n");
		exit(0);
	}
	else
	{
		int i = runast(getchild(node));
		if(getkind(getchild(node))==LVAL)
			printf("%d",recover(i));
		else if((getkind(getchild(node))==NUMN)||(getkind(getchild(node))==ARITHEXPR)||(getkind(getchild(node))==USERFUNCCALL))
			printf("%d",i);
		else
			printf("Erro output tipo!\n");
	}
	return -1;
}

int runwritecallnode(tree* node)
{
	if(getchild(node)==NULL)
	{
		printf("Erro write!\n");
		exit(0);
	}
	else
	{
		int i = runast(getchild(node));
		// printf("%s",getliteral(lt,i));
		const char *v = getliteral(lt,i);
		const char *aux;
		for(aux = v; aux != NULL; aux++)
		{
			if(*aux == '\0')
				return (aux - v);
			else if(*aux == '\n')
				printf("\n");
			else if(*aux == '\\')
			{
				aux++;
				switch(*aux)
				{
					case '0':
						return (aux - v);
					case 'n':
						printf("\n");
						break;
					case 't':
						printf("\t");
						break;
					default:
						printf("Erro printf\n");
						break;
				}
			}
			else if(*aux != '\"')
				printf("%c",*aux);
		}
	}
	return -1;
}

int runuserfunccallnode(tree* node)
{
	int i = lookupfunsimple(ft,gettval(node));
	tree *func = getfuncdecl(ft,i);
	if((getkind(func)!=FUNCDECL)||(getkind(getchild(func))!=FUNCHEADER))
	{
		printf("Erro userfunccall tipo!\n");
		exit(0);
	}

	push(fp);

	if(getfuntype(ft,i)==1)
		push(0);

	int aux = sp;

	// insere parâmetros na pilha
	runast(getchild(node));

	// retorna o header da função
	tree *head = getchild(func);

	// associa os parâmtros às variáveis de entrada
	if(getfunparam(ft,i)!=0)
		runast(head);

	fp = aux;

	runast(getbrother(getchild(func)));

	int ret = 0;
	if(getfuntype(ft,i)==1)
		ret = pop();
	sp = fp - 1;
	fp = pop();

	return ret;
}

int runoptarglistnode(tree* node)
{
	tree *i;
	for(i = getchild(node); i != NULL; i = getbrother(i))
		runast(i);
	return -1;
}

int runarglistnode(tree* node)
{
	tree *i;
	for(i = getchild(node); i != NULL; i = getbrother(i))
	{
		runast(i);
		if(getkind(i)==LVAL)
			push(recover(runast(i)));
		else
			push(runast(i));
	}
	return -1;
}

int runboolexprnode(tree* node)
{
	int i = runast(getchild(node));
	if(getkind(getchild(node)) == LVAL)
		i = recover(i);
	int j = runast(getbrother(getchild(node)));
	int k = runast(getbrother(getbrother(getchild(node))));
	if(getkind(getbrother(getbrother(getchild(node)))) == LVAL)
		k = recover(k);
	// printf("i: %d, j: %d, k: %d\n",i,j,k);
	switch(j)
	{
		case 0: // LT
			return (i < k ? 1 : 0);
			break;
		case 1: // LE
			return (i <= k ? 1 : 0);
			break;
		case 2: // GT
			return (i > k ? 1 : 0);
			break;
		case 3: // GE
			return (i >= k ? 1 : 0);
			break;
		case 4: // EQ
			return (i == k ? 1 : 0);
			break;
		case 5: // NEQ
			return (i != k ? 1 : 0);
			break;
		default:
			printf("Erro boolexpr.\n");
			break;
	}
	return -1;
}

int runboolopnode(tree* node)
{
	return (gettval(node));
}

int runarithexprnode(tree* node)
{
	int i;
	if(getchild(node)==NULL)
	{
		printf("Erro arith\n");
		exit(0);
	}
	else
	{
		i = gettval(node);
		int j, k;
		if(i == -1) // ( arith-expr )
			return runast(getchild(node));
		j = runast(getchild(node));
		if(getkind(getchild(node))==LVAL)
			j = recover(j);
		k = runast(getbrother(getchild(node)));
		if(getkind(getbrother(getchild(node)))==LVAL)
			k = recover(k);
		// printf("%d,%d,%d\n",i,j,k);
		switch(i)
		{
			case 0: // +
				return (j + k);
				break;
			case 1: // -
				return (j - k);
				break;
			case 2: // *
				return (j * k);
				break;
			case 3: // /
				return (j / k);
				break;
		}
	}
	return -1;
}

int runidnnode(tree* node)
{
	// int i = gettval(node);
	// printf("%s: %d",getliteral(lt,i),i);
	return (gettval(node));
}

int runstringnnode(tree* node)
{
	return (gettval(node));
}

int runnumnnode(tree *n)
{
	return gettval(n);
}

void execast(tree* arv,funtab *f, symtab *s, littab *l)
{
	ft = f;
	st = s;
	lt = l;
	runast(arv);
}
