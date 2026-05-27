extends Panel

signal slot_selected(item: InventoryItem)

# Paleta futurista
const COLOR_BG_DARK      := Color(0.04, 0.06, 0.10, 0.96)
const COLOR_BG_MEMORY    := Color(0.12, 0.09, 0.00, 0.96)
const COLOR_BORDER_CYAN  := Color(0.0,  0.85, 1.0,  1.0)
const COLOR_BORDER_GOLD  := Color(1.0,  0.78, 0.0,  1.0)
const COLOR_BORDER_IDLE  := Color(0.15, 0.25, 0.35, 1.0)
const COLOR_HOVER        := Color(0.0,  0.85, 1.0,  0.12)
const COLOR_SELECTED     := Color(0.0,  0.85, 1.0,  0.22)

var item: InventoryItem = null
var _is_selected: bool = false

@onready var icon_rect: TextureRect  = $MarginContainer/Icon
@onready var quantity_label: Label   = $QuantityLabel
@onready var highlight_rect: ColorRect = $Highlight


func set_item(new_item: InventoryItem) -> void:
	item = new_item

	if item == null:
		icon_rect.texture = null
		quantity_label.visible = false
		highlight_rect.visible = false
		_apply_style(COLOR_BORDER_IDLE, COLOR_BG_DARK)
		return

	icon_rect.texture = item.icon
	quantity_label.text = "x%d" % item.quantity
	quantity_label.visible = item.quantity > 1

	if item.type == InventoryItem.ItemType.MEMORY:
		_apply_style(COLOR_BORDER_GOLD, COLOR_BG_MEMORY)
	else:
		_apply_style(COLOR_BORDER_IDLE, COLOR_BG_DARK)


func set_selected(selected: bool) -> void:
	_is_selected = selected
	highlight_rect.color = COLOR_SELECTED if selected else COLOR_HOVER
	highlight_rect.visible = selected

	if item == null:
		return
	var border = COLOR_BORDER_GOLD if item.type == InventoryItem.ItemType.MEMORY else COLOR_BORDER_CYAN
	var bg     = COLOR_BG_MEMORY   if item.type == InventoryItem.ItemType.MEMORY else COLOR_BG_DARK
	_apply_style(border if selected else COLOR_BORDER_IDLE, bg, 2 if selected else 1)


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


func _apply_style(border_color: Color, bg_color: Color, border_width: int = 1) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(0)
	add_theme_stylebox_override("panel", style)
