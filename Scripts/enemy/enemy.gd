extends CharacterBody2D

@export var velocidade: float = 60.0
@export var distancia_patrulha: float = 80.0
@export var dano: int = 10
@export var vida_maxima: int = 60
@export var distancia_deteccao: float = 130.0
@export var duracao_telegraph: float = 0.55
@export var duracao_ataque: float = 0.2
@export var duracao_recuperacao: float = 0.9
@export var alcance_ataque: float = 60.0
## Caminho do SFX de ataque deste mob (ex: "res://Assets/Audio/SFX/enemies/mob1/attack.ogg").
@export var sfx_attack_path: String = ""
## Grupo da horda (ex: "horde_insetos"). Todos os inimigos da mesma horda
## devem ter o mesmo valor. A memória dropa quando o último morrer.
@export var horde_group: String = ""
## Recurso de memória que esta horda solta. Coloque o mesmo .tres em todos
## os inimigos da horda — apenas o último a morrer vai disparar o drop.
@export var memory_data: MemoryItem = null

const GRAVITY := 800.0
const _MEMORY_SCENE := preload("res://Scenes/memory_pickup.tscn")

enum Estado { PATRULHA, TELEGRAFANDO, ATACANDO, RECUPERANDO, MORTO }

signal morreu

var vida: int
var _origem_x: float
var _direcao := 1.0
var _estado: int = Estado.PATRULHA
var _tempo_estado := 0.0
var _ja_aplicou_dano := false
var _flash_tween: Tween = null

@onready var hitbox: Area2D = $Hitbox
@onready var _sprite: Sprite2D = get_node_or_null("Sprite")


func _ready() -> void:
	add_to_group("enemy")
	if horde_group != "":
		add_to_group(horde_group)
	_origem_x = global_position.x
	vida = vida_maxima


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	match _estado:
		Estado.PATRULHA:
			_processar_patrulha()
		Estado.TELEGRAFANDO:
			_processar_telegraph(delta)
		Estado.ATACANDO:
			_processar_ataque(delta)
		Estado.RECUPERANDO:
			_processar_recuperacao(delta)
		Estado.MORTO:
			velocity.x = 0.0

	if _sprite and _estado != Estado.MORTO:
		_sprite.scale.x = absf(_sprite.scale.x) * _direcao

	move_and_slide()


func _processar_patrulha() -> void:
	velocity.x = _direcao * velocidade
	if global_position.x >= _origem_x + distancia_patrulha:
		_direcao = -1.0
	elif global_position.x <= _origem_x - distancia_patrulha:
		_direcao = 1.0

	var player := _achar_player()
	if player == null:
		return
	var dx := player.global_position.x - global_position.x
	var dy := absf(player.global_position.y - global_position.y)
	if absf(dx) <= distancia_deteccao and dy <= 60.0:
		_direcao = signf(dx) if dx != 0.0 else _direcao
		_entrar_telegraph()


func _entrar_telegraph() -> void:
	_estado = Estado.TELEGRAFANDO
	_tempo_estado = 0.0
	velocity.x = 0.0
	if not sfx_attack_path.is_empty():
		AudioManager.play_sfx_path(sfx_attack_path)
	_aviso_telegraph()


func _processar_telegraph(delta: float) -> void:
	velocity.x = 0.0
	_tempo_estado += delta
	if _tempo_estado >= duracao_telegraph:
		_estado = Estado.ATACANDO
		_tempo_estado = 0.0
		_ja_aplicou_dano = false


func _processar_ataque(delta: float) -> void:
	velocity.x = 0.0
	_tempo_estado += delta
	if not _ja_aplicou_dano:
		_aplicar_dano_se_no_alcance()
	if _tempo_estado >= duracao_ataque:
		_estado = Estado.RECUPERANDO
		_tempo_estado = 0.0
		if _sprite:
			_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _processar_recuperacao(delta: float) -> void:
	velocity.x = 0.0
	_tempo_estado += delta
	if _tempo_estado >= duracao_recuperacao:
		_estado = Estado.PATRULHA
		_tempo_estado = 0.0


func _aplicar_dano_se_no_alcance() -> void:
	# Hitbox alcança quem encosta no inimigo durante o frame de ataque.
	# Como o overlap pode ser detectado depois do entered, varremos os bodies atuais.
	for body in hitbox.get_overlapping_bodies():
		if not body.is_in_group("player"):
			continue
		var dx := body.global_position.x - global_position.x
		if absf(dx) > alcance_ataque:
			continue
		if signf(dx) != _direcao and dx != 0.0:
			continue
		_ja_aplicou_dano = true
		if body.has_method("tomar_dano"):
			body.tomar_dano(dano)
		if body.has_method("aplicar_knockback"):
			body.aplicar_knockback(Vector2(_direcao * 260.0, -160.0))
		return


func _aviso_telegraph() -> void:
	if _sprite == null:
		return
	if _flash_tween and _flash_tween.is_valid():
		_flash_tween.kill()
	_flash_tween = create_tween().set_loops(2)
	_flash_tween.tween_property(_sprite, "modulate", Color(1.6, 1.4, 0.3, 1.0), 0.12)
	_flash_tween.tween_property(_sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.15)


func tomar_dano(valor: int) -> void:
	if _estado == Estado.MORTO:
		return
	vida = max(vida - valor, 0)
	_flash_dano()
	if vida == 0:
		_morrer()


func _flash_dano() -> void:
	if _sprite == null:
		return
	if _flash_tween and _flash_tween.is_valid():
		_flash_tween.kill()
	_flash_tween = create_tween()
	_flash_tween.tween_property(_sprite, "modulate", Color(1.8, 0.4, 0.4, 1.0), 0.06)
	_flash_tween.tween_property(_sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.22)


func _morrer() -> void:
	_estado = Estado.MORTO
	velocity = Vector2.ZERO
	morreu.emit()
	# Sai do grupo da horda antes de checar — assim o count já reflete a morte.
	if horde_group != "":
		remove_from_group(horde_group)
	_spawnar_memoria()
	# Desliga colisões para o cadáver não bloquear o jogador enquanto faz o fade.
	set_collision_layer(0)
	set_collision_mask(0)
	hitbox.set_deferred("monitoring", false)
	if _sprite:
		if _flash_tween and _flash_tween.is_valid():
			_flash_tween.kill()
		var t := create_tween()
		t.tween_property(_sprite, "modulate:a", 0.0, 0.35)
		await t.finished
	queue_free()


func _spawnar_memoria() -> void:
	if memory_data == null:
		return
	if GameState.get_flag("mem_" + memory_data.id):
		return
	# Só dropa se for o último vivo da horda (grupo já vazio após remove_from_group).
	if horde_group != "" and not get_tree().get_nodes_in_group(horde_group).is_empty():
		return
	var pickup := _MEMORY_SCENE.instantiate()
	pickup.memory_data = memory_data
	pickup.global_position = global_position
	get_parent().add_child(pickup)


func _achar_player() -> Node2D:
	return get_tree().get_first_node_in_group("player") as Node2D
