#ifndef __AST_H__
#define __AST_H__

typedef enum _Type Type;
typedef struct _Node Node;

Node* create_node(Type, Node*, Node*, Node*, char*, int);
char* get_type_name(char*);

#endif /* __AST_H__ */