#include <stdlib.h>

#include "../include/memory.h"
#include "../include/symbol_table.h"

const int TABLE_SIZE = 257;

/**
 * @brief Symbol entry struct
 *
 */
struct _SymbolEntry {
    char* name;
    SymbolDataType type;
    SymbolEntry* next;
};

/**
 * @brief Symbol table struct
 *
 */
struct _SymbolTable {
    SymbolEntry* table[TABLE_SIZE];
};

/**
 * @brief Symbol scope (stack of symbol tables) struct
 *
 */
struct _SymbolScope {
    SymbolTable* symbol_table;
    SymbolScope* next;
};

// -------------------- Symbol Entry -------------------- //

/**
 * @brief Create a new symbol entry
 * 
 * @param name Symbol name
 * @param type Symbol type (integer or character)
 * @return SymbolEntry* New symbol entry
 */
SymbolEntry* symbol_entry_create(char* name, SymbolDataType type) {
    SymbolEntry* symbol = (SymbolEntry*) allocate_memory(sizeof(SymbolEntry));

    *symbol = (SymbolEntry){
        .name = name,
        .type = type,
        .next = NULL,
    };

    return symbol;
}

/**
 * @brief Delete a symbol entry
 * 
 * @param symbol Symbol entry to be deleted
 */
void symbol_entry_delete(SymbolEntry* symbol) {
    free_memory(symbol);
}

// -------------------- Symbol Table -------------------- //

/**
 * @brief Create a new symbol table
 * 
 * @return SymbolTable* New symbol table
 */
SymbolTable* symbol_table_create(void) {
    SymbolTable* symbol_table = (SymbolTable*) allocate_memory(sizeof(SymbolTable));

    for (int i = 0; i < TABLE_SIZE; i++) {
        symbol_table->table[i] = NULL;
    }

    return symbol_table;
}

/**
 * @brief Delete a symbol table
 * 
 * @param symbol_table Symbol table to be deleted
 */
void symbol_table_delete(SymbolTable* symbol_table) {
    if (symbol_table == NULL) {
        return;
    }

    for (int i = 0; i < TABLE_SIZE; i++) {
        SymbolEntry* symbol = symbol_table->table[i];

        while (symbol != NULL) {
            SymbolEntry* next = symbol->next;
            symbol_entry_delete(symbol);
            symbol = next;
        }
    }

    free_memory(symbol_table);
}

// -------------------- Symbol Scope -------------------- //

/**
 * @brief Create a new symbol scope
 * 
 * @param symbol_table Symble table for initialize scope stack
 * @return SymbolScope* New symbol scope
 */
SymbolScope* symbol_scope_create(SymbolTable* symbol_table) {
    SymbolScope* symbol_scope = (SymbolScope*) allocate_memory(sizeof(SymbolScope));

    *symbol_scope = (SymbolScope){
        .symbol_table = symbol_table,
        .next = NULL,
    };

    return symbol_scope;
}

/**
 * @brief Delete a symbol scope
 * 
 * @param symbol_scope Symbol scope to be deleted
 */
void symbol_scope_delete(SymbolScope* symbol_scope) {
    while (symbol_scope != NULL) {
        SymbolScope* next = symbol_scope->next;

        symbol_table_delete(symbol_scope->symbol_table);
        free_memory(symbol_scope);

        symbol_scope = next;
    }
}