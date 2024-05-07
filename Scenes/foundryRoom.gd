extends Node2D


@onready var chunk: StaticBody2D = $Chunk

const ROTATE_DEGREES: float = 45.0

var _is_focusing_chunk: bool = false

func _ready() -> void:
	_is_focusing_chunk = true

func _physics_process(_delta: float) -> void:
	if _is_focusing_chunk or (get_local_mouse_position() - chunk.position).length() >= 25.0:
		_is_focusing_chunk = true
		chunk.rotation_degrees = _rotate_chunk(chunk.rotation_degrees)

	if Input.is_action_just_pressed("mouse_right"):
		chunk.rotation_degrees = _rotate_chunk(chunk.rotation_degrees)
		print("rotation: ", chunk.rotation_degrees)

func _on_dot_matrix_active_dot(dot_position: Vector2) -> void:
	chunk.position = dot_position
	_is_focusing_chunk = false

# 控制chunk每次旋转的角度，将值域控制在[0,360)中
func _rotate_chunk(current_degrees:float) -> float:
	if current_degrees >= 360.0 - ROTATE_DEGREES:
		return current_degrees - 360.0 + ROTATE_DEGREES
	return current_degrees + ROTATE_DEGREES
