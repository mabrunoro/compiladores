#ifndef TABLE_H
#define TABLE_H

#include "tree.h"

// Literals Table
// ----------------------------------------------------------------------------
// Opaque structure.
// For simplicity, the table is implemented as a sequential list.
struct littable;
typedef struct littable littab;

// Creates an empty literal table.
littab* createlittab();

// Adds the given string to the table without repetitions.
// String 's' is copied internally.
// Returns the index of the string in the table.
int addliteral(littab* lt, char* s);

// Returns a pointer to the string stored at index 'i'.
const char* getliteral(littab* lt, int i);

// Prints the given table to stdout.
void printlittab(littab* lt);

// Clear the allocated structure.
void freelittab(littab* lt);

// Scope Table
// ----------------------------------------------------------------------------

struct scotable;
typedef struct scotable scotab;

scotab* createscotab();

int lookupscope(scotab* sct, int i);

int addscope(scotab* sct, int at);

int supscope(scotab* sct,int i);

void freescotab(scotab* sct);

// Symbols Table
// ----------------------------------------------------------------------------
// Opaque structure.
// For simplicity, the table is implemented as a sequential list.
struct symtable;
typedef struct symtable symtab;

// Creates an empty symbol table.
symtab* createsymtab();

// Adds a fresh var to the table.
// No check is made by this function, so make sure to call 'lookup_var' first.
// Returns the index where the variable was inserted.
int addvar(symtab* st, int lpos, int line, int t, int sc);

// Returns the index where the given variable is stored or -1 otherwise, and the type pointed by t.
int lookupvar(symtab* st, int lpos, int sco);

int searchvar(symtab* st, scotab* sct, int lpos, int sco);

// Returns the variable name stored at the given index.
// No check is made by this function, so make sure that the index is valid first.
const char* getvarname(symtab* st, littab* lt, int i);

int getvarscop(symtab* st, int i);

// Returns the declaration line of the variable stored at the given index.
// No check is made by this function, so make sure that the index is valid first.
int getvarline(symtab* st, int i);

int getvartype(symtab* st, int i);

int getvaroffset(symtab* st, int i);

void setvaroffset(symtab* st, int i, int os);

void setvartype(symtab* st, int i, int type);

// Prints the given table to stdout.
void printsymtab(symtab* st,scotab* sct,littab* lt);

// Clear the allocated structure.
void freesymtab(symtab* st);

// ----------------------------------------------------------------------------
struct funtable;
typedef struct funtable funtab;

funtab* createfuntab();

int addfun(funtab* ft, int t, int lp, int li, int p);

int lookupfunsimple(funtab* ft,int lp);

int lookupfun(funtab* ft,int lp,int p);

void setfunnode(funtab* ft, int fpos, tree* ar);

const char* getfunname(funtab* ft, littab* lt, int i);

int getfunline(funtab* ft, int i);

int getfunparam(funtab* ft,int i);

int getfuntype(funtab* ft,int i);

tree* getfuncdecl(funtab *ft, int i);

void printfuntab(funtab* ft,littab* lt);

void freefuntab(funtab* ft);

#endif // TABLES_H
