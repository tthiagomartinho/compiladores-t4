%{
#include <stdio.h>
#include "hash.h"
#include "Pilha.h"
#include "Executor.h"
#include "Programa.h"

#define TIPO_OPERADOR_LOGICO 1
#define TIPO_OPERADOR_ARITMETICO 2

// rodrigo
#define TAM 50
    
    int erroDetectado = 0;
    
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
    
    // rodrigo
    Lista* programas = NULL;
    
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
        printf ("memoria desalocada!\n");
        erroDetectado = 1;
        //exit(0);
    }

    Variavel* validarIdentificadorSairCasoInvalido() {
        Variavel* v = buscarVariavelTabelaHash(hashVariavel, identificador, escopo);
        if(v == NULL && strcmp(escopo, "global") != 0){
            v = buscarVariavelTabelaHash(hashVariavel, identificador, "global");
        }
        if(v == NULL){
            finalizarProgramaComErro("Variavel nao declarada");

        }
      
        if (erroDetectado == 0) setVariavelUsada(v);
        return v;
    }

    void validarExpressaoSairCasoInvalido() {
        int operadoresIguais1 = operadoresIguais(operadores);
        if(operadoresIguais1 == 0){
            finalizarProgramaComErro("Noa eh possivel ter operadores logicos e artimeticos na mesma expressao");
        }

		if (erroDetectado) return;
		
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
    	if (erroDetectado == 0) {
        nomePrograma = (char*)malloc((strlen(identificador) + 1)*sizeof(char));
        strcpy(nomePrograma, identificador);
        programa = inicializaArvore(TIPO_LITERAL, nomePrograma, NULL, NULL);
        pilhaNiveis = empilhar(pilhaNiveis, NULL);
        }
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
        
        if (erroDetectado == 0) {
        	variaveis = liberarMemoriaLista(variaveis);
        	dimensoesMatriz = liberarMemoriaLista(dimensoesMatriz);
        }
    }  token_simboloPontoVirgula
    ;

LISTA_VARIAVEIS
    : LISTA_VARIAVEIS token_simboloVirgula token_identificador{
    
    	if (erroDetectado == 0) {
        	Variavel* var = criarNovaVariavel(identificador, NULL, tipo, escopo, line_num) ;
        	Lista* l = criarNovoNoLista(TIPO_VARIAVEL, var, variaveis);
        	variaveis = l;
        }
    }
    | token_identificador {
    	if (erroDetectado == 0) {
        	Variavel* var = criarNovaVariavel(identificador, NULL, tipo, escopo, line_num) ;
        	Lista* l = criarNovoNoLista(TIPO_VARIAVEL, var, variaveis);
       		variaveis = l;
       	}
    } 
    ;

DECLARACAO_FUNCAO
    : DECLARACAO_FUNCAO token_funcao token_identificador{
    	if (erroDetectado == 0) {
		    if (buscarFuncaoTabelaHash(hashFuncao, identificador) != NULL) {
		        finalizarProgramaComErro("Funcao ja declarada");
		    }
        
		    if (erroDetectado == 0) {
			    funcao = criarFuncao(identificador);
			    strcpy(escopo, identificador);
			    Arvore* funcaoArvore = inicializaArvore(TIPO_FUNCAO, identificador, NULL, NULL);
			    pilhaNiveis = empilhar(pilhaNiveis, funcaoArvore);
			}
    	}
    } DECLARACAO_FUNCAO_ARGUMENTOS {
        if (erroDetectado == 0) {
    	    Arvore* comandosFuncao = getArvoreTopoPilha(pilhaNiveis);
    	    pilhaNiveis = desempilhar(pilhaNiveis);
        	Arvore* funcaoArvore = getArvoreTopoPilha(pilhaNiveis);
        	pilhaNiveis = desempilhar(pilhaNiveis);
        	funcaoArvore = setFilhosEsquerdaCentroDireita(funcaoArvore, NULL, comandosFuncao, NULL);
        	Arvore* a = setProxComando(getFilhoCentro(programa), funcaoArvore);
        	programa = setFilhosEsquerdaCentroDireita(programa, NULL, a, NULL);
        }
    }

    | token_funcao token_identificador{
    	if (erroDetectado == 0) {
		    if (buscarFuncaoTabelaHash(hashFuncao, identificador) != NULL) {
		        finalizarProgramaComErro("Funcao ja declarada");
		    }
        
		    if (erroDetectado == 0) {
			    funcao = criarFuncao(identificador);
			    strcpy(escopo, identificador);
		    	Arvore* funcaoArvore = inicializaArvore(TIPO_FUNCAO, identificador, NULL, NULL);
		    	pilhaNiveis = empilhar(pilhaNiveis, funcaoArvore);
		    }
        }
    } DECLARACAO_FUNCAO_ARGUMENTOS {
    	if (erroDetectado == 0) {
	        Arvore* comandosFuncao = getArvoreTopoPilha(pilhaNiveis);
    	    pilhaNiveis = desempilhar(pilhaNiveis);
    	    Arvore* funcaoArvore = getArvoreTopoPilha(pilhaNiveis);
    	    pilhaNiveis = desempilhar(pilhaNiveis);
    	    funcaoArvore = setFilhosEsquerdaCentroDireita(funcaoArvore, NULL, comandosFuncao, NULL);
    	    Arvore* a = setProxComando(getFilhoCentro(programa), funcaoArvore);
    	    programa = setFilhosEsquerdaCentroDireita(programa, NULL, a, NULL);
    	}	
    }
    ;

DECLARACAO_FUNCAO_ARGUMENTOS
    : token_simboloAbreParentese PARAMETRO_DECLARACAO_FUNCAO token_simboloFechaParentese token_simboloDoisPontos DECLARACAO_FUNCAO_ARGUMENTOS2
    | token_simboloAbreParentese token_simboloFechaParentese token_simboloDoisPontos DECLARACAO_FUNCAO_ARGUMENTOS2
    ;

