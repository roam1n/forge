extends Area2D

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var dot: Polygon2D = $Dot

signal focus_chunk(chunk: Area2D)
signal unfocus_chunk(chunk: Area2D)

@export var data: Chunk :
	set(v):
		data = v
		_update_polygon(data.polygon)

const ROTATE_DEGREES: float = 45.0


func _ready() -> void:
	_update_polygon(data.polygon)
	polygon_2d.color = data.color
	if owner:
		focus_chunk.connect(owner._on_chunk_be_focused)
		unfocus_chunk.connect(owner._on_chunk_unfocused)

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

# 按住鼠标左键移动chunk，点击一下鼠标右键旋转一次块
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left"):
		print("mouse left pressed")
		focus_chunk.emit(self)
	elif event.is_action_released("mouse_left"):
		print("mouse left released")
		unfocus_chunk.emit(self)
	elif event.is_action_pressed("mouse_right"):
		rotation_degrees = _rotate_chunk(rotation_degrees)
		print("rotation: ", rotation_degrees)

# 控制chunk每次旋转的角度，将值域控制在[0,360)中
func _rotate_chunk(current_degrees:float) -> float:
	if current_degrees >= 360.0 - ROTATE_DEGREES:
		return current_degrees - 360.0 + ROTATE_DEGREES
	return current_degrees + ROTATE_DEGREES

# 重叠的区域如果属于chunk组，就多边形颜色变红
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("chunk"):
		polygon_2d.color = Color.CRIMSON

# 没有重叠的区域属于chunk组，就多边形颜色恢复data.color
func _on_area_exited(_area: Area2D) -> void:
	polygon_2d.color = data.color
	for overlap_area in get_overlapping_areas():
		if overlap_area.is_in_group("chunk"):
			polygon_2d.color = Color.CRIMSON
