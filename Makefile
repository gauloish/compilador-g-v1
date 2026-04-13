CC = gcc
OBJ_DIR = obj
INC_DIR = include

gv1: parser.o lexer.o
	$(CC) -o gv1 obj/lexer.o obj/parser.o

parser.o: parser.c
	$(CC) -Iinclude -c -o obj/parser.o src/parser.c

parser.c: src/parser.y
	bison -H"include/tokens.h" -o src/parser.c src/parser.y

lexer.o: lexer.c
	$(CC) -c -o obj/lexer.o src/lexer.c

lexer.c: src/lexer.l
	flex -o src/lexer.c src/lexer.l

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(INC_DIR):
	mkdir -p $(INC_DIR)

clean:
	rm gv1 include/tokens.h obj/*.o src/lexer.c src/parser.c
