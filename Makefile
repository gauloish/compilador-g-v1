CC = gcc
OBJ_DIR = obj

all: gv1

gv1: parser.o lexer.o ast.o main.o
	$(CC) -o gv1 obj/main.o obj/lexer.o obj/parser.o

parser.o: $(OBJ_DIR) parser.c
	$(CC) -I include -c -o obj/parser.o src/parser.c

parser.c: src/parser.y
	bison --header=include/tokens.h -o src/parser.c src/parser.y

lexer.o: $(OBJ_DIR) lexer.c
	$(CC) -c -o obj/lexer.o src/lexer.c

lexer.c: src/lexer.l
	flex -o src/lexer.c src/lexer.l

ast.o:
	$(CC) -I include -c -o obj/ast.o src/ast.c

main.o:
	$(CC) -c -o obj/main.o src/main.c

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# TODO: create a flag for ast compilation

clean:
	rm gv1 gv1.exe include/tokens.h obj/*.o src/lexer.c src/parser.c