DECLARACAO_FUNCAO_ARGUMENTOS2
    : TIPO_VARIAVEL_PRIMITIVO{
    	if (erroDetectado == 0) {
        	hashFuncao = inserirFuncaoTabelaHash(funcao, variaveisFuncao, tipo, hashFuncao);
        	Arvore* parametros = inicializaArvore(TIPO_LISTA, variaveisFuncao, NULL, NULL);
        	variaveisFuncao = NULL;
        	Arvore* topo = getArvoreTopoPilha(pilhaNiveis);
        	topo = setFilhosEsquerdaCentroDireita(topo, parametros, NULL, NULL);
        	pilhaNiveis = empilhar(pilhaNiveis, NULL);
        }
    } ROTINA_FUNCAO token_fimFuncao
    | {
    	if (erroDetectado == 0) {
	        hashFuncao = inserirFuncaoTabelaHash(funcao, variaveisFuncao, TIPO_VOID, hashFuncao);
    	    Arvore* parametros = inicializaArvore(TIPO_LISTA, variaveisFuncao, NULL, NULL);
    	    variaveisFuncao = NULL;
    	    Arvore* topo = getArvoreTopoPilha(pilhaNiveis);
    	    topo = setFilhosEsquerdaCentroDireita(topo, parametros, NULL, NULL);
    	    pilhaNiveis = empilhar(pilhaNiveis, NULL);
    	}
    } ROTINA_FUNCAO token_fimFuncao
    ;

PARAMETRO_DECLARACAO_FUNCAO
    : PARAMETRO_DECLARACAO_FUNCAO token_simboloVirgula token_identificador{
        if (erroDetectado == 0) strcpy(nomeVariavel, identificador);
    } token_simboloDoisPontos TIPO_VARIAVEL_PRIMITIVO{
    	if (erroDetectado == 0) {
	        Variavel* var = criarNovaVariavel(nomeVariavel, NULL, tipo, escopo, line_num) ;
    	    Lista* l = criarNovoNoListaFim(TIPO_VARIAVEL, var, variaveisFuncao);
    	    variaveisFuncao = l;
    	
    		hashVariavel = inserirVariavelTabelaHash(hashVariavel, var, NULL, tipo, escopo);
    	}
    } 
    | token_identificador{
         if (erroDetectado == 0) strcpy(nomeVariavel, identificador);
    } token_simboloDoisPontos TIPO_VARIAVEL_PRIMITIVO{
        if (erroDetectado == 0) {
        	Variavel* var = criarNovaVariavel(nomeVariavel, NULL, tipo, escopo, line_num) ;
        	Lista* l = criarNovoNoListaFim(TIPO_VARIAVEL, var, variaveisFuncao);
        	variaveisFuncao = l;
        	
		    hashVariavel = inserirVariavelTabelaHash(hashVariavel, var, NULL, tipo, escopo);
		}
    }
    ;

ROTINA_FUNCAO
    : DECLARACAO_VARIAVEL token_inicio LISTA_COMANDOS token_fim
    | token_inicio LISTA_COMANDOS token_fim
    ;

COMANDO_RETORNO
    : token_retorne {
        if (erroDetectado == 0) {
        	int tipoRetornoFuncao = getTipoRetornoFuncao(hashFuncao, funcao);
        	if(tipoRetornoFuncao == TIPO_VOID){
        	    finalizarProgramaComErro("Comando de retorno deve ser void");
        	}
        
        	if (erroDetectado == 0) {
	    	    tipoExpressaoAtribuicao = tipoRetornoFuncao;
	    	}
	    }
    } EXPRESSAO {
    	if (erroDetectado == 0) {
	        validarExpressaoSairCasoInvalido();
    	    Arvore* retorno = inicializaArvore(tipoExpressaoAtribuicao, "retorno", NULL, NULL);
    	    Arvore* ArvExp = getArvoreTopoPilha(p);
    	    p = desempilhar(p);
    	    retorno = setFilhosEsquerdaCentroDireita(retorno, ArvExp, NULL, NULL);
    	    arvoreComandoAtual = retorno;
    	}
    } token_simboloPontoVirgula
    | token_retorne {
	    if (erroDetectado == 0) {
    	    int tipoRetornoFuncao = getTipoRetornoFuncao(hashFuncao, funcao);
    	    if(tipoRetornoFuncao != TIPO_VOID){
    	        finalizarProgramaComErro("Comando retorno tem que ser diferente de void");
    	    }
    		if (erroDetectado == 0) {
    
		        Arvore* retorno = inicializaArvore(TIPO_LITERAL, "retorno", NULL, NULL);
		        retorno = setFilhosEsquerdaCentroDireita(retorno, NULL, NULL, NULL);
		        arvoreComandoAtual = retorno;
		    }
		}
    } token_simboloPontoVirgula
    ;

TIPO_VARIAVEIS
    : MATRIZ
    | TIPO_VARIAVEL_PRIMITIVO
    ;

TIPO_VARIAVEL_PRIMITIVO
    : token_tipoReal{
        if (erroDetectado == 0) tipo = TIPO_REAL;
    }
    | token_tipoInteiro{
        if (erroDetectado == 0) tipo = TIPO_INTEIRO;
    }
    | token_tipoCaractere{
        if (erroDetectado == 0) tipo = TIPO_CARACTERE;
    }
    | token_tipoLiteral{
        if (erroDetectado == 0) tipo = TIPO_LITERAL;
    }
    | token_tipoLogico {
        if (erroDetectado == 0) tipo = TIPO_LOGICO;
    }
    ;

MATRIZ
    : token_tipoMatriz POSICAO_MATRIZ token_de TIPO_VARIAVEL_PRIMITIVO
    ;

POSICAO_MATRIZ
    : POSICAO_MATRIZ token_simboloAbreColchete token_inteiro {
        if (erroDetectado == 0) dimensoesMatriz = criarNovoNoListaFim(TIPO_LITERAL, yytext, dimensoesMatriz);
    } token_simboloFechaColchete 
    | token_simboloAbreColchete token_inteiro {
        if (erroDetectado == 0) dimensoesMatriz = criarNovoNoListaFim(TIPO_LITERAL, yytext, dimensoesMatriz);
    }token_simboloFechaColchete
    ;

PROGRAMA_PRINCIPAL
    : token_inicio{
        if (erroDetectado == 0) strcpy(escopo, "global");
    } LISTA_COMANDOS {
	    if (erroDetectado == 0) {
    	    Arvore* comandos = getArvoreTopoPilha(pilhaNiveis);
    	    pilhaNiveis = desempilhar(pilhaNiveis);
    	    programa = setFilhosEsquerdaCentroDireita(programa, comandos, NULL, NULL);
    	}
    } token_fim
    | token_inicio token_fim
    ;

