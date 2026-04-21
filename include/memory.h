#include <stdlib.h>
#include <stdbool.h>

#ifndef __MEMORY_H__
#define __MEMORY_H__

void begin_memory(void);
void end_memory(void);

void* allocate_memory(const size_t);
void free_memory(const void*);

#endif /* __MEMORY_H__ */