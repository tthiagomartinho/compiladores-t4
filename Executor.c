#include "Executor.h"

int avaliaExpressaoInteiro (Arvore* a, Lista** hashVariavel, Lista** hashFuncao) {
	if(ehNoFolha(a)){
		int tipo = getTipoNo(a);
		switch(tipo){
			case TIPO_INTEIRO:
				return atoi(getValorNo(a));
				break;
			case TIPO_LOGICO:{
				char* valorNo = a->valorNo;
				if(strcmp(valorNo, "verdadeiro") == 0){
					return 1;
				}else{
					return 0;
				}
				break;
			}case TIPO_VARIAVEL:{
				Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(a), getEscopo(a));
				int i = *((int*) getValorVariavel(v));
				return i;
			}default:
			break;
		}       
	}else{
		if(strcmp(getValorNo(a), "+") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) + avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "-") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) - avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "*") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) * avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "/") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) / avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "^") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) ^ avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "%") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) % avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), ">") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) > avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "<") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) < avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "==") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) == avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), ">=") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) >= avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "<=") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) <= avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "<>") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) != avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "e") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) && avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "ou") == 0){
			return avaliaExpressaoInteiro(getFilhoCentro(a), hashVariavel, hashFuncao) || avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "nao") == 0){
			return !avaliaExpressaoInteiro(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}
	}
}

float avaliaExpressaoReal (Arvore* a, Lista** hashVariavel, Lista** hashFuncao) {
	if(ehNoFolha(a)){
		int tipo = getTipoNo(a);
		switch(tipo){
			case TIPO_REAL:
				return atof(getValorNo(a));
				break;
			case TIPO_VARIAVEL:{
				Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(a), getEscopo(a));
				float i = *((float*) getValorVariavel(v));
				return i;
			}default:
			break;
		}           
	}else{
		if(strcmp(getValorNo(a), "+") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) + avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "-") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) - avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "*") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) * avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "/") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) / avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), ">") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) > avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "<") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) < avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "==") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) == avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), ">=") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) >= avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "<=") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) <= avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "<>") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) != avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "e") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) && avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "ou") == 0){
			return avaliaExpressaoReal(getFilhoCentro(a), hashVariavel, hashFuncao) || avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}else if(strcmp(getValorNo(a), "nao") == 0){
			return !avaliaExpressaoReal(getFilhoEsquerda(a), hashVariavel, hashFuncao);
		}
	}
}

int avaliaExpressaoLogica (Arvore* a, Lista** hashVariavel, Lista** hashFuncao){
	int tipoExpressaoLogica = getTipoExpressaoLogica(a, hashVariavel, hashFuncao);
	if(tipoExpressaoLogica == TIPO_REAL){
		float valor = avaliaExpressaoReal (a, hashVariavel, hashFuncao);
		return valor > 0;
	}else{
		return avaliaExpressaoInteiro (a, hashVariavel, hashFuncao);
	}
}

int getTipoExpressaoLogica(Arvore* a, Lista** hashVariavel, Lista** hashFuncao){
	if(ehNoFolha(a)){
		int tipo = getTipoNo(a);
		int tipoRetorno;
		switch(tipo){
			case TIPO_REAL:
				tipoRetorno = TIPO_REAL;
				break;
			case TIPO_VARIAVEL:{
				Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(a), getEscopo(a));
				tipoRetorno = getTipoVariavel(v);
				break;
			}default:
				tipoRetorno = TIPO_INTEIRO;
				break;
		}
		return tipoRetorno;       
	}else{
		return getTipoExpressaoLogica(getFilhoEsquerda(a), hashVariavel, hashFuncao);
	}
}