LISTA_COMANDOS
    : LISTA_COMANDOS COMANDO_ATRIBUICAO token_simboloPontoVirgula {
        if (erroDetectado == 0) incluirComando();
    }
    | COMANDO_ATRIBUICAO token_simboloPontoVirgula {
		if (erroDetectado == 0) incluirComando();
    }
    | LISTA_COMANDOS COMANDO_ENQUANTO {
       if (erroDetectado == 0) incluirComando();
    }
    | COMANDO_ENQUANTO {
		if (erroDetectado == 0) incluirComando();
    }
    | LISTA_COMANDOS COMANDO_PARA  {
        if (erroDetectado == 0) incluirComando();
    }
    | COMANDO_PARA {
        if (erroDetectado == 0) incluirComando();
    }
    | LISTA_COMANDOS COMANDO_IMPRIMA {
        if (erroDetectado == 0) incluirComando();
    }
    | COMANDO_IMPRIMA {
        if (erroDetectado == 0) incluirComando();
    }
    | LISTA_COMANDOS COMANDO_CHAMADA_FUNCAO {
    	if (erroDetectado == 0) {
	        arvoreComandoAtual = getArvoreTopoPilha(pilhaNiveis);
	        pilhaNiveis = desempilhar(pilhaNiveis);
    	    incluirComando();
    	}
    } token_simboloPontoVirgula 
    | COMANDO_CHAMADA_FUNCAO {
    	if (erroDetectado == 0) {
	        arvoreComandoAtual = getArvoreTopoPilha(pilhaNiveis);
    	    pilhaNiveis = desempilhar(pilhaNiveis);
    	    incluirComando();
    	}
    } token_simboloPontoVirgula
    | LISTA_COMANDOS COMANDO_SE {
       if (erroDetectado == 0) incluirComando();
    }
    | COMANDO_SE {
        if (erroDetectado == 0) incluirComando();
    }
    | LISTA_COMANDOS COMANDO_FACA_ENQUANTO {
        if (erroDetectado == 0) incluirComando();
    }
    | COMANDO_FACA_ENQUANTO {
        if (erroDetectado == 0) incluirComando();
    }
    | LISTA_COMANDOS COMANDO_AVALIE {
        if (erroDetectado == 0) incluirComando();
    }
    | COMANDO_AVALIE {
        if (erroDetectado == 0) incluirComando();
    }
    | LISTA_COMANDOS COMANDO_RETORNO {
        if (erroDetectado == 0) incluirComando();
    }
    | COMANDO_RETORNO {
        if (erroDetectado == 0) incluirComando();
    }
    | LISTA_COMANDOS COMANDO_MAIS_MAIS_MENOS_MENOS {
        if (erroDetectado == 0) incluirComando();
    }
    | COMANDO_MAIS_MAIS_MENOS_MENOS {
        if (erroDetectado == 0) incluirComando();
    }
    ;

COMANDO_ATRIBUICAO
    :  token_identificador {
    	if (erroDetectado == 0) {
	        Variavel* v = validarIdentificadorSairCasoInvalido();
	        if (erroDetectado == 0) {
	    	    tipoExpressaoAtribuicao = getTipoVariavel(v);
    		    Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
    		    arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "=", NULL, NULL);
    		    arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, novoNo, NULL, NULL);
    		}
    	}
    } 
    token_operadorAtribuicao COMANDO_ATRIBUICAO2
    | ACESSO_MATRIZ {
        // Variavel* v = validarIdentificadorSairCasoInvalido();
        // validarAcessoMatrizSairCasoInvalido(v);
        // dimensoesMatriz = liberarMemoriaLista(dimensoesMatriz);
        // tipoExpressaoAtribuicao = getTipoVariavel(v);    
        // Lista* aux;
        // Lista* copiaDimensoes = copiarListaChar(dimensoesMatriz);
        // for(aux = dimensoesMatriz; aux != NULL; aux = aux->prox){
        //     printf("%s\n", (char*) aux->info);
        // }
        // Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), copiaDimensoes);
        
        if (erroDetectado == 0) {
	        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "=", NULL, NULL);
	        Arvore* novoNo = getArvoreTopoPilha(p);
    	    p = desempilhar(p);
    	    p = NULL;
    	    expressao = NULL;
    	    arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, novoNo, NULL, NULL);
    	}
    } 
    token_operadorAtribuicao COMANDO_ATRIBUICAO2
    ;

COMANDO_ATRIBUICAO2
    : VALOR_A_SER_ATRIBUIDO
    | COMANDO_LEIA {
    	if (erroDetectado == 0) {
	        Arvore* ArvExp = inicializaArvore(TIPO_LITERAL, "leia", NULL, NULL);
    	    arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, ArvExp, NULL);
    	}
    }
    ;

VALOR_A_SER_ATRIBUIDO
    : VALOR_A_SER_ATRIBUIDO EXPRESSAO {
	    if (erroDetectado == 0) {
		    validarExpressaoSairCasoInvalido();
			if (erroDetectado == 0) {
			    Arvore* ArvExp = getArvoreTopoPilha(p);
			    p = desempilhar(p);
			    arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, ArvExp, NULL);
			}
    	}
    }
    | EXPRESSAO {
    	if (erroDetectado == 0) {
	        validarExpressaoSairCasoInvalido();
				
			if (erroDetectado == 0) {
			    Arvore* ArvExp = getArvoreTopoPilha(p);
			    p = desempilhar(p);
			    arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, ArvExp, NULL);
			}
		}	
    }
    | VALOR_A_SER_ATRIBUIDO COMANDO_CHAMADA_FUNCAO {
	    if (erroDetectado == 0) {
        	int tipoRetornoFuncao = getTipoRetornoFuncao(hashFuncao, funcao);
        	if(tipoRetornoFuncao != tipoExpressaoAtribuicao){
        	    finalizarProgramaComErro("Tipo invalido associado a variavel");
        	}
        	
        	if (erroDetectado == 0) {
	        	Arvore* func = getArvoreTopoPilha(pilhaNiveis);
    	    	pilhaNiveis = desempilhar(pilhaNiveis);
    	    	arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, func, NULL);
    	   	}
        }
    }
    | COMANDO_CHAMADA_FUNCAO {
	    if (erroDetectado == 0) {
	        int tipoRetornoFuncao = getTipoRetornoFuncao(hashFuncao, funcao);
    	    if(tipoRetornoFuncao != tipoExpressaoAtribuicao){
    	        finalizarProgramaComErro("Tipo invalido associado a variavel");
    	    }
    	 
    	 	if (erroDetectado == 0) {
	    	    Arvore* func = getArvoreTopoPilha(pilhaNiveis);
    		    pilhaNiveis = desempilhar(pilhaNiveis);
    		    arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, func, NULL);
    		}
    	}
    }
    ;

