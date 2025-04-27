# bullet.gd
extends Area2D # Or whatever root node you chose

@export var speed = 1.0 # Pixels per second, adjustable in Inspector

# Called when the node enters the scene tree for the first time.
func _ready():
	# Optional: Connect the body_entered signal if you want the bullet
	# to detect hitting physics bodies (like enemies)
	# connect("body_entered", Callable(self, "_on_body_entered"))
	pass # You might set initial direction here if not done by the spawner

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move()
	
# Optional: Function to handle collision

func move():
	var direction = global_position - Global.player.global_position
	direction = -1 * direction.normalized()
	position += direction * speed

func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.HEALTH -= 1
	queue_free() # Destroy the bullet after hitting something

# Optional: Function to destroy bullet if it goes off-screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Destroy the bullet
	# Note: You need to add a VisibleOnScreenNotifier2D node to your
	# bullet scene and connect its screen_exited signal to this function
	# via the Node tab in the editor.
