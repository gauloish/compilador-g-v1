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
extern int line;

void yyerror(const char*);

TreeNode* tree;
bool analysis_error = true;
%}

%define parse.trace
%define parse.error custom
%define parse.lac full

%locations

%union {
    char* lexeme;
    struct TreeNode* node;
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

%token IDENTIFICADOR    "'identificador'"
%token CADEIACARACTERES "literal de 'cadeia de caracteres'"
%token CARCONST         "literal de 'caractere'"
%token INTCONST         "literal de 'inteiro'"

// %token <lexeme> IDENTIFICADOR    "'identificador'"
// %token <lexeme> CADEIACARACTERES "literal de 'cadeia de caracteres'"
// %token <lexeme> CARCONST         "literal de 'caractere'"
// %token <lexeme> INTCONST         "literal de 'inteiro'"

// %type <node> Programa DeclPrograma Bloco
// %type <node> VarSection ListaDeclVar DeclVar Tipo
// %type <node> Comando ListaComando
// %type <node> Expr OrExpr AndExpr EqExpr DesigExpr AddExpr MulExpr UnExpr PrimExpr

%%

Programa     : DeclPrograma
             ;

DeclPrograma : PRINCIPAL Bloco
             ;

Bloco        : '{' ListaComando '}'
             | VarSection '{' ListaComando '}'
             ;

VarSection   : '{' ListaDeclVar '}'
             ;

ListaDeclVar : IDENTIFICADOR DeclVar ':' Tipo ';' ListaDeclVar
             | IDENTIFICADOR DeclVar ':' Tipo ';'
             ;

DeclVar      : %empty
             | ',' IDENTIFICADOR DeclVar
             ;

Tipo         : INT
             | CAR
             ;

ListaComando : Comando
             | Comando ListaComando
             ;

Comando      : ';'
             | Expr ';'
             | LEIA IDENTIFICADOR ';'
             | ESCREVA Expr ';'
             | ESCREVA CADEIACARACTERES ';'
             | NOVALINHA ';'
             | SE '(' Expr ')' ENTAO Comando FIMSE
             | SE '(' Expr ')' ENTAO Comando SENAO Comando FIMSE
             | ENQUANTO '(' Expr ')' Comando
             | Bloco
             ;

Expr         : OrExpr
             | IDENTIFICADOR '=' Expr
             ;

OrExpr       : OrExpr OU AndExpr
             | AndExpr
             ;

AndExpr      : AndExpr E EqExpr
             | EqExpr
             ;

EqExpr       : EqExpr IGUAL DesigExpr
             | EqExpr DIFERENTE DesigExpr
             | DesigExpr
             ;

DesigExpr    : DesigExpr '<' AddExpr
             | DesigExpr '>' AddExpr
             | DesigExpr MAIORIGUAL AddExpr
             | DesigExpr MENORIGUAL AddExpr
             | AddExpr
             ;

AddExpr      : AddExpr '+' MulExpr
             | AddExpr '-' MulExpr
             | MulExpr
             ;

MulExpr      : MulExpr '*' UnExpr
             | MulExpr '/' UnExpr
             | UnExpr
             ;

UnExpr       : '-' PrimExpr
             | '!' PrimExpr
             | PrimExpr
             ;

PrimExpr     : IDENTIFICADOR
             | CARCONST
             | INTCONST
             | '(' Expr ')'
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
        fprintf(stderr, "ERRO: %s - LINHA: %d\n", error, line);
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

    if (n == 0) {
        if (lookahead == YYSYMBOL_YYEMPTY) {
            snprintf(message, sizeof(message), "algo inesperado ocorreu");
        }
        else if (lookahead == YYSYMBOL_YYEOF) {
            snprintf(message, sizeof(message), "fim de arquivo inesperado");
        }
        else {
            snprintf(message, sizeof(message), "termo %s inesperado", yysymbol_name(lookahead));
        }
    }
    else {
        int offset = 0;

        for (int i = 0; i < n; i++) {
            if (i == 0) {
                offset += snprintf(message + offset, sizeof(message) - offset, "%s %s", "espera-se", yysymbol_name(expected[i]));
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
                offset += snprintf(message + offset, sizeof(message) - offset, " antes de %s", yysymbol_name(lookahead));
            }
        }
    }

    yyerror(message);

    return 0;
}