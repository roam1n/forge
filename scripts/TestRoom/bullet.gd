extends Area2D

var direction = Vector2.RIGHT
var speed = 100
var damage = 5

func _process(delta):
	translate(direction.normalized() * speed * delta)



func _on_bullet_body_entered(body):
	# do damage
	queue_free()
