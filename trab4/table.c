
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "table.h"

static const char *TSTRING[] = {
	"int",
	"real",
	"bool",
	"string",
	"void"
};

const char* gettext(int type)
{
	return TSTRING[type];
}

// Literals Table
// ----------------------------------------------------------------------------

#define LITERAL_MAX_SIZE 128
#define LITERALS_TABLE_MAX_SIZE 100

struct littable
{
	char t[LITERALS_TABLE_MAX_SIZE][LITERAL_MAX_SIZE];
	int size;
};

littab* createlittab()
{
	littab *lt = malloc(sizeof * lt);
	lt->size = 0;
	return lt;
}

int addliteral(littab* lt, char* s)
{
	for (int i = 0; i < lt->size; i++)
	{
		if (strcmp(lt->t[i], s) == 0)
		{
			return i;
		}
	}
	strcpy(lt->t[lt->size], s);
	int old_side = lt->size;
	lt->size++;
	return old_side;
}

char* getliteral(littab* lt, int i)
{
	return lt->t[i];
}

void printlittab(littab* lt)
{
	printf("Literals table:\n");
	for (int i = 0; i < lt->size; i++)
	{
		printf("Entry %d -- %s\n", i, getliteral(lt, i));
	}
	printf("\n\n");
}

void freelittab(littab* lt) {
	free(lt);
}

// Scope Table
// ----------------------------------------------------------------------------

#define SCOPE_MAX_SIZE 128

struct scotable
{
	int superior[SCOPE_MAX_SIZE];
	int size;
};

scotab* createscotab()
{
	scotab *sct = malloc(sizeof *sct);
	for(int i = 0; i < SCOPE_MAX_SIZE; i++)
		sct->superior[i] = -1;
	sct->size = 1;
	return sct;
}

int lookupscope(scotab* sct, int i)
{
	return sct->superior[i];
}

int addscope(scotab* sct, int at)
{
	sct->superior[sct->size] = at;
	int old_side = sct->size;
	sct->size++;
	return old_side;
}

int supscope(scotab* sct,int i)
{
	return sct->superior[i];
}

void freescotab(scotab* sct)
{
	free(sct);
}

// Symbols Table
// ----------------------------------------------------------------------------

#define SYMBOL_MAX_SIZE 128
#define SYMBOL_TABLE_MAX_SIZE 100

typedef struct
{
	int type;
	int name;
	int line;
	int scope;
}Sentry;

struct symtable
{
	Sentry t[SYMBOL_TABLE_MAX_SIZE];
	int size;
};

symtab* createsymtab()
{
	symtab *st = malloc(sizeof * st);
	st->size = 0;
	return st;
}

int lookupvar(symtab* st, int lpos, int sco)
{
	for(int i = 0; i < st->size; i++)
	{
		if((st->t[i].name == lpos) && (st->t[i].scope == sco))
			return i;
	}
	return -1;
}

int searchvar(symtab* st, scotab* sct, int lpos, int sco)
{
	int scope = sco;
	while(scope != -1)
	{
		int j = lookupvar(st,lpos,scope);
		if(j == -1)
			scope = supscope(sct, scope);
		else
			return j;
	}
	return -1;
}

int addvar(symtab* st, int lpos, int line, int t, int sc)
{
	st->t[st->size].name = lpos;
	st->t[st->size].line = line;
	st->t[st->size].type = t;
	st->t[st->size].scope = sc;
	int old_side = st->size;
	st->size++;
	return old_side;
}

void setvartype(symtab* st, int i, int type)
{
	st->t[i].type = type;
}

char* getvarname(symtab* st, littab* lt, int i)
{
	return lt->t[st->t[i].name];
}

int getvarline(symtab* st, int i)
{
	return st->t[i].line;
}

int getvarscop(symtab* st, int i)
{
	return st->t[i].scope;
}

int getvartype(symtab* st, int i)
{
	return st->t[i].type;
}

void removelastvar(symtab* st)
{
	st->size--;
}

void printsymtab(symtab* st,scotab* sct,littab* lt)
{
	printf("Symbols table:\n");
	for (int i = 0; i < st->size; i++)
	{
		printf("Entry %d -- name: %s, line: %d, scope: %d, sup. scope: %d, type %s\n", i,
		getvarname(st,lt,i), getvarline(st, i),getvarscop(st,i),supscope(sct, getvarscop(st, i)), TSTRING[getvartype(st, i)]);
	}
	printf("\n\n");
}

void freesymtab(symtab* st) {
	free(st);
}

// Functions Table
// ----------------------------------------------------------------------------

#define FUNC_MAX_SIZE 128
#define FUNC_TAB_MAX 100

typedef struct
{
	int type;
	int name;
	int line;
	int param;
	tree *body;
}Fentry;

struct funtable
{
	Fentry t[FUNC_TAB_MAX];
	int size;
};

funtab* createfuntab()
{
	funtab *f = malloc(sizeof *f);
	f->size = 0;
	return f;
}

int addfun(funtab* ft, int t, int lp, int l, int p)
{
	ft->t[ft->size].name = lp;
	ft->t[ft->size].type = t;
	ft->t[ft->size].line = l;
	ft->t[ft->size].param = p;
	// printf("%d\t%d\t%d\t%d",lp,t,l,p);
	int old_side = ft->size;
	ft->size++;
	return old_side;
}

int lookupfunsimple(funtab* ft,int lp)
{
	int i;
	for(i = 0; i < ft->size; i++)
	{
		if(ft->t[i].name == lp)
			return i;
	}
	return -1;
}

int lookupfun(funtab* ft,int lp,int p)
{
	int i;
	for(i = 0; i < ft->size; i++)
	{
		if((ft->t[i].name == lp)&& (ft->t[i].param == p))
			return i;
	}
	return -1;
}

void setfunnode(funtab* ft, int fpos, tree* ar)
{
	ft->t[fpos].body = ar;
}

char* getfunname(funtab* ft, littab* lt, int i)
{
	if(i >= ft->size)
		return "";
	else
		return lt->t[ft->t[i].name];
}

int getfunline(funtab* ft, int i)
{
	if(i >= ft->size)
		return -1;
	else
		return ft->t[i].line;
}

int getfunparam(funtab* ft,int i)
{
	if(i >= ft->size)
		return -1;
	else
		return ft->t[i].param;
}

int getfuntype(funtab* ft,int i)
{
	if(i >= ft->size)
		return -1;
	else
		return ft->t[i].type;
}

void printfuntab(funtab* ft,littab* lt)
{
	printf("Functions table:\n");
	for (int i = 0; i < ft->size; i++)
	{
		printf("Entry %d -- name: %s, line: %d, arid: %d, type %s\n", i,
		getfunname(ft, lt, i), getfunline(ft, i), getfunparam(ft,i), TSTRING[getfuntype(ft, i)]);
	}
	printf("\n\n");
}

void freefuntab(funtab* ft)
{
	free(ft);
}
