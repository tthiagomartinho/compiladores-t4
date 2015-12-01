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
				if(getDimensaoMatriz(v) == 0){
					int i = *((int*) getValorVariavel(v));
					return i;
				}else{
					int posicao = getPosicaoMatriz(a->dimensoesMatriz, v);
					int i = *(int*) getValorVariavelMatriz(posicao, v);
					return i;
				}
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
				if(getDimensaoMatriz(v) == 0){
					float i = *((float*) getValorVariavel(v));
					return i;
				}else{
					int posicao = getPosicaoMatriz(a->dimensoesMatriz, v);
					float i = *(float*) getValorVariavelMatriz(posicao, v);
					return i;
				}
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

int getPosicaoMatriz(Lista* dimensoesMatriz, Variavel* variavel){
	if(tamanhoLista(dimensoesMatriz) == 1){
		return atoi(dimensoesMatriz->info);
	}

	Lista* aux;
	int tam = getDimensaoMatriz(variavel);
	int* dimensoes = getDimensoes(variavel);
	int pos = 1;

	int totalIndice = -1;

	for(aux = dimensoesMatriz; aux != NULL; aux = aux->prox){
		int indice = atoi(aux->info);
		int t;
		for(t = pos; t < tam; t++){
			indice = indice * dimensoes[t];
		}
		pos++;
		totalIndice += indice;
	}
	return totalIndice;
}

void executarAtribuicao(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao) {
	int funcao = 0;
	Arvore* variavelASerAtribuida = getFilhoEsquerda(comandoAtual);
	Arvore* comandoASerExecutado = getFilhoCentro(comandoAtual);
	
	// Verifica qual o tipo da variável 
	Variavel* variavel = buscarVariavelTabelaHash(hashVariavel, getValorNo(variavelASerAtribuida), getEscopo(variavelASerAtribuida));
	int tipoVariavel = getTipoVariavel(variavel);

	int posicao = -1;

	if(variavelASerAtribuida->dimensoesMatriz != NULL){
		posicao = getPosicaoMatriz(variavelASerAtribuida->dimensoesMatriz, variavel);
	}

	if(comandoASerExecutado->tipo == TIPO_FUNCAO){
		funcao = 1;
	} else if(strcmp(comandoASerExecutado->valorNo, "leia") == 0){
		executarLeia(variavel);
		return;
	}

	if(funcao == 1){
		executarSeForFuncao(comandoASerExecutado, funcoes, hashVariavel, hashFuncao, variavel, posicao);
	}else{
		switch (tipoVariavel) {
			case TIPO_INTEIRO:{
				int valor = avaliaExpressaoInteiro (comandoASerExecutado, hashVariavel, hashFuncao);
				setVariavelValor(variavel, &valor, TIPO_INTEIRO, posicao);
				break;
			}case TIPO_REAL:{
				float valor = avaliaExpressaoReal (comandoASerExecutado, hashVariavel, hashFuncao);
				setVariavelValor(variavel, &valor, TIPO_REAL, posicao);
				break;
			}case TIPO_LOGICO:{
				int valor = avaliaExpressaoLogica (comandoASerExecutado, hashVariavel, hashFuncao);
				setVariavelValor(variavel, &valor, TIPO_INTEIRO, posicao);
				break;
			}case TIPO_LITERAL:{
				char* valor = getValorNo(comandoASerExecutado);
				setVariavelValor(variavel, valor, TIPO_LITERAL, posicao);
				break;
			}
		}
	}
}

