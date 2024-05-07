extends Area2D


signal current_dot_position(position: Vector2)

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered() -> void:
	if owner and owner.active_dot:
		print("current dot position: ", position)
		owner.active_dot.emit(position)
