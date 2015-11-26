%{
#include <stdio.h>
#include "hash.h"
#include "Pilha.h"
#include "Executor.h"

#define TIPO_OPERADOR_LOGICO 1
#define TIPO_OPERADOR_ARITMETICO 2
    
    extern int line_num;
    extern char* yytext;
    extern char identificador[255];
    int tipo;
    char escopo[255] = "global";
    char nomeVariavel[255];
    Lista** hashVariavel = NULL;
    Lista** hashFuncao = NULL;
    Lista* variaveis = NULL;
    Lista* variaveisFuncao = NULL;
    Lista* dimensoesMatriz = NULL;
    Lista* expressao = NULL;
    Lista* operadores = NULL;
    Lista* parametrosFuncao = NULL;
    Funcao* funcao = NULL;
    int tipoExpressaoAtribuicao;
    int tipoRetornoFuncao;
    Pilha* p = NULL;
    Arvore* arvoreComandoAtual = NULL;
    Lista* listaComandos = NULL;
    Arvore* programa = NULL;
    char* nomePrograma;
    Pilha* pilhaNiveis = NULL;
    Lista* comandosRepeticao = NULL;
    Arvore* arvoreParametrosFuncao = NULL;


    void liberarMemoriaAlocada() {
        hashVariavel = liberarMemoriaTabelaHash(hashVariavel);
        hashFuncao = liberarMemoriaTabelaHash(hashFuncao);
        variaveis = liberarMemoriaLista(variaveis);
        variaveisFuncao = liberarMemoriaLista(variaveisFuncao);
        dimensoesMatriz = liberarMemoriaLista(dimensoesMatriz);
        expressao = liberarMemoriaLista(expressao);
        operadores = liberarMemoriaLista(operadores);
        parametrosFuncao = liberarMemoriaLista(parametrosFuncao);
    }

    void finalizarProgramaComErro(char* erro) {
        printf("Erro semantico na linha %d. %s.\n", line_num, erro);
        liberarMemoriaAlocada();
        exit(0);
    }

    Variavel* validarIdentificadorSairCasoInvalido() {
        Variavel* v = buscarVariavelTabelaHash(hashVariavel, identificador, escopo);
        if(v == NULL && strcmp(escopo, "global") != 0){
            v = buscarVariavelTabelaHash(hashVariavel, identificador, "global");
        }
        if(v == NULL){
            finalizarProgramaComErro("Variavel nao declarada");
        }
        setVariavelUsada(v);
        return v;
    }

    void validarExpressaoSairCasoInvalido() {
        int operadoresIguais1 = operadoresIguais(operadores);
        if(operadoresIguais1 == 0){
            finalizarProgramaComErro("Noa eh possivel ter operadores logicos e artimeticos na mesma expressao");
        }

        Lista* aux = expressao;
        int x = isExpressaoValida(aux, tipoExpressaoAtribuicao);
        if(x == 0){
            finalizarProgramaComErro("Expressao invalida");
        }
        expressao = liberarMemoriaLista(expressao);
        operadores = liberarMemoriaLista(operadores);
    }

    void validarAcessoMatrizSairCasoInvalido(Variavel* v) {
        int validacao = validarAcessoMatriz(v, dimensoesMatriz);
        if(validacao == 0){ //identificador nao eh matriz
            finalizarProgramaComErro("A variavel indicada nao eh uma matriz");
        } else if(validacao == -1){ //identificador eh matriz porem o indice de acesso ta errado
            finalizarProgramaComErro("A posicao que deseja acessar da matriz nao existe");
        }
    }

    Variavel* validarOperadoresMMMMSairCasoInvalido() { //++ --
        Variavel* v = validarIdentificadorSairCasoInvalido();
        int tipoVariavel = getTipoVariavel(v);
        if(tipoVariavel != TIPO_REAL && tipoVariavel != TIPO_INTEIRO){
            finalizarProgramaComErro("So variaveis do tipo real ou inteiro podem ser associadas a esse comando");
        }
        return v;
    }

    void incluirComando(){
        Arvore* topo = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        topo = setProxComando(topo, arvoreComandoAtual);
        pilhaNiveis = empilhar(pilhaNiveis, topo);
      //  listaComandos = criarNovoNoListaFim(TIPO_ARVORE, arvoreComandoAtual, listaComandos);
        arvoreComandoAtual = NULL;
        p = NULL;
    }

%}

/* TOKENS DEFINICOES BASICAS */
%token token_identificador
%token token_inteiro
%token token_inteiroNegativo
%token token_real
%token token_realNegativo
%token token_literal
%token token_caractere

/* TOKENS PALAVRAS RESERVADAS */
%token token_algoritmo
%token token_variaveis
%token token_fimVariaveis
%token token_inicio
%token token_fim
%token token_se
%token token_entao
%token token_senao
%token token_fimSe
%token token_de
%token token_leia
%token token_imprima
%token token_verdadeiro
%token token_falso
%token token_enquanto
%token token_faca
%token token_fimEnquanto
%token token_para
%token token_ate
%token token_fimPara
%token token_funcao
%token token_fimFuncao
%token token_retorne
%token token_passo
%token token_avalie
%token token_fimAvalie
%token token_caso
%token token_pare
%token token_facaEnquanto
%token token_fimFacaEnquanto

/* TOKENS TIPOS DE DADOS */
%token token_tipoReal
%token token_tipoInteiro
%token token_tipoCaractere
%token token_tipoLiteral
%token token_tipoLogico
%token token_tipoMatriz

