
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bt.h"

struct node {
	char kind[TAM_MAX_SYM];
	struct node *l, **r;
};

BT* create_node(const char* kind) {
	BT* node = malloc(sizeof * node);
	// node->kind = kind;
	strcpy(node->kind,kind);
	node->l = NULL;
	node->r = malloc(sizeof (TAM_MAX_RUL * (*node)));
	return node;
}

BT* new_leaf(const char* kind) {
	BT *leaf = create_node(kind);
	return leaf;
}

BT* new_node(const char* kind, BT *l, BT *r) {
	BT *node = create_node(kind);
	node->l = l;
	node->r = r;
	return node;
}

void print_node(BT *node, int level) {
	printf("%d: Node -- Addr: %p -- Kind: %s -- Data: %d -- Left: %p -- Right: %p\n",
	level, node, node->kind, node->l, node->r);
}

void print_bt(BT *tree, int level) {
	if (tree->l != NULL) print_bt(tree->l, level + 1);
	print_node(tree, level);
	if (tree->r != NULL) print_bt(tree->r, level + 1);
}

void print_tree(BT *tree) {
	print_bt(tree, 0);
}

void free_tree(BT *tree) {
	if (tree != NULL) {
		free_tree(tree->l);
		//      free_tree(tree->r);
		int i;
		for(i = 0; (i < TAM_MAX_RUL) && (tree->r[i] != NULL); i++)
		free_tree(tree->r[i]);
		free(tree);
	}
}

// Dot output.

void node2str(BT *node, char *s) {
	switch(node->kind) {
		case NUMBER_NODE: sprintf(s, "%d", node->data); break;
		case PLUS_NODE:   sprintf(s, "%s", "+"); break;
		case MINUS_NODE:  sprintf(s, "%s", "-"); break;
		case TIMES_NODE:  sprintf(s, "%s", "*"); break;
		case OVER_NODE:   sprintf(s, "%s", "/"); break;
		default: printf("Invalid node kind: %d!\n", node->kind);
	}
}

int nr;

int print_node_dot(BT *node) {
	char s[10];
	int my_nr = nr++;
	node2str(node, s);
	printf("node%d[label=\"%s\"];\n", my_nr, s);
	if (node->l != NULL) {
		int l_nr = print_node_dot(node->l);
		printf("node%d -> node%d;\n", my_nr, l_nr);
	}
	if (node->r != NULL) {
		int r_nr = print_node_dot(node->r);
		printf("node%d -> node%d;\n", my_nr, r_nr);
	}
	return my_nr;
}

void print_dot(BT *tree) {
	nr = 0;
	printf("digraph {\ngraph [ordering=\"out\"];\n");
	print_node_dot(tree);
	printf("}\n");
}
