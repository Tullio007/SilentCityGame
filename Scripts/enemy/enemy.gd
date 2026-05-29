extends CharacterBody2D

@export var velocidade: float = 60.0
@export var distancia_patrulha: float = 80.0
@export var dano: int = 10

const GRAVITY := 800.0
const COOLDOWN_DANO := 1.0

var _origem_x: float
var _direcao := 1.0
var _pode_dar_dano := true

@onready var hitbox: Area2D = $Hitbox
@onready var _sprite: Sprite2D = get_node_or_null("Sprite")


func _ready() -> void:
	add_to_group("enemy")
	_origem_x = global_position.x


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	velocity.x = _direcao * velocidade
	if global_position.x >= _origem_x + distancia_patrulha:
		_direcao = -1.0
	elif global_position.x <= _origem_x - distancia_patrulha:
		_direcao = 1.0

	if _sprite:
		_sprite.scale.x = absf(_sprite.scale.x) * _direcao

	move_and_slide()

	for body in hitbox.get_overlapping_bodies():
		if body.is_in_group("player"):
			_atacar(body)


func _atacar(player: Node) -> void:
	if not _pode_dar_dano or not player.has_method("tomar_dano"):
		return
	_pode_dar_dano = false
	player.tomar_dano(dano)
	if player.has_method("aplicar_knockback"):
		var dir := signf(player.global_position.x - global_position.x)
		player.aplicar_knockback(Vector2(dir * 250.0, -150.0))
	await get_tree().create_timer(COOLDOWN_DANO).timeout
	_pode_dar_dano = true