void executarAtribuicao(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao) {
	int funcao = 0;
	Arvore* variavelASerAtribuida = getFilhoEsquerda(comandoAtual);
	Arvore* comandoASerExecutado = getFilhoCentro(comandoAtual);
	
	// Verifica qual o tipo da variável 
	Variavel* variavel = buscarVariavelTabelaHash(hashVariavel, getValorNo(variavelASerAtribuida), getEscopo(variavelASerAtribuida));
	int tipoVariavel = getTipoVariavel(variavel);

	if(comandoASerExecutado->tipo == TIPO_FUNCAO){
		funcao = 1;
	} else if(strcmp(comandoASerExecutado->valorNo, "leia") == 0){
		executarLeia(variavel);
		return;
	}

	switch (tipoVariavel) {
		case TIPO_INTEIRO:{
			int valor;
			if(funcao == 1){
				//valor = executarFuncao();
			}else{
				valor = avaliaExpressaoInteiro (comandoASerExecutado, hashVariavel, hashFuncao);
			}
			setVariavelValor(variavel, &valor, TIPO_INTEIRO);
			break;
		}case TIPO_REAL:{
			float valor;
			if(funcao == 1){
				//valor = executarFuncao();
			}else{
				valor = avaliaExpressaoReal (comandoASerExecutado, hashVariavel, hashFuncao);
			}
			setVariavelValor(variavel, &valor, TIPO_REAL);
			break;
		}case TIPO_LOGICO:{
			int valor;
			if(funcao == 1){
				//valor = executarFuncao();
			}else{
				valor = avaliaExpressaoLogica (comandoASerExecutado, hashVariavel, hashFuncao);
			}
			setVariavelValor(variavel, &valor, TIPO_INTEIRO);
			break;
		}default:
			break;
	}
}

void executarLeia(Variavel* variavel){
	switch(getTipoVariavel(variavel)){
		case TIPO_INTEIRO:{
			int valor;
			scanf(" %d", &valor);
			setVariavelValor(variavel, &valor, TIPO_INTEIRO);
			break;
		}
		case TIPO_LOGICO:{
			int valor;
			scanf(" %d", &valor);
			setVariavelValor(variavel, &valor, TIPO_LOGICO);
			break;
		}
		case TIPO_REAL: {
			float valor;
			scanf(" %f", &valor);
			setVariavelValor(variavel, &valor, TIPO_REAL);
			break;
		}
		case TIPO_LITERAL: {
			char valor[255];
    		fgets(valor, sizeof valor, stdin);
			setVariavelValor(variavel, valor, TIPO_LITERAL);
			break;
		}
		case TIPO_CARACTERE: {
			char valor[255];
    		fgets(valor, sizeof valor, stdin);
			setVariavelValor(variavel, valor, TIPO_LITERAL);
			break;
		}
		default:
		break;
	}

}

void executarImprima(Arvore* comandoAtual, Lista** hashVariavel){
	Arvore* valorParaImprimir = getFilhoEsquerda(comandoAtual);
	if(valorParaImprimir->tipo == TIPO_VARIAVEL){
		Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(valorParaImprimir), getEscopo(valorParaImprimir));
		switch(getTipoVariavel(v)){
			case TIPO_INTEIRO:
				printf("%d\n", *((int*)getValorVariavel(v)));
				break;
			case TIPO_LOGICO:{
				int valor = *((int*)getValorVariavel(v));
				if(valor == 0){
					printf("falso\n");
				}else{
					printf("verdadeiro\n");
				}
				break;
			}case TIPO_REAL: 
				printf("%f\n", *((float*)getValorVariavel(v)));
				break;
			default:
				printf("%s\n", (char*)getValorVariavel(v));
			break;
		}
	}else{
		printf("%s\n", (char*)getValorNo(valorParaImprimir));
	}
}