void executarLeia(Variavel* variavel){
	int posicao = -1;
	fflush(stdin);
	switch(getTipoVariavel(variavel)){
		case TIPO_INTEIRO:{
			int valor;
			scanf(" %d", &valor);
			setVariavelValor(variavel, &valor, TIPO_INTEIRO, posicao);
			break;
		}
		case TIPO_LOGICO:{
			int valor;
			scanf(" %d", &valor);
			setVariavelValor(variavel, &valor, TIPO_LOGICO, posicao);
			break;
		}
		case TIPO_REAL: {
			float valor;
			scanf(" %f", &valor);
			setVariavelValor(variavel, &valor, TIPO_REAL, posicao);
			break;
		}
		case TIPO_LITERAL: {
			char valor[255];
    		fgets(valor, sizeof valor, stdin);
			setVariavelValor(variavel, valor, TIPO_LITERAL, posicao);
			break;
		}
		case TIPO_CARACTERE: {
			char valor[255];
    		fgets(valor, sizeof valor, stdin);
			setVariavelValor(variavel, valor, TIPO_LITERAL, posicao);
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

void executarPara(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao){
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

	for(i = valorDe; i < valorAte; i = i + valorPasso){
		exetuarPrograma(para, funcoes, hashVariavel, hashFuncao);
	}
}

void executarSe(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao){
	Arvore* expressao = getFilhoEsquerda(comandoAtual);
	Arvore* entao = getFilhoCentro(comandoAtual);
	Arvore* senao = getFilhoDireita(comandoAtual);

	int condicaoSe = avaliaExpressaoLogica (expressao, hashVariavel, hashFuncao);
	if(condicaoSe == 1){
		exetuarPrograma(entao, funcoes, hashVariavel, hashFuncao);
	} else {
		exetuarPrograma(senao, funcoes, hashVariavel, hashFuncao);
	}
}

void executarMaisMais(Arvore* comandoAtual, Lista** hashVariavel){
	Arvore* filhoEsquerda = getFilhoEsquerda(comandoAtual);
	Arvore* filhoCentro = getFilhoCentro(comandoAtual);
	int posicao = -1;
	if(filhoEsquerda != NULL){
		Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(filhoEsquerda), getEscopo(filhoEsquerda));
		
		switch(getTipoVariavel(v)){
			case TIPO_INTEIRO:{
				int valor = *(int*)getValorVariavel(v);
				valor++;
				setVariavelValor(v, &valor, TIPO_INTEIRO, posicao);
				break;
			}
			case TIPO_REAL:{
				float valor = *(float*) getValorVariavel(v);
				valor++;
				setVariavelValor(v, &valor, TIPO_INTEIRO, posicao);
				break;
			}
		}
	} else {
		Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(filhoCentro), getEscopo(filhoCentro));
		switch(getTipoVariavel(v)){
			case TIPO_INTEIRO:{
				int valor = *(int*)getValorVariavel(v);
				++valor;
				setVariavelValor(v, &valor, TIPO_INTEIRO, posicao);
				break;
			}
			case TIPO_REAL:{
				float valor = *(float*) getValorVariavel(v);
				++valor;
				setVariavelValor(v, &valor, TIPO_INTEIRO, posicao);
				break;
			}
		}
	}
}

void executarMenosMenos(Arvore* comandoAtual, Lista** hashVariavel){
	Arvore* filhoEsquerda = getFilhoEsquerda(comandoAtual);
	Arvore* filhoCentro = getFilhoCentro(comandoAtual);
	int posicao = -1;
	if(filhoEsquerda != NULL){
		Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(filhoEsquerda), getEscopo(filhoEsquerda));
		
		switch(getTipoVariavel(v)){
			case TIPO_INTEIRO:{
				int valor = *(int*)getValorVariavel(v);
				valor--;
				setVariavelValor(v, &valor, TIPO_INTEIRO, posicao);
				break;
			}
			case TIPO_REAL:{
				float valor = *(float*) getValorVariavel(v);
				valor--;
				setVariavelValor(v, &valor, TIPO_INTEIRO, posicao);
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
				setVariavelValor(v, &valor, TIPO_INTEIRO, posicao);
				break;
			}
			case TIPO_REAL:{
				float valor = *(float*) getValorVariavel(v);
				--valor;
				setVariavelValor(v, &valor, TIPO_INTEIRO, posicao);
				break;
			}
			default:
			break;
		}
	}
}

void executarEnquanto(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao){
	Arvore* expressao = getFilhoEsquerda(comandoAtual);
	Arvore* comandos = getFilhoCentro(comandoAtual);

	int valorCondicao = avaliaExpressaoLogica (expressao, hashVariavel, hashFuncao);

	while(valorCondicao == 1){
		exetuarPrograma(comandos, funcoes, hashVariavel, hashFuncao);
		valorCondicao = avaliaExpressaoLogica (expressao, hashVariavel, hashFuncao);
	}
}

void executarFacaEnquanto(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao){
	Arvore* expressao = getFilhoEsquerda(comandoAtual);
	Arvore* comandos = getFilhoCentro(comandoAtual);

	int valorCondicao = avaliaExpressaoLogica (expressao, hashVariavel, hashFuncao);

	do{
		exetuarPrograma(comandos, funcoes, hashVariavel, hashFuncao);
		valorCondicao = avaliaExpressaoLogica (expressao, hashVariavel, hashFuncao);
	}while(valorCondicao == 1);
}

void executarAvalie(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao){
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
			exetuarPrograma(caso, funcoes, hashVariavel, hashFuncao);
			break;
		}
	}
}

