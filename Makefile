COMPILER = gcc
NAME = gv1
OBJECTS_DIR = obj
INCLUDE = -I"include/"
FILES = memory syntax_tree lexer parser main

SOURCES = $(FILES:%=src/%.c)
OBJECTS = $(FILES:%=obj/%.o)

all: main

main: parser.c lexer.c $(OBJECTS)
	$(COMPILER) $(INCLUDE) -o $(NAME) $(OBJECTS)

obj/%.o: src/%.c | $(OBJECTS_DIR)
	$(COMPILER) $(INCLUDE) -c -o $@ $<

parser.c: src/parser.y
	bison --header=include/tokens.h -o src/parser.c src/parser.y

lexer.c: src/lexer.l
	flex -o src/lexer.c src/lexer.l

$(OBJECTS_DIR):
	mkdir -p $(OBJECTS_DIR)

clean:
	rm gv1 gv1.exe include/tokens.h obj/*.o src/{lexer,parser}.c
