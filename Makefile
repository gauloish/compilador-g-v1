COMPILER = gcc
NAME = gv1
OBJECTS_DIR = objects
INCLUDE = -I"include/"
FILES = memory syntax_tree lexer parser main

SOURCES = $(FILES:%=source/%.c)
OBJECTS = $(FILES:%=objects/%.o)

all: main

main: parser.c lexer.c $(OBJECTS)
	$(COMPILER) $(INCLUDE) -o $(NAME) $(OBJECTS)

objects/%.o: source/%.c | $(OBJECTS_DIR)
	$(COMPILER) $(INCLUDE) -c -o $@ $<

parser.c: source/parser.y
	bison --header=include/tokens.h -o source/parser.c source/parser.y

lexer.c: source/lexer.l
	flex -o source/lexer.c source/lexer.l

$(OBJECTS_DIR):
	mkdir -p $(OBJECTS_DIR)

clean:
	rm gv1 gv1.exe include/tokens.h objects/*.o source/{lexer,parser}.c