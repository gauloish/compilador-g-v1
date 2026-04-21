#include <stdbool.h>

#ifndef __SYMBOL_TABLE_H__
#define __SYMBOL_TABLE_H__

typedef enum _SymbolDataType SymbolDataType;

typedef struct _SymbolEntry SymbolEntry;
typedef struct _SymbolTable SymbolTable;
typedef struct _SymbolScope SymbolScope;

SymbolEntry* symbol_entry_create(const char*, SymbolDataType);
void symbol_entry_delete(SymbolEntry*);

SymbolTable* symbol_table_create(void);
void symbol_table_delete(SymbolTable*);
void symbol_table_add_symbol(SymbolTable*, const char*, SymbolDataType);
bool symbol_table_check_symbol(SymbolTable*, const char*);

SymbolScope* symbol_scope_create(void);
void symbol_scope_delete(SymbolScope*);

enum _SymbolDataType {
    SYMBOL_INTEGER,
    SYMBOL_CHARACTER,
};

#endif /* __SYMBOL_TABLE_H__ */