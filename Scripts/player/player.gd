extends CharacterBody2D
@export var camera_limit_left: int = 0
@export var camera_limit_top: int = 0
@export var camera_limit_right: int = 3100
@export var camera_limit_bottom: int = 560
@export var camera_smoothing_speed: float = 5.0
@onready var camera: Camera2D = $Camera2D

var _shake_tween: Tween = null

signal vida_alterada(vida_atual: int, vida_maxima: int)
signal morreu

const SPEED = 200.0
const GRAVITY = 800.0
const JUMP_FORCE = -400.0
const VIDA_MAXIMA = 100
const COOLDOWN_TIRO := 0.35
const PROJECTILE_SCENE := preload("res://Scenes/projectile.tscn")

var vida := VIDA_MAXIMA
var morto := false
var _olhando := 1.0
var _pode_atirar := true

# Animação: só existe o spritesheet "parado" (idle, 8 frames). Sem folha de
# caminhada, animamos os frames do idle (mais rápido ao andar) e viramos o sprite.
const _FRAMES_IDLE := 8
const _FRAME_TIME_PARADO := 0.16
const _FRAME_TIME_ANDANDO := 0.08
var _anim_t := 0.0

@onready var _sprite: Sprite2D = get_node_or_null("Sprite")


func _ready() -> void:
	add_to_group("player")
	camera.make_current()
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = camera_smoothing_speed
	camera.limit_left = camera_limit_left
	camera.limit_top = camera_limit_top
	camera.limit_right = camera_limit_right
	camera.limit_bottom = camera_limit_bottom

func _physics_process(delta: float) -> void:
	if morto:
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	if direction != 0.0:
		_olhando = signf(direction)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE

	if Input.is_action_just_pressed("attack") and _pode_atirar:
		_atirar()

	_animar(delta, direction)

	move_and_slide()


func _atirar() -> void:
	_pode_atirar = false
	var proj := PROJECTILE_SCENE.instantiate()
	# Spawn ligeiramente à frente e na altura do tronco para evitar tocar o chão.
	var origem := global_position + Vector2(_olhando * 24.0, -10.0)
	proj.configurar(_olhando, origem)
	get_parent().add_child(proj)
	await get_tree().create_timer(COOLDOWN_TIRO).timeout
	_pode_atirar = true


func tomar_dano(valor: int) -> void:
	if morto:
		return
	vida = max(vida - valor, 0)
	vida_alterada.emit(vida, VIDA_MAXIMA)
	_flash_dano()
	if vida == 0:
		morrer()


var _flash_tween: Tween = null

func _flash_dano() -> void:
	if _sprite == null:
		return
	# Em dano rápido, mata o tween anterior para os tweens não disputarem o modulate.
	if _flash_tween and _flash_tween.is_valid():
		_flash_tween.kill()
	_flash_tween = create_tween()
	_flash_tween.tween_property(_sprite, "modulate", Color(1.6, 0.35, 0.35, 1.0), 0.06)
	_flash_tween.tween_property(_sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.22)


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

func shake(intensidade: float = 8.0, duracao: float = 0.2) -> void:
	if _shake_tween != null:
		_shake_tween.kill()
		_shake_tween = null

	camera.offset = Vector2.ZERO

	_shake_tween = create_tween()
	var steps: int = max(1, int(duracao / 0.03))

	for i in range(steps):
		var random_offset := Vector2(
			randf_range(-intensidade, intensidade),
			randf_range(-intensidade, intensidade)
		)
		_shake_tween.tween_property(camera, "offset", random_offset, 0.03)

	_shake_tween.tween_property(camera, "offset", Vector2.ZERO, 0.05)
	await _shake_tween.finished
	_shake_tween = null