COMANDO_ENQUANTO
    : token_enquanto EXPRESSAO {
	    if (erroDetectado == 0) {
	        tipoExpressaoAtribuicao = TIPO_LOGICO;
    	    validarExpressaoSairCasoInvalido();
	
			if (erroDetectado == 0) {
	    	    Arvore* ArvExp = getArvoreTopoPilha(p);
    		    p = desempilhar(p);
    		    p = NULL;

    		    Arvore* enquanto = inicializaArvore(TIPO_LITERAL, "enquanto", NULL, NULL);
    		    Arvore* faca = inicializaArvore(TIPO_LITERAL, "faca", NULL, NULL);
    		    enquanto = setFilhosEsquerdaCentroDireita(enquanto, ArvExp, faca, NULL);
    		    pilhaNiveis = empilhar(pilhaNiveis, enquanto);
    		    pilhaNiveis = empilhar(pilhaNiveis, faca);
        //pilhaNiveis = empilhar(pilhaNiveis, NULL);
        	}
        }

    } token_faca LISTA_COMANDOS {
    	if (erroDetectado == 0) {
	        Arvore* faca = getArvoreTopoPilha(pilhaNiveis);
    	    pilhaNiveis = desempilhar(pilhaNiveis);
    	    Arvore* enquanto = getArvoreTopoPilha(pilhaNiveis);
    	    pilhaNiveis = desempilhar(pilhaNiveis);
    	    enquanto = setFilhosEsquerdaCentroDireita(enquanto, NULL, faca, NULL);
    	    arvoreComandoAtual = enquanto;
    	}
    } token_fimEnquanto
    ;

COMANDO_PARA
    : token_para token_identificador {
	    if (erroDetectado == 0) {
	        Variavel* v = validarIdentificadorSairCasoInvalido();
	        if (erroDetectado == 0) {
		        int tipoVariavel = getTipoVariavel(v);
        		if(tipoVariavel != TIPO_INTEIRO){
       				finalizarProgramaComErro("Comando PARA dever iterar sob variaveis do tipo inteiro");
        		}
        		
				if (erroDetectado == 0) {
		        	Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
    		    	comandosRepeticao = criarNovoNoListaFim(TIPO_ARVORE, novoNo, comandosRepeticao);
    		    }
    		}
    	}
    } token_de EXPRESSAO {
	    if (erroDetectado == 0) {
	        tipoExpressaoAtribuicao = TIPO_INTEIRO;
    	    validarExpressaoSairCasoInvalido();
    		
    		if (erroDetectado == 0) {

		        Arvore* ArvExp = getArvoreTopoPilha(p);
        		p = desempilhar(p);

        		comandosRepeticao = criarNovoNoListaFim(TIPO_ARVORE, ArvExp, comandosRepeticao);
        	}
        }
    } token_ate EXPRESSAO {
	    if (erroDetectado == 0) {
	        tipoExpressaoAtribuicao = TIPO_INTEIRO;
    	    validarExpressaoSairCasoInvalido();
		
			if (erroDetectado == 0) {
		        Arvore* ArvExp = getArvoreTopoPilha(p);
        		p = desempilhar(p);
        		comandosRepeticao = criarNovoNoListaFim(TIPO_ARVORE, ArvExp, comandosRepeticao);
        	}
        }
    }  COMANDO_PARA2
    ;   

COMANDO_PARA2
    : token_faca {
	    if (erroDetectado == 0) {
		    Arvore* para = inicializaArvore(TIPO_LITERAL, "para", NULL, NULL);
		    Arvore* faca = inicializaArvore(TIPO_LITERAL, "faca", NULL, NULL);
		    Arvore* lista = inicializaArvore(TIPO_LISTA, comandosRepeticao, NULL, NULL);
		    faca = setFilhosEsquerdaCentroDireita(faca, NULL, NULL, NULL);
		    para = setFilhosEsquerdaCentroDireita(para, lista, faca, NULL);
		    pilhaNiveis = empilhar(pilhaNiveis, para);
		    pilhaNiveis = empilhar(pilhaNiveis, faca);
		    //pilhaNiveis = empilhar(pilhaNiveis, NULL);
		    comandosRepeticao = NULL;
        }
    } LISTA_COMANDOS {
        if (erroDetectado == 0) {
		    Arvore* faca = getArvoreTopoPilha(pilhaNiveis);
		    pilhaNiveis = desempilhar(pilhaNiveis);
		    Arvore* para = getArvoreTopoPilha(pilhaNiveis);
		    pilhaNiveis = desempilhar(pilhaNiveis);
		    setFilhosEsquerdaCentroDireita(para, NULL, faca, NULL);
		    arvoreComandoAtual = para;
		}
    } token_fimPara
    | token_passo INTEIRO {
    
	    if (erroDetectado == 0) {
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
		    expressao = NULL;
		}
    } token_faca LISTA_COMANDOS {
	    if (erroDetectado == 0) {
		    Arvore* faca = getArvoreTopoPilha(pilhaNiveis);
		    pilhaNiveis = desempilhar(pilhaNiveis);
		    Arvore* para = getArvoreTopoPilha(pilhaNiveis);
		    pilhaNiveis = desempilhar(pilhaNiveis);
		    setFilhosEsquerdaCentroDireita(para, NULL, faca, NULL);
		    arvoreComandoAtual = para;
		}
    } token_fimPara
    ;

COMANDO_SE
    : token_se {
        if (erroDetectado == 0) tipoExpressaoAtribuicao = TIPO_LOGICO;
    } EXPRESSAO {
	    if (erroDetectado == 0) {
        validarExpressaoSairCasoInvalido();
			if (erroDetectado == 0) {
				Arvore* ArvExp = getArvoreTopoPilha(p);
				p = desempilhar(p);
				p = NULL;
				Arvore* se = inicializaArvore(TIPO_LITERAL, "se", NULL, NULL);
				Arvore* entao = inicializaArvore(TIPO_LITERAL, "entao", NULL, NULL);
				Arvore* senao = inicializaArvore(TIPO_LITERAL, "senao", NULL, NULL);
				se = setFilhosEsquerdaCentroDireita(se, ArvExp, entao, senao);
				pilhaNiveis = empilhar(pilhaNiveis, se);
			}
       	}
    } token_entao {
	    if (erroDetectado == 0) {
        	Arvore* se = getArvoreTopoPilha(pilhaNiveis);
		    Arvore* entao = getFilhoCentro(se);
		    pilhaNiveis = empilhar(pilhaNiveis, entao); 
		    //pilhaNiveis = empilhar(pilhaNiveis, NULL); 
		}
    } LISTA_COMANDOS {
    	if (erroDetectado == 0) {
		    Arvore* entao = getArvoreTopoPilha(pilhaNiveis);
		    pilhaNiveis = desempilhar(pilhaNiveis);
		    Arvore* se = getArvoreTopoPilha(pilhaNiveis);
		    pilhaNiveis = desempilhar(pilhaNiveis);
		    se = setFilhosEsquerdaCentroDireita(se, NULL, entao, NULL);
		    pilhaNiveis = empilhar(pilhaNiveis, se); 
		}
    } COMANDO_SE2
    ;

