#include <stdlib.h>

#include "../include/memory.h"
#include "../include/syntax_tree.h"

extern void yyerror(const char*);
extern int yylineno;

/**
 * @brief Operation kind of node in Abstract Syntax Tree
 * 
 */
enum _OperationKind {
    OPA,
};

/**
 * @brief Enum of data/ID types in Abstract Syntax Tree
 * 
 */
enum _DataType {
    INTEGER,
    CHARACTER,
    STRING,
    NONE,
};

/**
 * @brief Abstract Syntax Tree node struct
 * 
 */
struct _TreeNode {
    OperationKind kind;
    DataType type;
    TreeNode* left;
    TreeNode* right;
    char* lexeme;
    int line;
};

/**
 * @brief Create a tree node object for build Abstract Syntax Tree
 * 
 * @param kind Kind of operation represented by the node
 * @param type Type of data lexeme or ID represented by the node
 * @param left Left child of this node
 * @param right Right child of this node
 * @param lexeme Lexeme for ID or literal data
 * @return TreeNode* A node for build Abstracted Syntax Tree
 */
TreeNode* create_tree_node(OperationKind kind, DataType type, TreeNode* left, TreeNode* right, char* lexeme) {
    TreeNode* node = (TreeNode*) allocate_memory(sizeof(TreeNode));

    if (node == NULL) {
        yyerror("MEMÓRIA INSUFICIENTE!!!\n");
    }

    *node = (TreeNode){
        .kind = kind,
        .type = type,
        .left = left,
        .right = right,
        .lexeme = lexeme,
        .line = yylineno,
    };

    return node;
}