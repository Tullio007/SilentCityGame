extends SceneTree

# Teste headless do Merge Sort do inventário.
# Roda com:  godot --headless --path <projeto> --script res://tests/test_mergesort.gd
# Exit code 0 = todos verdes; >0 = nº de falhas.

func _initialize() -> void:
	var failures: int = 0

	var inv: Object = load("res://Scripts/Inventory/inventory.gd").new()

	# Ordem de coleta conhecida; "memoria_b1"/"memoria_b2" têm chave equivalente
	# (mesmo tipo e nome) para validar a ESTABILIDADE.
	inv.add_item(_make("comum_z",    "Zinco",   InventoryItem.ItemType.COMMON))
	inv.add_item(_make("memoria_b1", "Memoria", InventoryItem.ItemType.MEMORY))
	inv.add_item(_make("comum_a",    "Acido",   InventoryItem.ItemType.COMMON))
	inv.add_item(_make("memoria_b2", "Memoria", InventoryItem.ItemType.MEMORY))
	inv.add_item(_make("memoria_a",  "Antena",  InventoryItem.ItemType.MEMORY))

	var sorted_items: Array = inv.get_sorted_items()

	var actual_ids: Array = []
	for it in sorted_items:
		actual_ids.append(it.id)

	var expected_ids: Array = [
		"memoria_a",   # Antena  (MEMORY)
		"memoria_b1",  # Memoria (MEMORY) — coletada antes
		"memoria_b2",  # Memoria (MEMORY) — coletada depois (estabilidade)
		"comum_a",     # Acido   (COMMON)
		"comum_z",     # Zinco   (COMMON)
	]

	print("==========================================")
	print("TESTE — Merge Sort do Inventario")
	print("==========================================")
	print("Esperado: ", expected_ids)
	print("Obtido:   ", actual_ids)

	# 1) Ordenação correta.
	if actual_ids != expected_ids:
		failures += 1
		printerr("[FALHA] Ordem incorreta.")
	else:
		print("[OK] Ordem correta (tipo -> nome).")

	# 2) Estabilidade explícita.
	if actual_ids.find("memoria_b1") >= actual_ids.find("memoria_b2"):
		failures += 1
		printerr("[FALHA] Estabilidade quebrada: b1 deveria vir antes de b2.")
	else:
		print("[OK] Estavel: itens de chave igual mantiveram a ordem de coleta.")

	# 3) Não destrói o inventário original (get_sorted_items retorna cópia).
	if inv.get_all_items().size() != 5:
		failures += 1
		printerr("[FALHA] get_sorted_items alterou o inventario original.")
	else:
		print("[OK] Inventario original intacto (ordenacao nao-destrutiva).")

	print("------------------------------------------")
	if failures == 0:
		print("RESULTADO: TODOS VERDES ✓")
	else:
		printerr("RESULTADO: %d FALHA(S)" % failures)
	print("==========================================")

	quit(failures)


func _make(id: String, display_name: String, type: int) -> InventoryItem:
	var item := InventoryItem.new()
	item.id = id
	item.display_name = display_name
	item.type = type
	item.quantity = 1
	return item