COMANDO_SE2
    : token_senao {
	    if (erroDetectado == 0) {
    	    Arvore* se = getArvoreTopoPilha(pilhaNiveis);
    	    Arvore* senao = getFilhoDireita(se);
    	    pilhaNiveis = empilhar(pilhaNiveis, senao); 
    	    //pilhaNiveis = empilhar(pilhaNiveis, NULL);
    	}
    }
     LISTA_COMANDOS {
     	if (erroDetectado == 0) {
		    Arvore* senao = getArvoreTopoPilha(pilhaNiveis);
		    pilhaNiveis = desempilhar(pilhaNiveis);
		    Arvore* se = getArvoreTopoPilha(pilhaNiveis);
		    pilhaNiveis = desempilhar(pilhaNiveis);
		    setFilhosEsquerdaCentroDireita(se, NULL, NULL, senao);
		    arvoreComandoAtual = se;
		}
     } token_fimSe
    | token_fimSe {
        if (erroDetectado == 0) {
		    Arvore* se = getArvoreTopoPilha(pilhaNiveis);
		    pilhaNiveis = desempilhar(pilhaNiveis);
		    arvoreComandoAtual = se;
        }
    }
    ;

COMANDO_FACA_ENQUANTO
    : token_faca {
	    if (erroDetectado == 0) {
		    tipoExpressaoAtribuicao = TIPO_LOGICO;
		    validarExpressaoSairCasoInvalido();
			 if (erroDetectado == 0) {
				Arvore* facaEnquanto = inicializaArvore(TIPO_LITERAL, "faca-enquanto", NULL, NULL);
				Arvore* faca = inicializaArvore(TIPO_LITERAL, "faca", NULL, NULL);
				facaEnquanto = setFilhosEsquerdaCentroDireita(facaEnquanto, faca, NULL, NULL);
				pilhaNiveis = empilhar(pilhaNiveis, facaEnquanto);
				pilhaNiveis = empilhar(pilhaNiveis, faca);
			    //pilhaNiveis = empilhar(pilhaNiveis, NULL);
			 }
	   	}
    } token_simboloDoisPontos LISTA_COMANDOS token_enquanto EXPRESSAO {
	    if (erroDetectado == 0) {
        	tipoExpressaoAtribuicao = TIPO_LOGICO;
        	validarExpressaoSairCasoInvalido();
		    if (erroDetectado == 0) {
        		Arvore* ArvExp = getArvoreTopoPilha(p);
		        p = desempilhar(p);

        		Arvore* para = getArvoreTopoPilha(pilhaNiveis);
        		pilhaNiveis = desempilhar(pilhaNiveis);
        		Arvore* facaEnquanto = getArvoreTopoPilha(pilhaNiveis);
        		pilhaNiveis = desempilhar(pilhaNiveis);
        		facaEnquanto = setFilhosEsquerdaCentroDireita(facaEnquanto, ArvExp, para, NULL);
        		arvoreComandoAtual = facaEnquanto;
        		//pilhaNiveis = empilhar(pilhaNiveis, NULL);
        	}
        }
    } token_fimEnquanto
    ;

COMANDO_AVALIE
    : token_avalie token_simboloAbreParentese token_identificador {
	    if (erroDetectado == 0) {
	        Variavel* v = validarIdentificadorSairCasoInvalido();
    
    		if (erroDetectado == 0) {
		        int tipoVariavel = getTipoVariavel(v);
		        if(tipoVariavel != TIPO_INTEIRO){
        		    finalizarProgramaComErro("Nao eh possivel avaliar variaveis cujo tipo nao eh inteiro");
		        }
				if (erroDetectado == 0) {
			        Arvore* avalie = inicializaArvore(TIPO_LITERAL, "avalie", NULL, NULL);
			        // Arvore* casos = inicializaArvore(TIPO_LITERAL, "casos", NULL, NULL);
			        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
			        // avalie = setFilhosEsquerdaCentroDireita(avalie, ident, casos, NULL);
			        avalie = setFilhosEsquerdaCentroDireita(avalie, novoNo, NULL, NULL);
			        pilhaNiveis = empilhar(pilhaNiveis, avalie);
			        // pilhaNiveis = empilhar(pilhaNiveis, casos);
			        comandosRepeticao = NULL;
			    }
			}
		}			   
    } token_simboloFechaParentese token_simboloDoisPontos AVALIE_CASO {
	    if (erroDetectado == 0) {
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
       	}
    } token_fimAvalie
    ;

AVALIE_CASO
    : AVALIE_CASO token_caso INTEIRO {
    	if (erroDetectado == 0) {
		    Arvore* ArvExp = inicializaArvore(TIPO_INTEIRO, yytext, NULL, NULL);
		    Arvore* caso = inicializaArvore(TIPO_LITERAL, "caso", NULL, NULL);
		    caso = setFilhosEsquerdaCentroDireita(caso, ArvExp, NULL, NULL);
		    pilhaNiveis = empilhar(pilhaNiveis, caso);
		}
    } token_simboloDoisPontos LISTA_COMANDOS {
	    if (erroDetectado == 0) {
		    Arvore* caso = getArvoreTopoPilha(pilhaNiveis);
		    pilhaNiveis = desempilhar(pilhaNiveis);
		    // Arvore* casos = getArvoreTopoPilha(pilhaNiveis);
		    // pilhaNiveis = desempilhar(pilhaNiveis);
		    // casos = setProxComando(casos, caso);
		    // pilhaNiveis = empilhar(pilhaNiveis, casos);
		    comandosRepeticao = criarNovoNoListaFim(TIPO_ARVORE, caso, comandosRepeticao);
		}
    } token_pare token_simboloPontoVirgula
    | token_caso INTEIRO {
	    if (erroDetectado == 0) {
	        Arvore* ArvExp = inicializaArvore(TIPO_INTEIRO, yytext, NULL, NULL);
	        Arvore* caso = inicializaArvore(TIPO_LITERAL, "caso", NULL, NULL);
	        caso = setFilhosEsquerdaCentroDireita(caso, ArvExp, NULL, NULL);
	        pilhaNiveis = empilhar(pilhaNiveis, caso);
	    }
    } token_simboloDoisPontos LISTA_COMANDOS {
	    if (erroDetectado == 0) {
	        Arvore* caso = getArvoreTopoPilha(pilhaNiveis);
	        pilhaNiveis = desempilhar(pilhaNiveis);
	        // Arvore* casos = getArvoreTopoPilha(pilhaNiveis);
	        // pilhaNiveis = desempilhar(pilhaNiveis);
	        // casos = setProxComando(casos, caso);
	        // pilhaNiveis = empilhar(pilhaNiveis, casos);
	        comandosRepeticao = criarNovoNoListaFim(TIPO_ARVORE, caso, comandosRepeticao);
	    }
    } token_pare token_simboloPontoVirgula
    ;

