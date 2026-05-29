extends Node
class_name DialogueManager

var dialogues = {}
var current_dialogue = {}
var current_node_id = ""

func _ready():
	dialogues = DialogueDatabase.get_dialogues()

func start_dialogue(npc_id: String, phase: int):
	if not dialogues.has(npc_id):
		print("NPC não encontrado")
		return

	if not dialogues[npc_id]["phases"].has(phase):
		print("Fase não encontrada")
		return

	current_dialogue = dialogues[npc_id]["phases"][phase]
	current_node_id = current_dialogue["start"]

	print("=== INICIO DIALOGO ===")
	show_node()

func show_node():
	if current_node_id == "":
		end_dialogue()
		return

	var node = current_dialogue["nodes"][current_node_id]

	print("")
	print("NPC:", node.get("speaker", ""))
	print("Fala:", node.get("text", ""))

	if node.has("action"):
		execute_action(node["action"])

	if node.has("options"):
		print("Escolhas:")
		for i in range(node["options"].size()):
			print(str(i) + " - " + node["options"][i]["text"])
	else:
		print("Digite next() para continuar")

func next():
	var node = current_dialogue["nodes"][current_node_id]

	if node.has("options"):
		print("Use choose(index)")
		return

	current_node_id = node.get("next", "")
	show_node()

func choose(index: int):
	var node = current_dialogue["nodes"][current_node_id]

	if not node.has("options"):
		print("Sem opções")
		return

	var options = node["options"]

	if index < 0 or index >= options.size():
		print("Opção inválida")
		return

	current_node_id = options[index]["next"]
	show_node()

func execute_action(action_name: String):
	print("Executando:", action_name)

	match action_name:
		"mark_goblins":
			GameState.set_flag("goblins_marked", true)
			print("Goblins marcados no mapa")

		"start_goblin_combat":
			print("Combate iniciado")

		"start_nox_battle":
			print("Batalha final")

		"activate_reactor":
			GameState.set_flag("final_choice", "activate")
			print("Final A")

		"shutdown_world":
			GameState.set_flag("final_choice", "shutdown")
			print("Final B")

		"transition_to_final_choice":
			print("Cena final")

		_:
			print("Ação desconhecida")

func end_dialogue():
	print("=== FIM DIALOGO ===")
	current_dialogue = {}
	current_node_id = ""