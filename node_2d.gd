extends Node2D

@onready var player: CharacterBody2D = $CharacterBody2D
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar
@onready var end_screen: CanvasLayer = $EndScreen
@onready var end_title: Label = $EndScreen/Panel/VBox/Titulo
@onready var restart_button: Button = $EndScreen/Panel/VBox/Reiniciar
@onready var win_zone: Area2D = $WinZone
@onready var intro: CanvasLayer = $Intro
@onready var intro_wrapper: Control = $Intro/Wrapper
@onready var fundo: Sprite2D = $Fundo
@onready var camera: Camera2D = $CharacterBody2D/Camera2D


func _ready() -> void:
	end_screen.visible = false
	health_bar.max_value = 100
	health_bar.value = player.vida
	player.vida_alterada.connect(_on_vida_alterada)
	player.morreu.connect(_on_player_morreu)
	win_zone.body_entered.connect(_on_win_zone_body_entered)
	restart_button.pressed.connect(_on_reiniciar)
	_alinhar_fundo_aos_limites_da_camera()
	# Pula a intro se o jogador já a viu nesta sessão (ex.: após "Jogar de novo").
	if GameState.get_flag("intro_vista"):
		intro.queue_free()
	else:
		_animar_intro()


# Deriva position/scale do Fundo a partir dos limites da Camera2D, em vez de
# valores hardcoded — evita divergência se a câmera (#31) mudar os limites.
# Pré-requisito do nó Fundo: centered=false (position = canto superior esquerdo).
func _alinhar_fundo_aos_limites_da_camera() -> void:
	if fundo == null or fundo.texture == null or camera == null:
		return
	var tex_size := fundo.texture.get_size()
	if tex_size.x <= 0 or tex_size.y <= 0:
		return
	var largura := float(camera.limit_right - camera.limit_left)
	var altura := float(camera.limit_bottom - camera.limit_top)
	fundo.position = Vector2(camera.limit_left, camera.limit_top)
	fundo.scale = Vector2(largura / tex_size.x, altura / tex_size.y)


func _animar_intro() -> void:
	intro_wrapper.modulate.a = 0.0
	# Pausa o gameplay para mobs não atacarem o jogador "cego" atrás da tela preta.
	# O tween é criado a partir da Intro (process_mode=ALWAYS) para seguir animando.
	get_tree().paused = true
	var tween := intro.create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(intro_wrapper, "modulate:a", 1.0, 0.6).set_ease(Tween.EASE_OUT)
	tween.tween_interval(2.6)
	tween.tween_property(intro_wrapper, "modulate:a", 0.0, 2.0).set_ease(Tween.EASE_IN)
	tween.tween_callback(_finalizar_intro)


func _finalizar_intro() -> void:
	GameState.set_flag("intro_vista", true)
	get_tree().paused = false
	intro.queue_free()


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
