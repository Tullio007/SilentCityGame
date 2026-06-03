extends StaticBody2D

@export var required_item_id: String = "chave"

var _player_perto := false
var _aberta := false

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var area: Area2D = $Area2D
@onready var aviso: Label = $Aviso


func _ready() -> void:
	area.body_entered.connect(_on_area_body_entered)
	area.body_exited.connect(_on_area_body_exited)
	aviso.visible = false


func _process(_delta: float) -> void:
	if _player_perto and not _aberta and Input.is_action_just_pressed("interagir"):
		_tentar_abrir()


func _on_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_perto = true


func _on_area_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_perto = false
		aviso.visible = false


func _tentar_abrir() -> void:
	var item: InventoryItem = Inventory.get_item_by_id(required_item_id)
	if item != null:
		Inventory.remove_item(item)
		_abrir()
	else:
		aviso.text = "Está trancada. Falta uma chave."
		aviso.visible = true


func _abrir() -> void:
	_aberta = true
	aviso.visible = false
	collision.set_deferred("disabled", true)
	_animar_abertura()


func _animar_abertura() -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 130.0, 0.45) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, 0.45) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(func(): visible = false)
