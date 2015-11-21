#include "Executor.h"

int avaliaExpressaoInteiro (Arvore* a, Lista** tabelaVariavel, Arvore* arvoreVariavel) {
	if(ehNoFolha(a)){
		int tipo = getTipoNo(a);
		switch(tipo){
			case TIPO_INTEIRO:
				return atoi(getValorNo(a));
				break;
			case TIPO_VARIAVEL:{
				Variavel* v = buscarVariavelTabelaHash(tabelaVariavel, getValorNo(a), getEscopo(a));
				int i = *((int*) getValorVariavel(v));
				return i;
			}default:
			break;
		}       
	}else{
		if(strcmp(getValorNo(a), "+") == 0){
			return avaliarExpressao(getFilhoEsquerda(a), tabelaVariavel) + avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
		}else if(strcmp(getValorNo(a), "-") == 0){
			return avaliarExpressao(getFilhoEsquerda(a), tabelaVariavel) - avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
		}else	if(strcmp(getValorNo(a), "*") == 0){
			return avaliarExpressao(getFilhoEsquerda(a), tabelaVariavel) * avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
		} else if(strcmp(getValorNo(a), "=") == 0){
			return avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
		}
	}
	return 0;
}

int avaliaExpressaoReal (Arvore* a, Lista** tabelaVariavel, Arvore* arvoreVariavel) {
	if(ehNoFolha(a)){
		int tipo = getTipoNo(a);
		switch(tipo){
			case TIPO_REAL:
				return atoi(getValorNo(a));
				break;
			case TIPO_VARIAVEL:{
				Variavel* v = buscarVariavelTabelaHash(tabelaVariavel, getValorNo(a), getEscopo(a));
				int i = *((int*) getValorVariavel(v));
				return i;
			}default:
			break;
		}       
	}else{
		if(strcmp(getValorNo(a), "+") == 0){
			return avaliarExpressao(getFilhoEsquerda(a), tabelaVariavel) + avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
		}else if(strcmp(getValorNo(a), "-") == 0){
			return avaliarExpressao(getFilhoEsquerda(a), tabelaVariavel) - avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
		}else	if(strcmp(getValorNo(a), "*") == 0){
			return avaliarExpressao(getFilhoEsquerda(a), tabelaVariavel) * avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
		} else if(strcmp(getValorNo(a), "=") == 0){
			return avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
		}
	}
}

void avaliaExpressaoAtribuicao(Arvore* a, Lista** tabelaVariavel) {
	Arvore* arvoreVariavel = getFilhoEsquerda(a);
	
	// Verifica qual o tipo da variável 
	Variavel* variavel = buscarVariavelTabelaHash(tabelaVariavel, getValorNo(arvoreVariavel), getEscopo(arvoreVariavel));
	int tipoVariavel = getTipoVariavel(variavel);
	
	switch (tipoVariavel) {
		case TIPO_INTEIRO:
		//	int valor = avaliaExpressaoInteiro (a, tabelaVariavel, arvoreVariavel);
		//	setVariavelValor(variavel, &valor, TIPO_INTEIRO);
			break;
		case TIPO_REAL:
		//	variavel->valor = avaliaExpressaoReal (a, tabelaVariavel, arvoreVariavel);
			break;
		default:
			break;
	}
}

void identificaOperacao(Lista* listaArvores, Lista** tabelaVariavel) {
	if (listaArvores == NULL) {
		printf ("listaArvores está vazia!\n");
		return;
	}
	
	while (listaArvores != NULL) {
		Arvore* a = listaArvores->info;
		
		int tipo = getTipoNo(a);
		switch (tipo){
			case EXECUTOR_ATRIBUICAO:
				avaliaExpressaoAtribuicao (a, tabelaVariavel);
				break;
		/*	case EXECUTOR_ENQUANTO:
				//avaliaExpressaoEnquanto (a, tabelaVariavel);
				break;
			case EXECUTOR_PARA:
				//avaliaExpressaoPara (a, tabelaVariavel);
				break;
			case EXECUTOR_IMPRIMA:
				//avaliaExpressaoImprima (a, tabelaVariavel);
				break;
			case EXECUTOR_LEIA:
				//avaliaExpressaoImprima (a, tabelaVariavel);
				break;
			case EXECUTOR_SE:
				//avaliaExpressaoSe (a, tabelaVariavel);
				break;
			case EXECUTOR_FACA_ENQUANTO:
				//avaliaExpressaoFacaEnquanto (a, tabelaVariavel);
				break;
			case EXECUTOR_AVALIE:
				//avaliaExpressaoFacaEnquanto (a, tabelaVariavel);
				break;
			case EXECUTOR_RETORNO:
				//avaliaExpressaoFacaEnquanto (a, tabelaVariavel);
				break;				
			case EXECUTOR_MAIS_MAIS_MENOS_MENOS:
				//avaliaExpressaoFacaEnquanto (a, tabelaVariavel);
				break;
			case EXECUTOR_CHAMADA_FUNCAO:
				//avaliaExpressaoFacaEnquanto (a, tabelaVariavel);
				break;	*/
			default:
				break;
		}
		
		listaArvores = listaArvores->prox;
	}
	
}

int avaliarExpressao(Arvore* a, Lista** tabelaVariavel){
    if(ehNoFolha(a)){
        int tipo = getTipoNo(a);
        switch(tipo){
            case TIPO_INTEIRO:
                return atoi(getValorNo(a));
                break;
            case TIPO_VARIAVEL:{
                Variavel* v = buscarVariavelTabelaHash(tabelaVariavel, getValorNo(a), getEscopo(a));
                int i = *((int*) getValorVariavel(v));
                return i;
            }default:
                break;
        }       
    }else{
        if(strcmp(getValorNo(a), "+") == 0){
            return avaliarExpressao(getFilhoEsquerda(a), tabelaVariavel) + avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
        }else if(strcmp(getValorNo(a), "*") == 0){
            return avaliarExpressao(getFilhoEsquerda(a), tabelaVariavel) * avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
        } else if(strcmp(getValorNo(a), "=") == 0){
            return avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
        }
    }
}

int avaliarExpressaoInteiro(Arvore* a, Lista** tabelaVariavel){
	if(ehNoFolha(a)){
		int tipo = getTipoNo(a);
		switch(tipo){
			case TIPO_INTEIRO:
				return atoi(getValorNo(a));
				break;
			case TIPO_VARIAVEL:{
				Variavel* v = buscarVariavelTabelaHash(tabelaVariavel, getValorNo(a), getEscopo(a));
				int i = *((int*) getValorVariavel(v));
				return i;
			}default:
			break;
		}       
	}else{
		if(strcmp(getValorNo(a), "+") == 0){
			return avaliarExpressao(getFilhoEsquerda(a), tabelaVariavel) + avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
		}else if(strcmp(getValorNo(a), "*") == 0){
			return avaliarExpressao(getFilhoEsquerda(a), tabelaVariavel) * avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
		} else if(strcmp(getValorNo(a), "=") == 0){
			return avaliarExpressao(getFilhoCentro(a), tabelaVariavel);
		}
	}
}

