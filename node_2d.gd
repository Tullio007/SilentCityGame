extends Node2D

@onready var player: CharacterBody2D = $CharacterBody2D
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar
@onready var end_screen: CanvasLayer = $EndScreen
@onready var end_title: Label = $EndScreen/Panel/VBox/Titulo
@onready var restart_button: Button = $EndScreen/Panel/VBox/Reiniciar
@onready var win_zone: Area2D = $WinZone


func _ready() -> void:
	end_screen.visible = false
	health_bar.max_value = 100
	health_bar.value = player.vida
	player.vida_alterada.connect(_on_vida_alterada)
	player.morreu.connect(_on_player_morreu)
	win_zone.body_entered.connect(_on_win_zone_body_entered)
	restart_button.pressed.connect(_on_reiniciar)


func _on_vida_alterada(vida_atual: int, _vida_max: int) -> void:
	health_bar.value = vida_atual


func _on_player_morreu() -> void:
	_mostrar_fim("VOCÊ FALHOU")


func _on_win_zone_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_mostrar_fim("FIM")


func _mostrar_fim(texto: String) -> void:
	end_title.text = texto
	end_screen.visible = true
	get_tree().paused = true


func _on_reiniciar() -> void:
	get_tree().paused = false
	Inventory.clear()
	get_tree().reload_current_scene()
