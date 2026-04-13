%{

#include <stdlib.h>
#include <stdio.h>
#include "../include/tokens.h"

#define SIZE 128

extern void yyerror(const char*);
void format_lexical_error(const char*);

char message[SIZE];

%}

%option yylineno
%option noyywrap
%option debug

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
        format_lexical_error("COMENTARIO NAO TERMINA");
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

void format_lexical_error(const char* error_message) {
    snprintf(message, sizeof(message), "ERRO: %s - LINHA: %d\n", error_message, yylineno);
}