%{

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <limits.h>
#include <stdbool.h>

#include "../include/tokens.h"

#define SIZE 128

extern void yyerror(const char*);

void format_lexical_error(const char*);
char* copy_string(const char*);
long long convert_strin_to_integer(const char*);

char message[SIZE];

%}

%option yylineno
%option noyywrap
%option debug

_CADEIACARACTERES ["][^\n]*["]
_CARCONST ['](.|[\n\t])[']

DIGIT [[:digit:]]
ID [[:alpha:]_][[:alnum:]_]*

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
","         {return ',';}
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

{DIGIT}+ {
    yylval.ival = convert_strin_to_integer(yytext);
    return INT;
}

{ID} {
    yylval.sval = "temp_str";
    return IDENTIFICADOR;
}

\n ;

[ \t]+ ;

%%

void format_lexical_error(const char* error_message) {
    snprintf(message, sizeof(message), "ERRO: %s - LINHA: %d\n", error_message, yylineno);
}

long long convert_strin_to_integer(const char* string) {
    char *end;
    errno = 0;

    long long value = strtoll(string, &end, 10);

    if (errno == ERANGE) {
        // overflow ou underflow;
    }

    if (end == string) {
        // nenhum inteiro foi lido
    }

    if (*end != '\0') {
        // verifica se o lexema é realmente um inteiro
    }

    return value;
}