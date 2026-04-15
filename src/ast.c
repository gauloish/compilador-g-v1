#include "../include/ast.h"

// TODO: implement the structs, enums and methods
typedef enum _NodeType NodeType;
typedef struct _Node Node;

Node* create_node(NodeType, int, const char*, Node*, Node*);
char* get_type_name(char*);