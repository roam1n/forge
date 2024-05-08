extends Area2D

@onready var polygon_2d: Polygon2D = $Polygon2D

const DOT_TYPES_DATA: Dictionary = {
	"core": Color.CORNFLOWER_BLUE,
	"texture": Color.GOLDENROD,
	"output": Color.FOREST_GREEN
}
var dot_type: String :
	set(value):
		dot_type = value
		polygon_2d.color = DOT_TYPES_DATA[value]

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered() -> void:
	if owner and owner.active_dot:
		print("current dot position: ", position)
		# solid_dot的position是以dot_matrix为基点的
		owner.active_dot.emit(position + owner.position, dot_type)
