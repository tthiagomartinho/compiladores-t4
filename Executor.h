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

int avaliaExpressaoInteiro (Arvore* a, Lista** hashVariavel, Lista** hashFuncao);

float avaliaExpressaoReal (Arvore* a, Lista** hashVariavel, Lista** hashFuncao);

int avaliaExpressaoLogica (Arvore* a, Lista** hashVariavel, Lista** hashFuncao);

int getTipoExpressaoLogica(Arvore* a, Lista** hashVariavel, Lista** hashFuncao);

void executarAtribuicao(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao);

void executarLeia(Variavel* variavel);

void executarImprima(Arvore* comandoAtual, Lista** hashVariavel);

void executarPara(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao);

void executarSe(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao);

void executarMaisMais(Arvore* comandoAtual, Lista** hashVariavel);

void executarMenosMenos(Arvore* comandoAtual, Lista** hashVariavel);

void executarEnquanto(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao);

void executarFacaEnquanto(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao);

void executarAvalie(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao);

void executarSeForFuncao(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao);

void exetuarPrograma(Arvore* programa, Lista** hashVariavel, Lista** hashFuncao);
