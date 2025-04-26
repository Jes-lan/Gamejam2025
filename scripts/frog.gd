extends CharacterBody2D

var HEALTH = 2

func hurt():
	HEALTH -= 1
	if HEALTH <= 0:
		get_tree().queue_delete(self)
