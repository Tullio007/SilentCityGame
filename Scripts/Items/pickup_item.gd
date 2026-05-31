extends Area2D

@export var item_data: InventoryItem

var player_near := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interagir"):
		collect()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_near = true


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_near = false


func collect() -> void:
	if item_data == null:
		push_warning("Item sem dados!")
		return

	if Inventory.add_item(item_data):
		_animar_coleta()
	else:
		print("Inventário cheio")


func _animar_coleta() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	player_near = false
	set_process(false)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.8, 1.8), 0.18) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", position.y - 24.0, 0.24) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.24)
	tween.chain().tween_callback(queue_free)