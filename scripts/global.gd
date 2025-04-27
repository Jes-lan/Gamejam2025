extends Node

var HEALTH = 3
var magazine: Array[Sprite2D]
var currentBullet = 9
@onready var health_bar = $CanvasLayer/HealthBar
@onready var audio = $"Mount&BladeSoundtrack-SwadianHall(KalimbaCover)"

var player = null

func _process(delta):
	if HEALTH <= 0:
		SceneTransition.change_scene_to_file("res://scenes/main_menu.tscn")
		HEALTH = 3
