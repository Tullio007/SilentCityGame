extends Node2D
class_name NPC

@export var npc_id: String = "marcos"
@export var phase: int = 1

var dialogue_manager := DialogueManager.new()
var _player_perto := false

@onready var _hint: CanvasItem = get_node_or_null("Hint")
@onready var _area: Area2D = get_node_or_null("Area2D")


func _ready():
	dialogue_manager._ready()
	if _hint:
		_hint.visible = false
	if _area:
		_area.body_entered.connect(_on_body_entered)
		_area.body_exited.connect(_on_body_exited)


func _process(_delta):
	if _player_perto and Input.is_action_just_pressed("interagir"):
		interact()


func _on_body_entered(body):
	if body.is_in_group("player"):
		_player_perto = true
		if _hint:
			_hint.visible = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		_player_perto = false
		if _hint:
			_hint.visible = false


func interact():
	if _hint:
		_hint.visible = false
	DialogueUI.start(dialogue_manager, npc_id, phase)
