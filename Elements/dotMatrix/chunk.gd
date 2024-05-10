extends Area2D

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var polygon_2d_2: Polygon2D = $Polygon2D2
@onready var dot: Polygon2D = $Dot

const _011 = preload("res://assets/magic_patterns/011.png")
const ROTATE_DEGREES: float = 45.0
const CHUNK_SCALE: float = 8.0

signal focus_chunk(chunk: Area2D)
signal unfocus_chunk(chunk: Area2D)

@export var data: Chunk :
	set(v):
		data = v
		_update_polygon(data.polygon)
var pattern_edges: Array
var pattern_center: Vector2
var _pattern_area: Area2D
var _pattern_scope: Polygon2D
var _pattern_rotation: float
var _pattern_texture := _011
var _is_overlap :bool = false 


func _ready() -> void:
	_update_polygon(data.polygon)
	polygon_2d.color = data.color

# dot 不会跟随chunk一起旋转
func _set(property: StringName, value: Variant) -> bool:
	if property == "rotation_degrees":
		dot.rotation_degrees = -value
		rotation_degrees = value
		return true
	return false

# 根据当前chunk的数据生成多边形
func _update_polygon(base_polygon) -> void:
	var new_polygon: PackedVector2Array = PackedVector2Array()
	for point in base_polygon:
		new_polygon.push_back(point * CHUNK_SCALE)
	
	if collision_polygon_2d is CollisionPolygon2D:
		collision_polygon_2d.polygon = new_polygon
	if polygon_2d is Polygon2D:
		polygon_2d.polygon = new_polygon
		polygon_2d_2.polygon = new_polygon
		polygon_2d_2.texture = _pattern_texture
		data.generate_patterns_data()

func generate_patters_data(key: Vector3) -> void:
	if data.patterns_data.size() > 0:
		if not data.patterns_data.get(key):
			key = data.patterns_data.keys().pick_random()
		pattern_center = Vector2(key.x, key.y)
		pattern_edges = data.patterns_data[key]
		_pattern_rotation = key.z
		polygon_2d_2.texture_offset = Vector2(CHUNK_SCALE,CHUNK_SCALE) - pattern_center * CHUNK_SCALE
		polygon_2d_2.texture_rotation = _pattern_rotation
		_handler_pattern_start()

# 按住鼠标左键移动chunk，点击一下鼠标右键旋转一次块
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_released("mouse_left"): # 因为块被禁止一旦离开区域范围 有可能会检测不到离开鼠标左键
		#print("mouse left released")
		unfocus_chunk.emit(self)
	elif event.is_action_pressed("mouse_left"):
		#print("mouse left pressed")
		focus_chunk.emit(self)
	elif event.is_action_pressed("mouse_right"):
		rotation_degrees = _rotate_chunk(rotation_degrees)
		#print("rotation: ", rotation_degrees)

# 控制chunk每次旋转的角度，将值域控制在[0,360)中
func _rotate_chunk(current_degrees:float) -> float:
	if current_degrees >= 360.0 - ROTATE_DEGREES:
		return current_degrees - 360.0 + ROTATE_DEGREES
	return current_degrees + ROTATE_DEGREES

# 重叠的区域如果属于chunk组，就多边形颜色变红
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("chunk"):
		_is_overlap = true
		polygon_2d.color = Color.CRIMSON

# 没有重叠的区域属于chunk组，就多边形颜色恢复data.color
func _on_area_exited(_area: Area2D) -> void:
	_is_overlap = false
	polygon_2d.color = data.color
	for overlap_area in get_overlapping_areas():
		if overlap_area.is_in_group("chunk"):
			_is_overlap = true
			polygon_2d.color = Color.CRIMSON

# chunk有编号1的边，新增分组patternStart，并且以魔纹为中心点建立边长为2*CHUNK_SCALE的正方形
func _handler_pattern_start() -> void:
	if pattern_edges.find(1) > -1:
		add_to_group("patternStart")
		var area2D = Area2D.new()
		var collision = CollisionShape2D.new()
		var shape2D = RectangleShape2D.new()
		shape2D.set_size(Vector2(2*CHUNK_SCALE, 2*CHUNK_SCALE))
		collision.shape = shape2D
		collision.position = pattern_center * CHUNK_SCALE * Transform2D(_pattern_rotation, Vector2(0,0))
		area2D.add_child(collision)
		area2D.monitorable = false
		area2D.area_entered.connect(_on_pattern_start_area_entered)
		area2D.area_exited.connect(_on_pattern_start_area_exited)
		add_child(area2D)
		_pattern_area = area2D
		_show_pattern_action_scope()

# 凸显被激活的魔纹
func _show_pattern_action_scope() -> void:
	var big_square: Polygon2D = Polygon2D.new()
	big_square.polygon = PackedVector2Array([Vector2(-3,-3)*CHUNK_SCALE, Vector2(3,-3)*CHUNK_SCALE, 
		Vector2(3,3)*CHUNK_SCALE, Vector2(-3,3)*CHUNK_SCALE])
	big_square.offset = big_square.offset * Transform2D(_pattern_rotation, - pattern_center * CHUNK_SCALE)
	big_square.color = Color(0.7,0.7,0.7,0.15)
	big_square.hide()
	_pattern_scope = big_square
	add_child(big_square)

# patternStart来检测周围的chunk是否能组成一个魔纹
func _on_pattern_start_area_entered(_area: Area2D) -> void:
	_check_pattern_action()

func _on_pattern_start_area_exited(_area: Area2D) -> void:
	_check_pattern_action()

func _check_pattern_action() -> void:
	var edges: Dictionary = {}
	for overlap_area in _pattern_area.get_overlapping_areas():
		# position+pattern_center == overlap_area.position+overlap_area.pattern_center and
		if overlap_area.get("pattern_edges") and not overlap_area._is_overlap and not _is_overlap:
			for edge in overlap_area.get("pattern_edges"):
				if edges.get(edge):
					break
				edges[edge] = true
	for edge in pattern_edges:
		if edges.get(edge):
			break
		edges[edge] = true
	if edges.keys().size() == 8:
		_pattern_scope.show()
	else:
		_pattern_scope.hide()
