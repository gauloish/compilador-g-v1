#include <stdbool.h>

#ifndef __SYMBOL_TABLE_H__
#define __SYMBOL_TABLE_H__

typedef enum _SymbolDataType SymbolDataType;

typedef struct _SymbolEntry SymbolEntry;
typedef struct _SymbolTable SymbolTable;
typedef struct _SymbolScope SymbolScope;

SymbolEntry* symbol_entry_create(const char*, SymbolDataType, int, int);
void symbol_entry_delete(SymbolEntry*);

SymbolTable* symbol_table_create(void);
void symbol_table_delete(SymbolTable*);
void symbol_table_add_symbol(SymbolTable*, const char*, SymbolDataType, int, int);
bool symbol_table_check_symbol(SymbolTable*, const char*);
SymbolDataType symbol_table_get_data_type(SymbolTable*, const char*);
int symbol_table_get_level(SymbolTable*, const char*);
int symbol_table_get_position(SymbolTable*, const char*);
// SymbolEntry* symbol_table_get_symbols(SymbolTable*);

SymbolScope* symbol_scope_create(void);
void symbol_scope_delete(SymbolScope*);
SymbolScope* symbol_scope_push_scope(SymbolScope*);
SymbolScope* symbol_scope_pop_scope(SymbolScope*);
void symbol_scope_add_symbol(SymbolScope*, const char*, SymbolDataType);
bool symbol_scope_check_symbol(SymbolScope*, const char*, bool);
SymbolDataType symbol_scope_get_data_type(SymbolScope*, const char*, bool);
int symbol_scope_get_level(SymbolScope*, const char*, bool);
int symbol_scope_get_position(SymbolScope*, const char*, bool);
// SymbolEntry* symbol_scope_get_symbols(SymbolScope*);

enum _SymbolDataType {
    SYMBOL_INTEGER,
    SYMBOL_CHARACTER,
    SYMBOL_NOTYPE,
};

#endif /* __SYMBOL_TABLE_H__ */