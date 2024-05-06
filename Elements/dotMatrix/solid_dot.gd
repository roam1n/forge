extends Area2D


signal current_dot_position(position: Vector2)


func _ready() -> void:
	print("dot ready ", position)

func _on_mouse_entered() -> void:
	print("current dot position: ", position)
	#current_dot_position.emit(position)

func _on_mouse_exited() -> void:
	print("leave dot position: ", position)