/* TOKENS OPERADORES */
%token token_operadorAtribuicao
%token token_operadorPotencia
%token token_operadorSomaSoma
%token token_operadorSubtraiSubtrai
%token token_operadorPorcento
%token token_operadorMais
%token token_operadorMenos
%token token_operadorVezes
%token token_operadorDividir
%token token_operadorMaior
%token token_operadorMaiorIgual
%token token_operadorMenor
%token token_operadorMenorIgual
%token token_operadorIgualIgual
%token token_operadorDiferente
%token token_operadorE
%token token_operadorOu
%token token_operadorNao

/*TOKENS SIMBOLOS */
%token token_simboloPontoVirgula
%token token_simboloDoisPontos
%token token_simboloVirgula
%token token_simboloAbreParentese
%token token_simboloFechaParentese
%token token_simboloAbreColchete
%token token_simboloFechaColchete
%token token_simboloEspecial

%start ALGORITMO

%%

ALGORITMO
    : token_algoritmo token_identificador {
        nomePrograma = (char*)malloc((strlen(identificador) + 1)*sizeof(char));
        strcpy(nomePrograma, identificador);
        programa = inicializaArvore(TIPO_LITERAL, nomePrograma, NULL, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, NULL);
    } token_simboloPontoVirgula PROGRAMA
    ;

PROGRAMA
    : VARIAVEIS DECLARACAO_FUNCAO {p = NULL;} PROGRAMA_PRINCIPAL
    | VARIAVEIS PROGRAMA_PRINCIPAL
    | DECLARACAO_FUNCAO {p = NULL;} PROGRAMA_PRINCIPAL
    | PROGRAMA_PRINCIPAL
    ;

VARIAVEIS
    : token_variaveis DECLARACAO_VARIAVEL token_fimVariaveis
    ;

DECLARACAO_VARIAVEL
    : DECLARACAO_VARIAVEL DECLARACAO_VARIAVEL_GERAL
    | DECLARACAO_VARIAVEL_GERAL
    ;

DECLARACAO_VARIAVEL_GERAL
    : LISTA_VARIAVEIS token_simboloDoisPontos TIPO_VARIAVEIS { 
        hashVariavel = inserirListaVariaveisTabelaHash(hashVariavel, dimensoesMatriz, variaveis, tipo, escopo);
        if(hashVariavel == NULL){
            finalizarProgramaComErro("Variavel redeclarada");
        }
        variaveis = liberarMemoriaLista(variaveis);
        dimensoesMatriz = liberarMemoriaLista(dimensoesMatriz);
    }  token_simboloPontoVirgula
    ;

LISTA_VARIAVEIS
    : LISTA_VARIAVEIS token_simboloVirgula token_identificador{
    
        Variavel* var = criarNovaVariavel(identificador, NULL, tipo, escopo, line_num) ;
        Lista* l = criarNovoNoLista(TIPO_VARIAVEL, var, variaveis);
        variaveis = l;
    }
    | token_identificador {
        Variavel* var = criarNovaVariavel(identificador, NULL, tipo, escopo, line_num) ;
        Lista* l = criarNovoNoLista(TIPO_VARIAVEL, var, variaveis);
        variaveis = l;
    } 
    ;

DECLARACAO_FUNCAO
    : DECLARACAO_FUNCAO token_funcao token_identificador{
        if (buscarFuncaoTabelaHash(hashFuncao, identificador) != NULL) {
            finalizarProgramaComErro("Funcao ja declarada");
        }
        funcao = criarFuncao(identificador);
        strcpy(escopo, identificador);
        Arvore* funcaoArvore = inicializaArvore(TIPO_FUNCAO, identificador, NULL, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, funcaoArvore);
    } DECLARACAO_FUNCAO_ARGUMENTOS {
        Arvore* comandosFuncao = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        Arvore* funcaoArvore = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        funcaoArvore = setFilhosEsquerdaCentroDireita(funcaoArvore, NULL, comandosFuncao, NULL);
        Arvore* a = setProxComando(getFilhoCentro(programa), funcaoArvore);
        programa = setFilhosEsquerdaCentroDireita(programa, NULL, a, NULL);
    }

    | token_funcao token_identificador{
        if (buscarFuncaoTabelaHash(hashFuncao, identificador) != NULL) {
            finalizarProgramaComErro("Funcao ja declarada");
        }
        funcao = criarFuncao(identificador);
        strcpy(escopo, identificador);
        Arvore* funcaoArvore = inicializaArvore(TIPO_FUNCAO, identificador, NULL, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, funcaoArvore);
    } DECLARACAO_FUNCAO_ARGUMENTOS {
        Arvore* comandosFuncao = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        Arvore* funcaoArvore = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        funcaoArvore = setFilhosEsquerdaCentroDireita(funcaoArvore, NULL, comandosFuncao, NULL);
        Arvore* a = setProxComando(getFilhoCentro(programa), funcaoArvore);
        programa = setFilhosEsquerdaCentroDireita(programa, NULL, a, NULL);
    }
    ;

DECLARACAO_FUNCAO_ARGUMENTOS
    : token_simboloAbreParentese PARAMETRO_DECLARACAO_FUNCAO token_simboloFechaParentese token_simboloDoisPontos DECLARACAO_FUNCAO_ARGUMENTOS2
    | token_simboloAbreParentese token_simboloFechaParentese token_simboloDoisPontos DECLARACAO_FUNCAO_ARGUMENTOS2
    ;

