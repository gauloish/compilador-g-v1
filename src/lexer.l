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
long long string_to_integer(const char*);

char status_message[SIZE];

%}

%option yylineno
%option noyywrap
%option debug

DIGIT [[:digit:]]
ID [[:alpha:]_][[:alnum:]_]*

%x comentario
%x cadeiacaracteres

%%

"/*" {BEGIN(comentario);}

<comentario>{
    [^*\n]* ;
    "*"+[^/\n] ;
    <<EOF>> {
        format_lexical_error("COMENTARIO NAO TERMINA");
	    yyerror(status_message);
    }
    \n ;
    "*"+"/" BEGIN(INITIAL);
}

\" {BEGIN(cadeiacaracteres);}

<cadeiacaracteres>{
    [^"\n]+ {
        yylval.sval = strdup(yytext);
    }
    <<EOF>> {
        format_lexical_error("CADEIA DE CARACTERES NAO TERMINA");
	    yyerror(status_message);
    }
    \n {
        format_lexical_error("CADEIA DE CARACTERES OCUPA MAIS DE UMA LINHA");
	    yyerror(status_message);
    }
    \" {
        // TODO: alocar memoria para a string e retornar ela para o bison e a AST
        BEGIN(INITIAL);
        return CADEIACARACTERES;
    }
}

'([^'\\]|\\.)' {
    if (yytext[0] == '\\') {
        switch (yytext[1]) {
            case 'n':
                yylval.cval = '\n';
                break;
            case 't':
                yylval.cval = '\t';
                break;
            case 'r':
                yylval.cval = '\r';
                break;
            case '\\':
                yylval.cval = '\\';
                break;
            default:
                // TODO: sei la mano
                break;
        }
    }
    else {
        yylval.cval = yytext[0];
    }

    return CARCONST;
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
"leia"      {return LEIA;}
"escreva"   {return ESCREVA;}
"novalinha" {return NOVALINHA;}
"se"        {return SE;}
"entao"     {return ENTAO;}
"senao"     {return SENAO;}
"fimse"     {return FIMSE;}
"enquanto"  {return ENQUANTO;}

{DIGIT}+ {
    yylval.ival = string_to_integer(yytext);
    return INTCONST;
}

{ID} {
    yylval.sval = strdup(yytext);
    return IDENTIFICADOR;
}

\n ;

[ \t]+ ;

<<EOF>> {return (EOF);}

. {
    format_lexical_error("CARACTERE INVALIDO");
    yyerror(status_message);
}

%%

void format_lexical_error(const char* error_message) {
    snprintf(status_message, sizeof(status_message), "ERRO: %s - LINHA: %d\n", error_message, yylineno);
}

long long string_to_integer(const char* string) {
    char *end;
    errno = 0;

    long long value = strtoll(string, &end, 10);
    
    // TODO: tratar esses erros aqui
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