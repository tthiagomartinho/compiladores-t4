#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hash.h"

typedef struct arvore Arvore;

Arvore* inicializaArvore(int tipo, void* valor);
int getTipoNo(Arvore* a);
void arvore_imprime_profundidade(Arvore* a, int profundidade);
int arvore_vazia(Arvore* a);
Arvore* liberarArvore(Arvore* a);
Arvore* setFilhosEsquerdaCentroDireita(Arvore* arvore, Arvore* arvoreEsquerda, Arvore* arvoreCentro, Arvore* arvoreDireita);

int _print_t(Arvore *tree, int is_left, int offset, int depth, char s[20][255]);

int print_t(Arvore *tree);