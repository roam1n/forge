extends CharacterBody2D

var bullet_scene = preload("res://Scenes/TestRoom/bullet.tscn")

var speed = 100

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
	$face_direction.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("mouse_left"):
		fire()

func fire():
	var bullet = bullet_scene.instantiate()
	bullet.direction = $face_direction/Marker2D.global_position - global_position
	bullet.global_position = $face_direction/Marker2D.global_position
	get_tree().get_root().add_child(bullet)
