extends Control

const CENA_JOGO := "res://Scenes/node_2d.tscn"

@onready var botao_iniciar: Button = $VBoxContainer/BotaoIniciar
@onready var botao_fechar: Button = $VBoxContainer/BotaoFechar

func _ready() -> void:
	botao_iniciar.pressed.connect(_on_iniciar_pressed)
	botao_fechar.pressed.connect(_on_fechar_pressed)
	botao_iniciar.grab_focus()

func _on_iniciar_pressed() -> void:
	print("Botão pressionado!")
	
	
	
	print("Trocando de cena para: ", CENA_JOGO)
	
	var erro = get_tree().change_scene_to_file(CENA_JOGO)
	
	if erro != OK:
		print("ERRO ao trocar de cena! Código: ", erro)
		print("Verifique se o caminho está correto: ", CENA_JOGO)

func _on_fechar_pressed() -> void:
	get_tree().quit()
