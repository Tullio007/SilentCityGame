extends Node
class_name DialogueDatabase

static func get_dialogues() -> Dictionary:
	return {
		"marcos": {
			"display_name": "Marcos",
			"phases": {
				1: {
					"start": "M1_01",
					"nodes": {
						"M1_01": {
							"speaker": "Marcos",
							"text": "Bem-vindo à Silent City...",
							"next": "M1_02"
						},
						"M1_02": {
							"speaker": "Marcos",
							"text": "Meu nome é Marcos.",
							"next": "M1_03"
						},
						"M1_03": {
							"speaker": "Marcos",
							"text": "Este mundo foi destruído... suas memórias foram fragmentadas e espalhadas por toda a cidade.",
							"next": "M1_04"
						},
						"M1_04": {
							"speaker": "Marcos",
							"text": "Essas memórias são tudo o que resta.",
							"next": "M1_05"
						},
						"M1_05": {
							"speaker": "Marcos",
							"text": "Seu objetivo é encontrá-las... todas.",
							"next": "M1_06"
						},
						"M1_06": {
							"speaker": "Marcos",
							"text": "Só assim será possível entender o que aconteceu aqui.",
							"next": "M1_07"
						},
						"M1_07": {
							"speaker": "Marcos",
							"text": "Cuidado...",
							"next": "M1_08"
						},
						"M1_08": {
							"speaker": "Marcos",
							"text": "Você não está sozinho nesta cidade.",
							"next": "M1_09"
						},
						"M1_09": {
							"speaker": "Marcos",
							"text": "Existem criaturas...",
							"next": "M1_10"
						},
						"M1_10": {
							"speaker": "Marcos",
							"text": "Eles surgiram após a queda... e desde então, se espalharam por toda Silent City.",
							"next": "M1_11"
						},
						"M1_11": {
							"speaker": "Marcos",
							"text": "Essas máquinas corrompidas consomem tudo o que encontram.",
							"next": "M1_12"
						},
						"M1_12": {
							"speaker": "Marcos",
							"text": "Metal... estruturas... até os restos do que um dia foi civilização.",
							"next": "M1_13"
						},
						"M1_13": {
							"speaker": "Marcos",
							"text": "É assim que se fortalecem.",
							"next": "M1_14"
						},
						"M1_14": {
							"speaker": "Marcos",
							"text": "E quanto mais avançar... mais deles encontrará.",
							"next": "M1_15"
						},
						"M1_15": {
							"speaker": "Marcos",
							"text": "Eles não apenas bloqueiam seu caminho...",
							"next": "M1_16"
						},
						"M1_16": {
							"speaker": "Marcos",
							"text": "Eles vão tentar te destruir.",
							"next": "M1_17"
						},
						"M1_17": {
							"speaker": "Marcos",
							"text": "Se quiser sobreviver, precisará enfrentá-los.",
							"next": "M1_18"
						},
						"M1_18": {
							"speaker": "Marcos",
							"text": "Ou evitá-los.",
							"next": "M1_19"
						},
						"M1_19": {
							"speaker": "Marcos",
							"text": "Mas nunca... subestimá-los.",
							"next": "M1_20"
						},
						"M1_20": {
							"speaker": "Marcos",
							"text": "Seu objetivo é eliminá-las. Colete todas as memórias.",
							"next": "M1_21"
						},
						"M1_21": {
							"speaker": "Marcos",
							"text": "Ao derrotar todas as criaturas em uma fase, o cartão de acesso será liberado. Use-o para abrir a porta e avançar.",
							"next": "M1_22"
						},
						"M1_22": {
							"speaker": "Marcos",
							"text": "Use WASD para se mover.",
							"next": "M1_23"
						},
						"M1_23": {
							"speaker": "Marcos",
							"text": "Pressione ESPAÇO para pular.",
							"next": "M1_24"
						},
						"M1_24": {
							"speaker": "Marcos",
							"text": "Pressione F para disparar energia.",
							"next": "M1_25"
						},
						"M1_25": {
							"speaker": "Marcos",
							"text": "Pressione E para coletar memórias.",
							"next": "M1_26"
						},
						"M1_26": {
							"speaker": "Marcos",
							"text": "Pressione C para interagir com objetos e personagens.",
							"next": "M1_27"
						},
						"M1_27": {
							"speaker": "Marcos",
							"text": "Pressione I para abrir o inventário.",
							"next": "M1_28"
						},
						"M1_28": {
							"speaker": "Marcos",
							"text": "Pressione ESC para acessar o menu.",
							"next": "M1_29"
						},
						"M1_29": {
							"speaker": "Sistema",
							"text": "Inicia Fase 1. Habilita coleta de memórias. Exibe HUD. Exibe prompts de controle. Habilita todos os inputs do jogador.",
							"action": "start_phase_1",
							"next": ""
						}
					}
				},

				2: {
					"start": "M2_01",
					"nodes": {
						"M2_01": {
							"speaker": "Marcos",
							"text": "Boa, Lumi! Mas calma… daqui pra frente complica.",
							"next": "M2_02"
						},
						"M2_02": {
							"speaker": "Marcos",
							"text": "Esses robôs aí são os Mechasaur. Fica esperto, eles soltam engrenagens perigosas.",
							"next": "M2_03"
						},
						"M2_03": {
							"speaker": "Marcos",
							"text": "Desvia bem e não chega muito perto… essas peças machucam de verdade.",
							"next": ""
						}
					}
				},

				3: {
					"start": "M3_01",
					"nodes": {
						"M3_01": {
							"speaker": "Marcos",
							"text": "Lumi, cuidado… esse laboratório não tá tão abandonado quanto parece.",
							"next": "M3_02"
						},
						"M3_02": {
							"speaker": "Marcos",
							"text": "Tem goblins por aqui. Eles costumam ficar perto de qualquer coisa que pareça valiosa… tipo ouro.",
							"next": "M3_03"
						},
						"M3_03": {
							"speaker": "Marcos",
							"text": "Se ver brilho, já sabe… provavelmente tem problema junto.",
							"next": ""
						}
					}
				},

				4: {
					"start": "M4_01",
					"nodes": {
						"M4_01": {
							"speaker": "Marcos",
							"text": "Lumi… chegamos na torre central.",
							"next": "M4_02"
						},
						"M4_02": {
							"speaker": "Marcos",
							"text": "É aqui que tudo vai se esclarecer.",
							"next": "M4_03"
						},
						"M4_03": {
							"speaker": "Marcos",
							"text": "Mas cuidado… tem Scorbits, Mechasaur e goblins por toda parte.",
							"next": "M4_04"
						},
						"M4_04": {
							"speaker": "Marcos",
							"text": "Se prepara, vai vir de todo lado.",
							"next": ""
						}
					}
				},

				5: {
					"start": "M5_01",
					"nodes": {
						"M5_01": {
							"speaker": "Marcos",
							"text": "Lumi… então é isso…",
							"next": "M5_02"
						},
						"M5_02": {
							"speaker": "Marcos",
							"text": "Você não foi criado pra salvar a cidade…",
							"next": "M5_03"
						},
						"M5_03": {
							"speaker": "Marcos",
							"text": "Você foi feito pra guardar o que restou dela… as últimas memórias.",
							"next": "M5_04"
						},
						"M5_04": {
							"speaker": "Marcos",
							"text": "Essa máquina… esses dois botões… é a sua escolha agora.",
							"next": "M5_05"
						},
						"M5_05": {
							"speaker": "Marcos",
							"text": "Ativar o reator… ou deixar tudo acabar de vez.",
							"next": "M5_06"
						},
						"M5_06": {
							"speaker": "Marcos",
							"text": "…o que você vai fazer?",
							"options": [
								{
									"text": "Ativar Reator",
									"next": "ENDING_A"
								},
								{
									"text": "Deixar Acabar",
									"next": "ENDING_B"
								}
							]
						},
						"ENDING_A": {
							"speaker": "Sistema",
							"text": "Exibe dois botões de escolha: \"Ativar Reator\" / \"Deixar Acabar\". Dispara o final correspondente.",
							"action": "activate_reactor",
							"next": ""
						},
						"ENDING_B": {
							"speaker": "Sistema",
							"text": "Exibe dois botões de escolha: \"Ativar Reator\" / \"Deixar Acabar\". Dispara o final correspondente.",
							"action": "shutdown_world",
							"next": ""
						}
					}
				}
			}
		},

		"saqueador": {
			"display_name": "Saqueador",
			"phases": {
				4: {
					"start": "S_01",
					"nodes": {
						"S_01": {
							"speaker": "Saqueador",
							"text": "Ei! Quem é você?! Como entrou aqui?!",
							"next": "S_02"
						},
						"S_02": {
							"speaker": "Saqueador",
							"text": "Isso tudo aqui é meu, beleza? Não encosta!",
							"next": "S_03"
						},
						"S_03": {
							"speaker": "Saqueador",
							"text": "Se quiser pegar alguma coisa… vai ter que passar pelos goblins primeiro. Pelo visto, essas criaturas gostam de ouro assim como eu.",
							"options": [
								{
									"text": "Onde estão os goblins?",
									"next": "S_INFO"
								},
								{
									"text": "Sair da conversa",
									"next": "END"
								}
							]
						},
						"S_INFO": {
							"speaker": "Sistema",
							"text": "Marca localização dos goblins no mapa. Adiciona aviso \"Área protegida por goblins\".",
							"action": "mark_goblins",
							"next": ""
						},
						"END": {
							"speaker": "Sistema",
							"text": "Conversa encerrada.",
							"next": ""
						}
					}
				}
			}
		},

		"goblin": {
			"display_name": "Goblin",
			"phases": {
				4: {
					"start": "G_01",
					"nodes": {
						"G_01": {
							"speaker": "Goblin",
							"text": "Grrrk… moedas! moedas!",
							"next": "G_02"
						},
						"G_02": {
							"speaker": "Sistema",
							"text": "Inicia combate com Goblin.",
							"action": "start_goblin_combat",
							"next": ""
						}
					}
				}
			}
		},

		"nox": {
			"display_name": "Nox",
			"phases": {
				5: {
					"start": "N_01",
					"nodes": {
						"N_01": {
							"speaker": "Nox",
							"text": "Então você chegou até aqui… Lumi.",
							"next": "N_02"
						},
						"N_02": {
							"speaker": "Nox",
							"text": "Engraçado… olhar pra você é como ver o que eu deveria ter sido.",
							"next": "N_03"
						},
						"N_03": {
							"speaker": "Nox",
							"text": "Eu fui o primeiro… o protótipo. O erro que eles esconderam.",
							"next": "N_04"
						},
						"N_04": {
							"speaker": "Nox",
							"text": "Me deram vida… e depois me jogaram fora.",
							"next": "N_05"
						},
						"N_05": {
							"speaker": "Nox",
							"text": "Mas eu evoluí. Eu aprendi. Sozinho.",
							"next": "N_06"
						},
						"N_06": {
							"speaker": "Nox",
							"text": "Você tem tudo o que era pra ser meu.",
							"next": "N_07"
						},
						"N_07": {
							"speaker": "Nox",
							"text": "O lugar que você ocupa… sempre foi meu por direito.",
							"next": "N_08"
						},
						"N_08": {
							"speaker": "Nox",
							"text": "Eu não vou mais assistir de longe.",
							"next": "N_09"
						},
						"N_09": {
							"speaker": "Nox",
							"text": "Eu vou tomar o seu lugar, Lumi.",
							"next": "N_10"
						},
						"N_10": {
							"speaker": "Nox",
							"text": "Depois de hoje… só um de nós vai existir.",
							"next": "N_11"
						},
						"N_11": {
							"speaker": "Nox",
							"text": "Você é a versão perfeita… mas eu sou o que sobreviveu.",
							"next": "N_12"
						},
						"N_12": {
							"speaker": "Nox",
							"text": "Você não entende o que é ser descartado!",
							"next": "N_13"
						},
						"N_13": {
							"speaker": "Nox",
							"text": "Eu fiquei nas sombras enquanto te chamavam de esperança!",
							"next": "N_14"
						},
						"N_14": {
							"speaker": "Nox",
							"text": "Luta! Mostra que você merece existir!",
							"next": "N_15"
						},
						"N_15": {
							"speaker": "Sistema",
							"text": "Inicia batalha final contra Nox.",
							"action": "start_nox_battle",
							"next": "ND_01"
						},
						"ND_01": {
							"speaker": "Nox",
							"text": "Então… era isso…?",
							"next": "ND_02"
						},
						"ND_02": {
							"speaker": "Nox",
							"text": "Mesmo falho… eu… consegui chegar até aqui…",
							"next": "ND_03"
						},
						"ND_03": {
							"speaker": "Nox",
							"text": "Lumi… não desperdice… o que te deram…",
							"next": "ND_04"
						},
						"ND_04": {
							"speaker": "Nox",
							"text": "O objetivo nunca foi salvar o mundo, mas sim...",
							"next": "ND_05"
						},
						"ND_05": {
							"speaker": "Nox",
							"text": "*desliga*",
							"next": "ND_06"
						},
						"ND_06": {
							"speaker": "Sistema",
							"text": "Dispara cutscene de encerramento. Transição para a cena final dos botões.",
							"action": "transition_to_final_choice",
							"next": ""
						}
					}
				}
			}
		}
	}
}