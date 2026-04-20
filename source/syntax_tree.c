#include <stdlib.h>
#include <stdbool.h>

#include "../include/memory.h"
#include "../include/syntax_tree.h"

extern void yyerror(const char*);
extern int yylineno;
extern bool analysis_error;


/**
 * @brief Abstract Syntax Tree node struct
 * 
 */
struct _TreeNode {
    TreeNodeKind kind;
    TreeNodeDataType type;
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
TreeNode* tree_create_node(
    TreeNodeKind kind,
    TreeNodeDataType type,
    TreeNode* left,
    TreeNode* right,
    char* lexeme
) {
    TreeNode* node = (TreeNode*) allocate_memory(sizeof(TreeNode));

    if (node == NULL) {
        analysis_error = false;
        yyerror("Memória Insuficiente!!!\n");
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

/**
 * @brief Get node kind
 *
 * @param node Tree node
 * @return Node kind
 */
TreeNodeKind tree_get_node_kind(TreeNode* node) {
    if (node == NULL) {
        return TREE_NODE_NOKIND;
    }

    return node->kind;
}

/**
 * @brief Get node data type
 *
 * @param node Tree node
 * @return Node data type
 */
TreeNodeDataType tree_get_node_data_type(TreeNode* node) {
    if (node == NULL) {
        return TREE_NODE_NOTYPE;
    }

    return node->type;
}

/**
 * @brief Get node left
 *
 * @param node Tree node
 * @return Node left
 */
TreeNode* tree_get_node_left(TreeNode* node) {
    if (node == NULL) {
        return NULL;
    }

    return node->left;
}

/**
 * @brief Get node right
 *
 * @param node Tree node
 * @return Node right
 */
TreeNode* tree_get_node_right(TreeNode* node) {
    if (node == NULL) {
        return NULL;
    }

    return node->right;
}

/**
 * @brief Get node lexeme
 *
 * @param node Tree node
 * @return Node lexeme
 */
char* tree_get_node_lexeme(TreeNode* node) {
    if (node == NULL) {
        return NULL;
    }

    return node->lexeme;
}

/**
 * @brief Set node type
 *
 * @param node Tree node
 */
void tree_set_node_type(TreeNode* node, TreeNodeDataType type) {
    if (node == NULL) {
        return;
    }

    node->type = type;
}