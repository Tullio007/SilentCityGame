extends Node2D

# Harness de teste VISUAL/USUÁRIO do Merge Sort.
# Popula o autoload Inventory com itens em ordem de coleta "embaralhada",
# abre a UI REAL do inventário (Scenes/UI/inventory_ui.tscn) — que lista via
# get_sorted_items() — e salva um screenshot para inspeção.
# Roda com:  godot --path <projeto> res://tests/screenshot_harness.tscn

func _ready() -> void:
	Inventory.clear()

	# Ordem de COLETA (propositalmente fora de ordem):
	#   comum "Modulo", memoria "Diario", comum "Kit", memoria "Cartao", memoria "Alerta"
	# Após o Merge Sort (tipo -> nome) a UI deve mostrar:
	#   [MEMORIAS, douradas, alfabético] Alerta, Cartao, Diario
	#   [COMUNS, ciano/idle, alfabético] Kit, Modulo
	_add("com_speed",  "Modulo de Speed",   InventoryItem.ItemType.COMMON, "res://Assets/Sprites/item de velocidade/item de speed.png")
	_add("mem_diario", "Diario de Marcos",  InventoryItem.ItemType.MEMORY, "res://Assets/Sprites/npc_marcos_holograma.png")
	_add("com_vida",   "Kit de Vida",       InventoryItem.ItemType.COMMON, "res://Assets/Sprites/item de vida/vida.png")
	_add("mem_acesso", "Cartao de Acesso",  InventoryItem.ItemType.MEMORY, "res://Assets/Sprites/acesso.png")
	_add("mem_alerta", "Alerta do Sistema", InventoryItem.ItemType.MEMORY, "res://Assets/Sprites/acesso.png")

	var ui: CanvasLayer = preload("res://Scenes/UI/inventory_ui.tscn").instantiate()
	add_child(ui)

	await get_tree().process_frame
	ui.visible = true
	ui.call("_refresh_slots")

	# Espera o layout e a renderização estabilizarem.
	for i in 6:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw

	var img: Image = get_viewport().get_texture().get_image()
	var path: String = "res://tests/mergesort_demo.png"
	var err: int = img.save_png(path)
	if err == OK:
		print("SCREENSHOT_SAVED ", ProjectSettings.globalize_path(path))
	else:
		printerr("SCREENSHOT_FAIL err=", err)

	get_tree().quit()


func _add(id: String, display_name: String, type: int, icon_path: String) -> void:
	var it := InventoryItem.new()
	it.id = id
	it.display_name = display_name
	it.type = type
	it.quantity = 1
	if ResourceLoader.exists(icon_path):
		it.icon = load(icon_path)
	Inventory.add_item(it)