void executarPara(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao){
	Arvore* limitadores = getFilhoEsquerda(comandoAtual);
	Arvore* para = getFilhoCentro(comandoAtual);
	Lista* operador = (Lista*) getValorNo(limitadores);
	Lista* deLista = operador->prox;
	Lista* ateLista = deLista->prox;
	Lista* passoLista = NULL;

	int valorPasso = 0;
	if(tamanhoLista(operador) == 4){
		passoLista = ateLista->prox;
		Arvore* passo = (Arvore*) passoLista->info;
		valorPasso = atoi(getValorNo(passo));
	}

	Arvore* variavel = (Arvore*) operador->info;
	Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(variavel), getEscopo(variavel));

	Arvore* de = (Arvore*) deLista->info;
	int valorDe = atoi(getValorNo(de));

	Arvore* ate = (Arvore*) ateLista->info;
	int valorAte = atoi(getValorNo(ate));

	int i;
	imprimirArvoreComandos(para);
	for(i = valorDe; i < valorAte; i = i + valorPasso){
		exetuarPrograma(para, hashVariavel, hashFuncao);
	}
}

void executarSe(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao){
	Arvore* expressao = getFilhoEsquerda(comandoAtual);
	Arvore* entao = getFilhoCentro(comandoAtual);
	Arvore* senao = getFilhoDireita(comandoAtual);

	int condicaoSe = avaliaExpressaoLogica (expressao, hashVariavel, hashFuncao);
	if(condicaoSe == 1){
		exetuarPrograma(entao, hashVariavel, hashFuncao);
	} else {
		exetuarPrograma(senao, hashVariavel, hashFuncao);
	}
}

void executarMaisMais(Arvore* comandoAtual, Lista** hashVariavel){
	Arvore* filhoEsquerda = getFilhoEsquerda(comandoAtual);
	Arvore* filhoCentro = getFilhoCentro(comandoAtual);

	if(filhoEsquerda != NULL){
		Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(filhoEsquerda), getEscopo(filhoEsquerda));

		switch(getTipoVariavel(v)){
			case TIPO_INTEIRO:{
				int valor = *(int*)getValorVariavel(v);
				valor++;
				setVariavelValor(v, &valor, TIPO_INTEIRO);
				break;
			}
			case TIPO_REAL:{
				float valor = *(float*) getValorVariavel(v);
				valor++;
				setVariavelValor(v, &valor, TIPO_INTEIRO);
				break;
			}
		}
	} else {
		Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(filhoCentro), getEscopo(filhoCentro));
		switch(getTipoVariavel(v)){
			case TIPO_INTEIRO:{
				int valor = *(int*)getValorVariavel(v);
				++valor;
				setVariavelValor(v, &valor, TIPO_INTEIRO);
				break;
			}
			case TIPO_REAL:{
				float valor = *(float*) getValorVariavel(v);
				++valor;
				setVariavelValor(v, &valor, TIPO_INTEIRO);
				break;
			}
		}
	}
}

void executarMenosMenos(Arvore* comandoAtual, Lista** hashVariavel){
	Arvore* filhoEsquerda = getFilhoEsquerda(comandoAtual);
	Arvore* filhoCentro = getFilhoCentro(comandoAtual);

	if(filhoEsquerda != NULL){
		Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(filhoEsquerda), getEscopo(filhoEsquerda));
		switch(getTipoVariavel(v)){
			case TIPO_INTEIRO:{
				int valor = *(int*)getValorVariavel(v);
				valor--;
				setVariavelValor(v, &valor, TIPO_INTEIRO);
				break;
			}
			case TIPO_REAL:{
				float valor = *(float*) getValorVariavel(v);
				valor--;
				setVariavelValor(v, &valor, TIPO_INTEIRO);
				break;
			}
			default:
			break;
		}
	} else {
		Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(filhoCentro), getEscopo(filhoCentro));
		switch(getTipoVariavel(v)){
			case TIPO_INTEIRO:{
				int valor = *(int*)getValorVariavel(v);
				--valor;
				setVariavelValor(v, &valor, TIPO_INTEIRO);
				break;
			}
			case TIPO_REAL:{
				float valor = *(float*) getValorVariavel(v);
				--valor;
				setVariavelValor(v, &valor, TIPO_INTEIRO);
				break;
			}
			default:
			break;
		}
	}
}

