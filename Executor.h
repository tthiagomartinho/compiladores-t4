#include "hash.h"
#include "Arvore.h"

#define EXECUTOR_ATRIBUICAO 0
#define	EXECUTOR_ENQUANTO 1
#define	EXECUTOR_PARA 2
#define EXECUTOR_LEIA 3
#define	EXECUTOR_IMPRIMA 4
#define	EXECUTOR_SE 5
#define	EXECUTOR_FACA_ENQUANTO 6
#define	EXECUTOR_AVALIE 7
#define	EXECUTOR_RETORNO 8
#define	EXECUTOR_MAIS_MAIS_MENOS_MENOS 9
#define EXECUTOR_CHAMADA_FUNCAO 10

int avaliarExpressao(Arvore* arvore, Lista** tabelaVariavel);

int avaliarExpressaoInteiro(Arvore* arvore, Lista** tabelaVariavel);
