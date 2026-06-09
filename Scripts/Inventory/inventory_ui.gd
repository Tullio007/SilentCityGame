extends CanvasLayer

const ItemSlotScene := preload("res://Scenes/UI/item_slot.tscn")

# Paleta futurista
const COLOR_BG_MAIN      := Color(0.04, 0.06, 0.10, 0.96)
const COLOR_BG_DETAILS   := Color(0.06, 0.09, 0.14, 0.98)
const COLOR_BORDER_CYAN  := Color(0.0,  0.85, 1.0,  1.0)
const COLOR_BORDER_IDLE  := Color(0.15, 0.25, 0.35, 1.0)
const COLOR_TEXT_PRIMARY := Color(0.85, 0.97, 1.0,  1.0)
const COLOR_TEXT_SECONDARY := Color(0.45, 0.65, 0.75, 1.0)

var _selected_item: InventoryItem = null

@onready var background: Panel         = $Background
@onready var slots_grid: GridContainer = $Background/MainContainer/SlotsSection/SlotsGrid
@onready var title_label: Label        = $Background/MainContainer/SlotsSection/Title
@onready var item_name_label: Label    = $Background/MainContainer/DetailsPanel/DetailsContainer/ItemName
@onready var item_description_label: Label = $Background/MainContainer/DetailsPanel/DetailsContainer/ItemDescription
@onready var item_icon_large: TextureRect  = $Background/MainContainer/DetailsPanel/DetailsContainer/ItemIcon
@onready var use_button: Button        = $Background/MainContainer/DetailsPanel/DetailsContainer/ButtonRow/UseButton
@onready var discard_button: Button    = $Background/MainContainer/DetailsPanel/DetailsContainer/ButtonRow/DiscardButton
@onready var details_panel: Panel      = $Background/MainContainer/DetailsPanel


func _ready() -> void:
	visible = false
	_apply_styles()
	_clear_details()
	Inventory.inventory_changed.connect(_on_inventory_changed)
	use_button.pressed.connect(_on_use_pressed)
	discard_button.pressed.connect(_on_discard_pressed)


func _apply_styles() -> void:
	background.add_theme_stylebox_override("panel", _make_panel_style(COLOR_BG_MAIN, COLOR_BORDER_CYAN, 2))

	# O sufixo deixa explícito (em texto, não só por agrupamento visual) que a
	# lista é ordenada pelo Merge Sort do inventário: memórias primeiro, depois
	# em ordem alfabética.
	title_label.text = "[ INVENTÁRIO ]   ·   ordenado: memórias › nome"
	title_label.add_theme_color_override("font_color", COLOR_BORDER_CYAN)
	title_label.add_theme_font_size_override("font_size", 16)

	details_panel.add_theme_stylebox_override("panel", _make_panel_style(COLOR_BG_DETAILS, COLOR_BORDER_IDLE, 1))

	item_name_label.add_theme_color_override("font_color", COLOR_TEXT_PRIMARY)
	item_name_label.add_theme_font_size_override("font_size", 15)
	item_description_label.add_theme_color_override("font_color", COLOR_TEXT_SECONDARY)

	_style_button(use_button)
	_style_button(discard_button)


func _make_panel_style(bg: Color, border: Color, border_width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(0)
	style.set_content_margin_all(12.0)
	return style


func _style_button(btn: Button) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.04, 0.06, 0.10, 1.0)
	normal.border_color = COLOR_BORDER_CYAN
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(0)
	normal.set_content_margin_all(6.0)

	var hover := StyleBoxFlat.new()
	hover.bg_color = COLOR_BORDER_CYAN
	hover.border_color = COLOR_BORDER_CYAN
	hover.set_border_width_all(1)
	hover.set_corner_radius_all(0)
	hover.set_content_margin_all(6.0)

	var pressed := StyleBoxFlat.new()
	pressed.bg_color = Color(0.0, 0.55, 0.7, 1.0)
	pressed.border_color = COLOR_BORDER_CYAN
	pressed.set_border_width_all(1)
	pressed.set_corner_radius_all(0)
	pressed.set_content_margin_all(6.0)

	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)
	btn.add_theme_color_override("font_color", COLOR_BORDER_CYAN)
	btn.add_theme_color_override("font_hover_color", COLOR_BG_MAIN)
	btn.add_theme_color_override("font_pressed_color", COLOR_BG_MAIN)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_I or event.physical_keycode == KEY_I:
			get_viewport().set_input_as_handled()
			toggle()


func toggle() -> void:
	visible = !visible
	if visible:
		_refresh_slots()
		get_tree().paused = true
	else:
		_clear_details()
		get_tree().paused = false


func _refresh_slots() -> void:
	for child in slots_grid.get_children():
		child.queue_free()

	# Lista ordenada pelo Merge Sort estável do inventário (ver inventory.gd).
	for item in Inventory.get_sorted_items():
		var slot: Panel = ItemSlotScene.instantiate()
		slots_grid.add_child(slot)
		slot.set_item(item)
		slot.slot_selected.connect(_on_slot_selected)


func _on_slot_selected(item: InventoryItem) -> void:
	_selected_item = item

	for slot in slots_grid.get_children():
		slot.set_selected(slot.item == item)

	item_name_label.text = item.display_name
	item_description_label.text = item.description
	item_icon_large.texture = item.icon
	details_panel.visible = true

	use_button.text = "Visualizar" if item.type == InventoryItem.ItemType.MEMORY else "Usar"


func _on_use_pressed() -> void:
	if _selected_item == null:
		return
	Inventory.use_item(_selected_item)
	_selected_item = null
	_clear_details()
	_refresh_slots()


func _on_discard_pressed() -> void:
	if _selected_item == null:
		return
	Inventory.remove_item(_selected_item)
	_selected_item = null
	_clear_details()
	_refresh_slots()


func _on_inventory_changed() -> void:
	if visible:
		_refresh_slots()


func _clear_details() -> void:
	_selected_item = null
	item_name_label.text = ""
	item_description_label.text = ""
	item_icon_large.texture = null
	details_panel.visible = false