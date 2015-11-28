#include "hash.h"
#include "Arvore.h"


int avaliaExpressaoInteiro (Arvore* a, Lista** hashVariavel, Lista** hashFuncao);

float avaliaExpressaoReal (Arvore* a, Lista** hashVariavel, Lista** hashFuncao);

int avaliaExpressaoLogica (Arvore* a, Lista** hashVariavel, Lista** hashFuncao);

int getTipoExpressaoLogica(Arvore* a, Lista** hashVariavel, Lista** hashFuncao);

int getPosicaoMatriz(Lista* dimensoesMatriz, Variavel* variavel);

void executarAtribuicao(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao);

void executarLeia(Variavel* variavel);

void executarImprima(Arvore* comandoAtual, Lista** hashVariavel);

void executarPara(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao);

void executarSe(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao);

void executarMaisMais(Arvore* comandoAtual, Lista** hashVariavel);

void executarMenosMenos(Arvore* comandoAtual, Lista** hashVariavel);

void executarEnquanto(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao);

void executarFacaEnquanto(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao);

void executarAvalie(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao);

void executarSeForFuncao(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao, Variavel* v, int posicao);

void executarRetorne(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao, Variavel* v, int posicao);

void executarMaximo(Lista** hashVariavel, Arvore* parametrosPassados,  Variavel* variavel, int posicao);

void executarMinimo(Lista** hashVariavel, Arvore* parametrosPassados, Variavel* variavel, int posicao);

int cmpfunc (const void * a, const void * b);

void executarCentral(Lista** hashVariavel, Arvore* parametrosPassados, Variavel* variavel, int posicao);		

void exetuarPrograma(Arvore* programa, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao);

void exetuarPrograma1(Arvore* programa, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao, int executarFuncao, Variavel* v, int posicao);