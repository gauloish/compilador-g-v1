%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "../include/memory.h"
#include "../include/syntax_tree.h"

extern int yylex();
extern char* yytext;
extern int yyleng;
extern int yylineno;

void yyerror(const char*);

TreeNode* tree;
bool analysis_error = true;
%}

%define parse.trace
%define parse.error custom

%locations

%code requires {
    #include "../include/syntax_tree.h"
}

%union {
    char* lexeme;
    TreeNode* node;
}

%start Programa

%token PRINCIPAL        "'principal'"
%token INT              "'int'"
%token CAR              "'car'"
%token LEIA             "'leia'"
%token ESCREVA          "'escreva'"
%token NOVALINHA        "'novalinha'"
%token SE               "'se'"
%token ENTAO            "'entao'"
%token SENAO            "'senao'"
%token FIMSE            "'fimse'"
%token ENQUANTO         "'enquanto'"
%token OU               "'ou'"
%token E                "'e'"
%token IGUAL            "'='"
%token DIFERENTE        "'!='"
%token MAIORIGUAL       "'>='"
%token MENORIGUAL       "'<='"

%token <lexeme> IDENTIFICADOR    "'identificador'"
%token <lexeme> CADEIACARACTERES "literal de 'cadeia de caracteres'"
%token <lexeme> CARCONST         "literal de 'caractere'"
%token <lexeme> INTCONST         "literal de 'inteiro'"

%type <node> Programa DeclPrograma Bloco
%type <node> VarSection ListaDeclVar DeclVar Tipo
%type <node> Comando ListaComando
%type <node> Expr OrExpr AndExpr EqExpr DesigExpr AddExpr MulExpr UnExpr PrimExpr

%%

Programa     : DeclPrograma {
                    tree = tree_create_node(
                        TREE_NODE_PROGRAMA,
                        TREE_NODE_NOTYPE,
                        $1,
                        NULL,
                        NULL
                    );
                }
             ;

DeclPrograma : PRINCIPAL Bloco {
                    $$ = tree_create_node(
                        TREE_NODE_DECL_PROGRAMA,
                        TREE_NODE_NOTYPE,
                        $2,
                        NULL,
                        NULL
                    );
                }
             ;

Bloco        : '{' ListaComando '}' {
                    $$ = tree_create_node(
                        TREE_NODE_BLOCO,
                        TREE_NODE_NOTYPE,
                        $2,
                        NULL,
                        NULL
                    );
                }
             | VarSection '{' ListaComando '}' {
                    $$ = tree_create_node(
                        TREE_NODE_BLOCO,
                        TREE_NODE_NOTYPE,
                        $3,
                        $1,
                        NULL
                    );
                }
             ;

VarSection   : '{' ListaDeclVar '}' {
                    $$ = tree_create_node(
                        TREE_NODE_VAR_SECTION,
                        TREE_NODE_NOTYPE,
                        $2,
                        NULL,
                        NULL
                    );
                }
             ;

ListaDeclVar : IDENTIFICADOR DeclVar ':' Tipo ';' ListaDeclVar {
                    TreeNodeDataType type = tree_get_node_data_type($4);

                    TreeNode* node = tree_create_node(
                        TREE_NODE_DECL_VAR,
                        type,
                        $2,
                        NULL,
                        $1
                    );

                    $$ = tree_create_node(
                        TREE_NODE_LISTA_DECL_VAR,
                        TREE_NODE_NOTYPE,
                        node,
                        $6,
                        NULL
                    );

                    while (node != NULL) {
                        tree_set_node_type(node, type);
                        node = tree_get_node_left(node);
                    }
                }
             | IDENTIFICADOR DeclVar ':' Tipo ';' {
                    TreeNodeDataType type = tree_get_node_data_type($4);

                    TreeNode* node = tree_create_node(
                        TREE_NODE_DECL_VAR,
                        type,
                        $2,
                        NULL,
                        $1
                    );

                    $$ = tree_create_node(
                        TREE_NODE_LISTA_DECL_VAR,
                        TREE_NODE_NOTYPE,
                        node,
                        NULL,
                        NULL
                    );

                    while (node != NULL) {
                        tree_set_node_type(node, type);
                        node = tree_get_node_left(node);
                    }
                }
             ;

DeclVar      : %empty {
                    $$ = NULL;
                }
             | ',' IDENTIFICADOR DeclVar {
                    $$ = tree_create_node(
                        TREE_NODE_DECL_VAR,
                        TREE_NODE_NOTYPE,
                        $3,
                        NULL,
                        $2
                    );
                }
             ;

