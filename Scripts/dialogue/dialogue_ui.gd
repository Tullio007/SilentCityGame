extends CanvasLayer

var _manager: DialogueManager = null
var _ativo := false

# Memória mostrada por etapas (uma a cada Enter), como o diálogo do Marcos.
var _modo_memoria := false
var _memoria_etapas: PackedStringArray = PackedStringArray()
var _memoria_idx := 0

@onready var panel: Panel = $Panel
@onready var speaker_label: Label = $Panel/Margin/VBox/Speaker
@onready var text_label: Label = $Panel/Margin/VBox/Texto
@onready var options_box: VBoxContainer = $Panel/Margin/VBox/Opcoes
@onready var continuar_hint: Label = $Panel/Margin/VBox/Continuar


func _ready() -> void:
	panel.visible = false


func start(manager: DialogueManager, npc_id: String, phase: int) -> void:
	if _ativo or manager == null:
		return
	_manager = manager
	_ativo = true
	if not _manager.dialogue_node.is_connected(_on_dialogue_node):
		_manager.dialogue_node.connect(_on_dialogue_node)
	if not _manager.dialogue_finished.is_connected(_on_dialogue_finished):
		_manager.dialogue_finished.connect(_on_dialogue_finished)
	panel.visible = true
	get_tree().paused = true
	_manager.start_dialogue(npc_id, phase)


func _on_dialogue_node(speaker: String, text: String, options: Array) -> void:
	speaker_label.text = speaker
	text_label.text = text

	for child in options_box.get_children():
		child.queue_free()

	if options.is_empty():
		options_box.visible = false
		continuar_hint.visible = true
	else:
		continuar_hint.visible = false
		options_box.visible = true
		for i in options.size():
			var b := Button.new()
			b.text = str(options[i].get("text", "..."))
			b.pressed.connect(AudioManager.play_button_click)
			b.pressed.connect(_manager.choose.bind(i))
			options_box.add_child(b)


func _on_dialogue_finished() -> void:
	_fechar()


func _fechar() -> void:
	if _manager:
		if _manager.dialogue_node.is_connected(_on_dialogue_node):
			_manager.dialogue_node.disconnect(_on_dialogue_node)
		if _manager.dialogue_finished.is_connected(_on_dialogue_finished):
			_manager.dialogue_finished.disconnect(_on_dialogue_finished)
	_manager = null
	_ativo = false
	_modo_memoria = false
	panel.visible = false
	get_tree().paused = false


func show_memory(speaker: String, texto: String) -> void:
	if _ativo:
		return
	# Mostra a memória POR ETAPAS (uma a cada Enter), como o diálogo do Marcos,
	# em vez de despejar o texto inteiro. As etapas são os parágrafos do texto.
	_memoria_etapas = _dividir_em_etapas(texto)
	_memoria_idx = 0
	_modo_memoria = true
	speaker_label.text = speaker
	for child in options_box.get_children():
		child.queue_free()
	options_box.visible = false
	continuar_hint.visible = true
	text_label.text = _memoria_etapas[0]
	panel.visible = true
	_ativo = true
	get_tree().paused = true


func _dividir_em_etapas(texto: String) -> PackedStringArray:
	var etapas: PackedStringArray = PackedStringArray()
	for bruto in texto.split("\n\n", false):
		var t := bruto.strip_edges()
		if t != "":
			etapas.append(t)
	if etapas.is_empty():
		etapas.append(texto.strip_edges())
	return etapas


func _input(event: InputEvent) -> void:
	if not _ativo:
		return
	# Com opções na tela, o avanço é feito pelos botões.
	if options_box.visible and options_box.get_child_count() > 0:
		return
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		AudioManager.play_dialogue_skip()
		if _modo_memoria:
			_memoria_idx += 1
			if _memoria_idx < _memoria_etapas.size():
				text_label.text = _memoria_etapas[_memoria_idx]
			else:
				_fechar()
			return
		if _manager:
			_manager.next()
		else:
			_fechar()
