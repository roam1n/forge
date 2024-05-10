extends CharacterBody2D

var bullet_scene = preload("res://Scenes/TestRoom/bullet.tscn")

var speed = 100
var can_shoot = true

func _ready():
	$FireRate_Timer.wait_time = Global.current_weapon_fire_rate

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
	$face_direction.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("mouse_left") && can_shoot:
		fire()
		can_shoot = false
		$FireRate_Timer.start()

func fire():
	var bullet = bullet_scene.instantiate()
	bullet.damage = Global.current_weapon_damage
	bullet.direction = $face_direction/Marker2D.global_position - global_position
	bullet.global_position = $face_direction/Marker2D.global_position
	get_tree().get_root().add_child(bullet)

func _on_fire_rate_timer_timeout():
	can_shoot=true