DECLARACAO_FUNCAO_ARGUMENTOS2
    : TIPO_VARIAVEL_PRIMITIVO{
        hashFuncao = inserirFuncaoTabelaHash(funcao, variaveisFuncao, tipo, hashFuncao);
        Arvore* parametros = inicializaArvore(TIPO_LISTA, variaveisFuncao, NULL, NULL);
        variaveisFuncao = NULL;
        Arvore* topo = getArvoreTopoPilha(pilhaNiveis);
        topo = setFilhosEsquerdaCentroDireita(topo, parametros, NULL, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, NULL);
    } ROTINA_FUNCAO token_fimFuncao
    | {
        hashFuncao = inserirFuncaoTabelaHash(funcao, variaveisFuncao, TIPO_VOID, hashFuncao);
        Arvore* parametros = inicializaArvore(TIPO_LISTA, variaveisFuncao, NULL, NULL);
        variaveisFuncao = NULL;
        Arvore* topo = getArvoreTopoPilha(pilhaNiveis);
        topo = setFilhosEsquerdaCentroDireita(topo, parametros, NULL, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, NULL);
    } ROTINA_FUNCAO token_fimFuncao
    ;

PARAMETRO_DECLARACAO_FUNCAO
    : PARAMETRO_DECLARACAO_FUNCAO token_simboloVirgula token_identificador{
        strcpy(nomeVariavel, identificador);
    } token_simboloDoisPontos TIPO_VARIAVEL_PRIMITIVO{
        Variavel* var = criarNovaVariavel(nomeVariavel, NULL, tipo, escopo, line_num) ;
        Lista* l = criarNovoNoListaFim(TIPO_VARIAVEL, var, variaveisFuncao);
        variaveisFuncao = l;
    hashVariavel = inserirVariavelTabelaHash(hashVariavel, var, NULL, tipo, escopo);
    } 
    | token_identificador{
        strcpy(nomeVariavel, identificador);
    } token_simboloDoisPontos TIPO_VARIAVEL_PRIMITIVO{
        Variavel* var = criarNovaVariavel(nomeVariavel, NULL, tipo, escopo, line_num) ;
        Lista* l = criarNovoNoListaFim(TIPO_VARIAVEL, var, variaveisFuncao);
        variaveisFuncao = l;
    hashVariavel = inserirVariavelTabelaHash(hashVariavel, var, NULL, tipo, escopo);
    }
    ;

ROTINA_FUNCAO
    : DECLARACAO_VARIAVEL token_inicio LISTA_COMANDOS token_fim
    | token_inicio LISTA_COMANDOS token_fim
    ;

COMANDO_RETORNO
    : token_retorne {
        int tipoRetornoFuncao = getTipoRetornoFuncao(hashFuncao, funcao);
        if(tipoRetornoFuncao == TIPO_VOID){
            finalizarProgramaComErro("Comando de retorno deve ser void");
        }
        tipoExpressaoAtribuicao = tipoRetornoFuncao;
    } EXPRESSAO {
        validarExpressaoSairCasoInvalido();
        Arvore* retorno = inicializaArvore(TIPO_LITERAL, "retorno", NULL, NULL);
        Arvore* ArvExp = getArvoreTopoPilha(p);
        p = desempilhar(p);
        retorno = setFilhosEsquerdaCentroDireita(retorno, ArvExp, NULL, NULL);
        arvoreComandoAtual = retorno;
    } token_simboloPontoVirgula
    | token_retorne {
        int tipoRetornoFuncao = getTipoRetornoFuncao(hashFuncao, funcao);
        if(tipoRetornoFuncao != TIPO_VOID){
            finalizarProgramaComErro("Comando retorno tem que ser diferente de void");
        }
        Arvore* retorno = inicializaArvore(TIPO_LITERAL, "retorno", NULL, NULL);
        retorno = setFilhosEsquerdaCentroDireita(retorno, NULL, NULL, NULL);
        arvoreComandoAtual = retorno;
    } token_simboloPontoVirgula
    ;

TIPO_VARIAVEIS
    : MATRIZ
    | TIPO_VARIAVEL_PRIMITIVO
    ;

TIPO_VARIAVEL_PRIMITIVO
    : token_tipoReal{
        tipo = TIPO_REAL;
    }
    | token_tipoInteiro{
        tipo = TIPO_INTEIRO;
    }
    | token_tipoCaractere{
        tipo = TIPO_CARACTERE;
    }
    | token_tipoLiteral{
        tipo = TIPO_LITERAL;
    }
    | token_tipoLogico {
        tipo = TIPO_LOGICO;
    }
    ;

MATRIZ
    : token_tipoMatriz POSICAO_MATRIZ token_de TIPO_VARIAVEL_PRIMITIVO
    ;

POSICAO_MATRIZ
    : POSICAO_MATRIZ token_simboloAbreColchete token_inteiro {
        dimensoesMatriz = criarNovoNoListaFim(TIPO_LITERAL, yytext, dimensoesMatriz);
    } token_simboloFechaColchete 
    | token_simboloAbreColchete token_inteiro {
        dimensoesMatriz = criarNovoNoListaFim(TIPO_LITERAL, yytext, dimensoesMatriz);
    }token_simboloFechaColchete
    ;

PROGRAMA_PRINCIPAL
    : token_inicio{
        strcpy(escopo, "global");
    } LISTA_COMANDOS {
        Arvore* comandos = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        programa = setFilhosEsquerdaCentroDireita(programa, comandos, NULL, NULL);
    } token_fim
    | token_inicio token_fim
    ;