COMANDO_LEIA
    : token_leia token_simboloAbreParentese token_simboloFechaParentese
    ;

COMANDO_IMPRIMA
    : token_imprima token_simboloAbreParentese token_identificador {
	    if (erroDetectado == 0) {
        	Variavel* v = validarIdentificadorSairCasoInvalido();
        	if (erroDetectado == 0) {
				Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
				arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "imprima", NULL, NULL);
				arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, novoNo, NULL, NULL);
			}
        }
    } token_simboloFechaParentese token_simboloPontoVirgula
    | token_imprima token_simboloAbreParentese NUMERO {
	    if (erroDetectado == 0) {
		    Arvore* a = getArvoreTopoPilha(p);
		    arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "imprima", NULL, NULL);
		    arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, a, NULL, NULL);
        }
    } token_simboloFechaParentese token_simboloPontoVirgula
    | token_imprima token_simboloAbreParentese ACESSO_MATRIZ {
	    if (erroDetectado == 0) {
	        Arvore* a = getArvoreTopoPilha(p);
        	arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "imprima", NULL, NULL);
	        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, a, NULL, NULL);
	    }
    } token_simboloFechaParentese token_simboloPontoVirgula
    | token_imprima token_simboloAbreParentese LOGICO {
	    if (erroDetectado == 0) {
	        Arvore* a = getArvoreTopoPilha(p);
	        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "imprima", NULL, NULL);
	        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, a, NULL, NULL);
	    }
    } token_simboloFechaParentese token_simboloPontoVirgula
    | token_imprima token_simboloAbreParentese CARACTERE_LITERAL {
    	if (erroDetectado == 0) {
	        Arvore* a = getArvoreTopoPilha(p);
	        arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "imprima", NULL, NULL);
	        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, a, NULL, NULL);
	    }
    } token_simboloFechaParentese token_simboloPontoVirgula
    ;

 PARAMETROS_FUNCAO
     : PARAMETROS_FUNCAO token_simboloVirgula POSSIVEIS_PARAMETROS {
         if (erroDetectado == 0) parametrosFuncao = criarNovoNoListaFim(tipo, yytext, parametrosFuncao);
     }
     | POSSIVEIS_PARAMETROS {
		if (erroDetectado == 0) parametrosFuncao = criarNovoNoListaFim(tipo, yytext, parametrosFuncao);
     }
     ;

POSSIVEIS_PARAMETROS
    : FATOR {
    	if (erroDetectado == 0) {
	        Arvore* topo = getArvoreTopoPilha(p);
	        p = desempilhar(p);
	        p = NULL;
	        arvoreParametrosFuncao = setProxComando(arvoreParametrosFuncao, topo);
	    }
    }
    ;

COMANDO_CHAMADA_FUNCAO
    : token_identificador token_simboloAbreParentese {
    	if (erroDetectado == 0) {
	    	funcao = buscarFuncaoTabelaHash(hashFuncao, identificador);
	        if(funcao == NULL) {
	            finalizarProgramaComErro("A funcao nao foi declarada");
	        }
	        if (erroDetectado == 0) {
        		parametrosFuncao = liberarMemoriaLista(parametrosFuncao);

		        Arvore* func = inicializaArvore(TIPO_FUNCAO, identificador, NULL, NULL);
		        pilhaNiveis = empilhar(pilhaNiveis, func);
		    }
		}
    } COMANDO_CHAMADA_FUNCAO2 {
    	if (erroDetectado == 0) {
	        if(isChamadaFuncaoValida(funcao, parametrosFuncao) == 0){
    	       finalizarProgramaComErro("Parametros passados na chamada de funcao nao condizem com a declaracao");
    	   }
    	   
			if (erroDetectado == 0) {
		    	Arvore* func = getArvoreTopoPilha(pilhaNiveis);
       			pilhaNiveis = desempilhar(pilhaNiveis);
		    	func = setFilhosEsquerdaCentroDireita(func, NULL, arvoreParametrosFuncao, NULL);
		        pilhaNiveis = empilhar(pilhaNiveis, func);

				parametrosFuncao = NULL;
				arvoreParametrosFuncao = NULL;
		   }
		}
    }
    ;

COMANDO_CHAMADA_FUNCAO2
    : token_simboloFechaParentese 
    | PARAMETROS_FUNCAO token_simboloFechaParentese
    ;

COMANDO_MAIS_MAIS_MENOS_MENOS
    : token_identificador {
    	if (erroDetectado == 0) {
	        Variavel* v = validarOperadoresMMMMSairCasoInvalido();
    		if (erroDetectado == 0) {
    
		        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
        		arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "++", NULL, NULL);
		        arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, novoNo, NULL, NULL);
		    }
		}   
    } token_operadorSomaSoma token_simboloPontoVirgula
    | token_operadorSomaSoma token_identificador {
    
    	if (erroDetectado == 0) {
	        Variavel* v = validarOperadoresMMMMSairCasoInvalido();
        	if (erroDetectado == 0) {
			    Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
			    arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "++", NULL, NULL);
			    arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, novoNo, NULL);
			}
		}			    
    } token_simboloPontoVirgula
    | token_identificador {
    	if (erroDetectado == 0) {
	        Variavel* v = validarOperadoresMMMMSairCasoInvalido();
        	if (erroDetectado == 0) {
				Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
				arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "--", NULL, NULL);
				arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, novoNo, NULL, NULL);
			}
		}
    } token_operadorSubtraiSubtrai token_simboloPontoVirgula
    | token_operadorSubtraiSubtrai token_identificador {
	    if (erroDetectado == 0) {
	        Variavel* v = validarOperadoresMMMMSairCasoInvalido();
	        
	        if (erroDetectado == 0) {
				Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
				arvoreComandoAtual = inicializaArvore(TIPO_LITERAL, "--", NULL, NULL);
				arvoreComandoAtual = setFilhosEsquerdaCentroDireita(arvoreComandoAtual, NULL, novoNo, NULL);
			}
		}
    } token_simboloPontoVirgula
    ;  

