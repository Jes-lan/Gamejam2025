extends Node2D


func _on_texture_button_pressed() -> void:
	SceneTransition.change_scene_to_file("res://scenes/level_1.tscn")
