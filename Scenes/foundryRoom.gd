extends Node2D


var _is_focusing_chunk: bool = false
var focus_chunk: Node2D

func _ready() -> void:
	_is_focusing_chunk = true

func _physics_process(_delta: float) -> void:
	if focus_chunk:
		if _is_focusing_chunk or (get_global_mouse_position() - focus_chunk.position).length() >= 25.0:
			_is_focusing_chunk = true
			focus_chunk.position = get_global_mouse_position()

func _on_dot_matrix_active_dot(dot_position: Vector2) -> void:
	if focus_chunk:
		_is_focusing_chunk = false
		focus_chunk.position = dot_position

func _on_chunk_be_focused(chunk: Area2D) -> void:
	focus_chunk = chunk
	print("focus chunk: ", chunk)

func _on_chunk_unfocused(chunk: Area2D) -> void:
	if focus_chunk.get_instance_id() == chunk.get_instance_id():
		focus_chunk = null
