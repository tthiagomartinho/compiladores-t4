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

Pilha* empilharElementoCriandoArvore(Pilha* p, int tipo, void* valorNo){
    Arvore* a = inicializaArvore(tipo, valorNo, NULL, NULL);
    p = empilhar(p, a);
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
Pilha* desempilhar(Pilha* p) {
	if(p == NULL){
		return p;
	}	

	Pilha* pilha = p;
	p = p -> prox;
    return p;
}

Arvore* getArvoreTopoPilha(Pilha* p){
    if(p != NULL){
        return p->arvore;
    }else{
        return NULL;
    }
}

/*Cria um novo no no inicio da lista*/
Pilha* liberarPilha(Pilha* p) {
	Pilha* pilha;
	for(p; p != NULL; ){
		Pilha* aux = p -> prox;	
		p -> arvore = liberarArvore(p->arvore);
		free(p);
		p = aux;
	}
    return NULL;
}

int tamanhoPilha(Pilha* p){
    int i = 0;
    Pilha* pilha;
    for(pilha = p; pilha != NULL; pilha = pilha -> prox){
        i++;
    }
    return i;
}

Pilha* empilharExpressaoOperador(Pilha* p, char* operador){
    if(tamanhoPilha(p) > 1){
        Arvore* primeiro, *segundo;
        Pilha* pilha;
        primeiro = getArvoreTopoPilha(p);
        p = desempilhar(p);
        segundo = getArvoreTopoPilha(p);
        p = desempilhar(p);
        Arvore* arvoreOperador = inicializaArvore(TIPO_LITERAL, operador, NULL, NULL);
        arvoreOperador = setFilhosEsquerdaCentroDireita(arvoreOperador, primeiro, segundo, NULL);
        p = empilhar(p, arvoreOperador);
    }
    return p;
}

void imprimirArvorePilha(Pilha* p){
  //  arvore_imprime_profundidade(p->arvore, 0);
}
