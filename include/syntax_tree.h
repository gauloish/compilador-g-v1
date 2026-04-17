#ifndef __SYNTAX_TREE_H__
#define __SYNTAX_TREE_H__

typedef enum _OperationKind OperationKind;
typedef enum _DataType DataType;
typedef struct _TreeNode TreeNode;

TreeNode* create_tree_node(OperationKind, DataType, TreeNode*, TreeNode*, char*);

#endif /* __SYNTAX_TREE_H__ */