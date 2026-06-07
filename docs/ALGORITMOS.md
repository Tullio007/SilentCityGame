# Documentação de Algoritmos — Silent City

Este documento justifica as escolhas algorítmicas feitas no projeto **Silent City**, detalhando complexidade, trade-offs e onde cada algoritmo aparece no código.

---

## 1. Problema Computacional Principal: TSP (Caixeiro-Viajante)

### Contexto no jogo

Os mobs (inimigos) de Silent City patrulham um conjunto de **waypoints** espalhados pela fase. O desafio é determinar a ordem de visitação desses pontos que **minimize a distância total percorrida** — tornando a patrulha mais eficiente e realista.

Esse problema é formalmente equivalente ao **Problema do Caixeiro-Viajante (TSP — Travelling Salesman Problem)**:

> Dado um conjunto de `n` pontos e as distâncias entre eles, encontre o ciclo hamiltoniano de custo mínimo.

O TSP é **NP-difícil**: não existe algoritmo polinomial conhecido que resolva todas as instâncias de forma exata. Por isso, foram implementadas duas abordagens dependendo do tamanho da instância.

---

## 2. Algoritmo Exato: Held-Karp

**Arquivo:** `Scripts/tsp_exact.gd`  
**Aplicado quando:** número de waypoints ≤ 12

### Descrição

Held-Karp é um algoritmo de **programação dinâmica** que resolve o TSP de forma exata com complexidade:

| Complexidade | Valor |
|---|---|
| Tempo | O(2ⁿ · n²) |
| Espaço | O(2ⁿ · n) |

A ideia central é usar uma **tabela de memoização** onde o estado é representado por `(conjunto de cidades visitadas, última cidade)`. Isso evita recomputar subproblemas já resolvidos.

### Por que Held-Karp?

- Para mapas pequenos (≤ 12 waypoints), `2¹² · 144 ≈ 590.000` operações — **executável em tempo real** sem impacto perceptível no desempenho.
- Garante a **rota ótima**, tornando a patrulha dos mobs determinística e justa para o jogador.
- A implementação com bitmask é compacta e adequada ao GDScript.

### Pseudocódigo resumido

```
dp[S][i] = custo mínimo de visitar exatamente os nós em S, terminando em i
dp[{0}][0] = 0
Para cada subconjunto S com i em S:
    Para cada j não em S:
        dp[S | {j}][j] = min(dp[S][i] + dist[i][j])
Resposta = min(dp[full][i] + dist[i][0]) para todo i
```

---

## 3. Heurística: Vizinho Mais Próximo + 2-opt

**Arquivo:** `Scripts/tsp_heuristic.gd`  
**Aplicado quando:** número de waypoints > 12

### Por que heurística?

Para instâncias maiores, o Held-Karp torna-se impraticável: com 20 waypoints, são ~20 bilhões de estados. Uma heurística é necessária para manter o jogo responsivo.

### Fase 1 — Vizinho Mais Próximo (Greedy)

| Complexidade | Valor |
|---|---|
| Tempo | O(n²) |
| Espaço | O(n) |

Constrói uma rota gulosa: a partir do nó inicial, sempre vai para o waypoint **não visitado mais próximo**. Produz uma solução razoável como ponto de partida.

**Qualidade esperada:** em média, ~20–25% acima do ótimo.

### Fase 2 — 2-opt (Melhoria Local)

| Complexidade | Valor |
|---|---|
| Tempo | O(n² · iterações) |
| Espaço | O(n) |

Percorre a rota atual procurando pares de arestas `(i, k)` que, se **invertidos**, reduzem o custo total. Repete até nenhuma melhoria ser encontrada.

**Qualidade esperada após 2-opt:** tipicamente dentro de 5–10% do ótimo.

### Combinação das duas fases

```
rota ← vizinho_mais_proximo(waypoints)
repetir:
    melhorou ← falso
    para i de 0 até n-2:
        para k de i+2 até n:
            se inverter aresta (i, k) reduz custo:
                inverter segmento rota[i+1..k]
                melhorou ← verdadeiro
até não melhorou
```

### Justificativa da escolha

A combinação **Vizinho Mais Próximo + 2-opt** é um padrão consagrado na literatura de otimização combinatória por oferecer:
- Implementação simples (adequada ao escopo acadêmico)
- Boa qualidade de solução para instâncias de jogo (poucos waypoints reais)
- Execução rápida o suficiente para rodar no início de cada fase sem travar

---

## 4. Algoritmo de Ordenação do Inventário: Merge Sort

**Arquivo:** `Scripts/inventory.gd`  
**Aplicado em:** listagem de memórias coletadas pelo jogador

### Contexto no jogo

Lumi coleta **memórias** espalhadas pela fase. O inventário exibe essas memórias ordenadas por critério composto:
1. **Tipo** (memória de habitante, de sistema, de evento histórico)
2. **Ordem de coleta** (como desempate)

### Por que Merge Sort?

| Critério | Merge Sort | Quick Sort | Insertion Sort |
|---|---|---|---|
| Tempo (pior caso) | O(n log n) | O(n²) | O(n²) |
| Tempo (médio) | O(n log n) | O(n log n) | O(n²) |
| Espaço | O(n) | O(log n) | O(1) |
| Estável | ✅ Sim | ❌ Não | ✅ Sim |
| Adequado para n pequeno | Sim | Sim | Sim |

A **estabilidade** é o fator decisivo: com ordenação por critério composto (tipo + ordem de coleta), precisamos garantir que itens com o mesmo tipo **mantenham a ordem original de coleta**. Merge Sort garante isso por definição; Quick Sort não garante sem adaptação.

Além disso, o inventário de um jogo narrativo curto raramente ultrapassa ~30 itens, então o overhead de espaço O(n) do Merge Sort é completamente irrelevante.

### Comparação com alternativas descartadas

- **Insertion Sort:** seria aceitável para n pequeno (O(n) no melhor caso), mas O(n²) no pior — não escala se o escopo crescer.
- **Quick Sort:** não é estável nativamente e o pior caso O(n²) ocorre em listas quase ordenadas (que é exatamente o caso de um inventário onde o jogador coleta itens em sequência).
- **Godot `Array.sort_custom()`:** internamente usa Timsort (híbrido Merge Sort + Insertion Sort) — similar à nossa escolha, mas implementamos explicitamente para fins acadêmicos.

---

## 5. Resumo das Complexidades

| Algoritmo | Onde | Tempo | Espaço | Estável |
|---|---|---|---|---|
| Held-Karp (TSP exato) | `tsp_exact.gd` | O(2ⁿ · n²) | O(2ⁿ · n) | — |
| Vizinho mais próximo | `tsp_heuristic.gd` | O(n²) | O(n) | — |
| 2-opt | `tsp_heuristic.gd` | O(n² · iter) | O(n) | — |
| Merge Sort (inventário) | `inventory.gd` | O(n log n) | O(n) | ✅ |

---

## 6. Referências

- Held, M.; Karp, R. M. (1962). *A Dynamic Programming Approach to Sequencing Problems*. Journal of the Society for Industrial and Applied Mathematics.
- Lin, S.; Kernighan, B. W. (1973). *An Effective Heuristic Algorithm for the Traveling-Salesman Problem*. Operations Research.
- Cormen, T. H. et al. (2009). *Introduction to Algorithms*, 3rd ed. MIT Press. (Cap. 2 — Merge Sort; Cap. 15 — Programação Dinâmica)