Tipo         : INT {
                    $$ = tree_create_node(
                        TREE_NODE_INT,
                        TREE_NODE_INTEGER,
                        NULL,
                        NULL,
                        NULL
                    );
                }
             | CAR {
                    $$ = tree_create_node(
                        TREE_NODE_CAR,
                        TREE_NODE_CHARACTER,
                        NULL,
                        NULL,
                        NULL
                    );
                }
             ;

ListaComando : Comando {
                    $$ = tree_create_node(
                        TREE_NODE_LISTA_COMANDO,
                        TREE_NODE_NOTYPE,
                        $1,
                        NULL,
                        NULL
                    );
                }
             | Comando ListaComando {
                    $$ = tree_create_node(
                        TREE_NODE_LISTA_COMANDO,
                        TREE_NODE_NOTYPE,
                        $1,
                        $2,
                        NULL
                    );
             }
             ;

Comando      : ';' {
                    $$ = NULL;
                }
             | Expr ';'
             | LEIA IDENTIFICADOR ';' {
                    $$ = tree_create_node(
                        TREE_NODE_LEIA,
                        TREE_NODE_NOTYPE,
                        NULL,
                        NULL,
                        $2
                    );
                }
             | ESCREVA Expr ';' {
                    $$ = tree_create_node(
                        TREE_NODE_ESCREVA_EXPRESSAO,
                        TREE_NODE_NOTYPE,
                        $2,
                        NULL,
                        NULL
                    );
                }
             | ESCREVA CADEIACARACTERES ';' {
                    $$ = tree_create_node(
                        TREE_NODE_ESCREVA_CADEIACARACTERES,
                        TREE_NODE_STRING,
                        NULL,
                        NULL,
                        $2
                    );
                }
             | NOVALINHA ';' {
                    $$ = tree_create_node(
                        TREE_NODE_NOVALINHA,
                        TREE_NODE_NOTYPE,
                        NULL,
                        NULL,
                        NULL
                    );
                }
             | SE '(' Expr ')' ENTAO Comando FIMSE {
                    $$ = tree_create_node(
                        TREE_NODE_SE_ENTAO,
                        TREE_NODE_NOTYPE,
                        $3,
                        $6,
                        NULL
                    );
                }
             | SE '(' Expr ')' ENTAO Comando SENAO Comando FIMSE {
                    TreeNode* node = tree_create_node(
                        TREE_NODE_ENTAO_SENAO,
                        TREE_NODE_NOTYPE,
                        $6,
                        $8,
                        NULL
                    );

                    $$ = tree_create_node(
                        TREE_NODE_SE_ENTAO_SENAO,
                        TREE_NODE_NOTYPE,
                        $3,
                        node,
                        NULL
                    );
                }
             | ENQUANTO '(' Expr ')' Comando {
                    $$ = tree_create_node(
                        TREE_NODE_ENQUANTO,
                        TREE_NODE_NOTYPE,
                        $3,
                        $5,
                        NULL
                    );
                }
             | Bloco {
                    $$ = $1;
                }
             ;

Expr         : OrExpr {
                    $$ = $1;
                }
             | IDENTIFICADOR '=' Expr {
                    $$  = tree_create_node(
                        TREE_NODE_ASSIGN_EXPR,
                        TREE_NODE_NOTYPE,
                        $3,
                        NULL,
                        $1
                    );
                }
             ;

