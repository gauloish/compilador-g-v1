#ifndef __AST_H__
#define __AST_H__

typedef enum _NodeType NodeType;
typedef struct _Node Node;

Node* create_node(NodeType, int, const char*, Node*, Node*);
char* get_type_name(char*);

#endif /* __AST_H__ */