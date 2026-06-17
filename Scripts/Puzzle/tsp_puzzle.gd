extends CanvasLayer

## Puzzle do Caixeiro Viajante (TSP).
## CanvasLayer layer=5, process_mode=ALWAYS — mesmo padrão do DialogueUI e PauseMenu.
## Pausa o jogo na abertura e retoma ao fechar.

signal puzzle_resolvido

# ── Tolerância: até 5 % 
const TOLERANCIA := 1.05

# ── Paleta ciano-futurista do Silent City 
const COR_NO          := Color(0.00, 0.85, 1.00, 1.00)
const COR_NO_INICIO   := Color(0.42, 1.00, 0.55, 1.00)
const COR_NO_HOVER    := Color(1.00, 1.00, 1.00, 1.00)
const COR_NO_VISITADO := Color(0.00, 0.50, 0.65, 1.00)
const COR_LINHA       := Color(0.00, 0.75, 1.00, 0.90)
const COR_DICA        := Color(1.00, 0.85, 0.00, 0.75)
const COR_TEXTO       := Color(0.85, 0.97, 1.00, 1.00)
const COR_ERRO        := Color(1.00, 0.27, 0.27, 1.00)
const COR_OK          := Color(0.42, 1.00, 0.55, 1.00)

const RAIO_NO     := 14.0
const RAIO_CLIQUE := 22.0

# ── Pontos fixos do puzzle (coordenadas dentro do DrawArea 460×300)
const PONTOS_PUZZLE: Array[Vector2] = [
	Vector2(230, 30),   # 0 — início (S), topo centro
	Vector2(390, 90),   # 1
	Vector2(420, 230),  # 2
	Vector2(290, 280),  # 3
	Vector2(110, 240),  # 4
	Vector2(60,  100),  # 5
]

# ── Estado interno
var _rota_otima:   Array      = []
var _custo_otimo:  float      = 0.0
var _rota_jogador: Array[int] = []
var _no_hover:     int        = -1
var _tentativas:   int        = 0
var _resolvido:    bool       = false
var _dica_visivel: bool       = false

# ── Referências aos nós da cena (.tscn) 
@onready var _draw_area:   Control = $Painel/DrawArea
@onready var _linha:       Line2D  = $Painel/DrawArea/Linha
@onready var _linha_dica:  Line2D  = $Painel/DrawArea/LinhaDica
@onready var _label_custo: Label   = $Painel/Rodape/Custo
@onready var _label_otimo: Label   = $Painel/Rodape/Otimo
@onready var _label_status:Label   = $Painel/Rodape/Status
@onready var _btn_dica:    Button  = $Painel/Rodape/BtnDica
@onready var _btn_limpar:  Button  = $Painel/Rodape/BtnLimpar
@onready var _btn_fechar:  Button  = $Painel/Rodape/BtnFechar


func _ready() -> void:
	layer = 5
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Configura as duas Line2D
	_setup_linha(_linha,     COR_LINHA, 3.0)
	_setup_linha(_linha_dica,COR_DICA,  2.0)
	_linha_dica.visible = false

	# Conecta sinais dos botões
	_btn_limpar.pressed.connect(_limpar_rota)
	_btn_fechar.pressed.connect(_fechar)
	_btn_dica.pressed.connect(_mostrar_dica)

	# Conecta o sinal draw do DrawArea (Godot 4: Control emite "draw" a cada queue_redraw)
	_draw_area.draw.connect(_on_draw_area_draw)
	_draw_area.gui_input.connect(_on_draw_area_gui_input)
	_draw_area.mouse_exited.connect(func():
		_no_hover = -1
		_draw_area.queue_redraw()
	)

	# Calcula a rota ótima uma vez ao abrir
	var resultado := TSP.solve(PONTOS_PUZZLE)
	_rota_otima  = resultado["route"]
	_custo_otimo = resultado["cost"]

	_label_otimo.text  = "Ótimo: %.1f" % _custo_otimo
	_label_status.text = "Comece pelo nó verde (S)"
	_label_custo.text  = "Seu custo: —"

	get_tree().paused = true


# ── Input 

func _on_draw_area_gui_input(event: InputEvent) -> void:
	if _resolvido:
		return

	if event is InputEventMouseMotion:
		var novo := _indice_perto(event.position)
		if novo != _no_hover:
			_no_hover = novo
			_draw_area.queue_redraw()

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var idx := _indice_perto(event.position)
			if idx == -1:
				return
			if _rota_jogador.is_empty() and idx != 0:
				_piscar_status("Comece pelo nó verde (S)!", COR_ERRO)
				return
			if _rota_jogador.has(idx):
				_piscar_status("Nó já visitado!", COR_ERRO)
				return
			_adicionar_no(idx)


func _indice_perto(pos: Vector2) -> int:
	for i in range(PONTOS_PUZZLE.size()):
		if pos.distance_to(PONTOS_PUZZLE[i]) <= RAIO_CLIQUE:
			return i
	return -1


# ── Lógica 

