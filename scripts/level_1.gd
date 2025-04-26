extends Node2D

@onready var health_bar = $CanvasLayer/HealthBar

func _ready():
	print(health_bar)

func _process(delta):
	pass
