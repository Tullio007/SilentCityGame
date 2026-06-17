extends Area2D

@export var velocidade: float = 600.0
@export var dano: int = 25
@export var lifetime: float = 1.2

var direcao: Vector2 = Vector2.RIGHT
var _tempo_restante: float


func _ready() -> void:
	_tempo_restante = lifetime
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position += direcao * velocidade * delta
	_tempo_restante -= delta
	if _tempo_restante <= 0.0:
		queue_free()


func configurar(dir_x: float, origem_global: Vector2) -> void:
	# Chamado por quem instancia (player) antes de adicionar à árvore.
	direcao = Vector2(signf(dir_x), 0.0)
	if direcao.x == 0.0:
		direcao.x = 1.0
	global_position = origem_global
	# Espelha o sprite conforme a direção (escala negativa = vira pra esquerda).
	scale.x = direcao.x


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		return
	if body.is_in_group("enemy") and body.has_method("tomar_dano"):
		body.tomar_dano(dano)
	queue_free()
