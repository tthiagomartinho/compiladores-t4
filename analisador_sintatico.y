%{
#include <stdio.h>
#include "hash.h"
#include "Pilha.h"

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
    Arvore* arvoreExpressao = NULL;


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

    void validarOperadoresMMMMSairCasoInvalido() { //++ --
        Variavel* v = validarIdentificadorSairCasoInvalido();
        int tipoVariavel = getTipoVariavel(v);
        if(tipoVariavel != TIPO_REAL && tipoVariavel != TIPO_INTEIRO){
            finalizarProgramaComErro("So variaveis do tipo real ou inteiro podem ser associadas a esse comando");
        }
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
    : token_algoritmo token_identificador token_simboloPontoVirgula PROGRAMA
    ;

PROGRAMA
    : VARIAVEIS DECLARACAO_FUNCAO PROGRAMA_PRINCIPAL
    | VARIAVEIS PROGRAMA_PRINCIPAL
    | DECLARACAO_FUNCAO PROGRAMA_PRINCIPAL
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
    } DECLARACAO_FUNCAO_ARGUMENTOS

    | token_funcao token_identificador{
        if (buscarFuncaoTabelaHash(hashFuncao, identificador) != NULL) {
            finalizarProgramaComErro("Funcao ja declarada");
        }
        funcao = criarFuncao(identificador);
        strcpy(escopo, identificador);
    } DECLARACAO_FUNCAO_ARGUMENTOS
    ;

DECLARACAO_FUNCAO_ARGUMENTOS
    : token_simboloAbreParentese PARAMETRO_DECLARACAO_FUNCAO token_simboloFechaParentese token_simboloDoisPontos DECLARACAO_FUNCAO_ARGUMENTOS2
    | token_simboloAbreParentese token_simboloFechaParentese token_simboloDoisPontos DECLARACAO_FUNCAO_ARGUMENTOS2
    ;

DECLARACAO_FUNCAO_ARGUMENTOS2
    : TIPO_VARIAVEL_PRIMITIVO{
        hashFuncao = inserirFuncaoTabelaHash(funcao, variaveisFuncao, tipo, hashFuncao);
        variaveisFuncao = liberarMemoriaLista(variaveisFuncao);
    } ROTINA_FUNCAO token_fimFuncao
    | {
        hashFuncao = inserirFuncaoTabelaHash(funcao, variaveisFuncao, TIPO_VOID, hashFuncao);
    variaveisFuncao = liberarMemoriaLista(variaveisFuncao);
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
    } token_simboloPontoVirgula
    | token_retorne {
        int tipoRetornoFuncao = getTipoRetornoFuncao(hashFuncao, funcao);
        if(tipoRetornoFuncao != TIPO_VOID){
            finalizarProgramaComErro("Comando retorno tem que ser diferente de void");
        }
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
    } LISTA_COMANDOS token_fim
    | token_inicio token_fim
    ;

LISTA_COMANDOS
    : LISTA_COMANDOS COMANDO_ATRIBUICAO token_simboloPontoVirgula 
    | COMANDO_ATRIBUICAO token_simboloPontoVirgula
    | LISTA_COMANDOS COMANDO_ENQUANTO 
    | COMANDO_ENQUANTO
    | LISTA_COMANDOS COMANDO_PARA 
    | COMANDO_PARA
    | LISTA_COMANDOS COMANDO_IMPRIMA
    | COMANDO_IMPRIMA
    | LISTA_COMANDOS COMANDO_CHAMADA_FUNCAO token_simboloPontoVirgula 
    | COMANDO_CHAMADA_FUNCAO token_simboloPontoVirgula
    | LISTA_COMANDOS COMANDO_SE 
    | COMANDO_SE
    | LISTA_COMANDOS COMANDO_FACA_ENQUANTO
    | COMANDO_FACA_ENQUANTO
    | LISTA_COMANDOS COMANDO_AVALIE
    | COMANDO_AVALIE
    | LISTA_COMANDOS COMANDO_RETORNO
    | COMANDO_RETORNO
    | LISTA_COMANDOS COMANDO_MAIS_MAIS_MENOS_MENOS
    | COMANDO_MAIS_MAIS_MENOS_MENOS
    ;

COMANDO_ATRIBUICAO
    :  token_identificador {
        Variavel* v = validarIdentificadorSairCasoInvalido();
        tipoExpressaoAtribuicao = getTipoVariavel(v);
        Arvore* novoNo = inicializaArvore(TIPO_VARIAVEL, v);
        arvoreExpressao = inicializaArvore(TIPO_LITERAL, "=");
        arvoreExpressao = setFilhosEsquerdaCentroDireita(arvoreExpressao, novoNo, NULL, NULL);
    } 
    token_operadorAtribuicao COMANDO_ATRIBUICAO2
    | token_identificador POSICAO_MATRIZ{
        Variavel* v = validarIdentificadorSairCasoInvalido();
        validarAcessoMatrizSairCasoInvalido(v);
        dimensoesMatriz = liberarMemoriaLista(dimensoesMatriz);
        tipoExpressaoAtribuicao = getTipoVariavel(v);    
    } 
    token_operadorAtribuicao COMANDO_ATRIBUICAO2
    ;

COMANDO_ATRIBUICAO2
    : VALOR_A_SER_ATRIBUIDO
    | COMANDO_LEIA
    ;

VALOR_A_SER_ATRIBUIDO
    : VALOR_A_SER_ATRIBUIDO EXPRESSAO {
        Lista* aux = expressao;
        int x = isExpressaoValida(aux, tipoExpressaoAtribuicao);
        if(x == 0){
            finalizarProgramaComErro("Tipo invalido associado a variavel");
        }
        expressao = liberarMemoriaLista(expressao);
    }
    | EXPRESSAO {
        validarExpressaoSairCasoInvalido();
        Lista* aux = expressao;
        int x = isExpressaoValida(aux, tipoExpressaoAtribuicao);
        if(x == 0){
            finalizarProgramaComErro("Tipo invalido associado a variavel");
        }
        expressao = liberarMemoriaLista(expressao);

        Arvore* ArvExp = getArvoreTopoPilha(p);
        p = desempilhar(p);
        arvoreExpressao = setFilhosEsquerdaCentroDireita(arvoreExpressao, NULL, ArvExp, NULL);
       // print_t(ArvExp);
        arvore_imprime_profundidade(arvoreExpressao, 0 );
    }
    | VALOR_A_SER_ATRIBUIDO COMANDO_CHAMADA_FUNCAO {
        int tipoRetornoFuncao = getTipoRetornoFuncao(hashFuncao, funcao);
        if(tipoRetornoFuncao != tipoExpressaoAtribuicao){
            finalizarProgramaComErro("Tipo invalido associado a variavel");
        }
    }
    | COMANDO_CHAMADA_FUNCAO {
        int tipoRetornoFuncao = getTipoRetornoFuncao(hashFuncao, funcao);
        if(tipoRetornoFuncao != tipoExpressaoAtribuicao){
            finalizarProgramaComErro("Tipo invalido associado a variavel");
        }
    }
    ;

COMANDO_ENQUANTO
    : token_enquanto EXPRESSAO {
        tipoExpressaoAtribuicao = TIPO_LOGICO;
        validarExpressaoSairCasoInvalido();
    } token_faca LISTA_COMANDOS token_fimEnquanto
    ;

COMANDO_PARA
    : token_para token_identificador {
        Variavel* v = validarIdentificadorSairCasoInvalido();
        int tipoVariavel = getTipoVariavel(v);
        if(tipoVariavel != TIPO_INTEIRO){
            finalizarProgramaComErro("Comando PARA dever iterar sob variaveis do tipo inteiro");
        }
    } token_de EXPRESSAO {
        tipoExpressaoAtribuicao = TIPO_INTEIRO;
        validarExpressaoSairCasoInvalido();
    } token_ate EXPRESSAO {
        tipoExpressaoAtribuicao = TIPO_INTEIRO;
        validarExpressaoSairCasoInvalido();
    }  COMANDO_PARA2
    ;   

COMANDO_PARA2
    : token_faca LISTA_COMANDOS token_fimPara
    | token_passo INTEIRO token_faca LISTA_COMANDOS token_fimPara
    ;

COMANDO_SE
    : token_se {
        tipoExpressaoAtribuicao = TIPO_LOGICO;
    } EXPRESSAO {
        validarExpressaoSairCasoInvalido();
    } token_entao LISTA_COMANDOS COMANDO_SE2
    ;

COMANDO_SE2
    : token_senao LISTA_COMANDOS token_fimSe
    | token_fimSe
    ;

COMANDO_FACA_ENQUANTO
    : token_faca token_simboloDoisPontos LISTA_COMANDOS token_enquanto EXPRESSAO {
        tipoExpressaoAtribuicao = TIPO_LOGICO;
        validarExpressaoSairCasoInvalido();
    } token_fimEnquanto
    ;

COMANDO_AVALIE
    : token_avalie token_simboloAbreParentese token_identificador {
        Variavel* v = validarIdentificadorSairCasoInvalido();
        int tipoVariavel = getTipoVariavel(v);
        printf("%d\n", tipoVariavel);
        if(tipoVariavel != TIPO_INTEIRO){
            finalizarProgramaComErro("Nao eh possivel avaliar variaveis cujo tipo nao eh inteiro");
        }
    } token_simboloFechaParentese token_simboloDoisPontos AVALIE_CASO token_fimAvalie
    ;

AVALIE_CASO
    : AVALIE_CASO token_caso INTEIRO token_simboloDoisPontos LISTA_COMANDOS token_pare token_simboloPontoVirgula
    | token_caso INTEIRO token_simboloDoisPontos LISTA_COMANDOS token_pare token_simboloPontoVirgula
    ;

COMANDO_LEIA
    : token_leia token_simboloAbreParentese token_simboloFechaParentese
    ;

COMANDO_IMPRIMA
    : token_imprima token_simboloAbreParentese POSSIVEIS_PARAMETROS token_simboloFechaParentese token_simboloPontoVirgula
    ;

PARAMETROS_FUNCAO
    : PARAMETROS_FUNCAO token_simboloVirgula POSSIVEIS_PARAMETROS {
        parametrosFuncao = criarNovoNoListaFim(tipo, yytext, parametrosFuncao);
    }
    | POSSIVEIS_PARAMETROS {
       parametrosFuncao = criarNovoNoListaFim(tipo, yytext, parametrosFuncao);
    }
    ;

POSSIVEIS_PARAMETROS
    : token_identificador {
       Variavel* v = validarIdentificadorSairCasoInvalido();
       tipo = getTipoVariavel(v);
    }
    | NUMERO 
    | ACESSO_MATRIZ 
    | LOGICO {
        tipo = TIPO_LOGICO; 
    }
    | CARACTERE_LITERAL
    ;

COMANDO_CHAMADA_FUNCAO
    : token_identificador token_simboloAbreParentese {
        funcao = buscarFuncaoTabelaHash(hashFuncao, identificador);
        if(funcao == NULL) {
            finalizarProgramaComErro("A funcao nao foi declarada");
        }
        parametrosFuncao = liberarMemoriaLista(parametrosFuncao);
    } COMANDO_CHAMADA_FUNCAO2 {
        if(isChamadaFuncaoValida(funcao, parametrosFuncao) == 0){
           finalizarProgramaComErro("Parametros passados na chamada de funcao nao condizem com a declaracao");
       }
       parametrosFuncao = liberarMemoriaLista(parametrosFuncao);
    }
    ;

COMANDO_CHAMADA_FUNCAO2
    : token_simboloFechaParentese 
    | PARAMETROS_FUNCAO token_simboloFechaParentese
    ;

COMANDO_MAIS_MAIS_MENOS_MENOS
    : token_identificador {
        validarOperadoresMMMMSairCasoInvalido();
    } token_operadorSomaSoma token_simboloPontoVirgula
    | token_operadorSomaSoma token_identificador {
        validarOperadoresMMMMSairCasoInvalido();
    } token_simboloPontoVirgula
    | token_identificador {
        validarOperadoresMMMMSairCasoInvalido();
    } token_operadorSubtraiSubtrai token_simboloPontoVirgula
    | token_operadorSubtraiSubtrai token_identificador {
        validarOperadoresMMMMSairCasoInvalido();
    } token_simboloPontoVirgula
    ;  

EXPRESSAO
    : EXPRESSAO_SIMPLES
    | EXPRESSAO_SIMPLES token_operadorIgualIgual {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES 
    | EXPRESSAO_SIMPLES token_operadorMenor {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES 
    | EXPRESSAO_SIMPLES token_operadorMenorIgual {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES 
    | EXPRESSAO_SIMPLES token_operadorMaiorIgual {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES 
    | EXPRESSAO_SIMPLES token_operadorMaior {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES 
    | EXPRESSAO_SIMPLES token_operadorDiferente {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } EXPRESSAO_SIMPLES 
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
    } TERMO
    | EXPRESSAO_SIMPLES token_operadorOu {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } TERMO
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
    } FATOR
    | TERMO token_operadorPorcento {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } FATOR
    | TERMO token_operadorPotencia {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_ARITMETICO, NULL, operadores);
    } FATOR
    | TERMO token_operadorE {
        operadores = criarNovoNoListaFim(TIPO_OPERADOR_LOGICO, NULL, operadores);
    } FATOR
    ;


FATOR
    : token_identificador {
       //variavel declarada     
       Variavel* v = validarIdentificadorSairCasoInvalido();
        tipo = getTipoVariavel(v);
        expressao = criarNovoNoListaFim(tipo, yytext, expressao);
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
        int i = atoi(yytext);
        Arvore *novoNo = inicializaArvore(TIPO_INTEIRO, &i);
        p = empilhar(p, novoNo);
    }
    | REAL {
    tipo = TIPO_REAL;
        expressao = criarNovoNoListaFim(TIPO_REAL, NULL, expressao);
        float i = atof(yytext)
        Arvore *novoNo = inicializaArvore(TIPO_REAL, &i);
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
    : token_verdadeiro
    | token_falso
    | token_operadorNao FATOR
    ;

CARACTERE_LITERAL
    : token_literal {
    tipo = TIPO_LITERAL;
    }
    | token_caractere {
    tipo = TIPO_CARACTERE;
    }
    ;

ACESSO_MATRIZ
    : token_identificador POSICAO_MATRIZ {
        //variavel declarada 
        Variavel* v = validarIdentificadorSairCasoInvalido();
        validarAcessoMatrizSairCasoInvalido(v);
        tipo = getTipoVariavel(v);
        expressao = criarNovoNoListaFim(tipo, yytext, expressao);
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
 //   printf("IMPRIMINDO VARIAVEIS\n");
 //   imprimirTabelaHash(hashVariavel);
 //   printf("\n");
 //   printf("IMPRIMINDO FUNCOES\n");
   // imprimirTabelaHashFuncao(hashFuncao);
  //  imprimirRelatorioVariaveisNaoUtilizadas(hashVariavel);
    liberarMemoriaAlocada();
}

/* rotina chamada por yyparse quando encontra erro */
yyerror (void){
    printf("Erro na sintatico na linha %d\n", line_num);
    liberarMemoriaAlocada();
    exit(0);
}
