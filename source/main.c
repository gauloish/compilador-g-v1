#include <stdio.h>
#include <stdlib.h>

#include "../include/memory.h"

#define DEBUG_OFF 0
#define DEBUG_ON  1

extern FILE* yyin;
extern int yydebug;
extern int yy_flex_debug;
extern int yyparse();
extern void yyerror(char const *);

int main(int argc, char** argv){
    begin_memory();

    if (argc != 2) {
        yyerror("Uso correto: ./gv1 nome_arquivo");
    }

    yyin = fopen(argv[1], "r");

    if (!yyin) {
        yyerror("Arquivo não pode ser aberto!!!");
    }

    yydebug = DEBUG_OFF;
    yy_flex_debug = DEBUG_OFF;

    yyparse();
    fclose(yyin);
    
    end_memory();
}