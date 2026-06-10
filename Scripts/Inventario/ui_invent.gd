extends CanvasLayer

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("inventario"):
		visible = !visible


func adicionar_item(texture: Texture2D, quantidade: int = 1):

	# Procura um slot que já tenha o mesmo item
	for slot in $GridContainer.get_children():

		if slot.get_node("sprits").texture == texture:
			var atual = int(slot.get_node("quantidade").text)
			slot.get_node("quantidade").text = str(atual + quantidade)
			return true

	# Procura um slot vazio
	for slot in $GridContainer.get_children():

		if slot.get_node("sprits").texture == null:
			slot.get_node("sprits").texture = texture
			slot.get_node("quantidade").text = str(quantidade)
			return true

	return false
