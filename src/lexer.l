%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include "../include/tokens.h"

#define SIZE 128

extern void yyerror(const char*);

void format_error(const char*);
char* copy_substring(const char*, bool, int, int);

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
    [^\*]* ;
    "*"+[^/] ;
    <<EOF>> {
        format_error("COMENTARIO NAO TERMINA");
	    yyerror(status_message);
    }
    "*"+"/" BEGIN(INITIAL);
}

\" {BEGIN(cadeiacaracteres);}

<cadeiacaracteres>{
    ([^\\\"\n]|\\.)*\" {
        yylval.lexeme = copy_substring(yytext, true, 0, strlen(yytext) - 2);
        BEGIN(INITIAL);
        return CADEIACARACTERES;
    }
    <<EOF>> {
        format_error("CADEIA DE CARACTERES NAO TERMINA");
	    yyerror(status_message);
    }
    [\n] {
        format_error("CADEIA DE CARACTERES OCUPA MAIS DE UMA LINHA");
	    yyerror(status_message);
    }
}

'([^\'\\]|\\.)' {
    yylval.lexeme = copy_substring(yytext, true, 1, strlen(yytext) - 2);
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
    yylval.lexeme = copy_substring(yytext, false, 0, strlen(yytext) - 1);
    return INTCONST;
}

{ID} {
    yylval.lexeme = copy_substring(yytext, false, 0, strlen(yytext) - 1);
    return IDENTIFICADOR;
}

[ \n\t]+ ;

<<EOF>> {return (EOF);}

. {
    format_error("CARACTERE INVALIDO");
    yyerror(status_message);
}

%%

void format_error(const char* error_message) {
    snprintf(status_message, sizeof(status_message), "ERRO: %s - LINHA: %d\n", error_message, yylineno);
}

char* copy_substring(const char* string, bool escape, int left, int right) {
    int lenght = strlen(string);
    char* copy = (char*)malloc(lenght + 1);

    if (copy == NULL) {
        yyerror("MEMÓRIA INDISPONÍVEL!!!\n");
    }

    for (int i = 0; i <= lenght; i++) {
        copy[i] = '\0';
    }

    for (int i = 0, j = left; j <= right && i <= lenght; i++, j++) {
        if (yytext[j] == '\\' && j + 1 <= right) {
            switch (yytext[j + 1]) {
                case '\\':
                    copy[i] = '\\';
                    break;
                case 'n':
                    copy[i] = '\n';
                    break;
                case 't':
                    copy[i] = '\t';
                    break;
                case '\"':
                    copy[i] = '\"';
                    break;
                default:
                    copy[i] = string[j];
                    continue;
            }

            j++;
        }
        else {
            copy[i] = yytext[j];
        }
    }

    return copy;
}