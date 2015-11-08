
#include "Arvore.h"

struct arvore{
	void* valorNo;
	int tipo;
	struct arvore* esquerda;
	struct arvore* centro;
	struct arvore* direita;
	struct arvore* prox;
};

Arvore* inicializaArvore(int tipo, void* valor){
	Arvore* a = (Arvore*)malloc(sizeof(Arvore));
	if(tipo == TIPO_LITERAL){
		a->valorNo = (char*)malloc((strlen(valor) + 1)*sizeof(char));
		strcpy(a->valorNo, valor);
	}else{
		a->valorNo = valor;
	}
	
	a->tipo = tipo;
	a->esquerda = NULL;
	a->centro = NULL;
	a->direita = NULL;
	a->prox = NULL;
	return a;
}

int getTipoNo(Arvore* a){
	return a->tipo;
}

void arvore_imprime_profundidade(Arvore* a, int profundidade){
       if (!arvore_vazia(a)){
               arvore_imprime_profundidade(a->direita, profundidade+1);//imprime a sad
               int i;
               for (i=0; i<profundidade; i++) {
                       printf(" ");
               }
               printf("%c\n", a->info); // imprime a raiz
               arvore_imprime_profundidade(a->esquerda, profundidade+1); //imprime a sae
       }
}

int arvore_vazia(Arvore* a){
	if(a == NULL){
		return 1;
	}else{
		return 0;
	}
}

Arvore* liberarArvore(Arvore* a){
	return a;
}
