extends CharacterBody2D

signal vida_alterada(vida_atual: int, vida_maxima: int)
signal morreu

const SPEED = 200.0
const GRAVITY = 800.0
const JUMP_FORCE = -400.0
const VIDA_MAXIMA = 100

var vida := VIDA_MAXIMA
var morto := false


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


func morrer() -> void:
	if morto:
		return
	morto = true
	velocity = Vector2.ZERO
	morreu.emit()
