extends Area2D

var direction = Vector2.RIGHT
var speed = 100
var damage = 5
var start_pos

func _ready():
	start_pos = position

func _process(delta):
	var velocity = direction.normalized() * speed * delta
	var new_pos = position + velocity
	if start_pos.distance_to(new_pos) >= Global.current_weapon_range:
		queue_free()
	else:
		translate(velocity)

func _on_bullet_body_entered(body):
	if body.is_in_group("Targets"):
		body.take_damage(damage)
	queue_free()
