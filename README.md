# PRD — Silent City

## 1. Visão Geral

**Nome do jogo:** Silent City  
**Gênero:** Plataforma + Aventura narrativa  
**Estilo:** Pixel Art 2D  
**Duração estimada:** 1–2 horas  
**Plataforma:** PC  
**Engine recomendada:** Unity ou Godot  
**Tipo de projeto:** Acadêmico / equipe pequena

Silent City é um jogo 2D de plataforma com foco em narrativa, onde o jogador controla um robô que explora uma cidade abandonada após uma falha tecnológica global, coletando memórias da humanidade e decidindo o destino final do mundo.

---

## 2. Objetivo do Projeto

Criar um jogo curto com início, meio e fim que demonstre:

- Programação de gameplay
- Sistema de fases
- Narrativa interativa
- Organização com GitHub
- Trabalho em equipe

---

## 3. História

No futuro, o mundo ficou silencioso após uma falha tecnológica global.

O jogador controla **Lumi**, um pequeno robô criado para manter a última cidade funcionando.

A cidade está desligando lentamente.

Durante a exploração, Lumi encontra memórias gravadas das pessoas que viveram ali, mas para coletá-las terá que enfrentar mobs espalhados pelo mapa.

Cada fase revela o que aconteceu com a cidade e por que Lumi foi criado.

No final, Lumi descobre que não foi feito para salvar a cidade, mas para guardar as últimas lembranças da humanidade.

O jogador decide ativar ou não o último reator.

---

## 4. Vilão

Antes de Lumi, existiu um protótipo chamado **R-01**, um robô semelhante, mas com detalhes vermelhos e núcleo instável.

R-01 foi criado para proteger o sistema, mas interpretou sua missão de forma extrema.

Ele acredita que a humanidade causou o colapso e que a cidade não deve ser reiniciada.

Na última fase, R-01 impede o acesso ao reator, causando o confronto final contra Lumi.

---

## 5. Gameplay

Mecânicas principais:

- Andar
- Pular
- Interagir
- Coletar memórias
- Resolver puzzles simples

---

## 6. Estrutura do Jogo

O escopo foi reduzido para uma **fase única jogável**, com início, meio e fim:

- **Início:** Lumi começa na borda da cidade abandonada.
- **Meio:** o trajeto é guardado por **3 mobs hostis** que causam dano ao encostar no player.
- **Fim:** Lumi coleta uma **chave** e a usa para abrir a **porta trancada** (puzzle que reaproveita o inventário); ao atravessá-la, surge a tela de **"Fim"**.

A fase é a cena principal `Scenes/node_2d.tscn` (configurada como `run/main_scene`).

> As 5 fases originais (Cidade Abandonada → Núcleo Final) e o confronto com R-01 ficam **fora do escopo desta entrega**.

---

## 7. Sistemas do Jogo

| Sistema | Descrição | Dificuldade |
|--------|----------|------------|
| Player Controller | Andar e pular | Fácil |
| Câmera | Seguir jogador | Fácil |
| Interação | Tecla para ativar objetos | Fácil |
| Sistema de memória | Coletar e mostrar texto | Fácil |
| Sistema de puzzle | Botões e portas | Médio |
| Sistema de fases | Troca de cena | Médio |
| UI | Menu e textos | Fácil |
| Áudio | Música e efeitos | Fácil |

---

## 8. Divisão da Equipe

Programador 1  
- movimento  
- física  
- câmera  
- fases  

Programador 2  
- puzzles  
- interação  
- memórias  

Artista  
- sprites  
- tilesets  
- animações  

Designer  
- história  
- fases  
- diálogos  

Testes / UI  
- menu  
- bugs  
- sons  

---

## 9. Cronograma (2 meses)

### Mês 1

Semana 1  
- movimento do personagem  
- pulo  
- câmera  

Semana 2  
- interação  
- coletáveis  

Semana 3  
- fase 1  

Semana 4  
- UI básica  
- menu  

---

### Mês 2

Semana 5  
- fase 2  

Semana 6  
- puzzles  

Semana 7  
- fase 3 e fase final  

Semana 8  
- boss  
- sons  
- correção de bugs  
- build final  

---

## 10. Arte Necessária

Personagens:
- Lumi
- R-01
- mobs

Cenários:
- cidade
- laboratório
- torre

Objetos:
- portas
- plataformas
- terminais
- memórias

Total estimado: 20–30 sprites

---

## 11. Limitações

Para manter o projeto pequeno, não terá:

- multiplayer
- mundo aberto
- IA complexa
- inventário grande
- combate avançado
- habilidades especiais

---

## 12. Tecnologias

Engine: Unity ou Godot  
Versionamento: GitHub  
Arte: Pixel Art  
Áudio: efeitos simples

---
