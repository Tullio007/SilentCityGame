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
	if Inventory.has_item(required_item_id):
		for item in Inventory.items:
			if item.id == required_item_id:
				Inventory.remove_item(item)
				break
		_abrir()
	else:
		aviso.text = "Está trancada. Falta uma chave."
		aviso.visible = true


func _abrir() -> void:
	_aberta = true
	aviso.visible = false
	collision.set_deferred("disabled", true)
	visible = false
