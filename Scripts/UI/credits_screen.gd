extends CanvasLayer

## Tela de vitória → créditos (#58). Instanciada pela fase ao alcançar a WinZone.
## Fundo escuro, título "VITÓRIA", rolagem de créditos e um único CTA
## ("Jogar de novo"). A música de créditos já é disparada pela fase.

const _FONT := preload("res://Assets/Fonts/Oxanium/Oxanium-VariableFont_wght.ttf")
const _CIANO := Color(0.00, 0.85, 1.00)
const _BRANCO := Color(0.90, 0.97, 1.00)
const _SUAVE := Color(0.66, 0.78, 0.86)

# (texto, tamanho da fonte, cor) — uma linha vazia ("") vira um espaçador.
const _LINHAS := [
	["VITÓRIA", 64, "ciano"],
	["", 18, "suave"],
	["SILENT DISTRICT", 30, "branco"],
	["Capítulo Único", 20, "suave"],
	["", 30, "suave"],
	["— Equipe —", 22, "ciano"],
	["Tulio Machado", 20, "branco"],
	["Luís Arthur", 20, "branco"],
	["Kauê Anderson", 20, "branco"],
	["Bruno Duarte", 20, "branco"],
	["", 30, "suave"],
	["— Algoritmos —", 22, "ciano"],
	["Caixeiro Viajante · TSP (Held-Karp)", 18, "suave"],
	["Ordenação do inventário · Merge Sort", 18, "suave"],
	["", 40, "suave"],
	["Obrigado por jogar.", 24, "branco"],
]

var _roll: VBoxContainer


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS

	var bg := ColorRect.new()
	bg.color = Color(0.02, 0.03, 0.05, 1.0)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var vh := float(get_viewport().get_visible_rect().size.y)
	var vw := float(get_viewport().get_visible_rect().size.x)

	_roll = VBoxContainer.new()
	_roll.alignment = BoxContainer.ALIGNMENT_CENTER
	_roll.add_theme_constant_override("separation", 6)
	_roll.size.x = vw
	_roll.position = Vector2(0.0, vh + 20.0)
	add_child(_roll)

	for linha in _LINHAS:
		var l := Label.new()
		l.text = String(linha[0])
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.add_theme_font_override("font", _FONT)
		l.add_theme_font_size_override("font_size", int(linha[1]))
		l.add_theme_color_override("font_color", _cor(String(linha[2])))
		l.custom_minimum_size = Vector2(vw, 0.0)
		_roll.add_child(l)

	# CTA único, sempre disponível (também serve de "pular").
	var btn := Button.new()
	btn.text = "Jogar de novo"
	btn.add_theme_font_override("font", _FONT)
	btn.add_theme_font_size_override("font_size", 20)
	btn.anchor_left = 0.5
	btn.anchor_right = 0.5
	btn.anchor_top = 1.0
	btn.anchor_bottom = 1.0
	btn.offset_left = -110.0
	btn.offset_right = 110.0
	btn.offset_top = -64.0
	btn.offset_bottom = -20.0
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.04, 0.10, 0.14, 0.95)
	sb.border_color = _CIANO
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(6)
	btn.add_theme_stylebox_override("normal", sb)
	btn.add_theme_color_override("font_color", _CIANO)
	btn.pressed.connect(_on_jogar_de_novo)
	add_child(btn)

	# Mede a altura do conteúdo e rola de baixo para cima.
	await get_tree().process_frame
	await get_tree().process_frame
	var altura := _roll.size.y
	var t := create_tween()
	t.tween_property(_roll, "position:y", -(altura + 40.0), 16.0) \
		.set_trans(Tween.TRANS_LINEAR)


func _cor(nome: String) -> Color:
	match nome:
		"ciano":
			return _CIANO
		"suave":
			return _SUAVE
		_:
			return _BRANCO


func _on_jogar_de_novo() -> void:
	get_tree().paused = false
	Inventory.clear()
	GameState.set_flag("tsp_resolvido", false)
	get_tree().reload_current_scene()
