#ifndef HASH_H
#define HASH_H

#ifdef  __cplusplus
extern "C" {
#endif

    #include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct funcao Funcao;
typedef struct variavel Variavel;

typedef struct lista {
    void *info;
    int tipo; //real = 0, inteiro = 1, caractere = 2, literal = 3, logico = 4, void = -1, variavel = 6, funcao = 7
    struct lista *prox;
} Lista;

#define TIPO_VOID -1
#define TIPO_REAL 0 
#define TIPO_INTEIRO 1 
#define TIPO_CARACTERE 2 
#define TIPO_LITERAL 3 
#define TIPO_LOGICO 4 
#define TIPO_MATRIZ 5 
#define TIPO_VARIAVEL 6
#define TIPO_FUNCAO 7
#define TIPO_ARVORE 8
#define TIPO_LISTA 9

/**************************FUNCOES BASICAS DE LISTAS***************************/
Lista* inicializarLista();

/*Cria um novo no no inicio da lista*/
Lista* criarNovoNoLista(int tipo, void* info, Lista* prox);

/*Cria um novo no no fim da lista*/
Lista* criarNovoNoListaFim(int tipo, void* info, Lista* primeiro);

Lista* liberarMemoriaLista(Lista* lista);

/**************************FUNCOES TABELA HASH*********************************/
Lista** inicializarTabelaHash();

Lista** liberarMemoriaTabelaHash(Lista** tabelaHash);

/**************************MANIPULACAO DE VARIAVEIS****************************/

Variavel* criarNovaVariavel(char* nome, Lista* dimensoesMatriz, int tipo, char* escopo, int linhaDeclarada);

Variavel* liberarMemoriaVariavel(Variavel* v);

Variavel* buscarVariavelTabelaHash(Lista** tabelaHash, char nome[], char* escopo);

int getTipoVariavel(Variavel* variavel);

void setVariavelUsada(Variavel* v);

char* getNomeVariavel(Variavel* v);

char* getEscopoVariavel(Variavel* v);

/**************************MANIPULACAO TABELA HASH DE VARIAVEIS*****************/

Lista** inserirVariavelTabelaHash(Lista** tabelaHash, Variavel* v, Lista* dimensoesMatriz, int tipo, char* escopo);

void imprimirTabelaHash(Lista** tabelaHash);

Lista** inserirListaVariaveisTabelaHash(Lista** tabelaHash, Lista* dimensoesMatriz, Lista* variaveis, int tipo, char* escopo);

void imprimirRelatorioVariaveisNaoUtilizadas(Lista** hashVariavel);

void* getValorVariavel(Variavel* v);

// seta o valor da variavel de acordo com o tipo passado
void setVariavelValor (Variavel* v, void* valor, int tipo);

/**************************MANIPULACAO DE FUNCOES******************************/
Funcao* criarFuncao(char* nome);

Funcao* buscarFuncaoTabelaHash(Lista** tabelaHash, char* nome);

Lista** inserirFuncaoTabelaHash(Funcao* funcao, Lista* variaveis, int tipo, Lista** tabelaHash);

Funcao* setConfiguracaoParametrosFuncao(Funcao* funcao, Lista* variaveis);

Funcao* liberarMemoriaFuncao(Funcao* f);

char* getNomeFuncao(Funcao* funcao);

int isChamadaFuncaoValida(Funcao* funcao, Lista* parametrosFuncao);

/**************************MANIPULACAO TABELA HASH DE FUNCOES*************************************/

int getTipoRetornoFuncao(Lista** tabelaHash, Funcao* funcao);

Lista** inserirFuncoesInicias(Lista** hashFuncao);

/**************************RANDOM******************************/

void imprimirTabelaHashFuncao(Lista** tabelaHash);

void imprimirLista(Lista* l);

int operadoresIguais(Lista* l);

int isExpressaoValida(Lista* l, int tipoExpressaoAtribuicao);

int validarAcessoMatriz(Variavel* v, Lista* dimensoesMatriz);

Lista* copiarListaChar(Lista* lista);

int tamanhoLista(Lista* lista);


#ifdef  __cplusplus
}
#endif

#endif  /* HASH_H */