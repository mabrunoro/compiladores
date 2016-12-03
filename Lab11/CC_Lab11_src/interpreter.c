
#include <stdio.h>
#include <stdlib.h>
#include "interpreter.h"

static int pilha[256];
int pos;

SymTable *st;

void inipilha()
{
	pos = 0;
	st = create_sym_table();
}

void push(int i)
{
	if(pos < 256) pilha[pos++] = i;
}

void pop()
{
	return (pos == 0 ? -1 : pilha[pos--]);
}

void finpilha()
{
	free_sym_table(st);
	pos = 0;
}

void run_ast(AST *ast) {
	switch(ast->kind)
	{
    	STMT_SEQ_NODE:
		run_seq_node(ast);
		break;

    	IF_NODE:
		run_if_node(ast);
		break;

    	REPEAT_NODE:
		run_repeat_node(ast);
		break;

    	ASSIGN_NODE:
		run_assign_node(ast);
		break;

    	READ_NODE:
		run_read_node(ast);
		break;

    	WRITE_NODE:
		run_write_node(ast);
		break;

    	PLUS_NODE:
		run_plus_node(ast);
		break;

    	MINUS_NODE:
		run_minus_node(ast);
		break;

    	TIMES_NODE:
		run_times_node(ast);
		break;

    	OVER_NODE:
		run_over_node(ast);
		break;

    	LT_NODE:
		run_lt_node(ast);
		break;

    	EQ_NODE:
		run_eq_node(ast);
		break;

    	NUM_NODE:
		run_num_node(ast);
		break;
		
    	ID_NODE:
		run_id_node(ast);
		break;
	}

    printf("Root: %p\n", ast);
}

void run_seq_node(AST* node)
{
	int i;
	for(i = 0; i < node->count; i++)
		run_ast(node->child[i]);
}

void run_if_node(AST* node)
{
	if(node->child[0]==NULL)
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		run_ast(node->child[0]);
		if(pop() == 1)
		{
			if(node->child[1]==NULL)
			{
				printf("Erro!\n");
				exit(0);
			}
			else
				run_ast(node->child[1]);
		}
	}
}

void run_repeat_node(AST* node)
{
	if(node->child[1]==NULL)
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		run_ast(node->child[1]);
		while(pop() == 1)
		{
			if(node->child[0]==NULL)
			{
				printf("Erro!\n");
				exit(0);
			}
			else
				run_ast(node->child[0]);
			run_ast(node->child[1]);
		}
	}
}

void run_assign_node(AST* node)
{
	if((node->child[0]==NULL) || (node->child[1]==NULL))
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		int i, j;
		run_ast(node->child[0]);
		i = pop();
		run_ast(node->child[1]);
		j = pop();
		st->t[i].value = j;
	}
}

void run_read_node(AST* node)
{
	if(node->child[0]==NULL)
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		run_ast(node->child);
		int i;
		scanf("%d",&i);
		st->t[pop()].value = i;
	}
}

void run_write_node(AST* node)
{
	if(node->child[0]==NULL)
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		run_ast(node->child[0]);
		printf("write: %d\n",pop());
	}
}

void run_plus_node(AST* node)
{
	if((node->child[0]==NULL) || (node->child[1]==NULL))
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		run_ast(node->child[0]);
		run_ast(node->child[1]);
		push(pop()+pop());
	}
}

void run_minus_node(AST* node)
{
	if((node->child[0]==NULL) || (node->child[1]==NULL))
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		run_ast(node->child[1]);
		run_ast(node->child[0]);
		push(pop()-pop());
	}
}

void run_times_node(AST* node)
{
	if((node->child[0]==NULL) || (node->child[1]==NULL))
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		run_ast(node->child[0]);
		run_ast(node->child[1]);
		push(pop()*pop());
	}
}

void run_over_node(AST* node)
{
	if((node->child[0]==NULL) || (node->child[1]==NULL))
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		run_ast(node->child[1]);
		run_ast(node->child[0]);
		push(pop()/pop());
	}
}

void run_lt_node(AST* node)
{
	if((node->child[0]==NULL) || (node->child[1]==NULL))
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		run_ast(node->child[1]);
		run_ast(node->child[0]);
		push( (pop() < pop()) ? 1 : 0 );
	}
}

void run_eq_node(AST* node)
{
	if((node->child[0]==NULL) || (node->child[1]==NULL))
	{
		printf("Erro!\n");
		exit(0);
	}
	else
	{
		run_ast(node->child[0]);
		run_ast(node->child[1]);
		push( (pop()==pop()) ? 1 : 0 );
	}
}

void run_id_node(AST* node)
