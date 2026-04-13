%{
#include <stdlib.h>
#include <stdio.h>

#define SIZE 1024

extern void yyerror(const char*);

int num_line = 1;
char message[SIZE];
%}

%option yylineno noyywrap

PRINCIPAL principal
INT int
CAR car
ESCREVA escreva
NOVALINHA novalinha
SE se
ENTAO entao
SENAO senao
FIMSE fimse
ENQUANTO enquanto
CADEIACARACTERES ["][^\n]*["]
OU ||
E &
IGUAL ==
DIFERENTE !=
MAIORIGUAL >=
MENORIGUAL <=
CARCONST ['](.|[\n\t])[']
INTCONST [+-]?[[:digit:]]+
IDENTIFICADOR [[:alpha:]_][[:alnum:]_]*

%x comentario

%%

/* Processa comentário */
"/*" {BEGIN(comentario);}
<comentario>[^*\n]*
<comentario>"*"+[^/\n]
<comentario><<EOF>> {
    snprintf(message, sizeof(message), "ERRO: COMENTARIO NAO TERMINA. LINHA: %d", num_line);
	yyerror(message);
}
<comentario>\n nline++;
<comentario>"*"+"/" BEGIN(INITIAL);

"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}
"{" {return '{';}
"}" {return '}';}
"(" {return '(';}
")" {return ')';}
";" {return ';';}
"=" {return '=';}
"<" {return '<';}
">" {return '>';}

/* Consome quebra de linha e incrementa o número da linha */
\n num_line++;

/* Consome caracteres em branco */
[ \t]+ ;

%%

