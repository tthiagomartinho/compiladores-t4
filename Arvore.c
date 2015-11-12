
#include "Arvore.h"

struct arvore{
	char* valorNo;
	int tipo;
    char* escopo;
    Lista* dimensoesMatriz;
	struct arvore* esquerda;
	struct arvore* centro;
	struct arvore* direita;
	struct arvore* prox;
};

Arvore* inicializaArvore(int tipo, void* valor, char* escopo, Lista* dimensoesMatriz){
	Arvore* a = (Arvore*)malloc(sizeof(Arvore));
	if(tipo != TIPO_LISTA){
		a->valorNo = (char*)malloc((strlen(valor) + 1)*sizeof(char));
		strcpy(a->valorNo, valor);
	}else{
		a->valorNo = valor;
	}
	
	if(escopo != NULL){
        a->escopo = (char*)malloc((strlen(escopo) + 1)*sizeof(char));
        strcpy(a->escopo, escopo);
    }
    
    a->dimensoesMatriz = dimensoesMatriz;
	a->tipo = tipo;
	a->esquerda = NULL;
	a->centro = NULL;
	a->direita = NULL;
	a->prox = NULL;
	return a;
}

Arvore* setFilhosEsquerdaCentroDireita(Arvore* arvore, Arvore* arvoreEsquerda, Arvore* arvoreCentro, Arvore* arvoreDireita){
    if(arvoreEsquerda != NULL){
        arvore->esquerda = arvoreEsquerda;
    }
    if(arvoreDireita != NULL){
        arvore->direita = arvoreDireita;
    }
    if(arvoreCentro != NULL){
        arvore->centro = arvoreCentro;
    }
    return arvore;
}

int getTipoNo(Arvore* a){
	return a->tipo;
}

void* getValorNo(Arvore* a){
	return a->valorNo;
}

int arvore_vazia(Arvore* a){
	if(a == NULL){
		return 1;
	}else{
		return 0;
	}
}

Arvore* liberarArvore(Arvore* a){
    if(!arvore_vazia(a)){
		liberarArvore(a->esquerda);
		liberarArvore(a->centro);
		liberarArvore(a->direita);
		if(a->tipo != TIPO_LISTA){
			free(a->valorNo);
			a->valorNo = NULL;
		}
		free(a);
	}
	return NULL;
}

int ehNoFolha(Arvore* a){
    if(a->esquerda == NULL && a->centro == NULL && a->direita == NULL){
        return 1;
    }else{
        return 0;
    }
}

Arvore* getFilhoDireita(Arvore* a){
    return a->direita;
}
Arvore* getFilhoEsquerda(Arvore* a){
    return a->esquerda;
}
Arvore* getFilhoCentro(Arvore* a){
    return a->centro;
}

char* getEscopo(Arvore* a){
    return a->escopo;
}

void padding ( char ch, int n ){
  int i;
  for ( i = 0; i < n; i++ )
    putchar ( ch );
}
void print ( Arvore *root, int level ){
  int i;
  if ( root == NULL ) {
    padding ( '\t', level );
    puts ( "~" );
  }
  else {
    print ( root->centro, level + 1 );
    padding ( '\t', level );
    if(root->tipo != TIPO_LISTA){
       printf("%s", (char*) root->valorNo); 
    }
    print ( root->esquerda, level + 1 );
  }
}