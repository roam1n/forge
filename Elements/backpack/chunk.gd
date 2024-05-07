extends StaticBody2D

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var dot: Polygon2D = $Dot

@export var data: Chunk :
	set(v):
		data = v
		_update_polygon(data.polygon)

func _ready() -> void:
	_update_polygon(data.polygon)

# dot 不会跟随chunk一起旋转
func _set(property: StringName, value: Variant) -> bool:
	if property == "rotation_degrees":
		dot.rotation_degrees = -value
		rotation_degrees = value
		return true
	return false

# 根据当前chunk的数据生成多边形
func _update_polygon(new_polygon) -> void:
	if collision_polygon_2d is CollisionPolygon2D:
		collision_polygon_2d.polygon = new_polygon
	if polygon_2d is Polygon2D:
		polygon_2d.polygon = new_polygon
