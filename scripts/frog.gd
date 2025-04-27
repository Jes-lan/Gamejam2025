extends CharacterBody2D

var HEALTH = 2
@onready var animController = $AnimatedSprite2D
var isAttacking = false
var following = false
var player = null
var SPEED = 100

func _ready() -> void:
	add_to_group("enemies")

func _process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if following:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * SPEED
		
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	
	animHandler()
	move_and_slide()
	

func animHandler():
	if !isAttacking and velocity.x == 0:
		animController.play("idle")
	if velocity.x > 0 or velocity.x < 0 and !isAttacking:
		animController.play("walking")
	if isAttacking:
		animController.play("attack")
		
	

func hurt():
	HEALTH -= 1
	if HEALTH <= 0:
		get_tree().queue_delete(self)
		

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		following = true
		isAttacking = true
		$AttackTimer.start()
		player = body
		body.hurt()


func _on_attack_timer_timeout() -> void:
	isAttacking = false
