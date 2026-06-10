extends Control

func _get_drag_data(position):
	var data :={
		"sprits" : $sprits.texture,
		"quantidade": $quantidade.text,
		"backup" : self
		}

	var preview = TextureRect.new()
	preview.texture = $sprits.texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.size = Vector2(32, 32)
	
	set_empyt_slot()
	set_drag_preview(preview)

	return data

func set_empyt_slot() -> void:
	$sprits.texture = null
	$quantidade.text = ""

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	# Slot vazio
	if $sprits.texture == null:
		$sprits.texture = data.sprits
		$quantidade.text = data.quantidade
		return

	if $sprits.texture == data.sprits:
		var total = int($quantidade.text) + int(data.quantidade)
		$quantidade.text = str(total)

		data.backup.get_node("sprits").texture = null
		data.backup.get_node("quantidade").text = ""

	else:
		var textura_antiga = $sprits.texture
		var quantidade_antiga = $quantidade.text

		$sprits.texture = data.sprits
		$quantidade.text = data.quantidade

		data.backup.get_node("sprits").texture = textura_antiga
		data.backup.get_node("quantidade").text = quantidade_antiga
