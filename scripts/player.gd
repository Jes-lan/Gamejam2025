extends CharacterBody2D


var SPEED = 300.0
var JUMP_VELOCITY = -600.0


func _ready():
	Global.magazine = [$"../CanvasLayer/Bullet_0_5x", $"../CanvasLayer/Bullet_0_5x2", $"../CanvasLayer/Bullet_0_5x3", $"../CanvasLayer/Bullet_0_5x4", $"../CanvasLayer/Bullet_0_5x5", $"../CanvasLayer/Bullet_0_5x6", $"../CanvasLayer/Bullet_0_5x7", $"../CanvasLayer/Bullet_0_5x8", $"../CanvasLayer/Bullet_0_5x9", $"../CanvasLayer/Bullet_0_5x10"]
	
func movement(delta: float) -> void:
	if velocity.y > 0:
		$Camera2D.offset.y = lerp($Camera2D.offset.y, -20.0, 0.1)
	else:
		$Camera2D.offset.y = lerp($Camera2D.offset.y, -60.0, 0.1)

	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jumping") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Change speed to run.
	if Input.is_action_just_pressed("rolling"):
		SPEED = 600.0
	elif Input.is_action_just_released("rolling"):
		SPEED = 300.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction > 0:
			$Camera2D.offset.x = lerp($Camera2D.offset.x, 8.0, 0.1)
			$Sprite2D.flip_h = true
		elif direction < 0:
			$Camera2D.offset.x = lerp($Camera2D.offset.x, -20.0, 0.1)
			$Sprite2D.flip_h = false
			
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func _attack():
	if Global.currentBullet >= 0:
		# Attack logic here
		if Input.is_action_just_pressed("attack"):
			Global.magazine[Global.currentBullet].visible = false
			Global.currentBullet -= 1
			
			if Global.currentBullet == -1:
				$reloadTimer.start()
func reload():
	Global.currentBullet = 9
	Global.magazine[0].visible = true
	Global.magazine[1].visible = true
	Global.magazine[2].visible = true
	Global.magazine[3].visible = true
	Global.magazine[4].visible = true
	Global.magazine[5].visible = true
	Global.magazine[6].visible = true
	Global.magazine[7].visible = true
	Global.magazine[8].visible = true
	Global.magazine[9].visible = true

func hurt():
	# Hurt logic here
	Global.HEALTH -= 2
	$"../CanvasLayer/HealthBar".value = Global.HEALTH
	if Global.HEALTH <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _physics_process(delta: float) -> void:
	movement(delta)
	if !Input.is_action_pressed("rolling"):
		_attack()
		

	# Move the character.
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		body.hurt()


func _on_reload_timer_timeout() -> void:
	reload()