void executarSeForFuncao(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao, Variavel* variavel, int posicao){
	Arvore* aux, *arvoreFuncao = NULL;
	Funcao* f = buscarFuncaoTabelaHash(hashFuncao, getValorNo(comandoAtual));
	if(f == NULL){
		return;
	}

	//procura nas funcoes presentes no codigo
	for(aux = funcoes; aux != NULL; aux = aux->prox){
		if(strcmp(getValorNo(aux), getValorNo(comandoAtual)) == 0){
			arvoreFuncao = aux;
			break;
		}
	}

	Arvore* parametrosPassados = getFilhoCentro(comandoAtual);
	if(arvoreFuncao != NULL){
		Arvore* param = getFilhoEsquerda(arvoreFuncao);
		Lista* parametrosFuncao = (Lista*) getValorNo(param);

		 if(parametrosFuncao != NULL){
			// //inicia as variaveis
			for(aux = parametrosPassados; aux != NULL; aux = aux->prox, parametrosFuncao = parametrosFuncao->prox){
				Variavel* vAux = (Variavel*) parametrosFuncao->info;
				Variavel* vFuncao = buscarVariavelTabelaHash(hashVariavel, getNomeVariavel(vAux), getNomeFuncao(f));

				int posicao = -1;
				switch(getTipoNo(aux)){
					case TIPO_VARIAVEL:{
						Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(aux), getEscopo(aux));
						setVariavelValor (vFuncao, getValorVariavel(v), getTipoVariavel(v), posicao);
						break;
					}
					case TIPO_REAL:{
						float valor = atof(getValorNo(aux));
						setVariavelValor (vFuncao, &valor, TIPO_REAL, posicao);
						break;
					}case TIPO_INTEIRO:{
						int valor = atoi(getValorNo(aux));
						setVariavelValor (vFuncao, &valor, TIPO_INTEIRO, posicao);
						break;
					}case TIPO_LITERAL:{
						char* valor = (char*) getValorNo(aux);
						setVariavelValor (vFuncao, valor, TIPO_LITERAL, posicao);
						break;
					}case TIPO_LOGICO:{
						int valor = atoi(getValorNo(aux));
						setVariavelValor (vFuncao, &valor, TIPO_INTEIRO, posicao);
						break;
					}
				}
			}
		}
	}

	char* nomeFuncao = getNomeFuncao(f);

	if(strcmp(nomeFuncao, "minimo") == 0){
		executarMinimo(hashVariavel, parametrosPassados, variavel, posicao);
	} else if(strcmp(nomeFuncao, "maximo") == 0) {
		executarMaximo(hashVariavel, parametrosPassados, variavel, posicao);
	} else if(strcmp(nomeFuncao, "central") == 0){
		executarCentral(hashVariavel, parametrosPassados, variavel, posicao);
	} else{
		exetuarPrograma1(getFilhoCentro(arvoreFuncao), funcoes, hashVariavel, hashFuncao, 1, variavel, posicao);
	}
}

void executarRetorne(Arvore* comandoAtual, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao, Variavel* variavel, int posicao){
	int tipoExpressao = getTipoNo(comandoAtual);
	Arvore* comandoASerExecutado = getFilhoEsquerda(comandoAtual);
	if(comandoASerExecutado == NULL || variavel == NULL){
		return;
	}
	switch (tipoExpressao) {
		case TIPO_INTEIRO:{
			int valor = avaliaExpressaoInteiro (comandoASerExecutado, hashVariavel, hashFuncao);
			setVariavelValor(variavel, &valor, TIPO_INTEIRO, posicao);
			break;
		}case TIPO_REAL:{
			float valor = avaliaExpressaoReal (comandoASerExecutado, hashVariavel, hashFuncao);
			setVariavelValor(variavel, &valor, TIPO_REAL, posicao);
			break;
		}case TIPO_LOGICO:{
			int valor = avaliaExpressaoLogica (comandoASerExecutado, hashVariavel, hashFuncao);
			setVariavelValor(variavel, &valor, TIPO_LOGICO, posicao);
			break;
		}case TIPO_LITERAL:{
			char* valor = getValorNo(comandoASerExecutado);
			setVariavelValor(variavel, &valor, TIPO_LITERAL, posicao);
			break;
		}case TIPO_CARACTERE:{
			char* valor = getValorNo(comandoASerExecutado);
			setVariavelValor(variavel, &valor, TIPO_LITERAL, posicao);
			break;
		}
	}
}

