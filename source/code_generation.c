#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdarg.h>

#include "../include/memory.h"
#include "../include/syntax_tree.h"
#include "../include/symbol_table.h"
#include "../include/code_generation.h"

extern void yyerror(const char*);
extern bool analysis_error;

void emit(FILE *file, const char *format, ...) {
    if (file == NULL) {
        return;
    }

    va_list args;
    va_start(args, format);
    
    fprintf(file, "\t");
    vfprintf(file, format, args);
    fprintf(file, "\n");

    va_end(args);
}

void emitb(FILE *file, const char *format, ...) {
    if (file == NULL) {
        return;
    }

    va_list args;
    va_start(args, format);
    
    vfprintf(file, format, args);
    fprintf(file, "\n");

    va_end(args);
}

// TODO: implement this
void generate_strings(FILE* file, TreeNode* node) {

}

// TODO: implement this
void generate_instructions(FILE* file, TreeNode* node) {

}

void generate_code(TreeNode* tree) {
    FILE* file = fopen("assembly.s", "w");

    if (file == NULL) {
        analysis_error = false;
        yyerror("Não foi possível gerar arquivo assembly!!!");
    }

    emitb(file, ".data");

    generate_strings(file, tree);

    emitb(file, ".text");
    emitb(file, ".globl main\n");
    emitb(file, "main:");

    generate_instruction(file, tree);

    emit(file, "li $v0, 10");
    emit(file, "syscall");
}