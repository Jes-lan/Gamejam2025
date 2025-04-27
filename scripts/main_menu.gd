extends Node2D



func _on_texture_button_pressed() -> void:
	SceneTransition.change_scene_to_file("res://scenes/level_1.tscn")
	Global.audio.stop()


func _on_texture_button_2_button_down() -> void:
	SceneTransition.change_scene_to_file("res://scenes/options.tscn")


func _on_texture_button_3_pressed() -> void:
	SceneTransition.change_scene_to_file("res://scenes/how_to_play.tscn")


func _on_texture_button_4_pressed() -> void:
	get_tree().quit()
