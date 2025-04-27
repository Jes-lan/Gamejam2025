extends CharacterBody2D


var SPEED = 300.0
var JUMP_VELOCITY = -750.0
var canAttack = true
var attacked = false
var isRolling = false

@onready var animController = $AnimatedSprite2D

func animHandler():
	if velocity.x == 0 and !attacked:
		animController.play("idle")
	
	if attacked:
		animController.play("attack")
		$AnimatedSprite2D2.play("blast")
	
	if isRolling:
		animController.play("rolling")
	
func _ready():
	add_to_group("player")
	$Area2D.scale.x = 0
	$Area2D.scale.y = 0
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
		isRolling = true
	elif Input.is_action_just_released("rolling"):
		SPEED = 300.0
		isRolling = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction > 0:
			$Camera2D.offset.x = lerp($Camera2D.offset.x, 8.0, 0.1)
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D2.flip_h = true
			$AnimatedSprite2D2.position.x = 186
			$Area2D.rotation = 0
			$HurtBox.position = Vector2i(-33, 27)
		elif direction < 0:
			$Camera2D.offset.x = lerp($Camera2D.offset.x, -20.0, 0.1)
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D2.flip_h = false
			$AnimatedSprite2D2.position.x = -216
			$Area2D.rotation_degrees = 180
			$HurtBox.position = Vector2i(20, 27)
			
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func _attack():
	if Global.currentBullet >= 0 and canAttack and !attacked and !isRolling:
		$Area2D.scale.x = 1
		$Area2D.scale.y = 1
		# Attack logic here
		canAttack = false
		attacked = true
		Global.magazine[Global.currentBullet].visible = false
		Global.currentBullet -= 1
		$attackTimer.start()
		if Global.currentBullet == -1:
			$reloadTimer.start()
	pass

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
	Global.HEALTH -= 1
	$"../CanvasLayer/HealthBar".value = Global.HEALTH
	
func _physics_process(delta: float) -> void:
	movement(delta)
	if Input.is_action_just_pressed("attack"):
		_attack()
		
	animHandler()
	# Move the character.
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.hurt()


func _on_reload_timer_timeout() -> void:
	reload()


func _on_attack_timer_timeout() -> void:
	$Area2D.scale.x = 0
	$Area2D.scale.y = 0
	canAttack = true
	attacked = false
