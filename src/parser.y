%{
#include <stdio.h>
#include <stdlib.h>

#include "../include/ast.h"

extern int yylex();
extern char * yytext;
extern int yyleng;
extern int yylineno;

void yyerror(char const *s);
%}

%define parse.trace

%union {
    char* lexeme;
}

%start Programa

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

DeclPrograma : PRINCIPAL Bloco                                   {$$ = $2;}
             ;

Bloco        : '{' ListaComando '}'                              {$$ = $2;}
             | VarSection '{' ListaComando '}'                   {$$ = create_node(OPA, $1, $3, NULL, NULL);}
             ;

VarSection   : '{' ListaDeclVar '}'                              {$$ = $2;}
             ;

ListaDeclVar : IDENTIFICADOR DeclVar ':' Tipo ';' ListaDeclVar   {$$ = create_node(OPA, $2, $4, $6, NULL);}
             | IDENTIFICADOR DeclVar ':' Tipo ';'                {$$ = create_node(OPA, $2, $4, NULL, NULL);}
             ;

DeclVar      : %empty                                            {$$ = NULL;}
             | ',' IDENTIFICADOR DeclVar                         {$$ = create_node(OPA, $3, NULL, NULL, NULL);}
             ;

Tipo         : INT {$$ = create_node(OPA, $1, NULL, NULL, NULL);}
             | CAR {$$ = create_node(OPA, $1, NULL, NULL, NULL);}
             ;

ListaComando : Comando {$$ = create_node(OPA, $1, NULL, NULL, NULL);}
             | Comando ListaComando {$$ = create_node(OPA, $1, $2, NULL, NULL);}
             ;

Comando      : ';' {$$ = NULL}
             | Expr ';' {$$ = create_node(OPA, $1, NULL, NULL, NULL);}
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

void yyerror(char const *error) {
    perror(error);
    exit(EXIT_FAILURE);
}