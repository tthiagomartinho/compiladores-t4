
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

void arvore_imprime_profundidade(Arvore* a, int profundidade){
   if (!arvore_vazia(a)){
       arvore_imprime_profundidade(a->esquerda, profundidade+1);//imprime a sad
       int i;
       for (i=0; i<profundidade; i++) {
               printf(" ");
       }
       switch(a->tipo){
           case TIPO_INTEIRO:
              printf("%d", * (int*) a->valorNo); // imprime a raiz
              break;
           case TIPO_REAL:
              printf("%f", * (float*) a->valorNo); // imprime a raiz
              break;
           case TIPO_LITERAL:
              printf("%s", (char*) a->valorNo); // imprime a raiz
              break;
           case TIPO_VARIAVEL:{
               Variavel* v = (Variavel*) a->valorNo;
               printf("%s", getNomeVariavel(v)); // imprime a raiz
              break;
           }default:
               break;
       }
       arvore_imprime_profundidade(a->centro, profundidade+1); //imprime a sae
       arvore_imprime_profundidade(a->direita, profundidade+1); //imprime a sae
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
	/*if(!arvore_vazia(a)){
		liberarArvore(a->esquerda);
		liberarArvore(a->centro);
		liberarArvore(a->direita);
		if(a->tipo == TIPO_LITERAL){
			free(a->valorNo);
			a->valorNo = NULL;
		}
		free(a);
	}*/
	return NULL;
}

int _print_t(Arvore *tree, int is_left, int offset, int depth, char s[20][255])
{
    char b[20];
    int width = 5;

    if (!tree) return 0;

    switch(tree->tipo){
           case TIPO_INTEIRO:
           		sprintf(b, "%d", * (int*) tree->valorNo);
              break;
           case TIPO_REAL:
              sprintf(b, "%f", * (float*) tree->valorNo);
              break;
           case TIPO_LITERAL:
              sprintf(b, "%s", (char*) tree->valorNo);
              break;
           case TIPO_VARIAVEL:{
               Variavel* v = (Variavel*) tree->valorNo;
               sprintf(b, "%s", getNomeVariavel(v));
              break;
           }default:
               break;
       }

    int left  = _print_t(tree->esquerda,  1, offset,                depth + 1, s);
    int right = _print_t(tree->centro, 0, offset + left + width, depth + 1, s);

#ifdef COMPACT
    int i;
    for (i = 0; i < width; i++)
        s[depth][offset + left + i] = b[i];

    if (depth && is_left) {

        for (i = 0; i < width + right; i++)
            s[depth - 1][offset + left + width/2 + i] = '-';

        s[depth - 1][offset + left + width/2] = '.';

    } else if (depth && !is_left) {

        for (i = 0; i < left + width; i++)
            s[depth - 1][offset - width/2 + i] = '-';

        s[depth - 1][offset + left + width/2] = '.';
    }
#else
    int i;
    for (i = 0; i < width; i++)
        s[2 * depth][offset + left + i] = b[i];

    if (depth && is_left) {

        for (i = 0; i < width + right; i++)
            s[2 * depth - 1][offset + left + width/2 + i] = '-';

        s[2 * depth - 1][offset + left + width/2] = '+';
        s[2 * depth - 1][offset + left + width + right + width/2] = '+';

    } else if (depth && !is_left) {

        for (i = 0; i < left + width; i++)
            s[2 * depth - 1][offset - width/2 + i] = '-';

        s[2 * depth - 1][offset + left + width/2] = '+';
        s[2 * depth - 1][offset - width/2 - 1] = '+';
    }
#endif

    return left + width + right;
}

int print_t(Arvore *tree)
{
	int i;
    char s[20][255];
    for (i = 0; i < 20; i++)
        sprintf(s[i], "%80s", " ");

    _print_t(tree, 0, 0, 0, s);

    for (i = 0; i < 20; i++)
        printf("%s\n", s[i]);
}