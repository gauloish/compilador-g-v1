#include <stdlib.h>
#include <stdbool.h>

#include "../include/memory.h"

extern void yyerror(char*);
extern bool analysis_error;

/**
 * @brief End the program due to insufficient memory
 * 
 */
void out_of_memory(void) {
    analysis_error = false;
    yyerror("Memória Insuficiente!!!");
}

/**
 * @brief Allocate memory for the program
 * 
 * @param size Size of allocated memory
 * @return void* Pointer for allocated memory
 */
void* allocate_memory(const size_t size) {
    void* memory = malloc(size);

    if (memory == NULL) {
        out_of_memory();
    }

    return memory;
}

/**
 * @brief Search for the pointer in the global memory list and, if it in the list, free its memory
 * 
 * @param pointer Pointer for the memory to be deallocated
 */
void free_memory(void* pointer) {
    if (pointer == NULL) {
        return;
    }

    free(pointer);
}