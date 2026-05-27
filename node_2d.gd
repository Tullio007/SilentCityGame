extends Node2D

@onready var player = $CharacterBody2D
@onready var health_bar = $CanvasLayer/HealthBar

func _process(delta):
	health_bar.value = player.vida
