
#include "Arvore.h"

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

Arvore* getProx(Arvore* a){
    return a->prox;
}

Arvore* setProxComando(Arvore* a, Arvore* prox){
    if (a == NULL) {
        a = prox;
    } else {
        Arvore* aux = a;
        while (aux -> prox != NULL) {
            aux = aux -> prox;
        }
        aux -> prox = prox;
    }
    return a;
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

    print ( root->esquerda, level + 1 );
    padding ( '\t', level );
    if(root->tipo != TIPO_LISTA){
       printf("%s %d ", (char*) root->valorNo, tamanhoLista(root->dimensoesMatriz)); 
    }else{
        Lista* l = (Lista*) root->valorNo;
        Lista* aux;
        printf("IMPRIMINDO LISTA\n");
        for(aux = l; aux != NULL; aux = aux -> prox){
            switch(aux -> tipo){
                case TIPO_ARVORE:{
                    Arvore* ab = (Arvore*) aux->info;
                    imprimirArvoreComandos(ab);
                    break;
                }
                default:
                    printf("%s\n", (char*) aux->info);
                    break;
            }
        }
        printf("FIM DA IMPRESSAO DA LISTA\n");
    }
    print ( root->centro, level + 1 );
    padding ( '\t', level );
    print ( root->direita, level + 1 );
    padding ( '\t', level );


    print ( root->prox, level);
  }
}

void imprimirArvoreComandos(Arvore* programa){
    print(programa, 0);
}