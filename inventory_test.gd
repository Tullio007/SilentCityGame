extends Node2D

# ──────────────────────────────────────────────
# TESTE DO MERGE SORT DO INVENTÁRIO
# ──────────────────────────────────────────────
# Valida o algoritmo de ordenação implementado em Scripts/Inventory/inventory.gd:
#   1) Ordenação correta pelo critério composto (tipo → nome).
#   2) ESTABILIDADE — itens com chave equivalente preservam a ordem de coleta.
#
# Usa uma instância ISOLADA do inventário para não poluir o estado do jogo.
# Para rodar: abra esta cena/script no editor e execute (F6), ou anexe a um Node2D.


func _ready() -> void:
	print("==========================================")
	print("TESTE — Merge Sort do Inventário")
	print("==========================================")

	var inv: Node = preload("res://Scripts/Inventory/inventory.gd").new()

	# Itens adicionados em uma ordem de coleta conhecida.
	# "memoria_b1" e "memoria_b2" têm o MESMO nome e tipo de propósito,
	# para verificar a estabilidade (devem manter a ordem de coleta).
	inv.add_item(_make("comum_z",    "Zinco",   InventoryItem.ItemType.COMMON))
	inv.add_item(_make("memoria_b1", "Memória", InventoryItem.ItemType.MEMORY))
	inv.add_item(_make("comum_a",    "Acido",   InventoryItem.ItemType.COMMON))
	inv.add_item(_make("memoria_b2", "Memória", InventoryItem.ItemType.MEMORY))
	inv.add_item(_make("memoria_a",  "Antena",  InventoryItem.ItemType.MEMORY))

	var sorted_items: Array = inv.get_sorted_items()

	print("Ordem resultante:")
	for it in sorted_items:
		print("  - [%s] %s (%s)" % [
			it.id,
			it.display_name,
			"MEMORY" if it.type == InventoryItem.ItemType.MEMORY else "COMMON"
		])

	# Ordem esperada:
	#   Memórias primeiro, em ordem alfabética: "Antena", depois "Memória"x2.
	#   Empate (Memória == Memória): estabilidade mantém memoria_b1 antes de memoria_b2.
	#   Depois os comuns, alfabéticos: "Acido", "Zinco".
	var expected_ids: Array = [
		"memoria_a",   # Antena (MEMORY)
		"memoria_b1",  # Memória (MEMORY) — coletada primeiro
		"memoria_b2",  # Memória (MEMORY) — coletada depois (estabilidade)
		"comum_a",     # Acido (COMMON)
		"comum_z"      # Zinco (COMMON)
	]

	var actual_ids: Array = []
	for it in sorted_items:
		actual_ids.append(it.id)

	assert(actual_ids == expected_ids,
		"FALHOU: ordem esperada %s, obtida %s" % [expected_ids, actual_ids])

	# Verificação explícita de estabilidade.
	assert(actual_ids.find("memoria_b1") < actual_ids.find("memoria_b2"),
		"FALHOU: estabilidade quebrada — memoria_b1 deveria vir antes de memoria_b2")

	print("------------------------------------------")
	print("✓ PASSOU — ordenação e estabilidade corretas.")
	print("==========================================")

	inv.free()


func _make(id: String, display_name: String, type: int) -> InventoryItem:
	var item := InventoryItem.new()
	item.id = id
	item.display_name = display_name
	item.type = type
	item.quantity = 1
	return item
