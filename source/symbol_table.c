#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

#include "../include/memory.h"
#include "../include/symbol_table.h"

#define TABLE_SIZE 257

/**
 * @brief Symbol entry struct
 *
 */
struct _SymbolEntry {
    const char* name;
    SymbolDataType type;
    SymbolEntry* next;
    int level;
    int position;
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
    int level;
    int position;
};

// -------------------- Symbol Entry -------------------- //

/**
 * @brief Create a new symbol entry
 * 
 * @param name Symbol name
 * @param type Symbol type (integer or character)
 * @param level Scope level of symbol
 * @param position Position in relation the first symbol
 * @return SymbolEntry* New symbol entry
 */
SymbolEntry* symbol_entry_create(const char* name, SymbolDataType type, int level, int position) {
    SymbolEntry* symbol = (SymbolEntry*) allocate_memory(sizeof(SymbolEntry));

    *symbol = (SymbolEntry){
        .name = name,
        .type = type,
        .level = level,
        .position = position,
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

/**
 * @brief Compute hash of a string via FNV-1a algorithm
 * 
 * @param string String to be hashed
 * @return int Hash of the string
 */
int compute_hash(const char* string) {
    uint64_t hash = 1469598103934665603ULL;

    while (*string) {
        hash ^= (unsigned char)(*string++);
        hash *= 1099511628211ULL;
    }

    return hash % TABLE_SIZE;
}

/**
 * @brief Add a symbol in symbol table
 * 
 * @param symbol_table Symbol table where symbol will be added
 * @param name Name of the symbol
 * @param type Data type of the symbol
 * @param level Scope level of symbol
 * @param position Position in relation the first symbol
 */
void symbol_table_add_symbol(SymbolTable* symbol_table, const char* name, SymbolDataType type, int level, int position) {
    if (symbol_table == NULL) {
        return;
    }

    SymbolEntry* symbol = symbol_entry_create(name, type, level, position);
    int i = compute_hash(name);

    symbol->next = symbol_table->table[i];
    symbol_table->table[i] = symbol;
}

/**
 * @brief Check if a name is present in the symbol table
 * 
 * @param symbol_table Symbol table
 * @param name Name to be checked
 * @return true If name is present in the symbol table
 * @return false If not
 */
bool symbol_table_check_symbol(SymbolTable* symbol_table, const char* name) {
    if (symbol_table == NULL || name == NULL) {
        return false;
    }

    int i = compute_hash(name);
    SymbolEntry* symbol = symbol_table->table[i];

    while (symbol != NULL) {
        if (strcmp(name, symbol->name) == 0) {
            return true;
        }
    }

    return false;
}

/**
 * @brief Get the data type of a symbol in symbol table
 * 
 * @param symbol_table Symbol table
 * @param name Name of the symbol
 * @return SymbolDataType Symbol data type
 */
SymbolDataType symbol_table_get_data_type(SymbolTable* symbol_table, const char* name) {
    if (symbol_table == NULL || name == NULL) {
        return SYMBOL_NOTYPE;
    }

    int i = compute_hash(name);
    SymbolEntry* symbol = symbol_table->table[i];

    while (symbol != NULL) {
        if (strcmp(name, symbol->name) == 0) {
            return symbol->type;
        }
    }

    return SYMBOL_NOTYPE;
}

/**
 * @brief Get the scope level of a symbol in symbol table
 * 
 * @param symbol_table Symbol table
 * @param name Name of the symbol
 * @return int Symbol scope level
 */
int symbol_table_get_level(SymbolTable* symbol_table, const char* name) {
    if (symbol_table == NULL || name == NULL) {
        return 0;
    }

    int i = compute_hash(name);
    SymbolEntry* symbol = symbol_table->table[i];

    while (symbol != NULL) {
        if (strcmp(name, symbol->name) == 0) {
            return symbol->level;
        }
    }

    return 0;
}

/**
 * @brief Get the position of a symbol in symbol table
 * 
 * @param symbol_table Symbol table
 * @param name Name of the symbol
 * @return int Symbol position
 */
int symbol_table_get_position(SymbolTable* symbol_table, const char* name) {
    if (symbol_table == NULL || name == NULL) {
        return 0;
    }

    int i = compute_hash(name);
    SymbolEntry* symbol = symbol_table->table[i];

    while (symbol != NULL) {
        if (strcmp(name, symbol->name) == 0) {
            return symbol->position;
        }
    }

    return 0;
}

// /**
//  * @brief Get a list with all symbols in the table
//  * 
//  * @param symbol_table Symbol table
//  * @return SymbolEntry* A list with all symbols in the table
//  */
// SymbolEntry* symbol_table_get_symbols(SymbolTable* symbol_table) {
//     if (symbol_table == NULL) {
//         return NULL;
//     }

//     SymbolEntry* symbols = NULL;

//     for (int i = 0; i < TABLE_SIZE; i++) {
//         SymbolEntry* symbol = symbol_table->table[i];

//         while (symbol != NULL) {
//             SymbolEntry* new_symbol = symbol_entry_create(symbol->name, symbol->type, symbol->level, symbol->position);

//             if (symbols == NULL) {
//                 symbols = new_symbol;
//             }
//             else {
//                 new_symbol->next = symbol;
//                 symbol = new_symbol;
//             }
//         }
//     }

//     return symbols;
// }

// -------------------- Symbol Scope -------------------- //

/**
 * @brief Create a new symbol scope
 * 
 * @return SymbolScope* New symbol scope
 */
SymbolScope* symbol_scope_create(void) {
    SymbolScope* symbol_scope = (SymbolScope*) allocate_memory(sizeof(SymbolScope));

    *symbol_scope = (SymbolScope){
        .symbol_table = NULL,
        .next = NULL,
        .level = 0,
        .position = 0,
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

/**
 * @brief Push a new scope in symbol scopes
 * 
 * @param symbol_scope Symbol scope stack to be modified
 * @return SymbolScope* New symbol scope stack
 */
SymbolScope* symbol_scope_push_scope(SymbolScope* symbol_scope) {
    SymbolTable* symbol_table = symbol_table_create();
    SymbolScope* new_symbol_scope = symbol_scope_create();

    new_symbol_scope->symbol_table = symbol_table;
    new_symbol_scope->next = symbol_scope;
    new_symbol_scope->level = symbol_scope->level + 1;
    new_symbol_scope->position = symbol_scope->position;

    return new_symbol_scope;
}

/**
 * @brief Pop the top scope
 * 
 * @param symbol_scope Symbol scope stack
 * @return SymbolScope* New symbol scope stack
 */
SymbolScope* symbol_scope_pop_scope(SymbolScope* symbol_scope) {
    if (symbol_scope == NULL) {
        return NULL;
    }

    symbol_table_delete(symbol_scope->symbol_table);
    SymbolScope* next = symbol_scope->next;
    free_memory(symbol_scope);

    return next;
}

/**
 * @brief Add symbol in the current scope
 * 
 * @param symbol_scope Scymbol scope stack
 * @param name Name of the symbol
 * @param type Type of the symbol
 */
void symbol_scope_add_symbol(SymbolScope* symbol_scope, const char* name, SymbolDataType type) {
    if (symbol_scope == NULL) {
        return;
    }

    symbol_scope->position++;

    symbol_table_add_symbol(symbol_scope->symbol_table, name, type, symbol_scope->level, symbol_scope->position);
}

/**
 * @brief Check if the name is in the current/all scopes
 * 
 * @param symbol_scope Scymbol scope stack
 * @param name Name of the symbol
 * @param current_scope If checking is in current or all scopes
 * @return true If name is in the respectivelly scopes
 * @return false If not
 */
bool symbol_scope_check_symbol(SymbolScope* symbol_scope, const char* name, bool current_scope) {
    if (symbol_scope == NULL) {
        return false;
    }

    if (current_scope) {
        if (symbol_table_check_symbol(symbol_scope->symbol_table, name)) {
            return true;
        }
    }
    else {
        while (symbol_scope != NULL) {
            if (symbol_table_check_symbol(symbol_scope->symbol_table, name)) {
                return true;
            }

            symbol_scope = symbol_scope->next;
        }
    }

    return false;
}

/**
 * @brief Get the data type of an symbol in some symbol table of symbol scope stack
 * 
 * @param symbol_scope Symbol scope stack
 * @param name Name of the symbol
 * @param current_scope If search is in current or all scopes
 * @return SymbolDataType The data type of symbol
 */
SymbolDataType symbol_scope_get_data_type(SymbolScope* symbol_scope, const char* name, bool current_scope) {
    if (symbol_scope == NULL) {
        return SYMBOL_NOTYPE;
    }

    if (current_scope) {
        return symbol_table_get_data_type(symbol_scope->symbol_table, name);
    }
    else {
        while (symbol_scope != NULL) {
            SymbolDataType type = symbol_table_get_data_type(symbol_scope->symbol_table, name);

            if (type != SYMBOL_NOTYPE) {
                return type;
            }

            symbol_scope = symbol_scope->next;
        }
    }

    return SYMBOL_NOTYPE;
}

/**
 * @brief Get the scope level of a symbol in some symbol table of symbol scope stack
 * 
 * @param symbol_scope Symbol scope stack
 * @param name Name of the symbol
 * @param current_scope If search is in current or all scopes
 * @return int The scope level of symbol
 */
int symbol_scope_get_level(SymbolScope* symbol_scope, const char* name, bool current_scope) {
    if (symbol_scope == NULL) {
        return 0;
    }

    if (current_scope) {
        return symbol_table_get_level(symbol_scope->symbol_table, name);
    }
    else {
        while (symbol_scope != NULL) {
            int level = symbol_table_get_level(symbol_scope->symbol_table, name);

            if (level != 0) {
                return level;
            }

            symbol_scope = symbol_scope->next;
        }
    }

    return 0;
}

/**
 * @brief Get the position of a symbol in some symbol table of symbol scope stack
 * 
 * @param symbol_scope Symbol scope stack
 * @param name Name of the symbol
 * @param current_scope If search is in current or all scopes
 * @return int The position of symbol
 */
int symbol_scope_get_position(SymbolScope* symbol_scope, const char* name, bool current_scope) {
    if (symbol_scope == NULL) {
        return 0;
    }

    if (current_scope) {
        return symbol_table_get_position(symbol_scope->symbol_table, name);
    }
    else {
        while (symbol_scope != NULL) {
            int level = symbol_table_get_position(symbol_scope->symbol_table, name);

            if (level != 0) {
                return level;
            }

            symbol_scope = symbol_scope->next;
        }
    }

    return 0;
}


// /**
//  * @brief Get all symbols of the top of the symbol scope stack
//  * 
//  * @param symbol_scope Symbol scope stack
//  * @return SymbolEntry* The symbol list of the current symbol scope
//  */
// SymbolEntry* symbol_scope_get_symbols(SymbolScope* symbol_scope) {
//     if (symbol_scope == NULL) {
//         return NULL;
//     }

//     return symbol_table_get_symbols(symbol_scope->symbol_table);
// }