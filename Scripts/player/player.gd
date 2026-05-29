extends CharacterBody2D

signal vida_alterada(vida_atual: int, vida_maxima: int)
signal morreu

const SPEED = 200.0
const GRAVITY = 800.0
const JUMP_FORCE = -400.0
const VIDA_MAXIMA = 100

var vida := VIDA_MAXIMA
var morto := false

# Animação: só existe o spritesheet "parado" (idle, 8 frames). Sem folha de
# caminhada, animamos os frames do idle (mais rápido ao andar) e viramos o sprite.
const _FRAMES_IDLE := 8
const _FRAME_TIME_PARADO := 0.16
const _FRAME_TIME_ANDANDO := 0.08
var _anim_t := 0.0

@onready var _sprite: Sprite2D = get_node_or_null("Sprite")


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta: float) -> void:
	if morto:
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE

	_animar(delta, direction)

	move_and_slide()


func tomar_dano(valor: int) -> void:
	if morto:
		return
	vida = max(vida - valor, 0)
	vida_alterada.emit(vida, VIDA_MAXIMA)
	if vida == 0:
		morrer()


func aplicar_knockback(forca: Vector2) -> void:
	velocity = forca


func _animar(delta: float, direction: float) -> void:
	if _sprite == null:
		return
	# O robô está centrado na origem (via offset do Sprite), então inverter
	# scale.x espelha em torno do próprio centro, virando-o para o lado certo.
	if direction > 0.0:
		_sprite.scale.x = absf(_sprite.scale.x)
	elif direction < 0.0:
		_sprite.scale.x = -absf(_sprite.scale.x)

	var passo := _FRAME_TIME_ANDANDO if absf(velocity.x) > 5.0 else _FRAME_TIME_PARADO
	_anim_t += delta
	if _anim_t >= passo:
		_anim_t -= passo
		_sprite.frame = (_sprite.frame + 1) % _FRAMES_IDLE


func morrer() -> void:
	if morto:
		return
	morto = true
	velocity = Vector2.ZERO
	morreu.emit()
