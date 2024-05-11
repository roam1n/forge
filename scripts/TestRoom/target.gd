extends Node2D

signal requirement_reached

var health = 10
var max_health = 10

var one_time_kill = false
var regain_health = false
var regain_health_rate = 5
var shoot_range = 0

func _ready():
	health = max_health
	$ProgressBar.max_value = max_health
	$ProgressBar.value = max_health
	$StaticBody2D/Circle_collision.shape.radius = shoot_range


func _process(delta):
	if regain_health:
		health += regain_health_rate * delta
		health = min(health, max_health)
		$ProgressBar.value = health

func take_damage(damage: int):
	health -= damage
	$ProgressBar.value = health
	if health <= 0:
		# reach the requirement
		await emit_signal("requirement_reached")
		queue_free()

	elif one_time_kill:
		# fail the requirement
		health = max_health
		$ProgressBar.value = max_health

func _draw():
	draw_circle_arc(Vector2.ZERO, shoot_range, 0, 360, Color.WHITE)

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

