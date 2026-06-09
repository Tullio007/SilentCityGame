# Documentação dos Algoritmos

Este documento justifica a escolha dos algoritmos implementados, descreve suas características e aponta os arquivos e funções correspondentes na base de código.

---

## 1. Merge Sort — Ordenação do Inventário

**Arquivo:** `Scripts/Inventory/inventory.gd`
**Funções:** `get_sorted_items()`, `_merge_sort()`, `_merge()`, `_compare_items()`, `_type_rank()`

### Motivação

O inventário do jogador acumula itens de tipos distintos ao longo da partida. Exibir esses itens em ordem consistente — memórias primeiro, depois itens comuns, ambos em ordem alfabética — melhora a legibilidade da UI.

O Merge Sort foi escolhido por duas propriedades que importam para este caso de uso:

- **Complexidade O(n log n) garantida** em todos os casos, ao contrário do Quick Sort, cujo pior caso é O(n²).
- **Estabilidade:** quando dois itens possuem o mesmo tipo e o mesmo nome, a ordem relativa de coleta é preservada. Isso evita que a lista "salte" visualmente a cada atualização do inventário.

### Critério de ordenação

O comparador `_compare_items()` aplica dois critérios em cascata:

1. **Tipo** — memórias (`ItemType.MEMORY`, rank 0) aparecem antes de itens comuns (`ItemType.COMMON`, rank 1). A precedência é definida pela função `_type_rank()`.
2. **Nome** — dentro do mesmo tipo, os itens são ordenados alfabeticamente pelo campo `display_name` (case-insensitive).

Em empate nos dois critérios, a estabilidade do Merge Sort preserva a ordem de coleta.

> A documentação anterior mencionava ordenação por "peso" ou "raridade". Esses campos **não existem** na implementação. O critério real é `ItemType` → `display_name`, conforme o código acima.

### Como funciona

O método público `get_sorted_items()` retorna uma **nova lista ordenada** sem alterar o inventário interno (que usa um `Dictionary` com acesso O(1) por `id`).

A divisão e mesclagem recursivas:

```
_merge_sort(arr):
    se arr.size() <= 1: retorna arr
    mid = arr.size() / 2
    esquerda = _merge_sort(arr[0..mid])
    direita  = _merge_sort(arr[mid..fim])
    retorna _merge(esquerda, direita)

_merge(esq, dir):
    resultado = []
    enquanto esq e dir não vazios:
        se _compare_items(esq[0], dir[0]) <= 0:   # <= garante estabilidade
            resultado.append(esq.pop_front())
        senão:
            resultado.append(dir.pop_front())
    retorna resultado + esq + dir
```

A condição `<= 0` na mesclagem é o que garante a estabilidade: em empate, o elemento da metade esquerda (coletado antes) é inserido primeiro.

### Complexidade

| Caso   | Tempo      | Espaço |
|--------|------------|--------|
| Melhor | O(n log n) | O(n)   |
| Médio  | O(n log n) | O(n)   |
| Pior   | O(n log n) | O(n)   |

---

## 2. TSP (Travelling Salesman Problem) — Rota entre Pontos de Interesse

**Arquivo:** `Scripts/algorithms/TSP.gd`
**Função pública:** `TSP.solve(points: Array[Vector2]) -> Dictionary`

### Motivação

O Problema do Caixeiro-Viajante encontra a rota mais curta que visita um conjunto de pontos e retorna à origem. No contexto do jogo, modela a necessidade de percorrer locais do mapa com o menor deslocamento total possível.

### Abordagem implementada

A função `solve()` escolhe automaticamente o algoritmo conforme o tamanho da entrada:

#### Para ≤ 12 pontos — Held-Karp (solução exata)

Implementado em `_held_karp()`. Usa **programação dinâmica com bitmask**: o estado `dp[[mask, j]]` armazena o custo mínimo para visitar exatamente os nós representados por `mask`, terminando no nó `j`. A solução ótima é reconstituída via `parent`.

- Complexidade: **O(2ⁿ · n²)** em tempo, O(2ⁿ · n) em espaço.
- Garante a rota ótima.
- Muito mais eficiente que força-bruta O(n!) para até 12 nós.

#### Para > 12 pontos — Nearest Neighbor + 2-opt (heurística)

Implementado em `_heuristic()`, que combina:

1. **`_nearest_neighbor()`**: a partir do nó 0, sempre visita o nó não visitado mais próximo. Gera uma rota inicial razoável em O(n²).
2. **`_two_opt()`**: melhora iterativamente a rota trocando pares de arestas enquanto houver ganho. Reduz cruzamentos desnecessários.

- Complexidade: O(n²) para nearest neighbor + O(n²) por iteração do 2-opt.
- Não garante o ótimo, mas produz soluções de boa qualidade para conjuntos grandes de pontos.

### Interface

```gdscript
# Retorna: { "route": Array[int], "cost": float }
# "route" contém os índices dos pontos na ordem de visita.
var result = TSP.solve(points)
```

### Complexidade resumida

| Abordagem               | Ativada quando | Tempo       | Garante ótimo? |
|-------------------------|----------------|-------------|----------------|
| Held-Karp (exato)       | ≤ 12 pontos    | O(2ⁿ · n²)  | Sim            |
| Nearest Neighbor + 2opt | > 12 pontos    | O(n²)       | Não            |

### Estado de integração

O módulo TSP está **implementado e testado** (PR [#42](https://github.com/Tullio007/SilentCityGame/pull/42)).

A integração ao gameplay — um puzzle de rota em tela separada onde o jogador conecta pontos com o mouse — está planejada e rastreada na issue [**#39 [GAMEPLAY] TSP: puzzle de rota em tela separada**](https://github.com/Tullio007/SilentCityGame/issues/39). Essa integração **ainda não foi concluída**.

O TSP **não controla a patrulha de mobs** na versão atual. Afirmações anteriores nesse sentido eram incorretas.

---

## Resumo

| Algoritmo  | Arquivo                          | Integrado? | Observação                                          |
|------------|----------------------------------|------------|-----------------------------------------------------|
| Merge Sort | `Scripts/Inventory/inventory.gd` | ✅ Sim      | MEMORY → COMMON → alfabético; estável               |
| TSP        | `Scripts/algorithms/TSP.gd`      | ⏳ Parcial  | Held-Karp (≤12) + NN+2opt (>12); integração em #39 |
