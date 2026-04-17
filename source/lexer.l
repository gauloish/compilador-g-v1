%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include "../include/tokens.h"
#include "../include/memory.h"

extern void yyerror(const char*);

char* copy_substring(const char*, bool, int, int);
int line = 1;
%}

%option yylineno
%option noyywrap
%option debug

DIGIT [[:digit:]]
ID [[:alpha:]_][[:alnum:]_]*

%x comentario
%x cadeiacaracteres

%%

"/*" {
    line = yylineno;
    BEGIN(comentario);
}

<comentario>{
    [^\*]* ;
    "*"+[^/] ;
    <<EOF>> {
        yyerror("COMENTARIO NAO TERMINA");
    }
    "*"+"/" BEGIN(INITIAL);
}

"\"" {
    line = yylineno;
    BEGIN(cadeiacaracteres);
}

<cadeiacaracteres>{
    ([^\\\"\n]|\\.)*\" {
        yylval.lexeme = copy_substring(yytext, true, 0, strlen(yytext) - 2);
        BEGIN(INITIAL);
        return CADEIACARACTERES;
    }
    <<EOF>> {
        yyerror("CADEIA DE CARACTERES NAO TERMINA");
    }
    [\n] {
        yyerror("CADEIA DE CARACTERES OCUPA MAIS DE UMA LINHA");
    }
    . ;
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

<<EOF>> {return EOF;}

. {
    line = yylineno;
    yyerror("CARACTERE INVALIDO");
}

%%

/**
 * @brief Copy a substring of a string
 * 
 * @param string String to be copied
 * @param escape If true, process the escape characters.
 * @param left Initial position in string to be copied (begin of substring)
 * @param right Final position in string to be copied (end of substring)
 * @return char* The substring of string copied in new allocated memory block
 */
char* copy_substring(const char* string, bool escape, int left, int right) {
    int lenght = strlen(string);
    char* copy = (char*)allocate_memory(lenght + 1);

    if (copy == NULL) {
        yyerror("MEMÓRIA INDISPONÍVEL!!!");
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