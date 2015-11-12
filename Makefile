all: compila executa

compila:
	flex -i analisador_lexico.l
	bison -v analisador_sintatico.y
	gcc -otrab3 analisador_sintatico.tab.c hash.c Arvore.c Pilha.c Executor.c -lfl

executa:
	./trab3 < exemplos/in1.gpt

in5:
	./trab3 < ex/in5.gpt

clean:
	-rm -f *.o *.output lex.yy.c analisador_sintatico.tab.c
