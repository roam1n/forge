extends Node2D

var health = 10

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		queue_free()
