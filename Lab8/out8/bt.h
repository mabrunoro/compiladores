#ifndef BT_H
#define BT_H

/*typedef enum {
	SEMI_NODE,
	IF_NOME,
	THEN_NODE,
	ELSE_NODE,
	END_NODE,
	REPEAT_NODE,
	UNTIL_NODE,
	READ_NODE,
	WRITE_NODE,
	PLUS_NODE,
	MINUS_NODE,
	TIMES_NODE,
	OVER_NODE,
	EQ_NODE,
	LT_NODE,
	OP_NODE,
	CP_NODE,
	ASSIGN_NODE,
	NUMBER_NODE,
	ID_NODE
} NodeKind;*/

#define TAM_MAX_SYM 10;
#define TAM_MAX_RUL 7;

struct node; // Opaque structure to ensure encapsulation.

typedef struct node BT;

BT* new_leaf(const char* kind, int data);
BT* new_node(const char* kind, BT *l, BT *r);

void print_tree(BT *tree);
void free_tree(BT *tree);

void print_dot(BT *tree);


#endif
