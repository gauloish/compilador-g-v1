#include <stdlib.h>
#include <stdbool.h>

#ifndef __MEMORY_H__
#define __MEMORY_H__

void* allocate_memory(const size_t);
void free_memory(void*);

#endif /* __MEMORY_H__ */