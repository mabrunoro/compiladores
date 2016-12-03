
#ifndef TOKEN_H
#define TOKEN_H

typedef enum {
    IF,
    THEN,
    ELSE,
    END,
    REPEAT,
    UNTIL,
    READ,
    WRITE,
    PLUS,
    MINUS,
    TIMES,
    OVER,
    EQ,
    LT,
    LPAREN,
    RPAREN,
    SEMI,
    ASSIGN,
    NUM,
    ID
} TokenType;

static const char *TOKEN_TYPE_STRING[] = {
    "IF",
    "THEN",
    "ELSE",
    "END",
    "REPEAT",
    "UNTIL",
    "READ",
    "WRITE",
    "PLUS",
    "MINUS",
    "TIMES",
    "OVER",
    "EQ",
    "LT",
    "LPAREN",
    "RPAREN",
    "SEMI",
    "ASSIGN",
    "NUM",
    "ID"
};

#endif // TOKEN_H
