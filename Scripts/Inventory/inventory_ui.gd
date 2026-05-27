extends CanvasLayer

const ItemSlotScene := preload("res://Scenes/UI/item_slot.tscn")

var _selected_item: InventoryItem = null

@onready var background: Panel = $Background
@onready var slots_grid: GridContainer = $Background/MainContainer/SlotsSection/SlotsGrid
@onready var item_name_label: Label = $Background/MainContainer/DetailsPanel/DetailsContainer/ItemName
@onready var item_description_label: Label = $Background/MainContainer/DetailsPanel/DetailsContainer/ItemDescription
@onready var item_icon_large: TextureRect = $Background/MainContainer/DetailsPanel/DetailsContainer/ItemIcon
@onready var use_button: Button = $Background/MainContainer/DetailsPanel/DetailsContainer/ButtonRow/UseButton
@onready var discard_button: Button = $Background/MainContainer/DetailsPanel/DetailsContainer/ButtonRow/DiscardButton
@onready var details_panel: Panel = $Background/MainContainer/DetailsPanel


func _ready() -> void:
	visible = false
	_clear_details()
	Inventory.inventory_changed.connect(_on_inventory_changed)
	use_button.pressed.connect(_on_use_pressed)
	discard_button.pressed.connect(_on_discard_pressed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		toggle()


func toggle() -> void:
	visible = !visible
	if visible:
		_refresh_slots()
		# Pausa o jogo enquanto o inventário está aberto
		get_tree().paused = true
	else:
		_clear_details()
		get_tree().paused = false


func _refresh_slots() -> void:
	# Remove slots antigos
	for child in slots_grid.get_children():
		child.queue_free()

	# Cria um slot para cada item no inventário
	for item in Inventory.get_all_items():
		var slot: Panel = ItemSlotScene.instantiate()
		slots_grid.add_child(slot)
		slot.set_item(item)
		slot.slot_selected.connect(_on_slot_selected)


func _on_slot_selected(item: InventoryItem) -> void:
	_selected_item = item

	# Destaca o slot selecionado e remove destaque dos outros
	for slot in slots_grid.get_children():
		slot.set_selected(slot.item == item)

	# Preenche o painel de detalhes
	item_name_label.text = item.display_name
	item_description_label.text = item.description
	item_icon_large.texture = item.icon
	details_panel.visible = true

	# Botão "Usar" muda de texto para Memórias
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
