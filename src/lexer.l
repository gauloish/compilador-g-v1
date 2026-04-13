%{
#include <stdlib.h>
#include <stdio.h>

/* Definição dos Tokens da Linguagem */
#define PRINCIPAL        256
#define IDENTIFICADOR    257
#define INT              258
#define CAR              259
#define LEIA             260
#define ESCREVA          261
#define NOVALINHA        262
#define SE               263
#define SENAO            264
#define FIMSE            265
#define ENQUANTO         266
#define CADEIACARACTERES 267
#define OU               268
#define E                269
#define IGUAL            270
#define DIFERENTE        271
#define MAIORIGUAL       272
#define MENORIGUAL       273
#define CARCONST         274
#define INTCONST         275

#define SIZE 128

extern void yyerror(const char*);

char message[SIZE];
%}

%option yylineno noyywrap


CADEIACARACTERES ["][^\n]*["]
CARCONST ['](.|[\n\t])[']
INTCONST [+-]?[[:digit:]]+
IDENTIFICADOR [[:alpha:]_][[:alnum:]_]*

%x comentario

%%

/* Processa comentário */
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

/* Consome quebra de linha e incrementa o número da linha */
\n ;

/* Consome caracteres em branco */
[ \t]+ ;

%%

