extends CharacterBody2D


var SPEED = 300.0
var JUMP_VELOCITY = -400.0

func movement(delta: float) -> void:
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
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


func _physics_process(delta: float) -> void:
	movement(delta)
	# Move the character.
	move_and_slide()
