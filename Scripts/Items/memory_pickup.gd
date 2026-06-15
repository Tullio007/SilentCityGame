extends Area2D

@export var memory_data: MemoryItem

var _player_perto := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	scale = Vector2.ZERO
	var t := create_tween()
	t.tween_property(self, "scale", Vector2.ONE, 0.25) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _process(_delta: float) -> void:
	if _player_perto and Input.is_action_just_pressed("interagir"):
		collect()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_perto = true


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_perto = false


func collect() -> void:
	if memory_data == null:
		return
	if GameState.get_flag("mem_" + memory_data.id):
		return

	GameState.set_flag("mem_" + memory_data.id, true)
	Inventory.add_item(memory_data)

	if not memory_data.audio_path.is_empty():
		AudioManager.play_sfx_path(memory_data.audio_path)
	else:
		AudioManager.play_item_pickup()

	DialogueUI.show_memory(memory_data.display_name, memory_data.texto)
	queue_free()
