%{
    #include <string.h>
    #include <stdlib.h>
    int line_num = 1;
    int comment_caller;
    int tipo;
    char identificador[255];
     
%}

/* DEFINICOES BASICAS */
IDENTIFICADOR {CHAR}("_"|{CHAR}|{INTEIRO})*
INTEIRO [0-9]
CHAR [a-zA-Z]
REAL {INTEIRO}+"."{INTEIRO}+
INTEIRO_NEGATIVO "-"[0-9]+
REAL_NEGATIVO -{INTEIRO}+"."{INTEIRO}+
CARACTERE "'"{CHAR}"'"
COMENTARIO_LINHA "//"(.)*
LITERAL "\""[^"]*"\""

/* PARALVRAS RESERVADAS */
PA_RE_ALGORITMO "algoritmo"
PA_RE_VARIAVEIS "variaveis"
PA_RE_FIM_VARIAVEIS "fim-variaveis"
PA_RE_INICIO "inicio"
PA_RE_FIM "fim"
PA_RE_SE "se"
PA_RE_ENTAO "entao"
PA_RE_SENAO "senao"
PA_RE_FIMSE "fim-se"
PA_RE_DE "de"
PA_RE_LEIA "leia"
PA_RE_IMPRIMA "imprima"
PA_RE_VERDADEIRO "verdadeiro"
PA_RE_FALSO "falso"
PA_RE_ENQUANTO "enquanto"
PA_RE_FACA "faca"
PA_RE_FIM_ENQUANTO "fim-enquanto"
PA_RE_PARA "para"
PA_RE_ATE "ate"
PA_RE_FIM_PARA "fim-para"
PA_RE_FUNCAO "funcao"
PA_RE_FIM_FUNCAO "fim-funcao"
PA_RE_RETORNE "retorne"
PA_RE_PASSO "passo"
PA_RE_AVALIE "avalie"
PA_RE_FIM_AVALIE "fim-avalie"
PA_RE_CASO "caso"
PA_RE_PARE "pare"

/* TIPOS DE DADOS */
TIPO_REAL "real"
TIPO_INTEIRO "inteiro"
TIPO_CARACTERE "caractere"
TIPO_LITERAL "literal"
TIPO_LOGICO "logico"
TIPO_MATRIZ "matriz"

/* OPERADORES*/
OPERADOR_ATRIBUICAO "="
OPERADOR_POTENCIA "^"
OPERADOR_SOMA_SOMA "++"
OPERADOR_SUBTRAI_SUBTRAI "--"
OPERADOR_PORCENTO "%"
OPERADOR_MAIS "+"
OPERADOR_MENOS "-"
OPERADOR_VEZES "*"
OPERADOR_DIVIDIR "/"
OPERADOR_MAIOR ">"
OEPRADOR_MAIOR_IGUAL ">="
OPERADOR_MENOR "<"
OPERADOR_MENOR_IGUAL "<="
OPERADOR_IGUAL_IGUAL "=="
OPERADOR_DIFERENTE "<>"
OPERADOR_E "e"
OPERADOR_OU "ou"
OPERADOR_NAO "nao"

/* definicao de digitios */
SIMBOLO_PONTO_VIRGULA ";"
SIMBOLO_DOIS_PONTOS ":"
SIMBOLO_VIRGULA ","
SIMBOLO_ABRE_PARENTESE "("
SIMBOLO_FECHA_PARENTESE ")"
SIMBOLO_ABRE_COLCHETE "["
SIMBOLO_FECHA_COLCHETE "]"
SIMBOLO_ESPECIAL "\""|"."|"{"|"}"|"#"|"'"|"\\"

%x comment

%%
"/*" {
    comment_caller = INITIAL;
    BEGIN(comment);
}

{COMENTARIO_LINHA}          {}
{LITERAL}                   {return token_literal;}
{INTEIRO_NEGATIVO}          {return token_inteiroNegativo;}
{REAL_NEGATIVO}             {return token_realNegativo;}
{REAL}                      {return token_real;}
{INTEIRO}+                  {return token_inteiro;}
{CARACTERE}                 {return token_caractere;}


{PA_RE_ALGORITMO}           {return token_algoritmo;}
{PA_RE_VARIAVEIS}           {return token_variaveis;}
{PA_RE_FIM_VARIAVEIS}       {return token_fimVariaveis;}
{PA_RE_INICIO}              {return token_inicio;}
{PA_RE_FIM}                 {return token_fim;}
{PA_RE_SE}                  {return token_se;}
{PA_RE_ENTAO}               {return token_entao;}
{PA_RE_SENAO}               {return token_senao;}
{PA_RE_FIMSE}               {return token_fimSe;}
{PA_RE_DE}                  {return token_de;}
{PA_RE_LEIA}                {return token_leia;}
{PA_RE_IMPRIMA}             {return token_imprima;}
{PA_RE_VERDADEIRO}          {return token_verdadeiro;}
{PA_RE_FALSO}               {return token_falso;}
{PA_RE_ENQUANTO}            {return token_enquanto;}
{PA_RE_FACA}                {return token_faca;}
{PA_RE_FIM_ENQUANTO}        {return token_fimEnquanto;}
{PA_RE_PARA}                {return token_para;}
{PA_RE_ATE}                 {return token_ate;}
{PA_RE_FIM_PARA}            {return token_fimPara;}
{PA_RE_FUNCAO}              {return token_funcao;}
{PA_RE_FIM_FUNCAO}          {return token_fimFuncao;}
{PA_RE_RETORNE}             {return token_retorne;}
{PA_RE_PASSO}               {return token_passo;}
{PA_RE_AVALIE}              {return token_avalie;}
{PA_RE_FIM_AVALIE}          {return token_fimAvalie;}
{PA_RE_CASO}                {return token_caso;}
{PA_RE_PARE}                {return token_pare;}


{TIPO_REAL}                 {return token_tipoReal;}
{TIPO_INTEIRO}              {return token_tipoInteiro;}
{TIPO_CARACTERE}            {return token_tipoCaractere;}
{TIPO_LITERAL}              {return token_tipoLiteral;}
{TIPO_LOGICO}               {return token_tipoLogico;}
{TIPO_MATRIZ}               {return token_tipoMatriz;}


{OPERADOR_ATRIBUICAO}       {return token_operadorAtribuicao;}
{OPERADOR_POTENCIA}         {return token_operadorPotencia;}
{OPERADOR_SOMA_SOMA}        {return token_operadorSomaSoma;}
{OPERADOR_SUBTRAI_SUBTRAI}  {return token_operadorSubtraiSubtrai;}
{OPERADOR_PORCENTO}         {return token_operadorPorcento;}
{OPERADOR_MAIS}             {return token_operadorMais;}
{OPERADOR_MENOS}            {return token_operadorMenos;}
{OPERADOR_VEZES}            {return token_operadorVezes;}
{OPERADOR_DIVIDIR}          {return token_operadorDividir;}
{OPERADOR_MAIOR}            {return token_operadorMaior;}
{OEPRADOR_MAIOR_IGUAL}      {return token_operadorMaiorIgual;}
{OPERADOR_MENOR}            {return token_operadorMenor;}
{OPERADOR_MENOR_IGUAL}      {return token_operadorMenorIgual;}
{OPERADOR_IGUAL_IGUAL}      {return token_operadorIgualIgual;}
{OPERADOR_DIFERENTE}        {return token_operadorDiferente;}
{OPERADOR_E}                {return token_operadorE;}
{OPERADOR_OU}               {return token_operadorOu;}
{OPERADOR_NAO}              {return token_operadorNao;}

 
{SIMBOLO_PONTO_VIRGULA}     {return token_simboloPontoVirgula;}
{SIMBOLO_DOIS_PONTOS}       {return token_simboloDoisPontos;}
{SIMBOLO_VIRGULA}           {return token_simboloVirgula;}
{SIMBOLO_ABRE_PARENTESE}    {return token_simboloAbreParentese;}
{SIMBOLO_FECHA_PARENTESE}   {return token_simboloFechaParentese;}
{SIMBOLO_ABRE_COLCHETE}     {return token_simboloAbreColchete;}
{SIMBOLO_FECHA_COLCHETE}    {return token_simboloFechaColchete;}
{SIMBOLO_ESPECIAL}          {return token_simboloEspecial;}

 
{IDENTIFICADOR}             {strcpy(identificador, yytext);
                            return token_identificador;}


[ \t]                       ; /* sao ignorados */
[\n]                        line_num++;
.                           {}


<comment>([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/ { /*procura por qualquer coisa que termine com final de comentario */
                                                    int i = 0, count = 0;
                                                    for (i=0, count=0; i < strlen(yytext); i++)
                                                        count += (yytext[i] == '\n');
                                                    line_num += count;
                                                    BEGIN(comment_caller);
                                                }
<comment>.                                      { /*se nao encontrar o final do comentario, volta ao inicio avaliando normalmente */
                                                    return;
                                                }
%%
