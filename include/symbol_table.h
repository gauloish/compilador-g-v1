#ifndef __SYMBOL_TABLE_H__
#define __SYMBOL_TABLE_H__

typedef enum _SymbolDataType SymbolDataType;

typedef struct _SymbolEntry SymbolEntry;
typedef struct _SymbolTable SymbolTable;
typedef struct _SymbolScope SymbolScope;

SymbolEntry* symbol_entry_create(char*, SymbolDataType);
void symbol_entry_delete(SymbolEntry*);

SymbolTable* symbol_table_create(void);
void symbol_table_delete(SymbolTable*);

SymbolScope* symbol_scope_create(SymbolTable*);
void symbol_scope_delete(SymbolScope*);

enum _SymbolDataType {
    SYMBOL_INTEGER,
    SYMBOL_CHARACTER,
};

#endif /* __SYMBOL_TABLE_H__ */