func _adicionar_no(idx: int) -> void:
	_rota_jogador.append(idx)
	_linha.add_point(PONTOS_PUZZLE[idx])
	_draw_area.queue_redraw()

	var custo := _custo_rota(_rota_jogador)
	_label_custo.text = "Seu custo: %.1f" % custo

	if _rota_jogador.size() == PONTOS_PUZZLE.size():
		_verificar_solucao()


func _custo_rota(rota: Array) -> float:
	var total := 0.0
	for i in range(rota.size() - 1):
		total += PONTOS_PUZZLE[rota[i]].distance_to(PONTOS_PUZZLE[rota[i + 1]])
	return total


func _verificar_solucao() -> void:
	_tentativas += 1
	var custo := _custo_rota(_rota_jogador)

	if custo <= _custo_otimo * TOLERANCIA:
		_resolvido = true
		_piscar_status("✓ Rota aceita! Terminal ativado.", COR_OK)
		_btn_dica.disabled = false
		_btn_dica.text = "Ver rota ótima"
		var t := create_tween()
		t.tween_interval(1.8)
		t.tween_callback(_concluir)
	else:
		var pct := (custo / _custo_otimo - 1.0) * 100.0
		_piscar_status("%.1f%% acima do ótimo — tente outra rota." % pct, COR_ERRO)
		if _tentativas >= 3:
			_btn_dica.disabled = false


func _concluir() -> void:
	GameState.set_flag("tsp_resolvido", true)
	emit_signal("puzzle_resolvido")
	_fechar()


# ── Ações de UI 

func _mostrar_dica() -> void:
	_dica_visivel = not _dica_visivel
	_linha_dica.visible = _dica_visivel
	if _dica_visivel:
		_linha_dica.clear_points()
		for idx in _rota_otima:
			_linha_dica.add_point(PONTOS_PUZZLE[idx])
		_btn_dica.text = "Ocultar dica"
	else:
		_btn_dica.text = "Ver dica"


func _limpar_rota() -> void:
	_rota_jogador.clear()
	_linha.clear_points()
	_label_custo.text  = "Seu custo: —"
	_label_status.text = "Comece pelo nó verde (S)"
	_label_status.modulate = COR_TEXTO
	_dica_visivel = false
	_linha_dica.visible = false
	_btn_dica.text = "Ver dica"
	_draw_area.queue_redraw()


func _fechar() -> void:
	get_tree().paused = false
	queue_free()


func _piscar_status(texto: String, cor: Color) -> void:
	_label_status.text = texto
	_label_status.modulate = cor
	var t := create_tween()
	t.tween_interval(2.0)
	t.tween_callback(func():
		if not _resolvido:
			_label_status.text = "Conecte todos os nós"
			_label_status.modulate = COR_TEXTO
	)


# ── Desenho dos nós 

func _setup_linha(l: Line2D, cor: Color, largura: float) -> void:
	l.default_color = cor
	l.width = largura
	l.joint_mode  = Line2D.LINE_JOINT_ROUND
	l.begin_cap_mode = Line2D.LINE_CAP_ROUND
	l.end_cap_mode   = Line2D.LINE_CAP_ROUND
	l.antialiased = true


func _on_draw_area_draw() -> void:
	var fonte: Font = ThemeDB.fallback_font
	const TAM_FONTE := 12

	for i in range(PONTOS_PUZZLE.size()):
		var p       := PONTOS_PUZZLE[i]
		var visitado := _rota_jogador.has(i)
		var hover    := (i == _no_hover and not visitado)

		# Escolhe cor base do nó
		var cor_base: Color
		if i == 0:
			cor_base = COR_NO_INICIO
		elif visitado:
			cor_base = COR_NO_VISITADO
		else:
			cor_base = COR_NO

		# Glow (anel externo semitransparente)
		_draw_area.draw_circle(p, RAIO_NO + 5.0, Color(cor_base, 0.20))
		_draw_area.draw_circle(p, RAIO_NO + 2.0, Color(cor_base, 0.12))

		# Círculo principal
		var cor_final := COR_NO_HOVER if hover else cor_base
		_draw_area.draw_circle(p, RAIO_NO, cor_final)

		# Rótulo: "S" para o início, número para os demais
		var label := "S" if i == 0 else str(i)
		var tam := fonte.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, TAM_FONTE)
		_draw_area.draw_string(
			fonte,
			p - Vector2(tam.x * 0.5, -TAM_FONTE * 0.35),
			label,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			TAM_FONTE,
			Color(0.04, 0.06, 0.10, 1.0)
		)

	# Preview tracejado: último nó → nó sob o cursor
	if _no_hover != -1 and not _rota_jogador.is_empty() and not _rota_jogador.has(_no_hover):
		var a := PONTOS_PUZZLE[_rota_jogador[-1]]
		var b := PONTOS_PUZZLE[_no_hover]
		_draw_area.draw_dashed_line(a, b, Color(COR_LINHA, 0.30), 1.5, 8.0)