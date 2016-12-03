#ifndef INTERPRETER_H
#define INTERPRETER_H

#include "tree.h"
#include "table.h"

#define STACKSIZE 1024

void runast(tree *ast);

void execast(tree* arv,funtab *f, symtab *s, littab *l);

#endif
