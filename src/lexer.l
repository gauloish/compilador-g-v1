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

char status_message[SIZE];

/* Processamento das strings */
typedef struct {
    char* data;
    size_t length;
    size_t capacity;
} String;

String string_buffer = {
    .data = NULL,
    .length = 0,
    .capacity = 0,
};

void string_begin();
void string_append(char);
void string_end();

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
    [^"\\\n\t\r]+ {
        printf("AIN BOLSONARO 22: %s\n", yytext);
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
        yylval.sval = "temp_string";
        printf("AIN BOLSONARO: %s\n", yytext);
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
    yylval.ival = convert_strin_to_integer(yytext);
    return INTCONST;
}

{ID} {
    // TODO: fazer a alocação dinamica do identificador para a AST
    yylval.sval = "temp_id";
    return IDENTIFICADOR;
}

\n ;

[ \t]+ ;

%%

void format_lexical_error(const char* error_message) {
    snprintf(status_message, sizeof(status_message), "ERRO: %s - LINHA: %d\n", error_message, yylineno);
}

long long convert_strin_to_integer(const char* string) {
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

void string_begin() {
    string_buffer.capacity = 32;
    string_buffer.length = 0;

    if (string_buffer.data != NULL) {
        free(string_buffer.data);
    }

    string_buffer.data = (char*) malloc(string_buffer.capacity);
}

void string_append(char c) {
    
}