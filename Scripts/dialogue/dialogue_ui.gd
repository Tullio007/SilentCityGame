extends CanvasLayer

var _manager: DialogueManager = null
var _ativo := false

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
	panel.visible = false
	get_tree().paused = false


func _input(event: InputEvent) -> void:
	if not _ativo:
		return
	# Com opções na tela, o avanço é feito pelos botões.
	if options_box.visible and options_box.get_child_count() > 0:
		return
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		if _manager:
			_manager.next()
