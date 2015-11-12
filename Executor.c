#include "Executor.h"

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