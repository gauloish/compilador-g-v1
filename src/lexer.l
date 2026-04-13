%{

#include <stdlib.h>
#include <stdio.h>
#include "../include/tokens.h"

#define SIZE 128

extern void yyerror(const char*);
void format_lexical_error(const char*);

char message[SIZE];

// TODO: retirar os logs improvisados desse arquivo kk

%}

%option yylineno noyywrap

CADEIACARACTERES ["][^\n]*["]
CARCONST ['](.|[\n\t])[']
INTCONST [+-]?[[:digit:]]+
IDENTIFICADOR [[:alpha:]_][[:alnum:]_]*

%x comentario

%%

"/*" {printf("entrou no comentario\n"); BEGIN(comentario);}

<comentario>{
    [^*\n]* printf("consumiu caracteres: %s\n", yytext);
    "*"+[^/\n] printf("consumiu *\n");
    <<EOF>> {
        format_lexical_error("COMENTARIO NAO TERMINA");
	    yyerror(message);
    }
    \n printf("consumiu \\n\n");
    "*"+"/" printf("encerrou comentario\n"); BEGIN(INITIAL);
}

"+"         {return '+';}
"-"         {return '-';}
"*"         {return '*';}
"/"         {return '/';}
"{"         {return '{';}
"}"         {return '}';}
"("         {return '(';}
")"         {return ')';}
";"         {return ';';}
":"         {return ':';}
"!"         {return '!';}
"="         {return '=';}
"<"         {return '<';}
">"         {return '>';}
"&"         {return E;}
"||"        {return OU;}
"=="        {return IGUAL;}
"!="        {return DIFERENTE;}
"<="        {return MENORIGUAL;}
">="        {return MAIORIGUAL;}
"principal" {return PRINCIPAL;}
"int"       {return INT;}
"car"       {return CAR;}
"escreva"   {return ESCREVA;}
"novalinha" {return NOVALINHA;}
"se"        {return SE;}
"entao"     {return ENTAO;}
"senao"     {return SENAO;}
"fimse"     {return FIMSE;}
"enquanto"  {return ENQUANTO;}

\n printf("fudeu\n");

[ \t]+ ;

%%

void format_lexical_error(const char* error_message) {
    snprintf(message, sizeof(message), "ERRO: %s - LINHA: %d\n", error_message, yylineno);
}