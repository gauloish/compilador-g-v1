#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdarg.h>

#include "../include/memory.h"
#include "../include/syntax_tree.h"
#include "../include/symbol_table.h"
#include "../include/code_generation.h"

extern void yyerror(const char*);
extern bool analysis_error;

typedef struct _Strings Strings;

Strings* strings_create(void);
void strings_delete(Strings*);
Strings* strings_add(Strings*, const char*);
int strings_get_index(Strings*, const char*);
bool strings_check(Strings*, const char*);

int get_index(void);
void emit(FILE*, const char*, ...);
void emitb(FILE*, const char*, ...);
Strings* get_strings(TreeNode*, Strings*);
Strings* generate_strings(FILE*, TreeNode*);
void generate_instructions(FILE*, TreeNode*, Strings*);
void generate_code(TreeNode*);

/**
 * @brief Strings struct for store all
 * string literals of the code
 * 
 */
struct _Strings {
    const char* string;
    int index;
    Strings* next;
};

/**
 * @brief Create a new strings list object
 * 
 * @return Strings* String list object
 */
Strings* strings_create(void) {
    Strings* strings = (Strings*) allocate_memory(sizeof(Strings));

    *strings = (Strings) {
        .string = NULL,
        .index = 0,
        .next = NULL,
    };

    return strings;
}

/**
 * @brief Delete a strings list
 * 
 * @param strings Strings list to be deleted
 */
void strings_delete(Strings* strings) {
    while (strings != NULL) {
        Strings* next = strings->next;
        free_memory(strings);
        strings = next;
    }
}

/**
 * @brief Add a new string in the strings list
 * 
 * @param strings Strings list
 * @param string String to be added
 * @return Strings* Strings list updated
 */
Strings* strings_add(Strings* strings, const char* string) {
    if (strings_check(strings, string)) {
        return strings;
    }

    Strings* new_strings = (Strings*) allocate_memory(sizeof(Strings));

    *new_strings = (Strings) {
        .string = string,
        .index = get_index(),
        .next = strings,
    };

    return new_strings;
}

/**
 * @brief Get index of the string in strings
 * 
 * @param strings Strings list
 * @param string String to be searched
 * @return int String index
 */
int strings_get_index(Strings* strings, const char* string) {
    if (strings == NULL || string == NULL) {
        return 0;
    }

    while (strings != NULL) {
        if (strings->string == NULL) {
            break;
        }

        if (strcmp(strings->string, string) == 0) {
            return strings->index;
        }

        strings = strings->next;
    }

    return 0;
}

/**
 * @brief Check if a string already be in the strings list
 * 
 * @param strings Strings list
 * @param string String literal
 * @return true If the string already be in the strings list
 * @return false If not
 */
bool strings_check(Strings* strings, const char* string) {
    if (strings == NULL || string == NULL) {
        return true;
    }

    while (strings != NULL) {
        if (strings->string == NULL) {
            break;
        }

        if (strcmp(strings->string, string) == 0) {
            return true;
        }

        strings = strings->next;
    }

    return false;
}

/**
 * @brief Get the index value
 * 
 * @return int index value
 */
int get_index(void) {
    static int index = 1;
    return index++;
}

/**
 * @brief Write in the output file the formated text (MIPS assembly code) with
 * a tab in each line of code
 * 
 * @param file File to be wrote
 * @param format String format for the text (code)
 * @param ... The parameters for the format
 */
void emit(FILE* file, const char* format, ...) {
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

/**
 * @brief Write in the output file the formated text (MIPS assembly code) without
 * a tab in each line of code
 * 
 * @param file File to be wrote
 * @param format String format for the text (code)
 * @param ... The parameters for the format
 */
void emitb(FILE* file, const char* format, ...) {
    if (file == NULL) {
        return;
    }

    va_list args;
    va_start(args, format);
    
    vfprintf(file, format, args);
    fprintf(file, "\n");

    va_end(args);
}

/**
 * @brief Get the strings object present in the code
 * 
 * @param node Node of the AST
 * @param strings Strings list
 * @return Strings* Updated strings list
 */
Strings* get_strings(TreeNode* node, Strings* strings) {
    if (node != NULL) {
        if (tree_node_get_kind(node) == TREE_NODE_ESCREVA_CADEIACARACTERES) {
            strings = strings_add(strings, tree_node_get_lexeme(node));
        }
        else {
            strings = get_strings(tree_node_get_left(node), strings);
            strings = get_strings(tree_node_get_right(node), strings);
        }
    }

    return strings;
}

/**
 * @brief Generate code for store all strings in memory
 * 
 * @param file Output file where code will be wrote
 * @param node Node of the AST to generate code
 * @return Strings* Strings list with all strings in the code
 */
Strings* generate_strings(FILE* file, TreeNode* node) {
    Strings* strings = strings_create();
    strings = get_strings(node, strings);
    Strings* string = strings;

    while (string != NULL) {
        if (string->string == NULL) {
            break;
        }

        emit(file, "string_%d: .asciiz \"%s\"", string->index, string->string);
        string = string->next;
    }

    emitb(file, "");

    return strings;
}

/**
 * @brief Generate code with all instructions of the code
 * 
 * @param file Output file where code will be wrote
 * @param node Node of the AST to generate code
 * @param strings Strings list with all strings in the code
 */
void generate_instructions(FILE* file, TreeNode* node, Strings* strings) {

}

/**
 * @brief Generate code from Abstract Syntax Tree
 * 
 * @param tree Abstract Syntax Tree where code will be generated from
 */
void generate_code(TreeNode* tree) {
    FILE* file = fopen("assembly.s", "w");

    if (file == NULL) {
        analysis_error = false;
        yyerror("Não foi possível gerar arquivo assembly!!!");
    }

    emitb(file, ".data");

    Strings* strings = generate_strings(file, tree);

    emitb(file, ".text");
    emitb(file, ".globl main\n");
    emitb(file, "main:");

    generate_instructions(file, tree, strings);

    emit(file, "li $v0, 10");
    emit(file, "syscall");

    strings_delete(strings);
    fclose(file);
}