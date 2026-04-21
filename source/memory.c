#include <stdlib.h>
#include <stdbool.h>

#include "../include/memory.h"

extern void yyerror(char*);
extern bool analysis_error;

typedef struct _MemoryNode MemoryNode;

/**
 * @brief Node list for allocated memory
 * 
 */
struct _MemoryNode {
    void* memory;
    MemoryNode* next;
};

MemoryNode* node = NULL;

/**
 * @brief End the program due to insufficient memory
 * 
 */
void out_of_memory(void) {
    analysis_error = false;
    yyerror("Memória Insuficiente!!!");
}

/**
 * @brief Initialize the global memory list
 * 
 */
void begin_memory(void) {
    node = (MemoryNode*) malloc(sizeof(MemoryNode));

    if (node == NULL) {
        out_of_memory();
    }

    *node = (MemoryNode){
        .memory = NULL,
        .next = NULL,
    };
}

/**
 * @brief End the global memory list and free all allocated memory
 * 
 */
void end_memory(void) {
    while (node != NULL) {
        MemoryNode* next = node->next;

        free(node->memory);
        free(node);

        node = next;
    }

    node = NULL;
}

/**
 * @brief Allocate memory for the program and store it in the init of global memory list
 * 
 * @param size Size of allocated memory
 * @return void* Pointer for allocated memory
 */
void* allocate_memory(const size_t size) {
    MemoryNode* next = (MemoryNode*) malloc(sizeof(MemoryNode));

    if (next == NULL) {
        out_of_memory();
    }

    void* memory = malloc(size);

    if (memory == NULL) {
        free(next);
        out_of_memory();
    }

    *next = (MemoryNode){
        .memory = memory,
        .next = node,
    };

    node = next;
    return memory;
}

/**
 * @brief Search for the pointer in the global memory list and, if it in the list, free its memory
 * 
 * @param pointer Pointer for the memory to be deallocated
 */
void free_memory(const void* pointer) {
    if (pointer == NULL) {
        return;
    }

    MemoryNode* current = node;

    while (current != NULL) {
        if (current->memory == pointer) {
            MemoryNode* next = current->next;

            free(current->memory);

            current->memory = next->memory;
            current->next = next->next;

            free(next);
            break;
        }

        current = current->next;
    }
}