
all: bison flex gcc
	@echo "Done."

bison: parser.y
	bison -v parser.y

flex: scanner.l
	flex scanner.l

gcc: scanner.c parser.c
	gcc -o trab4 scanner.c parser.c tree.c table.c interpreter.c -ly -Wall #-std=c99

clean:
	@rm -f *.o *.output scanner.c parser.h parser.c parser *.dot *.pdf

clear:
	@rm -f *.o *.output scanner.c parser.h parser.c parser *.dot *.pdf trab4
