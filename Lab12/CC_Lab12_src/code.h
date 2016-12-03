#ifndef CODE_H
#define CODE_H

#include "ast.h"

typedef enum {
    HALT,
    IN,
    OUT,
    ADD,
    SUB,
    MUL,
    DIV,
    LD,     // Load variable
    LDA,    // Load address
    LDC,    // Load constant
    ST,     // Store
    JON,    // Jump On Negative
    JNZ,    // Jump on Not Zero
    JMP     // Unconditional jump
} OpCode;

static char* OpStr[] =
{ "HALT", "IN", "OUT", "ADD", "SUB", "MUL", "DIV",
  "LD", "LDA", "LDC", "ST", "JON", "JNZ", "JMP" };

static int OpCount[] =
{ 0, 1, 1, 3, 3, 3, 3,
  3, 3, 2, 3, 2, 2, 1 };

// Traverses the given AST and emits the corresponding TM ASM code to STDOUT.
void emit_code(AST *ast);

int emit_recursively(AST *ast);

#endif