LISTA_COMANDOS
    : LISTA_COMANDOS COMANDO_ATRIBUICAO token_simboloPontoVirgula {
        incluirComando();
    }
    | COMANDO_ATRIBUICAO token_simboloPontoVirgula {
        incluirComando();
    }
    | LISTA_COMANDOS COMANDO_ENQUANTO {
        incluirComando();
    }
    | COMANDO_ENQUANTO {
        incluirComando();
    }
    | LISTA_COMANDOS COMANDO_PARA  {
        incluirComando();
    }
    | COMANDO_PARA {
        incluirComando();
    }
    | LISTA_COMANDOS COMANDO_IMPRIMA {
        incluirComando();
    }
    | COMANDO_IMPRIMA {
        incluirComando();
    }
    | LISTA_COMANDOS COMANDO_CHAMADA_FUNCAO {
        arvoreComandoAtual = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        incluirComando();
    } token_simboloPontoVirgula 
    | COMANDO_CHAMADA_FUNCAO {
        arvoreComandoAtual = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        incluirComando();
    } token_simboloPontoVirgula
    | LISTA_COMANDOS COMANDO_SE {
        incluirComando();
    }
    | COMANDO_SE {
        incluirComando();
    }
    | LISTA_COMANDOS COMANDO_FACA_ENQUANTO {
        incluirComando();
    }
    | COMANDO_FACA_ENQUANTO {
        incluirComando();
    }
    | LISTA_COMANDOS COMANDO_AVALIE {
        incluirComando();
    }
    | COMANDO_AVALIE {
        incluirComando();
    }
    | LISTA_COMANDOS COMANDO_RETORNO {
        incluirComando();
    }
    | COMANDO_RETORNO {
        incluirComando();
    }
    | LISTA_COMANDOS COMANDO_MAIS_MAIS_MENOS_MENOS {
        incluirComando();
    }
    | COMANDO_MAIS_MAIS_MENOS_MENOS {
        incluirComando();
    }
    ;

COMANDO_ATRIBUICAO
    :  token_identificador {
        Variavel* v = validarIdentificadorSairCasoInvalido();
        tipoExpressaoAtribuicao = getTipoVariavel(v);
        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "=", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, novoNo, NULL, NULL);
    } 
    token_operadorAtribuicao COMANDO_ATRIBUICAO2
    | token_identificador POSICAO_MATRIZ{
        Variavel* v = validarIdentificadorSairCasoInvalido();
        validarAcessoMatrizSairCasoInvalido(v);
        dimensoesMatriz = liberarMemoriaLista(dimensoesMatriz);
        tipoExpressaoAtribuicao = getTipoVariavel(v);    
        Lista* copiaDimensoes = copiarListaChar(dimensoesMatriz);
        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), copiaDimensoes);
        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "=", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, novoNo, NULL, NULL);
    } 
    token_operadorAtribuicao COMANDO_ATRIBUICAO2
    ;

COMANDO_ATRIBUICAO2
    : VALOR_A_SER_ATRIBUIDO
    | COMANDO_LEIA {
        Arvore* ArvExp = inicializaArvore(TIPO_LITERAL, "leia", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, ArvExp, NULL);
    }
    ;

VALOR_A_SER_ATRIBUIDO
    : VALOR_A_SER_ATRIBUIDO EXPRESSAO {
        validarExpressaoSairCasoInvalido();

        Arvore* ArvExp = getArvoreTopoPilha(p);
        p = desempilhar(p);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, ArvExp, NULL);
    }
    | EXPRESSAO {
        validarExpressaoSairCasoInvalido();

        Arvore* ArvExp = getArvoreTopoPilha(p);
        p = desempilhar(p);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, ArvExp, NULL);
    }
    | VALOR_A_SER_ATRIBUIDO COMANDO_CHAMADA_FUNCAO {
        int tipoRetornoFuncao = getTipoRetornoFuncao(hashFuncao, funcao);
        if(tipoRetornoFuncao != tipoExpressaoAtribuicao){
            finalizarProgramaComErro("Tipo invalido associado a variavel");
        }
        Arvore* func = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, func, NULL);
    }
    | COMANDO_CHAMADA_FUNCAO {
        int tipoRetornoFuncao = getTipoRetornoFuncao(hashFuncao, funcao);
        if(tipoRetornoFuncao != tipoExpressaoAtribuicao){
            finalizarProgramaComErro("Tipo invalido associado a variavel");
        }
        Arvore* func = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, func, NULL);
    }
    ;

COMANDO_ENQUANTO
    : token_enquanto EXPRESSAO {
        tipoExpressaoAtribuicao = TIPO_LOGICO;
        validarExpressaoSairCasoInvalido();

        Arvore* ArvExp = getArvoreTopoPilha(p);
        p = desempilhar(p);
        p = NULL;
        Arvore* enquanto = inicializaArvore(TIPO_LITERAL, "enquanto", NULL, NULL);
        Arvore* faca = inicializaArvore(TIPO_LITERAL, "faca", NULL, NULL);
        enquanto = setFilhosEsquerdaCentroDireita(enquanto, ArvExp, faca, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, enquanto);
        pilhaNiveis = empilhar(pilhaNiveis, faca);
        //pilhaNiveis = empilhar(pilhaNiveis, NULL);


    } token_faca LISTA_COMANDOS {
        Arvore* faca = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        Arvore* enquanto = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        enquanto = setFilhosEsquerdaCentroDireita(enquanto, NULL, faca, NULL);
        arvoreComandoAtual = enquanto;
    } token_fimEnquanto
    ;

