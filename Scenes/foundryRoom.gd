extends Node2D

@onready var rigid_body_2d: CollisionObject2D = $RigidBody2D

const ROTATE_DEGREES: float = 45.0

var _is_focusing_chunk: bool = false

func _ready() -> void:
	_is_focusing_chunk = true

func _physics_process(_delta: float) -> void:
	if _is_focusing_chunk:
		rigid_body_2d.position = get_local_mouse_position()
	
	if Input.is_action_just_pressed("mouse_right"):
		rigid_body_2d.rotation_degrees = _rotate_chunk(rigid_body_2d.rotation_degrees)
		print("rotation: ", rigid_body_2d.rotation_degrees)

func _on_solid_dot_mouse_entered(dot_position: Vector2) -> void:
	rigid_body_2d.position = dot_position
	_is_focusing_chunk = false
	print("remove rigid body")

func _on_solid_dot_mouse_exited() -> void:
	_is_focusing_chunk = true
	print("leave area")

func _rotate_chunk(current_degrees:float) -> float:
	if current_degrees > 360.0 :
		return current_degrees - 360.0 + ROTATE_DEGREES
	return current_degrees + ROTATE_DEGREES
