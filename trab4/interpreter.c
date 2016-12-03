
#include <stdio.h>
#include <stdlib.h>
#include "interpreter.h"

int *pilha;
int pos;
int chamada;

funtab *ft;
symtab *st;
littab *lt;

void inipilha()
{
	pos = 0;
	chamada = false;
	pilha = malloc(STACKSIZE * (sizeof int));
}

void finpilha()
{
	free(pilha);
	pos = 0;
}

void store(int var,int i)
{
	pilha[var] = i;
}

int recover(int var)
{
	return pilha[var];
}

int runast(tree *astree) {
	switch(astree->tipo)
	{
		PROGRAM:
		// return runprogramnode(astree);
		break;

		FUNCDECLLIST:
		// return runfuncdecllistnode(astree);
		break;

		FUNCDECL:
		// return runfuncdeclnode(astree);
		break;

		FUNCHEADER:
		// return runfuncheadernode(astree);
		break;

		FUNCBODY:
		// return runfuncbodynode(astree);
		break;

		OPTVARDECL:
		return runoptvardeclnode(astree);
		break;

		OPTSTMTLIST:
		return runoptstmtlistnode(astree);
		break;

		RETTYPE:
		// return runrettypenode(astree);
		break;

		PARAMS:
		// return runparamsnode(astree);
		break;

		PARAMLIST:
		// return runparamlistnode(astree);
		break;

		PARAM:
		// return runparamnode(astree);
		break;

		VARDECLLIST:
		return runvardecllistnode(astree);
		break;

		VARDECL:
		return runvardeclnode(astree);
		break;

		STMTLIST:
		return runstmtlistnode(astree);
		break;

		STMT:
		return runstmtnode(astree);
		break;

		ASSIGNSTMT:
		return runassignstmtnode(astree);
		break;

		LVAL:
		return runlvalnode(astree);
		break;

		IFSTMT:
		return runifstmtnode(astree);
		break;

		BLOCK:
		return runblocknode(astree);
		break;

		WHILESTMT:
		return runwhilestmtnode(astree);
		break;

		RETURNSTMT:
		return runreturnstmtnode(astree);
		break;

		FUNCCAL:
		// return runfunccallnode(astree);
		break;

		INPUTCALL:
		return runinputcallnode(astree);
		break;

		OUTPUTCALL:
		return runoutputcallnode(astree);
		break;

		WRITECALL:
		return runwritecallnode(astree);
		break;

		USERFUNCCALL:
		// return runuserfunccallnode(astree);
		break;

		OPTARGLIST:
		return runoptarglistnode(astree);
		break;

		ARGLIST:
		return runarglistnode(astree);
		break;

		BOOLEXPR:
		return runboolexprnode(astree);
		break;

		BOOLOP:
		return runboolopnode(astree);
		break;

		ARITHEXPR:
		return runarithexprnode(astree);
		break;

		IDN:
		return runidnnode(astree);
		break;

		STRINGN:
		return runstringnnode(astree);
		break;
	}
	return -1;
  printf("Root: %p\n", astree);
}

// int runprogramnode(tree* node)
// {
// 	runast(node->child);
// 	return -1;
// }
//
// int runfuncdecllistnode(tree* node)
// {
// }

// int runfuncdeclnode(tree* node)
// {
//
// }
//
// int runfuncheadernode(tree* node)
// {
// }
//
// int runfuncbodynode(tree* node)
// {
// }

int runoptvardeclnode(tree* node)
{
	tree *i;
	for(i = node->child; i != NULL; i = i->brother)
		runast(i);
	return -1;
}

int runoptstmtlistnode(tree* node)
{
	tree *i;
	for(i = node->child; i != NULL; i = i->brother)
		runast(i);
	return -1;
}

// int runrettypenode(tree* node)
// {
// }
//
// int runparamsnode(tree* node)
// {
// }
//
// int runparamlistnode(tree* node)
// {
// }
//
// int runparamnode(tree* node)
// {
// }

int runvardecllistnode(tree* node)
{
	tree *i;
	for(i = node->child; i != NULL; i = i->brother)
		runast(i);
	return -1;
}

int runvardeclnode(tree* node)
{
	return -1;
}

int runstmtlistnode(tree* node)
{
	tree *i;
	for(i = node->child; i != NULL; i = i->brother)
		runast(i);
	return -1;
}

int runstmtnode(tree* node)
{
	if(node->child != NULL)
		runast(node->child);
	return -1;
}

int runassignstmtnode(tree* node)
{
	if((node->child==NULL) || (node->child->brother==NULL))
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		int i, j;
		i = runast(node->child);
		j = runast(node->child->brother);
		store(i,j);
	}
	return -1;
}

int runlvalnode(tree* node)
{
	return (node->tval);
}

int runifstmtnode(tree* node)
{
	if(node->child==NULL)
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		int i = runast(node->child);
		if(i == 1)
		{
			if(node->child->brother==NULL)
			{
				printf("Erro!\n");
				exit(0);
			}
			else
				runast(node->child->brother);
		}
	}
	return -1;
}

int runblocknode(tree* node)
{
	tree *i;
	for(i = node->child; i != NULL; i = i->brother)
		runast(i);
	return -1;
}

int runwhilestmtnode(tree* node)
{
	if((node->child == NULL) || (node->child->brother == NULL))
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		int i = runast(node->child->brother);
		while(i == 1)
		{
			if(node->child == NULL)
			{
				printf("Erro!\n");
				exit(0);
			}
			else
				runast(node->child);
			i = runast(node->child->brother);
		}
	}
	return -1;
}

// int runreturnstmtnode(tree* node)
// {
// }

// int runfunccallnode(tree* node)
// {
// 	chamada = 1;
// 	chamada = 0;
// }

int runinputcallnode(tree* node)
{
	int i;
	if(node->child==NULL)
	{
		printf("Erro!\n");
		exit(0);
	}
	else
		scanf("%d",&i);
	return i;
}

int runoutputcallnode(tree* node)
{
	if(node->child==NULL)
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		int i = runast(node->child);
		printf("%d\n",i);
	}
	return -1;
}

int runwritecallnode(tree* node)
{
	if(node->child==NULL)
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		int i = runast(node->child);
		printf("write: %s\n",getliteral(lt,i));
	}
	return -1;
}

// int runuserfunccallnode(tree* node)
// {
// }

int runoptarglistnode(tree* node)
{
	tree *i;
	for(i = node->child; i != NULL; i = i->brother)
		runast(i);
	return -1;
}

int runarglistnode(tree* node)
{
	return -1;
}

int runboolexprnode(tree* node)
{
	int i = runast(node->child);
	int j = runast(node->child->brother);
	int k = runast(node->child->brother->brother);
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
	return (node->tval);
}

int runarithexprnode(tree* node)
{
	int i;
	if(node->child==NULL)
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		i = node->tval;
		int j, k;
		if(i == -1) // ( arith-expr )
			return runast(node->child);
		j = runast(node->child);
		k = runast(node->child->brother);
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
	return (node->tval);
}

int runstringnnode(tree* node)
{
	return (node->tval);
}

void execast(tree* arv,funtab *f, symtab *s, littab *l)
{
	ft = f;
	st = s;
	lt = l;
	runast(arv);
}
