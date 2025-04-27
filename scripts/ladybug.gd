extends CharacterBody2D

@export var bullet_scene: PackedScene
var health = 10

func hurt():
	health -= 1
	if health == 0:
		queue_free()

func _ready() -> void:
	add_to_group("enemies")

func bulletSpawner():
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.position = position 
	get_parent().add_child(bullet_instance)
	
func _process(delta):
	pass

func _on_bullet_timer_timeout() -> void:
	bulletSpawner()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.player = body
