# Silent City 🤖

> Plataforma 2D narrativa em Pixel Art — projeto acadêmico

**Silent City** é um jogo 2D de plataforma com foco em narrativa, onde o jogador controla **Lumi**, um robô que explora uma cidade abandonada após uma falha tecnológica global, coletando memórias da humanidade e decidindo o destino final do mundo.

---

## Como Rodar

### Pré-requisitos

- [Godot 4.6](https://godotengine.org/download) instalado na máquina

### Passos

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/silent-city.git
   cd silent-city
   ```
2. Abra o **Godot 4.6** e clique em **"Import"**.
3. Navegue até a pasta do projeto e selecione o arquivo `project.godot`.
4. Com o projeto aberto, a cena principal já está configurada em:
   ```
   Scenes/node_2d.tscn
   ```
5. Pressione **F5** (ou clique no botão ▶) para executar o jogo.

> **Nota:** a cena `Scenes/node_2d.tscn` está definida como `run/main_scene` no `project.godot` — nenhuma configuração adicional é necessária.

---

## Gênero

| Campo | Descrição |
|---|---|
| Gênero principal | Plataforma 2D |
| Subgênero | Aventura narrativa |
| Estilo visual | Pixel Art |
| Duração estimada | 1–2 horas |
| Plataforma | PC |

---

## História (resumo)

No futuro, o mundo ficou silencioso após uma falha tecnológica global. Lumi é um pequeno robô criado para manter a última cidade funcionando — mas a cidade está desligando lentamente. Durante a exploração, Lumi coleta memórias gravadas dos habitantes e, ao final, descobre que foi criado não para salvar a cidade, mas para guardar as últimas lembranças da humanidade.

**O jogador decide:** ativar ou não o último reator.

---

## Escopo da Entrega Atual

A entrega atual implementa **uma fase jogável** com início, meio e fim:

| Parte | Descrição |
|---|---|
| Início | Lumi começa na borda da cidade abandonada |
| Meio | 3 mobs hostis que causam dano ao encostar no player |
| Fim | Coletar chave → abrir porta trancada → tela de "Fim" |

As 5 fases completas e o confronto com o vilão **R-01** estão fora do escopo desta entrega.

---

## Algoritmos Implementados

### 1. TSP — Rota Ótima dos Mobs (`Scripts/mob_patrol.gd`)

Os mobs patrulham um conjunto de pontos de waypoint. O problema de encontrar a rota de patrulha mais eficiente é modelado como o **Problema do Caixeiro-Viajante (TSP)**.

Duas abordagens foram implementadas:

| Algoritmo | Arquivo | Uso |
|---|---|---|
| Held-Karp (TSP exato) | `Scripts/tsp_exact.gd` | Mapas pequenos (≤ 12 waypoints) |
| Vizinho mais próximo + 2-opt (heurística) | `Scripts/tsp_heuristic.gd` | Mapas maiores (> 12 waypoints) |

### 2. Ordenação do Inventário (`Scripts/inventory.gd`)

O inventário de memórias coletadas é ordenado por tipo e ordem de coleta usando **Merge Sort**.

| Algoritmo | Arquivo | Complexidade |
|---|---|---|
| Merge Sort | `Scripts/inventory.gd` | O(n log n) tempo / O(n) espaço |

Documentação detalhada das justificativas algorítmicas: [`docs/ALGORITMOS.md`](docs/ALGORITMOS.md)

---

## Mapeamento de Requisitos da Atividade

| Requisito da Atividade | Implementação | Arquivo / Issue |
|---|---|---|
| Problema computacional (NP-difícil ou equivalente) | TSP para rotas de patrulha dos mobs | `Scripts/tsp_exact.gd`, `Scripts/tsp_heuristic.gd` |
| Algoritmo exato | Held-Karp (programação dinâmica) | `Scripts/tsp_exact.gd` |
| Heurística / aproximação | Vizinho mais próximo + 2-opt | `Scripts/tsp_heuristic.gd` |
| Algoritmo de ordenação com justificativa | Merge Sort no inventário | `Scripts/inventory.gd` |
| README com instruções de execução | Este arquivo | `README.md` |
| Documentação curta de algoritmos | Justificativa de escolhas e complexidades | `docs/ALGORITMOS.md` |
| Repositório GitHub com histórico | Commits organizados por feature | Issues e PRs no repositório |
| Jogo jogável (início, meio, fim) | Fase única completa | `Scenes/node_2d.tscn` |

---

## Estrutura do Projeto

```
silent-city/
├── project.godot
├── README.md
├── docs/
│   └── ALGORITMOS.md
├── Scenes/
│   └── node_2d.tscn        ← cena principal
├── Scripts/
│   ├── player.gd
│   ├── mob_patrol.gd
│   ├── tsp_exact.gd        ← Held-Karp
│   ├── tsp_heuristic.gd    ← vizinho mais próximo + 2-opt
│   ├── inventory.gd        ← Merge Sort
│   ├── puzzle.gd
│   └── memory_item.gd
├── Assets/
│   ├── Sprites/
│   ├── Tilesets/
│   └── Audio/
└── UI/
    └── hud.tscn
```

---

## Equipe

| Papel | Responsabilidades |
|---|---|
| Programador 1 | Movimento, física, câmera, fases |
| Programador 2 | Puzzles, interação, memórias, algoritmos |
| Artista | Sprites, tilesets, animações |
| Designer | História, fases, diálogos |
| Testes / UI | Menu, bugs, sons |

---

## Tecnologias

- **Engine:** Godot 4.6
- **Linguagem:** GDScript
- **Versionamento:** GitHub
- **Arte:** Pixel Art
- **Áudio:** Efeitos simples (`.ogg` / `.wav`)
