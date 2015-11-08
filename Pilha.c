#include "Pilha.h"

struct pilha{
	Arvore* arvore;
	struct pilha* prox;
};

Pilha* inicializarPilha(){
	return NULL;
}

Pilha* criarNovoItemPilha(Arvore* a){
	Pilha* p = (Pilha*)malloc(sizeof(Pilha));
	p->arvore = a;
	return p;
}

/*Cria um novo no no inicio da lista*/
Pilha* empilhar(Pilha* p, Arvore* a) {
	Pilha* pilha = criarNovoItemPilha(a);
	pilha->prox = p;
	p = pilha;
    return p;
}

/*Cria um novo no no inicio da lista*/
Pilha* desempilhar(Pilha* p, Arvore* a) {
	if(p == NULL){
		return p;
	}	

	Pilha* pilha = p;
	p = p -> prox;
	a = pilha -> arvore;
    return p;
}

/*Cria um novo no no inicio da lista*/
Pilha* liberar(Pilha* p) {
	Pilha* pilha;
	for(p; p != NULL; ){
		Pilha* aux = p -> prox;	
		p -> arvore = liberarArvore(p->arvore);
		free(p);
		p = aux;
	}
    return p;
}
