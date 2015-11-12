#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hash.h"

typedef struct arvore Arvore;

Arvore* inicializaArvore(int tipo, void* valor, char* escopo, Lista* dimensoesMatriz);
int getTipoNo(Arvore* a);
void* getValorNo(Arvore* a);
char* getEscopo(Arvore* a);
void arvore_imprime_profundidade(Arvore* a, int profundidade);
int arvore_vazia(Arvore* a);
Arvore* getFilhoDireita(Arvore* a);
Arvore* getFilhoEsquerda(Arvore* a);
Arvore* getFilhoCentro(Arvore* a);
int ehNoFolha(Arvore* a);
Arvore* liberarArvore(Arvore* a);
Arvore* setFilhosEsquerdaCentroDireita(Arvore* arvore, Arvore* arvoreEsquerda, Arvore* arvoreCentro, Arvore* arvoreDireita);
void print ( Arvore *root, int level );