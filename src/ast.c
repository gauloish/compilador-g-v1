#include <stdlib.h>

#include "../include/ast.h"

// TODO: implement the structs, enums and methods
enum _Kind {
    OPA
};

enum _Type {
    Integer,
    Character,
    String,
    None,
};

union _Value {
    int integer;
    char character;
    char* string;
};

struct _Node {
    Kind kind;
    Type type;
    Value value;
    int line;
    Node* left;
    Node* middle;
    Node* right;
};

Node* create_node(Kind kind, Type type, Value value, Node* left, Node* middle, Node* right) {
    Node* node = NULL;

    while (node == NULL) {
        node = (Node*)malloc(sizeof(Node));
    }

    *node = (Node){
        .kind = kind,
        .type = type,
        .value = value,
        .left = left,
        .middle = middle,
        .right = right
    };

    return node;
}

char* get_type_name(char*) {
    // TODO: implement this function
    return NULL;
}