void executarMaximo(Lista** hashVariavel, Arvore* parametrosPassados, Variavel* variavel, int posicao){
	Arvore* aux;
	int maximo = -999999;
	for(aux = parametrosPassados; aux != NULL; aux = aux->prox){
		switch(getTipoNo(aux)){
			case TIPO_VARIAVEL:{
				Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(aux), getEscopo(aux));
				int valorVariavel = atoi(getValorVariavel(v));
				if(maximo < valorVariavel){
					maximo = valorVariavel;
				}
				break;
			}
			case TIPO_INTEIRO:{
				int valor = atoi(getValorNo(aux));
				if(maximo < valor){
					maximo = valor;
				}
				break;
			}
		}
	}

	setVariavelValor (variavel, &maximo, getTipoVariavel(variavel), posicao);
}

void executarMinimo(Lista** hashVariavel, Arvore* parametrosPassados, Variavel* variavel, int posicao){
	Arvore* aux;
	int minimo = 999999;
	for(aux = parametrosPassados; aux != NULL; aux = aux->prox){
		switch(getTipoNo(aux)){
			case TIPO_VARIAVEL:{
				Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(aux), getEscopo(aux));
				int valorVariavel = atoi(getValorVariavel(v));
				if(minimo > valorVariavel){
					minimo = valorVariavel;
				}
				break;
			}
			case TIPO_INTEIRO:{
				int valor = atoi(getValorNo(aux));
				if(minimo > valor){
					minimo = valor;
				}
				break;
			}
		}
	}
	setVariavelValor (variavel, &minimo, getTipoVariavel(variavel), posicao);
}

int cmpfunc (const void * a, const void * b){
   return ( *(int*)a - *(int*)b );
}

void executarCentral(Lista** hashVariavel, Arvore* parametrosPassados, Variavel* variavel, int posicao){
	Arvore* aux;
	int numeros[3];
	int i = 0;
	for(aux = parametrosPassados; aux != NULL; aux = aux->prox){
		switch(getTipoNo(aux)){
			case TIPO_VARIAVEL:{
				Variavel* v = buscarVariavelTabelaHash(hashVariavel, getValorNo(aux), getEscopo(aux));
				int valorVariavel = atoi(getValorVariavel(v));
				numeros[i] = valorVariavel;
				i++;
				break;
			}
			case TIPO_INTEIRO:{
				int valor = atoi(getValorNo(aux));
				numeros[i] = valor;
				i++;
				break;
			}
		}
	}
	qsort(numeros, 3, sizeof(int), cmpfunc);


	setVariavelValor (variavel, &numeros[1], getTipoVariavel(variavel), posicao);
}

void exetuarPrograma(Arvore* programa, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao){
    exetuarPrograma1(programa, funcoes, hashVariavel, hashFuncao, 0, NULL, 0);
}

void exetuarPrograma1(Arvore* programa, Arvore* funcoes, Lista** hashVariavel, Lista** hashFuncao, int executarFuncao, Variavel* v, int posicao){
    Arvore* comandoAtual;

    for(comandoAtual = programa; comandoAtual != NULL; comandoAtual = comandoAtual -> prox){
        char* comando = (char*) getValorNo(comandoAtual);
        if(strcmp(comando, "=") == 0){
            executarAtribuicao(comandoAtual, funcoes, hashVariavel, hashFuncao);
        } else if(strcmp(comando, "imprima") == 0){
            executarImprima(comandoAtual, hashVariavel);
        } else if(strcmp(comando, "para") == 0){
            executarPara(comandoAtual, funcoes, hashVariavel, hashFuncao);
        } else if(strcmp(comando, "se") == 0){
            executarSe(comandoAtual, funcoes, hashVariavel, hashFuncao);
        } else if(strcmp(comando, "--") == 0){
            executarMenosMenos(comandoAtual, hashVariavel);
        } else if(strcmp(comando, "++") == 0){
            executarMaisMais(comandoAtual, hashVariavel);
        } else if(strcmp(comando, "enquanto") == 0){
            executarEnquanto(comandoAtual, funcoes, hashVariavel, hashFuncao);
        } else if(strcmp(comando, "faca-enquanto") == 0){
            executarFacaEnquanto(comandoAtual, funcoes, hashVariavel, hashFuncao);
        } else if(strcmp(comando, "avalie") == 0){
            executarAvalie(comandoAtual, funcoes, hashVariavel, hashFuncao);
        } else if(strcmp(comando, "retorno") == 0){
            executarRetorne(comandoAtual, funcoes, hashVariavel, hashFuncao, v, posicao);
        } else{
        	executarSeForFuncao(comandoAtual, funcoes, hashVariavel, hashFuncao, v, posicao);
        }
    }
}
