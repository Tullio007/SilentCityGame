extends Node2D
class_name NPC

@export var npc_id: String = "marcos"
@export var phase: int = 1

var dialogue_manager := DialogueManager.new()

func _ready():
	dialogue_manager._ready()

func interact():
	print("Interagindo com NPC:", npc_id, "na fase:", phase)
	dialogue_manager.start_dialogue(npc_id, phase)