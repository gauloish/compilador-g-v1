%{
#include <stdio.h>
#include <stdlib.h>

#include "../include/ast.h"

extern int yylex();
extern char * yytext;
extern int yyleng;

void yyerror(char const *s);
%}

%define parse.trace

%union {
    int ival;
    char cval;
    char *sval;
    Node *node;
}

%start Program


%token PRINCIPAL
%token IDENTIFICADOR
%token INT
%token CAR
%token LEIA
%token ESCREVA
%token NOVALINHA
%token SE
%token ENTAO
%token SENAO
%token FIMSE
%token ENQUANTO
%token CADEIACARACTERES
%token OU
%token E
%token IGUAL
%token DIFERENTE
%token MAIORIGUAL
%token MENORIGUAL
%token CARCONST
%token INTCONST

%%

Programa     : DeclPrograma                                      {root = $1;}
             ;

DeclPrograma : PRINCIPAL Bloco                                   {$$ = $1;}
             ;

Bloco        : '{' ListaComando '}'                              {$$ = $1;}
             | VarSection '{' ListaComando '}'                   {$$ = create_node(OPA, None, 0, $1, $2, NULL);}
             ;

VarSection   : '{' ListaDeclVar '}'                              {$$ = $1;}
             ;

ListaDeclVar : IDENTIFICADOR DeclVar ':' Tipo ';' ListaDeclVar   {$$ = create_node(OPA, None, 0, $1, $2, $3);}
             | IDENTIFICADOR DeclVar ':' Tipo ';'                {$$ = create_node(OPA, None, 0, $1, $2, NULL);}
             ;

DeclVar      : %empty                                            {$$ = NULL;}
             | ',' IDENTIFICADOR DeclVar                         {$$ = create(OPA, None, 0, $1, NULL, NULL);}
             ;

Tipo         : INT {$$ = create(OPA, None, 0, $1, NULL, NULL);}
             | CAR {$$ = create(OPA, None, 0, $1, NULL, NULL);}
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

void yyerror(char const *s) {
    // TODO: desalocar toda memória alocada.
    printf(s);
}