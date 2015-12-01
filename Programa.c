#include "Programa.h"

Programa* criarPrograma(Arvore* comandos, Lista** hashVariavel, Lista** hashFuncao){
	Programa* p = (Programa*)malloc(sizeof(Programa));
	p->comandos = comandos;
	p->hashVariavel = hashVariavel;
	p->hashFuncao = hashFuncao;
	return p;
}

/**
 * Retorna 1 se já existir um programa compilado com o nome passado,
 * Retorna 0 se o programa não existir
 * Retorna -1 se um erro ocorrer
 */
Programa* buscarProgramaListaProgramas (Lista* lista, char* nomePrograma) {
	int debug = 1;
	
	if (lista == NULL) {
		printf ("Lista vazia! Retornando busca nome programa!\n");
		return NULL;
	}

	Programa* auxPrograma = NULL;
	Arvore* auxArvore = NULL;
	
	if (debug) printf ("Começando função de busca do %s!\n", nomePrograma);
	
	while (lista != NULL) {
		auxPrograma = (Programa*) lista->info;
		auxArvore = auxPrograma->comandos;
		
		printf ("%s == %s\n", (char*) getValorNo(auxArvore), nomePrograma);
		
		if (strcmp ((char*) getValorNo(auxArvore), nomePrograma) == 0) {
			printf ("Encontrou um programa com o nome %s\n", nomePrograma);
			return auxPrograma;
		}
		lista = lista->prox;
	}
	
	printf ("Não encontrou-se um programa com o nome %s\n", nomePrograma);
	return NULL;
}

void liberaPrograma (Programa* p);

Lista* removerProgramaListaProgramas (Lista* lista, Programa* programa) {
	Programa* auxPrograma = NULL;
	Arvore* auxArvore = NULL;
	Lista* atual = lista;
	Lista* anterior = lista;
	
	if (lista == NULL || programa == NULL) {
		printf ("Lista ou Arvore passada é igual a nulo!\n");
		return lista;
	}
	
	while (atual != NULL) {
		auxPrograma = (Programa*) atual->info;
		auxArvore = auxPrograma->comandos;
		if (strcmp ((char*) getValorNo(auxArvore), (char*) getValorNo(programa->comandos)) == 0) {
			printf ("Encontrou o elemento! Removendo o mesmo!\n");
			// Árvore foi achada, remove-a da lista
			if (atual == lista) {
				// Primeiro elemento
				lista = lista->prox;
				
				// Libera as estruturas
				liberaPrograma (auxPrograma);
//				liberarMemoriaTabelaHash (auxPrograma->hashVariavel);
//				liberarMemoriaTabelaHash (auxPrograma->hashFuncao);
//				auxArvore = liberarArvore (auxPrograma->comandos);
				free (auxPrograma);
				free (atual);
				return lista;
			} else {
				// Removendo do meio da lista
				anterior->prox = atual->prox;
				
				// Libera as estruturas
				liberaPrograma (auxPrograma);
//				liberarMemoriaTabelaHash (auxPrograma->hashVariavel);
//				liberarMemoriaTabelaHash (auxPrograma->hashFuncao);
//				auxArvore = liberarArvore (auxPrograma->comandos);
				free (auxPrograma);
				free (atual);
				return lista;
			}
		} else {
			// Não encontrou o elemento
			anterior = atual;
			atual = atual->prox;
		}
	}
	
	printf ("Não encontrou o elemento!\n");
	return lista;
}

/**
 * Imprimir lista de programas, mostrando o nome do programa compilado!
 */
void imprimirListaProgramas (Lista* lista) {
	Programa* auxPrograma = NULL;
	Arvore* auxArvore = NULL;
	Lista* auxLista = lista;
	
	if (lista == NULL) {
		printf ("Lista de programas vazia!\n");
		return;
	}
	
	printf ("Imprimindo lista de programas!\n");
	while (auxLista != NULL) {
		auxPrograma = (Programa*) auxLista->info;
		
		if (auxPrograma != NULL) {
			auxArvore = auxPrograma->comandos;
			printf ("Nome Programa: %s\n", (char*) getValorNo(auxArvore));
		} else {
			printf ("Variável auxPrograma é nula!\n");
		}
		auxLista = auxLista->prox;
	}
	
	return;
}

Lista* atualizaListaDeProgramas (Lista*programas, Programa* p, char* nomePrograma) {
		printf ("Buscando programa na lista de programas!\n");
    
    // verifica se o programa já existe na lista de programas compilados
    Programa* programaEncontrado = NULL;    
   
	programaEncontrado = buscarProgramaListaProgramas (programas, nomePrograma);
	
    if (programaEncontrado == NULL) {
    	printf ("Inserindo programa na lista de programas compilados!\n");
		programas = criarNovoNoLista(TIPO_PROGRAMA, p, programas); 	
    } else if (programaEncontrado != NULL) {
    	printf ("Removendo programa na lista de programas compilados!\n");
		programas = removerProgramaListaProgramas (programas, programaEncontrado);
    	
    	printf ("Inserindo programa na lista de programas compilados!\n");
    	programas = criarNovoNoLista(TIPO_ARVORE, p, programas);
    }
    
    return programas;
}

void executarPrograma (int opcao6, char* nomeDoPrograma, Lista* programas) {
	Programa* programaExecutado = buscarProgramaListaProgramas (programas, nomeDoPrograma);
				
	Lista** auxHashVariavel = NULL;
	Lista** auxHashFuncao = NULL;
	Arvore* auxArvoreExecutando = NULL;
	
	if (programaExecutado != NULL) {
		Lista** auxHashVariavel = programaExecutado->hashVariavel;
		Lista** auxHashFuncao = programaExecutado->hashFuncao;
		Arvore* auxArvoreExecutando = programaExecutado->comandos;
		system("clear");
		printf ("\n------- EXECUÇÃO DO PROGRAMA ----------\n");
		exetuarPrograma(getFilhoEsquerda(auxArvoreExecutando), getFilhoCentro(auxArvoreExecutando), auxHashVariavel, auxHashFuncao);

		
		if (opcao6) {
			printf ("\n-------- IMPRIMIR TABELA DE VARIÁVEIS ------\n");
			imprimirTabelaHash(auxHashVariavel);
		}

		printf ("\n-------- FIM DA EXECUÇÃO ------------\n");
	} else {
		printf ("Não existe programa para ser executado com o nome %s!\n", nomeDoPrograma);
	}
	
	return;
}

void liberaPrograma (Programa* p) {
	liberarMemoriaTabelaHash (p->hashVariavel);
	liberarMemoriaTabelaHash (p->hashFuncao);
	Arvore* a = liberarArvore (p->comandos);
}

void liberaListaProgramas (Lista* programas) {
	Programa* auxPrograma = NULL;
	Lista* auxLista = programas;
	
	while (auxLista != NULL) {
		auxPrograma = (Programa*) auxLista->info;
		liberaPrograma (auxPrograma);
		free (auxPrograma);
		auxPrograma = NULL;
		auxLista = auxLista->prox;
	}
}
