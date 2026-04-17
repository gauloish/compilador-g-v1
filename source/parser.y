%{
#include <stdio.h>
#include <stdlib.h>

#include "../include/memory.h"
#include "../include/syntax_tree.h"

extern int yylex();
extern char* yytext;
extern int yyleng;
extern int yylineno;
extern int line;

void yyerror(const char*);
%}

%define parse.trace
%define parse.error detailed

%union {
    char* lexeme;
}

%start Programa

%token PRINCIPAL        "'principal'"
%token IDENTIFICADOR    "'identificador'"
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
%token CADEIACARACTERES "literal de 'cadeia de caracteres'"
%token OU               "'ou'"
%token E                "'e'"
%token IGUAL            "'='"
%token DIFERENTE        "'!='"
%token MAIORIGUAL       "'>='"
%token MENORIGUAL       "'<='"
%token CARCONST         "literal de 'caractere'"
%token INTCONST         "literal de 'inteiro'"

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

    fprintf(stderr, "ERRO: %s - LINHA: %d\n", error, line);
    
    exit(EXIT_FAILURE);
}