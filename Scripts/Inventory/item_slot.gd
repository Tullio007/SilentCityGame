extends Panel

signal slot_selected(item: InventoryItem)

# O quadro do slot vem da textura Slots.png (nó SlotBg). O tipo do item e o
# estado de seleção são comunicados por "modulate" sobre esse quadro — sem
# alterar os limites do nó (evita layout shift). A cor não é o único indicador:
# o tipo também aparece no painel de detalhes (botão "Visualizar" p/ memórias).
const TINT_COMMON := Color(0.70, 0.95, 1.20, 1.0) # realce ciano frio (itens comuns)
const TINT_MEMORY := Color(1.45, 1.02, 0.40, 1.0) # dourado quente (brilho >1 p/ destacar memórias)
const DIM         := Color(0.68, 0.68, 0.68, 1.0) # escurece quando não selecionado

const COLOR_HOVER    := Color(0.0, 0.85, 1.0, 0.12)
const COLOR_SELECTED := Color(0.0, 0.85, 1.0, 0.22)

var item: InventoryItem = null
var _is_selected: bool = false

@onready var bg_rect: TextureRect      = $SlotBg
@onready var icon_rect: TextureRect    = $MarginContainer/Icon
@onready var quantity_label: Label     = $QuantityLabel
@onready var highlight_rect: ColorRect = $Highlight


func _ready() -> void:
	# O Panel em si fica transparente; o visual do slot é a textura Slots.png.
	add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	_atualizar_visual()


func set_item(new_item: InventoryItem) -> void:
	item = new_item

	if item == null:
		icon_rect.texture = null
		quantity_label.visible = false
		highlight_rect.visible = false
		_atualizar_visual()
		return

	icon_rect.texture = item.icon
	quantity_label.text = "x%d" % item.quantity
	quantity_label.visible = item.quantity > 1
	_atualizar_visual()


func set_selected(selected: bool) -> void:
	_is_selected = selected
	highlight_rect.color = COLOR_SELECTED if selected else COLOR_HOVER
	highlight_rect.visible = selected
	_atualizar_visual()


func _atualizar_visual() -> void:
	if bg_rect == null:
		return
	var base := TINT_MEMORY if (item != null and item.type == InventoryItem.ItemType.MEMORY) else TINT_COMMON
	# Selecionado: quadro em brilho pleno; caso contrário, levemente escurecido.
	bg_rect.modulate = base if _is_selected else base * DIM


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if item != null:
			emit_signal("slot_selected", item)


func _on_mouse_entered() -> void:
	if not _is_selected and item != null:
		highlight_rect.color = COLOR_HOVER
		highlight_rect.visible = true


func _on_mouse_exited() -> void:
	if not _is_selected:
		highlight_rect.visible = false
