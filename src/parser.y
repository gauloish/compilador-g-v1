%{
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

extern char * yytext;
extern int yylex();
extern FILE* yyin;

void yyerror(char const *s);

%}

%token

%%
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