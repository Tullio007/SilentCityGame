extends Node2D

const _COR_DISPONIVEL := Color(0.00, 0.85, 1.00, 1.00)   # ciano
const _COR_RESOLVIDO  := Color(0.42, 1.00, 0.55, 1.00)   # verde

@export var puzzle_scene: PackedScene = \
	preload("res://Scenes/UI/tsp_puzzle.tscn")

var _player_perto := false
var _puzzle_aberto := false

@onready var _hint:  Label  = get_node_or_null("Hint")
@onready var _luz:   ColorRect = get_node_or_null("Luz")
@onready var _area:  Area2D = get_node_or_null("Area2D")


func _ready() -> void:
	if _hint:
		_hint.visible = false
	if _luz:
		_luz.color = _COR_DISPONIVEL
	if _area:
		_area.body_entered.connect(_on_body_entered)
		_area.body_exited.connect(_on_body_exited)

	# Se o puzzle já foi resolvido nesta sessão, marca o terminal como ativo
	if GameState.get_flag("tsp_resolvido"):
		_marcar_resolvido()


func _process(_delta: float) -> void:
	if _player_perto and not _puzzle_aberto and Input.is_action_just_pressed("interagir"):
		_abrir_puzzle()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_perto = true
		if _hint and not GameState.get_flag("tsp_resolvido"):
			_hint.visible = true


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_perto = false
		if _hint:
			_hint.visible = false


func _abrir_puzzle() -> void:
	if puzzle_scene == null:
		push_error("TerminalTSP: puzzle_scene não atribuída.")
		return

	_puzzle_aberto = true
	if _hint:
		_hint.visible = false

	var puzzle: Node = puzzle_scene.instantiate()
	get_tree().current_scene.add_child(puzzle)

	# Escuta o sinal de conclusão
	if puzzle.has_signal("puzzle_resolvido"):
		puzzle.puzzle_resolvido.connect(_on_puzzle_resolvido)

	# Detecta quando o puzzle foi fechado (queue_free) para liberar o flag
	puzzle.tree_exited.connect(_on_puzzle_fechado)


func _on_puzzle_resolvido() -> void:
	_marcar_resolvido()


func _on_puzzle_fechado() -> void:
	_puzzle_aberto = false
	# Se o jogador fechou sem resolver, mostra hint novamente se ainda estiver perto
	if _player_perto and not GameState.get_flag("tsp_resolvido"):
		if _hint:
			_hint.visible = true


func _marcar_resolvido() -> void:
	if _luz:
		_luz.color = _COR_RESOLVIDO
	if _hint:
		_hint.text = "Terminal ativado"
		_hint.modulate = _COR_RESOLVIDO