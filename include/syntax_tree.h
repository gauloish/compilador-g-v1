#ifndef __SYNTAX_TREE_H__
#define __SYNTAX_TREE_H__

typedef enum _TreeNodeKind TreeNodeKind;
typedef enum _TreeNodeDataType TreeNodeDataType;
typedef struct _TreeNode TreeNode;

TreeNode* tree_create_node(TreeNodeKind, TreeNodeDataType, TreeNode*, TreeNode*, char*);
TreeNodeKind tree_get_node_kind(TreeNode*);
TreeNodeDataType tree_get_node_data_type(TreeNode*);
TreeNode* tree_get_node_left(TreeNode*);
TreeNode* tree_get_node_right(TreeNode*);
char* tree_get_node_lexeme(TreeNode*);
void tree_set_node_type(TreeNode*, TreeNodeDataType);

/**
 * @brief Operation kind of node in Abstract Syntax Tree
 * 
 */
enum _TreeNodeKind {
    TREE_NODE_PROGRAMA,
    TREE_NODE_DECL_PROGRAMA,
    TREE_NODE_BLOCO,
    TREE_NODE_VAR_SECTION,
    TREE_NODE_LISTA_DECL_VAR,
    TREE_NODE_DECL_VAR,
    TREE_NODE_INT,
    TREE_NODE_CAR,
    TREE_NODE_LISTA_COMANDO,
    TREE_NODE_COMANDO,
    TREE_NODE_LEIA,
    TREE_NODE_ESCREVA_EXPRESSAO,
    TREE_NODE_ESCREVA_CADEIACARACTERES,
    TREE_NODE_NOVALINHA,
    TREE_NODE_SE_ENTAO,
    TREE_NODE_SE_ENTAO_SENAO,
    TREE_NODE_ENTAO_SENAO,
    TREE_NODE_ENQUANTO,
    TREE_NODE_ASSIGN_EXPR,
    TREE_NODE_OR_EXPR,
    TREE_NODE_AND_EXPR,
    TREE_NODE_EQ_EXPR,
    TREE_NODE_NEQ_EXPR,
    TREE_NODE_LE_EXPR,
    TREE_NODE_GE_EXPR,
    TREE_NODE_LEQ_EXPR,
    TREE_NODE_GEQ_EXPR,
    TREE_NODE_ADD_EXPR,
    TREE_NODE_SUB_EXPR,
    TREE_NODE_MUL_EXPR,
    TREE_NODE_DIV_EXPR,
    TREE_NODE_MINUS_EXPR,
    TREE_NODE_NEG_EXPR,
    TREE_NODE_IDENTIFICADOR,
    TREE_NODE_CARCONST,
    TREE_NODE_INTCONST,
    TREE_NODE_NOKIND,
};

/**
 * @brief Enum of data/ID types in Abstract Syntax Tree
 * 
 */
enum _TreeNodeDataType {
    TREE_NODE_INTEGER,
    TREE_NODE_CHARACTER,
    TREE_NODE_BOOL,
    TREE_NODE_STRING,
    TREE_NODE_NOTYPE,
};

#endif /* __SYNTAX_TREE_H__ */