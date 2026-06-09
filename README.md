# Silent City Game

Jogo de exploração top-down em cidade abandonada desenvolvido em **Godot 4.x** como projeto acadêmico. O jogador navega por ambientes urbanos decadentes, coleta itens, interage com NPCs e diálogos.

## Como rodar

1. Instale o **Godot 4.6** (versão padrão, sem .NET/Mono).
2. Clone o repositório:
   ```
   git clone https://github.com/Tullio007/SilentCityGame.git
   ```
3. Abra o Godot, clique em **Import** e aponte para a pasta do projeto.
4. Abra a cena principal: `Scenes/node_2d.tscn`.
5. Pressione **F5** (ou o botão ▶) para executar.

## Estrutura de pastas

```
SilentCityGame/
├── project.godot
├── Assets/
├── Scenes/
│   ├── UI/
│   ├── node_2d.tscn          ← cena principal
│   ├── enemy.tscn
│   ├── npc.tscn
│   ├── door.tscn
│   ├── pause_menu.tscn
│   └── tela_de_menu.tscn
├── Scripts/
│   ├── Inventory/
│   │   ├── inventory.gd      ← lógica de inventário + Merge Sort
│   │   ├── inventory_item.gd
│   │   ├── inventory_ui.gd
│   │   └── item_slot.gd
│   ├── Items/
│   ├── Audio/
│   ├── dialogue/
│   ├── enemy/
│   ├── global/
│   ├── menu inicial/
│   ├── npc/
│   ├── pause menu/
│   ├── player/
│   └── door.gd
├── docs/
│   └── ALGORITMOS.md
├── inventory_test.gd
├── menu_principal.gd
└── node_2d.gd
```

> **Nota:** `Scripts/algorithms/TSP.gd` existe na branch `main` (PR [#42](https://github.com/Tullio007/SilentCityGame/pull/42)). A integração ao gameplay está rastreada na issue [#39](https://github.com/Tullio007/SilentCityGame/issues/39).

## Algoritmos implementados

| Algoritmo  | Arquivo                          | Finalidade no jogo                    |
|------------|----------------------------------|---------------------------------------|
| Merge Sort | `Scripts/Inventory/inventory.gd` | Ordenação dos itens do inventário     |
| TSP        | `Scripts/algorithms/TSP.gd`      | Rota ótima entre pontos de interesse  |

Detalhes de cada implementação em [`docs/ALGORITMOS.md`](docs/ALGORITMOS.md).

## Estado de integração

- **Merge Sort** — integrado e funcional no inventário.
- **TSP** — módulo implementado e testado (PR [#42](https://github.com/Tullio007/SilentCityGame/pull/42)). A integração visual ao gameplay está planejada na issue [#39](https://github.com/Tullio007/SilentCityGame/issues/39). O TSP **não** controla a patrulha dos mobs na versão atual.

## Equipe

6 contribuidores — ver aba [Contributors](https://github.com/Tullio007/SilentCityGame/graphs/contributors).

## Licença

MIT — ver arquivo `LICENSE`.