void executarEnquanto(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao){
	Arvore* expressao = getFilhoEsquerda(comandoAtual);
	Arvore* comandos = getFilhoCentro(comandoAtual);

	int valorCondicao = avaliaExpressaoLogica (expressao, hashVariavel, hashFuncao);

	while(valorCondicao == 1){
		exetuarPrograma(comandos, hashVariavel, hashFuncao);
		valorCondicao = avaliaExpressaoLogica (expressao, hashVariavel, hashFuncao);
	}
}

void executarFacaEnquanto(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao){
	Arvore* expressao = getFilhoEsquerda(comandoAtual);
	Arvore* comandos = getFilhoCentro(comandoAtual);

	int valorCondicao = avaliaExpressaoLogica (expressao, hashVariavel, hashFuncao);

	do{
		exetuarPrograma(comandos, hashVariavel, hashFuncao);
		valorCondicao = avaliaExpressaoLogica (expressao, hashVariavel, hashFuncao);
	}while(valorCondicao == 1);
}

void executarAvalie(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao){
	Arvore* ident = getFilhoEsquerda(comandoAtual);
	Arvore* casosArvore = getFilhoCentro(comandoAtual);
	
	Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(ident), getEscopo(ident));
	int valorVariavel = *(int*) getValorVariavel(v);

	Lista* casos = (Lista*) getValorNo(casosArvore);
	Lista* aux;
	for(aux = casos; aux != NULL; aux = aux -> prox){
		Arvore* caso = (Arvore*) aux->info;
		Arvore* condicao = getFilhoEsquerda(caso);
		int valorCondicao = atoi(getValorNo(condicao));
		if(valorVariavel == valorCondicao){
			exetuarPrograma(caso, hashVariavel, hashFuncao);
			break;
		}
	}
}

void executarSeForFuncao(Arvore* comandoAtual, Lista** hashVariavel, Lista** hashFuncao){
	Funcao* f = buscarFuncaoTabelaHash(hashFuncao, getValorNo(comandoAtual));
	if(f == NULL){
		return;
	}

	Arvore* parametrosPassados = getFilhoCentro(comandoAtual);
	Arvore* filhoEsquerda = getFilhoEsquerda(comandoAtual);
	Lista* variaveis = (Lista*) getValorNo(filhoEsquerda);
	Lista* aux, *variaveisFuncao = NULL;
	for(aux = variaveis; aux != NULL; aux = aux->prox){
		
	}
}

void exetuarPrograma(Arvore* programa, Lista** hashVariavel, Lista** hashFuncao){
    Arvore* comandoAtual;
    
    for(comandoAtual = programa; comandoAtual != NULL; comandoAtual = comandoAtual -> prox){
        char* comando = (char*) getValorNo(comandoAtual);
        if(strcmp(comando, "=") == 0){
            executarAtribuicao(comandoAtual, hashVariavel, hashFuncao);
        } else if(strcmp(comando, "imprima") == 0){
            executarImprima(comandoAtual, hashVariavel);
        } else if(strcmp(comando, "para") == 0){
            executarPara(comandoAtual, hashVariavel, hashFuncao);
        } else if(strcmp(comando, "se") == 0){
            executarSe(comandoAtual, hashVariavel, hashFuncao);
        } else if(strcmp(comando, "--") == 0){
            executarMenosMenos(comandoAtual, hashVariavel);
        } else if(strcmp(comando, "++") == 0){
            executarMaisMais(comandoAtual, hashVariavel);
        } else if(strcmp(comando, "enquanto") == 0){
            executarEnquanto(comandoAtual, hashVariavel, hashFuncao);
        } else if(strcmp(comando, "faca-enquanto") == 0){
            executarFacaEnquanto(comandoAtual, hashVariavel, hashFuncao);
        } else if(strcmp(comando, "avalie") == 0){
            executarAvalie(comandoAtual, hashVariavel, hashFuncao);
        } else{
        	executarSeForFuncao(comandoAtual, hashVariavel, hashFuncao);
        }
    }
}