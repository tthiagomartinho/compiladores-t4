#include <stdio.h>
#include <stdlib.h>
#include "Arvore.h"

typedef struct pilha Pilha;

Pilha* inicializarPilha();

Pilha* criarNovoItemPilha(Arvore* a);

/*Cria um novo no no inicio da lista*/
Pilha* empilhar(Pilha* p, Arvore* a);

/*Cria um novo no no inicio da lista*/
Pilha* desempilhar(Pilha* p, Arvore* a);

/*Cria um novo no no inicio da lista*/
Pilha* liberar(Pilha* p);