OrExpr       : OrExpr OU AndExpr {
                    $$ = tree_create_node(
                        TREE_NODE_OR_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | AndExpr {
                    $$ = $1;
                }
             ;

AndExpr      : AndExpr E EqExpr {
                    $$ = tree_create_node(
                        TREE_NODE_AND_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | EqExpr {
                    $$ = $1;
                }
             ;

EqExpr       : EqExpr IGUAL DesigExpr {
                    $$ = tree_create_node(
                        TREE_NODE_EQ_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | EqExpr DIFERENTE DesigExpr {
                    $$ = tree_create_node(
                        TREE_NODE_NEQ_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | DesigExpr {
                    $$ = $1;
                }
             ;

DesigExpr    : DesigExpr '<' AddExpr {
                    $$ = tree_create_node(
                        TREE_NODE_LE_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | DesigExpr '>' AddExpr {
                    $$ = tree_create_node(
                        TREE_NODE_GE_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | DesigExpr MENORIGUAL AddExpr {
                    $$ = tree_create_node(
                        TREE_NODE_LEQ_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | DesigExpr MAIORIGUAL AddExpr {
                    $$ = tree_create_node(
                        TREE_NODE_GEQ_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | AddExpr {
                    $$ = $1;
                }
             ;

AddExpr      : AddExpr '+' MulExpr {
                    $$ = tree_create_node(
                        TREE_NODE_ADD_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | AddExpr '-' MulExpr {
                    $$ = tree_create_node(
                        TREE_NODE_SUB_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | MulExpr {
                    $$ = $1;
                }
             ;

MulExpr      : MulExpr '*' UnExpr {
                    $$ = tree_create_node(
                        TREE_NODE_MUL_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | MulExpr '/' UnExpr {
                    $$ = tree_create_node(
                        TREE_NODE_DIV_EXPR,
                        TREE_NODE_NOTYPE,
                        $1,
                        $3,
                        NULL
                    );
                }
             | UnExpr {
                    $$ = $1;
                }
             ;

UnExpr       : '-' PrimExpr {
                    $$ = tree_create_node(
                        TREE_NODE_MINUS_EXPR,
                        TREE_NODE_NOTYPE,
                        $2,
                        NULL,
                        NULL
                    );
                }
             | '!' PrimExpr {
                    $$ = tree_create_node(
                        TREE_NODE_NEG_EXPR,
                        TREE_NODE_NOTYPE,
                        $2,
                        NULL,
                        NULL
                    );
                }
             | PrimExpr {
                    $$ = $1;
                }
             ;

PrimExpr     : IDENTIFICADOR {
                    $$ = tree_create_node(
                        TREE_NODE_IDENTIFICADOR,
                        TREE_NODE_NOTYPE,
                        NULL,
                        NULL,
                        $1
                    );
                }
             | CARCONST {
                    $$ = tree_create_node(
                        TREE_NODE_CARCONST,
                        TREE_NODE_NOTYPE,
                        NULL,
                        NULL,
                        $1
                    );
                }
             | INTCONST {
                    $$ = tree_create_node(
                        TREE_NODE_INTCONST,
                        TREE_NODE_NOTYPE,
                        NULL,
                        NULL,
                        $1
                    );
                }
             | '(' Expr ')' {
                    $$ = $2;
                }
             ;

%%

/**
 * @brief Print the error, free the allocated memory and exit program
 * 
 * @param error Error to be printed
 */
void yyerror(const char *error) {
    end_memory();

    if (analysis_error) {
        fprintf(stderr, "ERRO: %s - LINHA: %d, COLUNA: %d\n", error, yylloc.first_line, yylloc.first_column);
    }
    else {
        fprintf(stderr, "ERRO: %s\n", error);
    }
    
    exit(EXIT_FAILURE);
}

/**
 * @brief Report and format syntax error for yyerror call
 *
 * @param context Error context with all information for report error
 * @return Success
 */
int yyreport_syntax_error(const yypcontext_t *context) {
    char message[512];

    enum {
        TOKENMAX = 10
    };

    yysymbol_kind_t lookahead = yypcontext_token(context);
    yysymbol_kind_t expected[TOKENMAX];

    int n = yypcontext_expected_tokens(context, expected, TOKENMAX);
    int offset = 0;

    if (n == 0) {
        if (lookahead == YYSYMBOL_YYEMPTY) {
            offset += snprintf(message + offset, sizeof(message) - offset, "Algo inesperado ocorreu");
        }
        else if (lookahead == YYSYMBOL_YYEOF) {
            offset += snprintf(message + offset, sizeof(message) - offset, "Fim de arquivo inesperado");
        }
        else {
            offset += snprintf(message + offset, sizeof(message) - offset, "Termo %s inesperado", yysymbol_name(lookahead));
        }
    }
    else {
        for (int i = 0; i < n; i++) {
            if (i == 0) {
                offset += snprintf(message + offset, sizeof(message) - offset, "%s %s", "Espera-se", yysymbol_name(expected[i]));
            }
            else {
                offset += snprintf(message + offset, sizeof(message) - offset, "%s %s", " ou", yysymbol_name(expected[i]));
            }
        }

        if (lookahead != YYSYMBOL_YYEMPTY) {
            if (lookahead == YYSYMBOL_YYEOF) {
                offset += snprintf(message + offset, sizeof(message) - offset, " antes do fim de arquivo");
            }
            else {
                bool has_lexeme = (
                    (lookahead == YYSYMBOL_IDENTIFICADOR) ||
                    (lookahead == YYSYMBOL_CADEIACARACTERES) ||
                    (lookahead == YYSYMBOL_INTCONST) ||
                    (lookahead == YYSYMBOL_CARCONST)
                );

                if (has_lexeme) {
                    offset += snprintf(message + offset, sizeof(message) - offset, " antes de %s (valor: '%s')", yysymbol_name(lookahead), yytext);
                }
                else {
                    offset += snprintf(message + offset, sizeof(message) - offset, " antes de %s", yysymbol_name(lookahead));
                }
            }
        }
    }

    yyerror(message);

    return 0;
}