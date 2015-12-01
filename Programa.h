#include "hash.h"
#include "Arvore.h"

typedef struct Programa{
	Arvore* comandos;
	Lista** hashVariavel;
	Lista** hashFuncao;
}Programa;

Programa* criarPrograma(Arvore* comandos, Lista** hashVariavel, Lista** hashFuncao);
Programa* buscarProgramaListaProgramas (Lista* lista, char* nomePrograma);
Lista* removerProgramaListaProgramas (Lista* lista, Programa* programa);

Lista* atualizaListaDeProgramas (Lista*programas, Programa* p, char* nomePrograma);
void executarPrograma (int opcao6, char* nomeDoPrograma, Lista* programas);
void liberaListaProgramas (Lista* programas);

// rodrigo
void imprimirListaProgramas (Lista* lista);
