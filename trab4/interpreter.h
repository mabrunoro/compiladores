#ifndef INTERPRETER_H
#define INTERPRETER_H

#include "tree.h"
#include "table.h"

#define STACKSIZE 1024

void inipilha();

void finpilha();

int runast(tree *ast);

void execast(tree* arv,funtab *f, symtab *s, littab *l);

int runprogramnode(tree* node);
int runfuncdecllistnode(tree* node);
int runfuncdeclnode(tree* node);
int runfuncheadernode(tree* node);
int runfuncbodynode(tree* node);
int runoptvardeclnode(tree* node);
int runoptstmtlistnode(tree* node);
int runrettypenode(tree* node);
int runparamsnode(tree* node);
int runparamlistnode(tree* node);
int runparamnode(tree* node);
int runvardecllistnode(tree* node);
int runvardeclnode(tree* node);
int runstmtlistnode(tree* node);
int runstmtnode(tree* node);
int runassignstmtnode(tree* node);
int runlvalnode(tree* node);
int runifstmtnode(tree* node);
int runblocknode(tree* node);
int runwhilestmtnode(tree* node);
int runreturnstmtnode(tree* node);
int runfunccallnode(tree* node);
int runinputcallnode(tree* node);
int runoutputcallnode(tree* node);
int runwritecallnode(tree* node);
int runuserfunccallnode(tree* node);
int runoptarglistnode(tree* node);
int runarglistnode(tree* node);
int runboolexprnode(tree* node);
int runboolopnode(tree* node);
int runarithexprnode(tree* node);
int runidnnode(tree* node);
int runstringnnode(tree* node);
int runnumnnode(tree *n);

#endif