EXPRESSAO
    : EXPRESSAO_SIMPLES
    | EXPRESSAO_SIMPLES token_operadorIgualIgual {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, "==");
    }
    | EXPRESSAO_SIMPLES token_operadorMenor {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, "<");
    }
    | EXPRESSAO_SIMPLES token_operadorMenorIgual {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
       if (erroDetectado == 0)  p = empilharExpressaoOperador(p, "<=");
    }
    | EXPRESSAO_SIMPLES token_operadorMaiorIgual {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, ">=");
    }
    | EXPRESSAO_SIMPLES token_operadorMaior {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, ">");
    }
    | EXPRESSAO_SIMPLES token_operadorDiferente {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, "<>");
    }
    ;

EXPRESSAO_SIMPLES
    : TERMO
    | EXPRESSAO_SIMPLES token_operadorMais {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } TERMO {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, "+");
    }
    | EXPRESSAO_SIMPLES token_operadorMenos {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } TERMO {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, "-");
    }
    | EXPRESSAO_SIMPLES token_operadorOu {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } TERMO {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, "ou");
    }
    ;

TERMO
    : FATOR
    | TERMO token_operadorVezes {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } FATOR {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, "*");
    }
    | TERMO token_operadorDividir {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } FATOR {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, "/");
    }
    | TERMO token_operadorPorcento {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } FATOR{
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, "%");
    }
    | TERMO token_operadorPotencia {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } FATOR {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, "^");
    }
    | TERMO token_operadorE {
        if (erroDetectado == 0) operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } FATOR {
        if (erroDetectado == 0) p = empilharExpressaoOperador(p, "e");
    }
    ;


FATOR
    : token_identificador {
    	if (erroDetectado == 0) {
       //variavel declarada     
        Variavel* v = validarIdentificadorSairCasoInvalido();
        	if (erroDetectado == 0) {
				tipo = getTipoVariavel(v);
				expressao = criarNovoNoListaFim(tipo, yytext, expressao);
				Arvore *novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), NULL);
				p = empilhar(p, novoNo);
			}
        }
    }
    | NUMERO
    | ACESSO_MATRIZ
    | LOGICO {
    	if (erroDetectado == 0) {
		    tipo = TIPO_LOGICO; 
		    expressao = criarNovoNoListaFim(TIPO_LOGICO, NULL, expressao);
        }
    }
    | CARACTERE_LITERAL
    | token_simboloAbreParentese EXPRESSAO token_simboloFechaParentese
    ;

NUMERO
    : INTEIRO {
    	if (erroDetectado == 0) {
			tipo = TIPO_INTEIRO;
		    expressao = criarNovoNoListaFim(TIPO_INTEIRO, NULL, expressao);
		    Arvore *novoNo = inicializaArvore(TIPO_INTEIRO, yytext, NULL, NULL);
		    p = empilhar(p, novoNo);
        }
    }
    | REAL {
    	if (erroDetectado == 0) {
			tipo = TIPO_REAL;
		    expressao = criarNovoNoListaFim(TIPO_REAL, NULL, expressao);
		    Arvore *novoNo = inicializaArvore(TIPO_REAL, yytext, NULL, NULL);
		    p = empilhar(p, novoNo);
        }
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
    	if (erroDetectado == 0) {
		    Arvore* novoNo = inicializaArvore(TIPO_LOGICO, "verdadeiro", NULL, NULL);
		    p = empilhar(p, novoNo);
        }
    }
    | token_falso {
    	if (erroDetectado == 0) {
		    Arvore* novoNo = inicializaArvore(TIPO_LOGICO, "falso", NULL, NULL);
		    p = empilhar(p, novoNo);
        }
    }
    | token_operadorNao {
    	if (erroDetectado == 0) {
		    Arvore* novoNo = inicializaArvore(TIPO_LOGICO, "nao", NULL, NULL);
		    p = empilhar(p, novoNo);
        }
    } FATOR
    ;

CARACTERE_LITERAL
    : token_literal {
    	if (erroDetectado == 0) {
		    Arvore* novoNo = inicializaArvore(TIPO_LITERAL, yytext, NULL, NULL);
		    p = empilhar(p, novoNo);
        }
    }
    | token_caractere {
    	if (erroDetectado == 0) {
       		Arvore* novoNo = inicializaArvore(TIPO_LITERAL, yytext, NULL, NULL);
        	p = empilhar(p, novoNo); 
        }
    }
    ;

ACESSO_MATRIZ
    : token_identificador POSICAO_MATRIZ {
    	if (erroDetectado == 0) {
        //variavel declarada 
		    Variavel* v = validarIdentificadorSairCasoInvalido();
		  	if (erroDetectado == 0)  {
				validarAcessoMatrizSairCasoInvalido(v);
				if (erroDetectado == 0) {
					tipo = getTipoVariavel(v);
					expressao = criarNovoNoListaFim(tipo, yytext, expressao);
					tipoExpressaoAtribuicao = tipo;
					Lista* copiaDimensoes = copiarListaChar(dimensoesMatriz);
					Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, getNomeVariavel(v), getEscopoVariavel(v), copiaDimensoes);
					p = empilhar(p, novoNo);
				 
					dimensoesMatriz = liberarMemoriaLista(dimensoesMatriz);
				}
		    }
        }
    }
    ;

%%

#include "lex.yy.c"

/**
 * Função para exibir o menu
 */
void mostrarMenu() {
	printf ("TRABALHO 4 DE COMPILADORES\n");
	printf ("-----------------------------\n");
	printf ("Autores: \n");
	printf ("		Thiago Martinho\n");
	printf ("		Rodrigo B. Pimenta\n");
	printf ("-----------------------------\n");
	printf ("Selecione um das opções abaixo!\n");
	printf ("1 – Compilar Programa\n");
	printf ("2 – Executar Programa\n");
	printf ("3 – Listar programas no diretorio Exemplos (que podem ser compilados)\n");	
	printf ("4 – Listar programas compilados\n");
	printf ("5 – Imprimir Arvore de Execucao\n");	
	printf ("6 – Executar programa e imprimr tabela de variaveis\n");	
	printf ("7 – Sair\n");
	printf ("Opcao selecionada:");
}

// Variável utilizada para representar o nome do programa
char* nomeDoPrograma = NULL;

void esperaTecla() {
	printf("Pressione qualquer tecla para mostrar o menu!\n");
	getchar();
}

/**
 * Função para abrir arquivo
 */
FILE *abre_arquivo(char *filename, char *modo) {
	FILE *file;
	
	if (!(file = fopen(filename, modo))) {
		printf("Erro na abertura do arquivo %s\n", filename);
	} else {
		printf ("Programa %s aberto com sucesso!\n", filename);
	}
	return file;
}

/**
 * Função para compilar um programa de acordo com o seu nome
 */
