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

# Animação por troca de textura no Sprite2D. As três folhas têm frames
# 2048x2048 e posicionam o robô na mesma região da célula, então a escala e o
# offset do nó (definidos na cena) servem para idle / andar / tiro.
const _TEX_IDLE  := preload("res://Assets/Sprites/lumi sprites/lumi - Animação parado .png")
const _TEX_ANDAR := preload("res://Assets/Sprites/lumi sprites/lumi - animação de andar.png")
const _TEX_TIRO  := preload("res://Assets/Sprites/lumi sprites/lumi tiro .png")

# Grade (hframes x vframes) e nº de frames usáveis de cada folha. Constantes
# tipadas de propósito (sem Dictionary/Variant) para não recriar bug de inferência.
const _IDLE_H := 3
const _IDLE_V := 3
const _IDLE_N := 8
const _IDLE_DT := 0.16
const _ANDAR_H := 3
const _ANDAR_V := 4
const _ANDAR_N := 10
const _ANDAR_DT := 0.08
const _TIRO_H := 3
const _TIRO_V := 3
const _TIRO_N := 8

var _anim_t := 0.0
var _anim_frame := 0
var _atirando := false
var _tiro_dt := 0.05

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
	# Dispara a animação de tiro: 8 frames distribuídos ao longo do cooldown.
	_atirando = true
	_anim_frame = 0
	_anim_t = 0.0
	_tiro_dt = COOLDOWN_TIRO / float(_TIRO_N)
	AudioManager.play_lumi_attack()
	var proj := PROJECTILE_SCENE.instantiate()
	# Spawn ligeiramente à frente e na altura do tronco para evitar tocar o chão.
	var origem := global_position + Vector2(_olhando * 24.0, -10.0)
	proj.configurar(_olhando, origem)
	get_parent().add_child(proj)
	await get_tree().create_timer(COOLDOWN_TIRO).timeout
	_pode_atirar = true
	_atirando = false


func tomar_dano(valor: int) -> void:
	if morto:
		return
	vida = max(vida - valor, 0)
	vida_alterada.emit(vida, VIDA_MAXIMA)
	AudioManager.play_lumi_hurt()
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


func _set_sheet(tex: Texture2D, h: int, v: int) -> void:
	if _sprite.texture == tex:
		return
	_sprite.texture = tex
	_sprite.hframes = h
	_sprite.vframes = v
	_anim_frame = 0
	_sprite.frame = 0


func _animar(delta: float, direction: float) -> void:
	if _sprite == null:
		return
	# O robô está centrado na origem (via offset do Sprite), então inverter
	# scale.x espelha em torno do próprio centro, virando-o para o lado certo.
	if direction > 0.0:
		_sprite.scale.x = absf(_sprite.scale.x)
	elif direction < 0.0:
		_sprite.scale.x = -absf(_sprite.scale.x)

	_anim_t += delta

	# Tiro: roda a folha de tiro uma vez (sem loop), prioridade sobre idle/andar.
	if _atirando:
		_set_sheet(_TEX_TIRO, _TIRO_H, _TIRO_V)
		if _anim_t >= _tiro_dt:
			_anim_t -= _tiro_dt
			if _anim_frame < _TIRO_N - 1:
				_anim_frame += 1
				_sprite.frame = _anim_frame
		return

	# Andar (se há velocidade horizontal) ou idle.
	var passo: float
	var total: int
	if absf(velocity.x) > 5.0:
		_set_sheet(_TEX_ANDAR, _ANDAR_H, _ANDAR_V)
		passo = _ANDAR_DT
		total = _ANDAR_N
	else:
		_set_sheet(_TEX_IDLE, _IDLE_H, _IDLE_V)
		passo = _IDLE_DT
		total = _IDLE_N

	if _anim_t >= passo:
		_anim_t -= passo
		_anim_frame = (_anim_frame + 1) % total
		_sprite.frame = _anim_frame


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