COMANDO_PARA
    : token_para token_identificador {
        Variavel* v = validarIdentificadorSairCasoInvalido();
        int tipoVariavel = getTipoVariavel(v);
        if(tipoVariavel != TIPO_INTEIRO){
            finalizarProgramaComErro("Comando PARA dever iterar sob variaveis do tipo inteiro");
        }
        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
        comandosRepeticao = criarNovoNoListaFim(TIPO_ARVORE, novoNo, comandosRepeticao);
    } token_de EXPRESSAO {
        tipoExpressaoAtribuicao = TIPO_INTEIRO;
        validarExpressaoSairCasoInvalido();

        Arvore* ArvExp = getArvoreTopoPilha(p);
        p = desempilhar(p);
        comandosRepeticao = criarNovoNoListaFim(TIPO_ARVORE, ArvExp, comandosRepeticao);
    } token_ate EXPRESSAO {
        tipoExpressaoAtribuicao = TIPO_INTEIRO;
        validarExpressaoSairCasoInvalido();

        Arvore* ArvExp = getArvoreTopoPilha(p);
        p = desempilhar(p);
        comandosRepeticao = criarNovoNoListaFim(TIPO_ARVORE, ArvExp, comandosRepeticao);
    }  COMANDO_PARA2
    ;   

COMANDO_PARA2
    : token_faca {
        Arvore* para = inicializaArvore(TIPO_LITERAL, "para", NULL, NULL);
        Arvore* faca = inicializaArvore(TIPO_LITERAL, "faca", NULL, NULL);
        Arvore* lista = inicializaArvore(TIPO_LISTA, comandosRepeticao, NULL, NULL);
        faca = setFilhosEsquerdaCentroDireita(faca, NULL, NULL, NULL);
        para = setFilhosEsquerdaCentroDireita(para, lista, faca, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, para);
        pilhaNiveis = empilhar(pilhaNiveis, faca);
        //pilhaNiveis = empilhar(pilhaNiveis, NULL);
        comandosRepeticao = NULL;
    } LISTA_COMANDOS {
        Arvore* faca = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        Arvore* para = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        setFilhosEsquerdaCentroDireita(para, NULL, faca, NULL);
        arvoreComandoAtual = para;
    } token_fimPara
    | token_passo INTEIRO {
        Arvore* ArvExp = inicializaArvore(TIPO_INTEIRO, yytext, NULL, NULL);
        comandosRepeticao = criarNovoNoListaFim(TIPO_ARVORE, ArvExp, comandosRepeticao);
        Arvore* para = inicializaArvore(TIPO_LITERAL, "para", NULL, NULL);
        Arvore* faca = inicializaArvore(TIPO_LITERAL, "faca", NULL, NULL);
        Arvore* lista = inicializaArvore(TIPO_LISTA, comandosRepeticao, NULL, NULL);
        faca = setFilhosEsquerdaCentroDireita(faca, NULL, NULL, NULL);
        para = setFilhosEsquerdaCentroDireita(para, lista, faca, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, para);
        pilhaNiveis = empilhar(pilhaNiveis, faca);
       // pilhaNiveis = empilhar(pilhaNiveis, NULL);
        comandosRepeticao = NULL;
        p = NULL;

    } token_faca LISTA_COMANDOS {
        Arvore* faca = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        Arvore* para = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        setFilhosEsquerdaCentroDireita(para, NULL, faca, NULL);
        arvoreComandoAtual = para;
    } token_fimPara
    ;

COMANDO_SE
    : token_se {
        tipoExpressaoAtribuicao = TIPO_LOGICO;
    } EXPRESSAO {
        validarExpressaoSairCasoInvalido();

        Arvore* ArvExp = getArvoreTopoPilha(p);
        p = desempilhar(p);
        p = NULL;
        Arvore* se = inicializaArvore(TIPO_LITERAL, "se", NULL, NULL);
        Arvore* entao = inicializaArvore(TIPO_LITERAL, "entao", NULL, NULL);
        Arvore* senao = inicializaArvore(TIPO_LITERAL, "senao", NULL, NULL);
        se = setFilhosEsquerdaCentroDireita(se, ArvExp, entao, senao);
        pilhaNiveis = empilhar(pilhaNiveis, se);
    } token_entao {
        Arvore* se = getArvoreTopoPilha(pilhaNiveis);
        Arvore* entao = getFilhoCentro(se);
        pilhaNiveis = empilhar(pilhaNiveis, entao); 
        //pilhaNiveis = empilhar(pilhaNiveis, NULL); 
    } LISTA_COMANDOS {
        Arvore* entao = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        Arvore* se = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        se = setFilhosEsquerdaCentroDireita(se, NULL, entao, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, se); 

    } COMANDO_SE2
    ;

COMANDO_SE2
    : token_senao {
        Arvore* se = getArvoreTopoPilha(pilhaNiveis);
        Arvore* senao = getFilhoDireita(se);
        pilhaNiveis = empilhar(pilhaNiveis, senao); 
        //pilhaNiveis = empilhar(pilhaNiveis, NULL); 
    }
     LISTA_COMANDOS {
        Arvore* senao = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        Arvore* se = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        setFilhosEsquerdaCentroDireita(se, NULL, NULL, senao);
        arvoreComandoAtual = se;
     } token_fimSe
    | token_fimSe {
        Arvore* se = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        arvoreComandoAtual = se;
    }
    ;