Programa *compila(char *nome_programa) {
	
	// Abrir arquivo de acordo com o seu nome
	
	FILE* file = abre_arquivo(nome_programa, "r");
	yyin = file;//abre_arquivo(nome_programa, "r");
	yyrestart(file);
	if (yyin == NULL) return NULL;
	
	printf ("Executando analisador léxico, sintático, semântico e o gerador de código!\n");
	// Executar o analisador léxico, sintático, semântico e o gerador de código
	hashVariavel = inicializarTabelaHash();
    hashFuncao = inicializarTabelaHash();
    variaveis = NULL;
    erroDetectado = 0;
	hashFuncao = inserirFuncoesInicias(hashFuncao);
	yyparse();
	Programa* p = criarPrograma(programa, hashVariavel, hashFuncao);
	
	fclose(yyin);
	
	return p;
}

int main(){

	int mostrar = 1;
	if (mostrar == 0) {

	int opcao = 0;
	char lixo;
	Programa* programaExecutado = NULL;
	Programa* auxPrograma = NULL;
	// inicializa lista de Arvores
	//	programas = NULL;
	
	mostrarMenu();
	scanf ("%d", &opcao);

	while (opcao != 7) {	
		switch (opcao) {
			// Compilar Programa
			case 1:			
				printf("\nOpcao 1 Selecionada - \"Compilar Programa\"\n");
				nomeDoPrograma = (char *) calloc(TAM, sizeof(char));
				
				printf("Digite o nome do programa: ");
				scanf(" %[^\n]", nomeDoPrograma);
				scanf("%c", &lixo);
				
				system("clear");
				printf("Abrindo %s\n", nomeDoPrograma);
				
				//compila o arquivo digitado
				auxPrograma = compila (nomeDoPrograma);
				
				if (auxPrograma != NULL && erroDetectado != 1) {
					// insere programa na lista de programas se o mesmo não possuir erro
					programas = atualizaListaDeProgramas(programas, auxPrograma, nomePrograma);
				} else {
					printf ("Erro Detectado no programa %s!\n", nomeDoPrograma);
				}
				
				free (nomeDoPrograma);
				nomeDoPrograma = NULL;
				
				esperaTecla();
				system("clear");
				erroDetectado = 0;
				
				break;
				
			// Executa um programa
			case 2:
				printf("\nOpcao 2 Selecionada - \"Executar Programa\"\n");

				// inicializa a variável nomeProgramaCompilado
				nomeDoPrograma = (char *) calloc(TAM, sizeof(char));

				printf("Digite o nome do programa: ");
				scanf(" %[^\n]", nomeDoPrograma);
				scanf("%c", &lixo);

				system("clear");
				
				executarPrograma (0, nomeDoPrograma, programas);
				
				free (nomeDoPrograma);
				nomeDoPrograma = NULL;
				esperaTecla();
				system("clear");
				break;
			
			case 3:
				system("clear");
				printf("\nOpcao 3 Selecionada - \"Listar programas no diretorio Exemplos\"\n");
				printf ("\nImprimindo arquivos da pasta exemplos:\n");
				system ("ls exemplos/*.gpt");
				printf ("\n");
				
				scanf("%c", &lixo);
				esperaTecla();
				system("clear");

				break;
			
			case 4:
				system("clear");
				printf("\nOpcao 4 Selecionada - \"Listar programas compilados\"\n");
				printf ("\nImprimindo Lista de programas compilados:\n");
				imprimirListaProgramas(programas);

				scanf("%c", &lixo);
				esperaTecla();
				system("clear");
				break;
				
			case 5:
				printf("\nOpcao 5 Selecionada - \"Imprimir Arvore de Execucao\"\n");

				// inicializa a variável nomeProgramaCompilado
				nomeDoPrograma = (char *) calloc(TAM, sizeof(char));

				printf("Digite o nome do programa: ");
				scanf(" %[^\n]", nomeDoPrograma);
				scanf("%c", &lixo);
				system("clear");
				
				programaExecutado = buscarProgramaListaProgramas (programas, nomeDoPrograma);
				if (programaExecutado != NULL) {
					imprimirArvoreComandos(programaExecutado->comandos);
				}
				
				free (nomeDoPrograma);
				nomeDoPrograma = NULL;
				esperaTecla();
				system("clear");
				break;

			case 6:
				printf("\nOpcao 6 Selecionada - \"Executar programa e imprimr tabela de variaveis\"\n");

				// inicializa a variável nomeProgramaCompilado
				nomeDoPrograma = (char *) calloc(TAM, sizeof(char));

				printf("Digite o nome do programa: ");
				scanf(" %[^\n]", nomeDoPrograma);
				scanf("%c", &lixo);
				system("clear");
				
				executarPrograma (1, nomeDoPrograma, programas);
				
				free (nomeDoPrograma);
				nomeDoPrograma = NULL;
				esperaTecla();
				system("clear");
				break;
	
	//TODO: Não sei como deve ser feito a execução. Acredito que devemos salvar na lista de programas não só a sua árvore,
	//como também suas tabelas hash. Se for a segunda opção, acredito que criar outra estrutura de dados será mais fácil e prático!
			
			// Sair do programa, liberar todas as memórias alocadas
			case 7:
				//exit(1);
				printf ("passou!\n");
				liberaListaProgramas(programas);
				liberarMemoriaAlocada();
				break;
				
			default:
				break;
			
		}
		
		mostrarMenu();
		scanf ("%d", &opcao);
	}

	} else {
	// Funções necessárias para rodar o programa
    hashVariavel = inicializarTabelaHash();
    hashFuncao = inicializarTabelaHash();
    variaveis = NULL;
    hashFuncao = inserirFuncoesInicias(hashFuncao);
    yyparse();    
    exetuarPrograma(getFilhoEsquerda(programa), getFilhoCentro(programa), hashVariavel, hashFuncao);
 if(erroDetectado == 0){

 //  imprimirArvoreComandos(programa);
 //   printf("IMPRIMINDO VARIAVEIS\n");
  imprimirTabelaHash(hashVariavel);
 //   printf("\n");
 //   printf("IMPRIMINDO FUNCOES\n");
 //imprimirTabelaHashFuncao(hashFuncao);
  //  imprimirRelatorioVariaveisNaoUtilizadas(hashVariavel);
  //  liberarMemoriaAlocada();
}
    }
    return 0;
}

/* rotina chamada por yyparse quando encontra erro */
yyerror (void){
    printf("Erro na sintatico na linha %d\n", line_num);
    liberarMemoriaAlocada();
    erroDetectado = 1;
    // YYABORT;
    //exit(0);
}
