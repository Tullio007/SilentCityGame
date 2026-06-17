extends CanvasLayer

## HUD de objetivos da fase (#58). Construído por código e instanciado pela
## cena. Acompanha o loop: derrotar inimigos → ativar o terminal (TSP) →
## pegar o cartão → escapar pela porta. Estética ciano do Silent City + Oxanium.

const _FONT := preload("res://Assets/Fonts/Oxanium/Oxanium-VariableFont_wght.ttf")
const _CIANO := Color(0.00, 0.85, 1.00)
const _VERDE := Color(0.42, 1.00, 0.55)
const _APAGADO := Color(0.62, 0.74, 0.82)

var _labels: Array[Label] = []
var _viu_inimigos := false
var _venceu := false

const _PASSOS := [
	"Derrotar os inimigos",
	"Ativar o terminal (TSP)",
	"Pegar o cartão de acesso",
	"Escapar pela porta",
]


func _ready() -> void:
	layer = 3
	process_mode = Node.PROCESS_MODE_ALWAYS

	var panel := PanelContainer.new()
	panel.anchor_left = 1.0
	panel.anchor_right = 1.0
	panel.offset_left = -332.0
	panel.offset_top = 14.0
	panel.offset_right = -14.0
	panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN

	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.03, 0.06, 0.10, 0.80)
	sb.border_color = Color(_CIANO.r, _CIANO.g, _CIANO.b, 0.55)
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(6)
	sb.content_margin_left = 14.0
	sb.content_margin_right = 14.0
	sb.content_margin_top = 10.0
	sb.content_margin_bottom = 10.0
	panel.add_theme_stylebox_override("panel", sb)
	add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 5)
	panel.add_child(vbox)

	var titulo := Label.new()
	titulo.text = "OBJETIVOS"
	titulo.add_theme_font_override("font", _FONT)
	titulo.add_theme_font_size_override("font_size", 16)
	titulo.add_theme_color_override("font_color", _CIANO)
	vbox.add_child(titulo)

	for t in _PASSOS:
		var l := Label.new()
		l.text = "○  " + t
		l.add_theme_font_override("font", _FONT)
		l.add_theme_font_size_override("font_size", 15)
		l.add_theme_color_override("font_color", _APAGADO)
		vbox.add_child(l)
		_labels.append(l)


func marcar_vitoria() -> void:
	_venceu = true


func _process(_delta: float) -> void:
	var n_inimigos := get_tree().get_nodes_in_group("enemy").size()
	if n_inimigos > 0:
		_viu_inimigos = true
	var sem_inimigos := _viu_inimigos and n_inimigos == 0

	_atualizar(0, sem_inimigos)
	_atualizar(1, GameState.get_flag("tsp_resolvido") == true)
	_atualizar(2, Inventory.has_item("chave"))
	_atualizar(3, _venceu)


func _atualizar(i: int, feito: bool) -> void:
	var l := _labels[i]
	if feito:
		l.text = "✓  " + _PASSOS[i]
		l.add_theme_color_override("font_color", _VERDE)
	else:
		l.text = "○  " + _PASSOS[i]
		l.add_theme_color_override("font_color", _APAGADO)
