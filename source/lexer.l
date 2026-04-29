%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include "../include/tokens.h"
#include "../include/syntax_tree.h"
#include "../include/memory.h"

extern void yyerror(const char*);
extern bool analysis_error;

char* copy_substring(const char*, bool, int, int);

#define YY_USER_ACTION                        \
    yylloc.first_line = yylloc.last_line;     \
    yylloc.first_column = yylloc.last_column; \
    for (int i = 0; i < yyleng; i++) {        \
        if (yytext[i] == '\n') {              \
            yylloc.last_line++;               \
            yylloc.last_column = 1;           \
        }                                     \
        else {                                \
            yylloc.last_column++;             \
        }                                     \
    }                                         \

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
    BEGIN(comentario);
}

<comentario>{
    [^\*]* ;
    "*"+[^/] ;
    <<EOF>> {
        yyerror("Comentário não termina");
    }
    "*"+"/" BEGIN(INITIAL);
}

"\"" {
    BEGIN(cadeiacaracteres);
}

<cadeiacaracteres>{
    ([^\\\"\n]|\\.)*\" {
        yylval.lexeme = copy_substring(yytext, true, 0, strlen(yytext) - 2);
        BEGIN(INITIAL);
        return CADEIACARACTERES;
    }
    <<EOF>> {
        yyerror("Cadeia de caracteres nao termina");
    }
    [\n] {
        yyerror("Cadeia de caracteres ocupa mais de uma linha");
    }
    . ;
}

'([^\'\\]|\\.)' {
    yylval.lexeme = copy_substring(yytext, true, 1, strlen(yytext) - 2);
    return CARCONST;
}

'.*' {
    yyerror("Caractere com mais de um símbolo");
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
    yyerror("Caractere inválido");
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

    for (int i = 0; i <= lenght; i++) {
        copy[i] = '\0';
    }

    for (int i = 0, j = left; j <= right && i <= lenght; i++, j++) {
        if (yytext[j] == '\\' && j + 1 <= right) {
            switch (yytext[j + 1]) {
                case '0':
                    copy[i] = '\0';
                    break;
                case 'n':
                    copy[i] = '\n';
                    break;
                case 't':
                    copy[i] = '\t';
                    break;
                case 'r':
                    copy[i] = '\r';
                    break;
                case 'b':
                    copy[i] = '\b';
                    break;
                case '\\':
                    copy[i] = '\\';
                    break;
                case '\"':
                    copy[i] = '\"';
                    break;
                case '\'':
                    copy[i] = '\'';
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