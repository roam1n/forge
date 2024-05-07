extends Area2D


signal current_dot_position(position: Vector2)

func _ready() -> void:
	print("dot ready ", position)
	
	mouse_entered.connect(_on_mouse_entered)
	if owner:
		mouse_exited.connect(owner._on_solid_dot_mouse_exited)
		current_dot_position.connect(owner._on_solid_dot_mouse_entered)

func _on_mouse_entered() -> void:
	print("current dot position: ", position)
	current_dot_position.emit(position)
