%{
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

extern char * yytext;
extern int yylex();
extern FILE * yyin;

void yyerror(char const *s);
%}

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

Programa     : DeclPrograma

DeclPrograma : PRINCIPAL Bloco

Bloco        : '{' ListaComando '}'
             | VarSection '{' ListaComando '}'

VarSection   : '{' ListaDeclVar '}'

ListaDeclVar : IDENTIFICADOR DeclVar ':' Tipo ';' ListaDeclVar
             | IDENTIFICADOR DeclVar ':' Tipo ';'

DeclVar      : %empty
             | ',' IDENTIFICADOR DeclVar

Tipo         : INT
             | CAR

ListaComando : Comando
             | Comando ListaComando

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

Expr         : OrExpr
             | IDENTIFICADOR '=' Expr

OrExpr       : OrExpr OU AndExpr
             | AndExpr

AndExpr      : AndExpr E EqExpr
             | EqExpr

EqExpr       : EqExpr IGUAL DesigExpr
             | EqExpr DIFERENTE DesigExpr
             | DesigExpr

DesigExpr    : DesigExpr '<' AddExpr
             | DesigExpr '>' AddExpr
             | DesigExpr MAIORIGUAL AddExpr
             | DesigExpr MENORIGUAL AddExpr
             | AddExpr

AddExpr      : AddExpr '+' MulExpr
             | AddExpr '-' MulExpr
             | MulExpr

MulExpr      : MulExpr '*' UnExpr
             | MulExpr '/' UnExpr
             | UnExpr

UnExpr       : '-' PrimExpr
             | '!' PrimExpr
             | PrimExpr

PrimExpr     : IDENTIFICADOR
             | CARCONST
             | INTCONST
             | '(' Expr ')'

%%

int main(int argc, char** argv){
    if(argc != 2) {
        yyerror("Uso correto: ./gv1 nome_arquivo\n");
    }

    yyin = fopen(argv[1], "r");

    if(!yyin) {
        yyerror("Arquivo não pode ser aberto!!!\n");
    }

    yyparse();
}

void yyerror(char const *s) {
    printf(s);
    exit(1);
}