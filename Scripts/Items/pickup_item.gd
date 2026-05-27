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
		queue_free()
	else:
		print("Inventário cheio")