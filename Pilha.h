#include <stdio.h>
#include <stdlib.h>
#include "Arvore.h"

typedef struct pilha Pilha;

Pilha* inicializarPilha();

Pilha* criarNovoItemPilha(Arvore* a);

Pilha* empilharElementoCriandoArvore(Pilha* p, int tipo, void* valorNo);

/*Cria um novo no no inicio da lista*/
Pilha* empilhar(Pilha* p, Arvore* a);

/*Cria um novo no no inicio da lista*/
Pilha* desempilhar(Pilha* p);

Arvore* getArvoreTopoPilha(Pilha* p);

/*Cria um novo no no inicio da lista*/
Pilha* liberarPilha(Pilha* p);

Pilha* empilharExpressaoOperador(Pilha* p, char* operador);

int tamanhoPilha(Pilha* p);

void imprimirArvorePilha(Pilha* p);
