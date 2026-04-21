#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

#include "../include/memory.h"
#include "../include/syntax_tree.h"

extern char* yytext;

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
    int column;
};

char* opa(TreeNodeKind kind) {
    static char* op;

    switch (kind) {
        case TREE_NODE_PROGRAMA:
            op = "PROGRAMA";
            break;
        case TREE_NODE_DECL_PROGRAMA:
            op = "DECL_PROGRAMA";
            break;
        case TREE_NODE_BLOCO:
            op = "BLOCO";
            break;
        case TREE_NODE_VAR_SECTION:
            op = "VAR_SECTION";
            break;
        case TREE_NODE_LISTA_DECL_VAR:
            op = "LISTA_DECL_VAR";
            break;
        case TREE_NODE_DECL_VAR:
            op = "DECL_VAR";
            break;
        case TREE_NODE_INT:
            op = "INT";
            break;
        case TREE_NODE_CAR:
            op = "CAR";
            break;
        case TREE_NODE_LISTA_COMANDO:
            op = "LISTA_COMANDO";
            break;
        case TREE_NODE_COMANDO:
            op = "COMANDO";
            break;
        case TREE_NODE_LEIA:
            op = "LEIA";
            break;
        case TREE_NODE_ESCREVA_EXPRESSAO:
            op = "ESCREVA_EXPRESSAO";
            break;
        case TREE_NODE_ESCREVA_CADEIACARACTERES:
            op = "ESCREVA_CADEIACARACTERES";
            break;
        case TREE_NODE_NOVALINHA:
            op = "NOVALINHA";
            break;
        case TREE_NODE_SE_ENTAO:
            op = "SE_ENTAO";
            break;
        case TREE_NODE_SE_ENTAO_SENAO:
            op = "SE_ENTAO_SENAO";
            break;
        case TREE_NODE_ENTAO_SENAO:
            op = "ENTAO_SENAO";
            break;
        case TREE_NODE_ENQUANTO:
            op = "ENQUANTO";
            break;
        case TREE_NODE_ASSIGN_EXPR:
            op = "ASSIGN_EXPR";
            break;
        case TREE_NODE_OR_EXPR:
            op = "OR_EXPR";
            break;
        case TREE_NODE_AND_EXPR:
            op = "AND_EXPR";
            break;
        case TREE_NODE_EQ_EXPR:
            op = "EQ_EXPR";
            break;
        case TREE_NODE_NEQ_EXPR:
            op = "NEQ_EXPR";
            break;
        case TREE_NODE_LE_EXPR:
            op = "LE_EXPR";
            break;
        case TREE_NODE_GE_EXPR:
            op = "GE_EXPR";
            break;
        case TREE_NODE_LEQ_EXPR:
            op = "LEQ_EXPR";
            break;
        case TREE_NODE_GEQ_EXPR:
            op = "GEQ_EXPR";
            break;
        case TREE_NODE_ADD_EXPR:
            op = "ADD_EXPR";
            break;
        case TREE_NODE_SUB_EXPR:
            op = "SUB_EXPR";
            break;
        case TREE_NODE_MUL_EXPR:
            op = "MUL_EXPR";
            break;
        case TREE_NODE_DIV_EXPR:
            op = "DIV_EXPR";
            break;
        case TREE_NODE_MINUS_EXPR:
            op = "MINUS_EXPR";
            break;
        case TREE_NODE_NEG_EXPR:
            op = "NEG_EXPR";
            break;
        case TREE_NODE_IDENTIFICADOR:
            op = "IDENTIFICADOR";
            break;
        case TREE_NODE_CARCONST:
            op = "CARCONST";
            break;
        case TREE_NODE_INTCONST:
            op = "INTCONST";
            break;
        case TREE_NODE_NOKIND:
            op = "NOKIND";
            break;
        default:
            op = "default";
            break;
    }

    return op;
}

/**
 * @brief Create a tree node object for build Abstract Syntax Tree
 * 
 * @param kind Kind of operation represented by the node
 * @param type Type of data lexeme or ID represented by the node
 * @param left Left child of this node
 * @param right Right child of this node
 * @param lexeme Lexeme for ID or literal data
 * @param line Line where token is in the code
 * @param column Column where token is in the code
 * @return TreeNode* A node for build Abstracted Syntax Tree
 */
TreeNode* tree_node_create(
    TreeNodeKind kind,
    TreeNodeDataType type,
    TreeNode* left,
    TreeNode* right,
    char* lexeme,
    int line,
    int column
) {
    TreeNode* node = (TreeNode*) allocate_memory(sizeof(TreeNode));

    *node = (TreeNode){
        .kind = kind,
        .type = type,
        .left = left,
        .right = right,
        .lexeme = lexeme,
        .line = line,
        .column = column,
    };

    printf("(%d, %d): %s\n", line, column, opa(kind));

    return node;
}

/**
 * @brief Get node kind
 *
 * @param node Tree node
 * @return Node kind
 */
TreeNodeKind tree_node_get_kind(TreeNode* node) {
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
TreeNodeDataType tree_node_get_data_type(TreeNode* node) {
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
TreeNode* tree_node_get_left(TreeNode* node) {
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
TreeNode* tree_node_get_right(TreeNode* node) {
    if (node == NULL) {
        return NULL;
    }

    return node->right;
}

/**
 * @brief Get node line
 *
 * @param node Tree node
 * @return Node line
 */
int tree_node_get_line(TreeNode* node) {
    if (node == NULL) {
        return 0;
    }

    return node->line;
}

/**
 * @brief Get node column
 *
 * @param node Tree node
 * @return Node line
 */
int tree_node_get_column(TreeNode* node) {
    if (node == NULL) {
        return 0;
    }

    return node->column;
}

/**
 * @brief Get node lexeme
 *
 * @param node Tree node
 * @return Node lexeme
 */
char* tree_node_get_lexeme(TreeNode* node) {
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
void tree_node_set_type(TreeNode* node, TreeNodeDataType type) {
    if (node == NULL) {
        return;
    }

    node->type = type;
}