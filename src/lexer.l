%{
#include <stdlib.h>
#include <stdio.h>
#include "../include/tokens.h"

#define SIZE 128

extern void yyerror(const char* s);

char message[SIZE];
%}

%option yylineno noyywrap

CADEIACARACTERES ["][^\n]*["]
CARCONST ['](.|[\n\t])[']
INTCONST [+-]?[[:digit:]]+
IDENTIFICADOR [[:alpha:]_][[:alnum:]_]*

%x comentario

%%

"/*" {BEGIN(comentario);}
<comentario>{
    [^*\n]* ;
    "*"+[^/\n] ;
    <<EOF>> {
        snprintf(message, sizeof(message), "ERRO: COMENTARIO NAO TERMINA. LINHA: %d", yylineno);
	    yyerror(message);
    }
    \n ;
    "*"+"/" BEGIN(INITIAL);
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

\n ;

[ \t]+ ;

%%
