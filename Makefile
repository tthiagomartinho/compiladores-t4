all: compila

compila:
	flex -i analisador_lexico.l
	bison -v analisador_sintatico.y
	gcc -otrab4 analisador_sintatico.tab.c hash.c Arvore.c Pilha.c Executor.c Programa.c -lfl
	pdflatex interpretador.tex

executa1:
	./trab4

executa:
	./trab4 < exemplos/in1.gpt

in5:
	./trab4 < ex/in5.gpt

clean:
	-rm -f *.o *.output lex.yy.c analisador_sintatico.tab.c
