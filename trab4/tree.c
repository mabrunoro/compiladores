#include "tree.h"

struct node
{
	tipo kind;
	int tval;
	int cnt;
	tree *brother;
	tree *child;
};

tree* newnode(tipo p,int i)
{
	tree* n = malloc(sizeof *n);
	n->kind = p;
	n->tval = i;
	n->child = NULL;
	n->brother = NULL;
	n->cnt = 0;
	// printf("ponteiro: %p\n",n);
	return n;
}

void addchild(tree *p, tree *c)
{
	if(p == NULL)
		printf("Erro. Pai é nulo.\n");
	else if(p->child == NULL)
	{
		p->child = c;
		if(c != NULL)
			p->cnt = 1;
	}
	else
	{
		tree *aux = p->child;
		for(;aux->brother != NULL; aux = aux->brother);
		aux->brother = c;
		if(c != NULL)
			p->cnt++;
	}
}

tree* getchild(tree *p)
{
	return p->child;
}

tree* getbrother(tree *s)
{
	return s->brother;
}

int gettval(tree *n)
{
	return n->tval;
}

tipo getkind(tree *n)
{
	return n->kind;
}

tree* newsubtree(tipo p, int j, int c, ...)
{
	int i;
	tree* node = newnode(p,j);
	va_list ap;
	va_start(ap, c);
	for (i = 0; i < c; i++) {
		addchild(node, va_arg(ap, tree*));
	}
	va_end(ap);
	return node;
}

void printnode(tree *node, int level)
{
	if(node == NULL)
		return;
	printf("%d: Node -- Tipo: %d -- Count: %d -- Val: %d\n", level, node->kind, node->cnt, node->tval);
	tree* n;
	for(n = node->child; n != NULL; n = n->brother)
		printnode(n, level+1);
}

void printtree(tree *t)
{
	printf("Início\n");
	printnode(t, 0);
	printf("Fim\n");
}

void freetree(tree *t)
{
	tree* i;
	// printf("Entrou freetree\n");
	if(t->child != NULL)
		freetree(t->child);
	for(i = t->brother; i != NULL; ) //erro: perco o link do irmao
	{
		tree *j = i->brother;
		// printf("Apagar filhos de: %d\n",t->tval);
		freetree(i);
		i = j;
	}
	// printf("Valor apagado: %d\n",t->tval);
	free(t);
}

const char * getenumname(int i,int j)
{
	switch(i)
	{
		case PROGRAM:
		return "PROGRAM";
		break;

		case FUNCDECLLIST:
		return "FUNCDECLLIST";
		break;

		case FUNCDECL:
		return "FUNCDECL";
		break;

		case FUNCHEADER:
		return "FUNCHEADER";
		break;

		case FUNCBODY:
		return "FUNCBODY";
		break;

		case OPTVARDECL:
		return "OPTVARDECL";
		break;

		case OPTSTMTLIST:
		return "OPTSTMTLIST";
		break;

		case RETTYPE:
		if(j == INT)
			return "INT";
		else if(j == VOID)
			return "VOID";
		else
			return "RETTYPE";
		break;

		case PARAMS:
		return "PARAMS";
		break;

		case PARAMLIST:
		return "PARAMLIST";
		break;

		case PARAM:
		return "PARAM";
		break;

		case VARDECLLIST:
		return "VARDECLLIST";
		break;

		case VARDECL:
		return "VARDECL";
		break;

		case STMTLIST:
		return "STMTLIST";
		break;

		case STMT:
		return "STMT";
		break;

		case ASSIGNSTMT:
		return "ASSIGNSTMT";
		break;

		case LVAL:
		return "LVAL";
		break;

		case IFSTMT:
		return "IFSTMT";
		break;

		case BLOCK:
		return "BLOCK";
		break;

		case WHILESTMT:
		return "WHILESTMT";
		break;

		case RETURNSTMT:
		return "RETURNSTMT";
		break;

		case FUNCCALL:
		return "FUNCCALL";
		break;

		case INPUTCALL:
		return "INPUTCALL";
		break;

		case OUTPUTCALL:
		return "OUTPUTCALL";
		break;

		case WRITECALL:
		return "WRITECALL";
		break;

		case USERFUNCCALL:
		return "USERFUNCCALL";
		break;

		case OPTARGLIST:
		return "OPTARGLIST";
		break;

		case ARGLIST:
		return "ARGLIST";
		break;

		case BOOLEXPR:
		return "BOOLEXPR";
		break;

		case BOOLOP:
		return "BOOLOP";
		break;

		case ARITHEXPR:
		return "ARITHEXPR";
		break;

		case IDN:
		return "ID";
		break;

		case STRINGN:
		return "STRING";
		break;

		case NUMN:
		return "NUM";
		break;

		default:
		return "Desconhecido";
		break;
	}
}

// Dot output.

int nr;

int printnodedot(tree *node)
{
	int my_nr = nr++;
	if((node->kind == IDN) || (node->kind == STRINGN) || (node->kind == VARDECL) || (node->kind == NUMN) || (node->kind == LVAL)
			|| (node->kind == PARAMS) || (node->kind == PARAM))
		printf("node%d[label=\"%s,%d\"];\n", my_nr, getenumname(node->kind,node->tval),node->tval);
	else
		printf("node%d[label=\"%s\"];\n", my_nr, getenumname(node->kind,node->tval));
	tree *n;
	for(n = node->child; n != NULL; n = n->brother)
	{
		int child_nr = printnodedot(n);
		printf("node%d -> node%d;\n", my_nr, child_nr);
	}
	return my_nr;
}

void printdot(tree *a)
{
	nr = 0;
	printf("digraph {\ngraph [ordering=\"out\"];\n");
	printnodedot(a);
	printf("}\n");
}
