extends StaticBody2D

## Porta de saída da fase. Só abre quando o player tem o item exigido no
## inventário (reaproveitando o Inventory global). Configurável por export para
## que a mesma cena sirva a qualquer porta/chave futura.
@export var required_item_id: String = "chave"
@export var texto_trancada: String = "Trancada — falta a Chave de Acesso"
@export var texto_abrir: String = "[E] Abrir"
## Consome a chave do inventário ao abrir. Desligue para portas reutilizáveis.
@export var consumir_chave: bool = true

const _COR_TRANCADA := Color(1.0, 0.27, 0.27, 1.0)   # vermelho (bloqueado)
const _COR_LIBERADA := Color(0.0, 0.85, 1.0, 1.0)    # ciano (interagível)
const _COR_ABERTA := Color(0.42, 1.0, 0.55, 1.0)     # verde (destrancada)

var _player_perto := false
var _aberta := false
var _shake_tween: Tween = null

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var area: Area2D = $Area2D
@onready var aviso: Label = $Aviso
@onready var _luz: ColorRect = $VLine          # "tranca": muda de cor por estado
@onready var _sfx: AudioStreamPlayer = $AbrirSFX


func _ready() -> void:
	area.body_entered.connect(_on_area_body_entered)
	area.body_exited.connect(_on_area_body_exited)
	aviso.visible = false
	_luz.color = _COR_LIBERADA


func _process(_delta: float) -> void:
	if _aberta or not _player_perto:
		return
	# Prompt reativo: reflete se o player já tem a chave naquele instante.
	_atualizar_prompt()
	if Input.is_action_just_pressed("interagir"):
		_tentar_abrir()


func _on_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_perto = true
		_atualizar_prompt()


func _on_area_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_perto = false
		aviso.visible = false


func _tem_chave() -> bool:
	return Inventory.get_item_by_id(required_item_id) != null


func _atualizar_prompt() -> void:
	if _aberta:
		return
	if _tem_chave():
		aviso.text = texto_abrir
		aviso.modulate = _COR_LIBERADA
		_luz.color = _COR_LIBERADA
	else:
		aviso.text = texto_trancada
		aviso.modulate = _COR_TRANCADA
		_luz.color = _COR_TRANCADA
	aviso.visible = true


func _tentar_abrir() -> void:
	var item: InventoryItem = Inventory.get_item_by_id(required_item_id)
	if item != null:
		if consumir_chave:
			Inventory.remove_item(item)
		_abrir()
	else:
		_feedback_negado()


## Sem a chave: chacoalha a porta e pisca a tranca em vermelho, comunicando o
## bloqueio sem precisar de texto extra.
func _feedback_negado() -> void:
	_atualizar_prompt()
	if _shake_tween and _shake_tween.is_valid():
		_shake_tween.kill()
	var x0 := position.x
	_shake_tween = create_tween()
	for desloc in [6.0, -5.0, 4.0, -3.0, 0.0]:
		_shake_tween.tween_property(self, "position:x", x0 + desloc, 0.04)
	_luz.color = _COR_TRANCADA


func _abrir() -> void:
	_aberta = true
	aviso.visible = false
	_luz.color = _COR_ABERTA
	if _sfx.stream != null:
		_sfx.play()
	# Diferido: alterar colisão dentro de callbacks de física/sinal exige set_deferred.
	collision.set_deferred("disabled", true)
	_animar_abertura()


func _animar_abertura() -> void:
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 130.0, 0.45) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 0.0, 0.45) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(func(): visible = false)