COMANDO_FACA_ENQUANTO
    : token_faca {
        tipoExpressaoAtribuicao = TIPO_LOGICO;
        validarExpressaoSairCasoInvalido();
        Arvore* facaEnquanto = inicializaArvore(TIPO_LITERAL, "faca-enquanto", NULL, NULL);
        Arvore* faca = inicializaArvore(TIPO_LITERAL, "faca", NULL, NULL);
        facaEnquanto = setFilhosEsquerdaCentroDireita(facaEnquanto, faca, NULL, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, facaEnquanto);
        pilhaNiveis = empilhar(pilhaNiveis, faca);
        //pilhaNiveis = empilhar(pilhaNiveis, NULL);
    } token_simboloDoisPontos LISTA_COMANDOS token_enquanto EXPRESSAO {
        tipoExpressaoAtribuicao = TIPO_LOGICO;
        validarExpressaoSairCasoInvalido();
        Arvore* ArvExp = getArvoreTopoPilha(p);
        p = desempilhar(p);

        Arvore* para = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        Arvore* facaEnquanto = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        facaEnquanto = setFilhosEsquerdaCentroDireita(facaEnquanto, ArvExp, para, NULL);
        arvoreComandoAtual = facaEnquanto;
        //pilhaNiveis = empilhar(pilhaNiveis, NULL);
    } token_fimEnquanto
    ;

COMANDO_AVALIE
    : token_avalie token_simboloAbreParentese token_identificador {
        Variavel* v = validarIdentificadorSairCasoInvalido();
        int tipoVariavel = getTipoVariavel(v);
        if(tipoVariavel != TIPO_INTEIRO){
            finalizarProgramaComErro("Nao eh possivel avaliar variaveis cujo tipo nao eh inteiro");
        }

        Arvore* avalie = inicializaArvore(TIPO_LITERAL, "avalie", NULL, NULL);
        // Arvore* casos = inicializaArvore(TIPO_LITERAL, "casos", NULL, NULL);
        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
        // avalie = setFilhosEsquerdaCentroDireita(avalie, ident, casos, NULL);
        avalie = setFilhosEsquerdaCentroDireita(avalie, novoNo, NULL, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, avalie);
        // pilhaNiveis = empilhar(pilhaNiveis, casos);
        comandosRepeticao = NULL;
    } token_simboloFechaParentese token_simboloDoisPontos AVALIE_CASO {
        // Arvore* casos = getArvoreTopoPilha(pilhaNiveis);
        // pilhaNiveis = desempilhar(pilhaNiveis);
        Arvore* avalie = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);

        // casos = setFilhosEsquerdaCentroDireita(avalie, NULL, casos, NULL);
        // avalie = setFilhosEsquerdaCentroDireita(avalie, NULL, casos, NULL);
        Arvore* novoNo = inicializaArvore(TIPO_LISTA, comandosRepeticao, NULL, NULL);
        avalie = setFilhosEsquerdaCentroDireita(avalie, NULL, novoNo, NULL);
        comandosRepeticao = NULL;
        arvoreComandoAtual = avalie;
    } token_fimAvalie
    ;

AVALIE_CASO
    : AVALIE_CASO token_caso INTEIRO {
        Arvore* ArvExp = inicializaArvore(TIPO_INTEIRO, yytext, NULL, NULL);
        Arvore* caso = inicializaArvore(TIPO_LITERAL, "caso", NULL, NULL);
        caso = setFilhosEsquerdaCentroDireita(caso, ArvExp, NULL, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, caso);
    } token_simboloDoisPontos LISTA_COMANDOS {
        Arvore* caso = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        // Arvore* casos = getArvoreTopoPilha(pilhaNiveis);
        // pilhaNiveis = desempilhar(pilhaNiveis);
        // casos = setProxComando(casos, caso);
        // pilhaNiveis = empilhar(pilhaNiveis, casos);
        comandosRepeticao = criarNovoNoListaFim(TIPO_ARVORE, caso, comandosRepeticao);
    } token_pare token_simboloPontoVirgula
    | token_caso INTEIRO {
        Arvore* ArvExp = inicializaArvore(TIPO_INTEIRO, yytext, NULL, NULL);
        Arvore* caso = inicializaArvore(TIPO_LITERAL, "caso", NULL, NULL);
        caso = setFilhosEsquerdaCentroDireita(caso, ArvExp, NULL, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, caso);
    } token_simboloDoisPontos LISTA_COMANDOS {
        Arvore* caso = getArvoreTopoPilha(pilhaNiveis);
        pilhaNiveis = desempilhar(pilhaNiveis);
        // Arvore* casos = getArvoreTopoPilha(pilhaNiveis);
        // pilhaNiveis = desempilhar(pilhaNiveis);
        // casos = setProxComando(casos, caso);
        // pilhaNiveis = empilhar(pilhaNiveis, casos);
        comandosRepeticao = criarNovoNoListaFim(TIPO_ARVORE, caso, comandosRepeticao);
    } token_pare token_simboloPontoVirgula
    ;

COMANDO_LEIA
    : token_leia token_simboloAbreParentese token_simboloFechaParentese
    ;

