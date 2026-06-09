extends Node


func _ready() -> void:

	var points: Array[Vector2] = [
		Vector2(0, 0),
		Vector2(10, 5),
		Vector2(20, 15),
		Vector2(5, 25),
		Vector2(30, 10)
	]

	var result := TSP.solve(points)

	print("====================")
	print("RESULTADO DO TSP")
	print("====================")
	print("Rota: ", result["route"])
	print("Custo: ", result["cost"])