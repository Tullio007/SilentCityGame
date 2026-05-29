extends Node

signal item_added(item: InventoryItem)
signal item_removed(item: InventoryItem)
signal inventory_changed
signal memory_collected(item: InventoryItem)

const MAX_SLOTS: int = 20

# ─────────────────────────────────────────────
# ESTRUTURA PRINCIPAL: Dictionary (HashMap)
# Chave  → item.id  (String)
# Valor  → InventoryItem
# ─────────────────────────────────────────────
var items: Dictionary = {}


# ── Propriedade de compatibilidade ────────────
# inventory_ui.gd itera sobre "Inventory.items" esperando um Array.
# Este getter converte o Dictionary para Array transparentemente,
# sem expor a estrutura interna nem quebrar a UI existente.
var items_as_array: Array[InventoryItem]:
	get:
		var arr: Array[InventoryItem] = []
		for key in items:
			arr.append(items[key])
		return arr


# ══════════════════════════════════════════════
# 1. ADICIONAR ITEM
# ══════════════════════════════════════════════
func add_item(item: InventoryItem) -> bool:
	# Acesso O(1) pela chave — verifica se o item já existe no inventário
	if items.has(item.id):
		# Item já existe: atualiza a quantidade (empilha)
		items[item.id].quantity += item.quantity
		emit_signal("item_added", items[item.id])
		emit_signal("inventory_changed")
		return true

	# Item novo: verifica o limite de slots
	if items.size() >= MAX_SLOTS:
		return false

	# Cria novo registro no inventário usando o id como chave
	var new_item := item.duplicate() as InventoryItem
	items[new_item.id] = new_item
	emit_signal("item_added", new_item)
	emit_signal("inventory_changed")
	return true


# ══════════════════════════════════════════════
# 2. CONSULTAR ITEM
# ══════════════════════════════════════════════

# Consulta por ID — acesso direto O(1) pela chave do mapa
func get_item_by_id(id: String) -> InventoryItem:
	if items.has(id):
		return items[id]
	return null


# Consulta por nome — percorre os valores do Dictionary
func get_item_by_name(name: String) -> InventoryItem:
	for key in items:
		if items[key].display_name.to_lower() == name.to_lower():
			return items[key]
	return null


# Verifica existência por ID — acesso O(1)
func has_item(id: String) -> bool:
	return items.has(id)


# Retorna a quantidade armazenada de um item (por ID)
func get_quantity(id: String) -> int:
	if items.has(id):
		return items[id].quantity
	return 0


# ══════════════════════════════════════════════
# 3. EXIBIR INVENTÁRIO
# ══════════════════════════════════════════════

# Retorna todos os itens como Array (para a UI e para listagem)
func get_all_items() -> Array[InventoryItem]:
	return items_as_array


# Imprime o inventário no console (debug / linha de comando)
func print_inventory() -> void:
	if items.is_empty():
		print("[Inventário] Vazio.")
		return
	print("[Inventário] %d/%d slots ocupados:" % [items.size(), MAX_SLOTS])
	for key in items:
		var it: InventoryItem = items[key]
		print("  [%s] %s  x%d" % [it.id, it.display_name, it.quantity])


# ══════════════════════════════════════════════
# 4. REMOVER ITEM
# ══════════════════════════════════════════════

# Remove uma quantidade específica ou o item completo do inventário.
# amount = -1  → remove o item inteiro independente da quantidade
func remove_item(item: InventoryItem, amount: int = -1) -> void:
	if not items.has(item.id):
		return

	if amount == -1 or items[item.id].quantity <= amount:
		# Remove o item completamente do Dictionary
		var removed: InventoryItem = items[item.id]
		items.erase(item.id)
		emit_signal("item_removed", removed)
	else:
		# Decrementa apenas a quantidade solicitada
		items[item.id].quantity -= amount
		emit_signal("inventory_changed")

	emit_signal("inventory_changed")


# ══════════════════════════════════════════════
# FUNCIONALIDADES AUXILIARES (mantidas do original)
# ══════════════════════════════════════════════

func use_item(item: InventoryItem) -> void:
	match item.type:
		InventoryItem.ItemType.MEMORY:
			# Memórias não são consumidas — emite sinal para exibir conteúdo
			emit_signal("memory_collected", item)
		InventoryItem.ItemType.COMMON:
			# Itens comuns são consumidos ao usar
			remove_item(item, 1)


func get_memories() -> Array[InventoryItem]:
	var memories: Array[InventoryItem] = []
	for key in items:
		if items[key].type == InventoryItem.ItemType.MEMORY:
			memories.append(items[key])
	return memories


func clear() -> void:
	items.clear()
	emit_signal("inventory_changed")