COMANDO_IMPRIMA
    : token_imprima token_simboloAbreParentese token_identificador {
        Variavel* v = validarIdentificadorSairCasoInvalido();
        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "imprima", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, novoNo, NULL, NULL);
    } token_simboloFechaParentese token_simboloPontoVirgula
    | token_imprima token_simboloAbreParentese NUMERO {
        Arvore* a = getArvoreTopoPilha(p);
        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "imprima", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, a, NULL, NULL);
    } token_simboloFechaParentese token_simboloPontoVirgula
    | token_imprima token_simboloAbreParentese ACESSO_MATRIZ {
        Arvore* a = getArvoreTopoPilha(p);
        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "imprima", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, a, NULL, NULL);
    } token_simboloFechaParentese token_simboloPontoVirgula
    | token_imprima token_simboloAbreParentese LOGICO {
        Arvore* a = getArvoreTopoPilha(p);
        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "imprima", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, a, NULL, NULL);
    } token_simboloFechaParentese token_simboloPontoVirgula
    | token_imprima token_simboloAbreParentese CARACTERE_LITERAL {
        Arvore* a = getArvoreTopoPilha(p);
        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "imprima", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, a, NULL, NULL);
    } token_simboloFechaParentese token_simboloPontoVirgula
    ;

 PARAMETROS_FUNCAO
     : PARAMETROS_FUNCAO token_simboloVirgula POSSIVEIS_PARAMETROS {
         parametrosFuncao = criarNovoNoListaFim(tipo, yytext, parametrosFuncao);
     }
     | POSSIVEIS_PARAMETROS {
        parametrosFuncao = criarNovoNoListaFim(tipo, yytext, parametrosFuncao);
     }
     ;
// PARAMETROS_FUNCAO
//     : PARAMETROS_FUNCAO token_simboloVirgula POSSIVEIS_PARAMETROS 
//     | POSSIVEIS_PARAMETROS
//     ;

POSSIVEIS_PARAMETROS
    : FATOR {
        Arvore* topo = getArvoreTopoPilha(p);
        p = desempilhar(p);
        p = NULL;
        arvoreParametrosFuncao = setProxComando(arvoreParametrosFuncao, topo);
    }
    ;

// VALORES_EXPRESSAO
//     : NUMERO
//     | ACESSO_MATRIZ
//     | LOGICO 
//     | CARACTERE_LITERAL
//     ;

// POSSIVEIS_PARAMETROS
//     : token_identificador {
//        Variavel* v = validarIdentificadorSairCasoInvalido();
//        tipo = getTipoVariavel(v);
//     }
//     | NUMERO 
//     | ACESSO_MATRIZ 
//     | LOGICO {
//         tipo = TIPO_LOGICO; 
//     }
//     | CARACTERE_LITERAL
//     ;

COMANDO_CHAMADA_FUNCAO
    : token_identificador token_simboloAbreParentese {
        funcao = buscarFuncaoTabelaHash(hashFuncao, identificador);
        if(funcao == NULL) {
            finalizarProgramaComErro("A funcao nao foi declarada");
        }
        parametrosFuncao = liberarMemoriaLista(parametrosFuncao);

        Arvore* func = inicializaArvore(TIPO_FUNCAO, identificador, NULL, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, func);

    } COMANDO_CHAMADA_FUNCAO2 {
        if(isChamadaFuncaoValida(funcao, parametrosFuncao) == 0){
           finalizarProgramaComErro("Parametros passados na chamada de funcao nao condizem com a declaracao");
       }

       Arvore* func = getArvoreTopoPilha(pilhaNiveis);
       pilhaNiveis = desempilhar(pilhaNiveis);
       func = setFilhosEsquerdaCentroDireita(func, NULL, arvoreParametrosFuncao, NULL);
       pilhaNiveis = empilhar(pilhaNiveis, func);

       parametrosFuncao = NULL;
       arvoreParametrosFuncao = NULL;
    }
    ;

COMANDO_CHAMADA_FUNCAO2
    : token_simboloFechaParentese 
    | PARAMETROS_FUNCAO token_simboloFechaParentese
    ;

COMANDO_MAIS_MAIS_MENOS_MENOS
    : token_identificador {
        Variavel* v = validarOperadoresMMMMSairCasoInvalido();
        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "++", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, novoNo, NULL, NULL);
    } token_operadorSomaSoma token_simboloPontoVirgula
    | token_operadorSomaSoma token_identificador {
        Variavel* v = validarOperadoresMMMMSairCasoInvalido();
        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "++", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, novoNo, NULL);
    } token_simboloPontoVirgula
    | token_identificador {
        Variavel* v = validarOperadoresMMMMSairCasoInvalido();
        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "--", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, novoNo, NULL, NULL);
    } token_operadorSubtraiSubtrai token_simboloPontoVirgula
    | token_operadorSubtraiSubtrai token_identificador {
        Variavel* v = validarOperadoresMMMMSairCasoInvalido();
        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "--", NULL, NULL);
        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, novoNo, NULL);
    } token_simboloPontoVirgula
    ;  

EXPRESSAO
    : EXPRESSAO_SIMPLES
    | EXPRESSAO_SIMPLES token_operadorIgualIgual {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
        p = empilharExpressaoOperador(p, "==");
    }
    | EXPRESSAO_SIMPLES token_operadorMenor {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
        p = empilharExpressaoOperador(p, "<");
    }
    | EXPRESSAO_SIMPLES token_operadorMenorIgual {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
        p = empilharExpressaoOperador(p, "<=");
    }
    | EXPRESSAO_SIMPLES token_operadorMaiorIgual {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
        p = empilharExpressaoOperador(p, ">=");
    }
    | EXPRESSAO_SIMPLES token_operadorMaior {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
        p = empilharExpressaoOperador(p, ">");
    }
    | EXPRESSAO_SIMPLES token_operadorDiferente {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
        p = empilharExpressaoOperador(p, "<>");
    }
    ;

