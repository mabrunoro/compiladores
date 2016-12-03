#include <stdlib.h>
#include <stdio.h>
#include "ast.h"
#include "code.h"

int temp;

int newtemp()
{
	return ++temp;
}

int opsize(OpCode op)
{
	switch (op)
	{
		case HALT:
		return 4;

		case IN:
		return 2;

		case LD:
		return 2;

		case ST:
		return 2;

		default:
		return 3;
	}
	return 0;
}

void emit1(OpCode op, int reg1)
{
	int i = opsize(op);
	printf("%s",OpStr[op]);
	int j;
	for(j = 0; j < i; j++)
		printf(" ");
	printf("r%d\n",reg1);
}

void emit2(OpCode op, int reg1, int reg2)
{
	int i = opsize(op);
	printf("%s",OpStr[op]);
	int j;
	for(j = 0; j < i; j++)
		printf(" ");
	printf("r%d, r%d\n",reg1,reg2);
}

void emit3(OpCode op, int reg1, int reg2, int reg3)
{
	int i = opsize(op);
	printf("%s",OpStr[op]);
	int j;
	for(j = 0; j < i; j++)
		printf(" ");
	printf("r%d, r%d, r%d\n",reg1,reg2,reg3);
}


void emit_seq(AST* n)
{
	int i;
	for(i = 0; i < get_child_count(n); i++)
		emit_recursively(get_child(n,i));
}

// void emit_read(AST* node)
// {
// 	if(node->child[0]==NULL)
// 	{
// 		printf("Erro!\n");
// 		exit(0);
// 	}
// 	else
// 	{
// 		run_ast(node->child);
// 		int i;
// 		scanf("%d",&i);
// 		st->t[pop()].value = i;
// 	}
// }

void emit_write(AST* node)
{
	if(get_child(node,0)==NULL)
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		int t = emit_recursively(get_child(node,0));
		emit1(OUT,t);
		// printf("write: %d\n",pop());
	}
}

int emit_plus(AST* node)
{
	if((get_child(node,0)==NULL) || (get_child(node,1)==NULL))
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		int l = emit_recursively(get_child(node,0));
		int r = emit_recursively(get_child(node,1));
		int t = newtemp();
		emit3(ADD,t,r,l);
		return t;
	}
}

int emit_num(AST *ast)
{
	int t = newtemp();
	emit2(LDC,t,get_data(ast));
	return t;
}

int emit_recursively(AST *ast)
{
	switch(get_kind(ast))
	{
    	STMT_SEQ_NODE:
		emit_seq(ast);
		return -1;

    // 	IF_NODE:
		// emit_if(ast);
		// break;
		//
    // 	REPEAT_NODE:
		// emit_repeat(ast);
		// break;
		//
    // 	ASSIGN_NODE:
		// emit_assign(ast);
		// break;

    // 	READ_NODE:
		// emit_read(ast);
		// break;

    	WRITE_NODE:
		emit_write(ast);
		return -1;

    	PLUS_NODE:
		return emit_plus(ast);

    // 	MINUS_NODE:
		// emit_minus(ast);
		// break;
		//
    // 	TIMES_NODE:
		// emit_times(ast);
		// break;
		//
    // 	OVER_NODE:
		// emit_over(ast);
		// break;
		//
    // 	LT_NODE:
		// emit_lt(ast);
		// break;
		//
    // 	EQ_NODE:
		// emit_eq(ast);
		// break;

    	NUM_NODE:
		return emit_num(ast);

    // 	ID_NODE:
		// emit_id(ast);
		// break;
	}
	return 0;
}

void emit_code(AST *ast)
{
	temp = 0;

	emit_recursively(AST *ast);

	printf("Root: %p\n", ast);
}
