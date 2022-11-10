# analisesensibilidade

O presente projeto utiliza o framework Flutter na versão 1.22.5

## Integrantes

- Joyce Massau de Moraes Santos
- Matheus de Souza Mello
- Heron José Bueno de Oliveira Almeida

## Arquivo contendo a lógica do exercício

Diretório: lib / utils / colunas_tabela.dart

## Lógica do método _aumentarReduzir

Considerando a Análise de Sensibilidade um procedimento para compreender o que alterações nos valores influenciam em seu total, dada uma lista de números, contendo números considerados Infinity, conforme exemplo:

```
List<dynamic> s2 = [417, -208, Infinity];
```

O procedimento foi:

* Remover elementos Infinity;

```
_valoresParaSeremOrdenados[_chave].removeWhere((numero) => numero.isInfinite == true);
```

* Separar números restantes em duas listas, identificando positivos e negativos
* Verificar se lista a positiva / negativa contém elementos, não está vazia
    * Se houver, identificar o menor valor entre eles, o mais próximo de zero e este é o resultado da coluna Max / Min
    * Senão, sabe-se que esta lista conteria elementos Infinity sendo este o resultado da coluna Max / Min