EXPRESSAO_SIMPLES
    : TERMO
    | EXPRESSAO_SIMPLES token_operadorMais {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } TERMO {
        p = empilharExpressaoOperador(p, "+");
    }
    | EXPRESSAO_SIMPLES token_operadorMenos {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } TERMO {
        p = empilharExpressaoOperador(p, "-");
    }
    | EXPRESSAO_SIMPLES token_operadorOu {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } TERMO {
        p = empilharExpressaoOperador(p, "ou");
    }
    ;

TERMO
    : FATOR
    | TERMO token_operadorVezes {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } FATOR {
        p = empilharExpressaoOperador(p, "*");
    }
    | TERMO token_operadorDividir {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } FATOR {
         p = empilharExpressaoOperador(p, "/");
    }
    | TERMO token_operadorPorcento {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } FATOR{
        p = empilharExpressaoOperador(p, "%");
    }
    | TERMO token_operadorPotencia {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } FATOR {
        p = empilharExpressaoOperador(p, "^");
    }
    | TERMO token_operadorE {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } FATOR {
        p = empilharExpressaoOperador(p, "e");
    }
    ;


FATOR
    : token_identificador {
       //variavel declarada     
        Variavel* v = validarIdentificadorSairCasoInvalido();
        tipo = getTipoVariavel(v);
        expressao = criarNovoNoListaFim(tipo, yytext, expressao);
        Arvore *novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
        p = empilhar(p, novoNo);
    }
    | NUMERO
    | ACESSO_MATRIZ
    | LOGICO {
        tipo = TIPO_LOGICO; 
        expressao = criarNovoNoListaFim(TIPO_LOGICO, NULL, expressao);
    }
    | CARACTERE_LITERAL
    | token_simboloAbreParentese EXPRESSAO token_simboloFechaParentese
    ;

NUMERO
    : INTEIRO {
    tipo = TIPO_INTEIRO;
        expressao = criarNovoNoListaFim(TIPO_INTEIRO, NULL, expressao);
        Arvore *novoNo = inicializaArvore(TIPO_INTEIRO, yytext, NULL, NULL);
        p = empilhar(p, novoNo);
    }
    | REAL {
    tipo = TIPO_REAL;
        expressao = criarNovoNoListaFim(TIPO_REAL, NULL, expressao);
        Arvore *novoNo = inicializaArvore(TIPO_REAL, yytext, NULL, NULL);
        p = empilhar(p, novoNo);
    }
    ;

INTEIRO
    : token_inteiro
    | token_inteiroNegativo
    ;

REAL
    : token_real
    | token_realNegativo
    ;

LOGICO
    : token_verdadeiro {
        Arvore* novoNo = inicializaArvore(TIPO_LOGICO, "verdadeiro", NULL, NULL);
        p = empilhar(p, novoNo);
    }
    | token_falso {
        Arvore* novoNo = inicializaArvore(TIPO_LOGICO, "falso", NULL, NULL);
        p = empilhar(p, novoNo);
    }
    | token_operadorNao {
        Arvore* novoNo = inicializaArvore(TIPO_LOGICO, "nao", NULL, NULL);
        p = empilhar(p, novoNo);
    } FATOR
    ;

CARACTERE_LITERAL
    : token_literal {
        Arvore* novoNo = inicializaArvore(TIPO_LITERAL, yytext, NULL, NULL);
        p = empilhar(p, novoNo);
    }
    | token_caractere {
       Arvore* novoNo = inicializaArvore(TIPO_LITERAL, yytext, NULL, NULL);
        p = empilhar(p, novoNo); 
    }
    ;

ACESSO_MATRIZ
    : token_identificador POSICAO_MATRIZ {
        //variavel declarada 
        Variavel* v = validarIdentificadorSairCasoInvalido();
        validarAcessoMatrizSairCasoInvalido(v);
        tipo = getTipoVariavel(v);
        expressao = criarNovoNoListaFim(tipo, yytext, expressao);
        
        Lista* copiaDimensoes = copiarListaChar(dimensoesMatriz);
        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), copiaDimensoes);
        p = empilhar(p, novoNo);
     
        dimensoesMatriz = liberarMemoriaLista(dimensoesMatriz);
    }
    ;

%%

#include "lex.yy.c"

main(){
    hashVariavel = inicializarTabelaHash();
    hashFuncao = inicializarTabelaHash();
    variaveis = NULL;
    hashFuncao = inserirFuncoesInicias(hashFuncao);
    yyparse();
    exetuarPrograma(getFilhoEsquerda(programa), hashVariavel, hashFuncao);
    imprimirArvoreComandos(programa);
 //   printf("IMPRIMINDO VARIAVEIS\n");
  //imprimirTabelaHash(hashVariavel);
 //   printf("\n");
 //   printf("IMPRIMINDO FUNCOES\n");
 //imprimirTabelaHashFuncao(hashFuncao);
  //  imprimirRelatorioVariaveisNaoUtilizadas(hashVariavel);
    liberarMemoriaAlocada();
}

/* rotina chamada por yyparse quando encontra erro */
yyerror (void){
    printf("Erro na sintatico na linha %d\n", line_num);
    liberarMemoriaAlocada();
    exit(0);
}
