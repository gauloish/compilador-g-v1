#ifndef __AST_H__
#define __AST_H__

typedef enum _Kind Kind;
typedef enum _Type Type;
typedef union _Value Value;
typedef struct _Node Node;

Node* create_node(Kind, Type, Value, Node*, Node*, Node*);
char* get_type_name(char*);

#endif /* __AST_H__ */