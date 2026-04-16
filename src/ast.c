#include <stdlib.h>

#include "../include/ast.h"

extern void yyerror(const char*);
extern int yylineno;

enum _Type {
    OPA,
};

struct _Node {
    Type type;
    Node* left;
    Node* middle;
    Node* right;
    char* lexeme;
    int line;
};

Node* create_node(Type type, Node* left, Node* middle, Node* right, char* lexeme) {
    Node* node = (Node*)malloc(sizeof(Node));

    if (node == NULL) {
        yyerror("MEMÓRIA INDISPONÍVEL!!!\n");
    }

    *node = (Node){
        .type = type,
        .left = left,
        .middle = middle,
        .right = right,
        .lexeme = lexeme,
        .line = yylineno,
    };

    return node;
}

char* get_type_name(char*) {
    // TODO: implement this function
    return NULL;
}