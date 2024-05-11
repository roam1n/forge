class_name Chunk
extends Resource

@export var name: String
@export var polygon: PackedVector2Array :
	set(value):
		_format_polygon = _handle_polygon(value)
		polygon = value
@export_color_no_alpha var color: Color = Color.GAINSBORO
@export var patterns_data: Dictionary

var _format_polygon: PackedVector2Array


# 通过遍历点，生成可生成魔纹的中心点位置及包含魔纹哪些部分
func generate_patterns_data() -> void:
	for i in range(1,4):
		for r in range(0,8):
			var ratation = r*0.25*PI
			_check_point_of_ring(i, ratation)

# 目前点的数据为了相邻的点不产生重叠，有一定点偏移量
func _check_point_of_ring(num: int, curr_rotation:float = 0.0) -> void:
	var format_polygon = _format_polygon * Transform2D(curr_rotation, Vector2(0,0))
	var points: PackedVector2Array = _generate_square_points(Vector2(0,0), num)
	for point in points:
		var ring_points: PackedVector2Array = _generate_square_points(point, 1)
		var intersect_polygons: Array[PackedVector2Array] = Geometry2D.intersect_polygons(ring_points , format_polygon)
		if intersect_polygons.size() > 0:
			var edges: Array = intersect_polygons.map(func(i): return _check_same_edges(i * Transform2D(0.0, point)))[0]
			if edges.size() > 0:
				# 记录相交的点，点的旋转(小数点三位)和点包含点边
				patterns_data[Vector3(point.x, point.y, roundf(curr_rotation*1000.0)/1000.0)] = edges

# 围绕中心点，生成正方形
func _generate_square_points(center: Vector2, size: int) -> PackedVector2Array:
	var points: PackedVector2Array = PackedVector2Array()
	# 计算正方形的四个角的位置
	var top_left: Vector2 = center + Vector2(-size, -size)
	var top_right: Vector2 = center + Vector2(size, -size)
	var bottom_right: Vector2 = center + Vector2(size, size)
	var bottom_left: Vector2 = center + Vector2(-size, size)
	# 顶边
	for x in range(top_left.x, top_right.x):
		points.append(Vector2(x, top_left.y))
	# 右边
	for y in range(top_right.y, bottom_right.y):
		points.append(Vector2(top_right.x, y))
	# 底边
	for x in range(bottom_right.x, bottom_left.x, -1):
		points.append(Vector2(x, bottom_right.y))
	# 左边
	for y in range(bottom_left.y, top_left.y, -1):
		points.append(Vector2(bottom_left.x, y))
	return points

# 将polygon中点0.999变成1等等
func _handle_polygon(curr_polygon: PackedVector2Array) -> PackedVector2Array:
	var format_polygon: PackedVector2Array = []
	for point in curr_polygon:
		format_polygon.append(Vector2(round(point.x), round(point.y)))
	return format_polygon

# 找到与魔纹的正方形重叠的边
func _check_same_edges(polygon_a: PackedVector2Array) -> Array:
	var points = _generate_square_points(Vector2(0,0), 1)
	var p_i: int = 1
	var edges: Array = []
	points.append(Vector2(-1,-1))
	var new_polygon = _filter_points(polygon_a)
	# 三个点以上才是闭合的形状
	if new_polygon.size() < 3 :
		return []
	while p_i < points.size():
		var a = PackedVector2Array([Vector2(0,0),points[p_i - 1],points[p_i]])
		var t = Geometry2D.intersect_polygons(new_polygon, a)
		if t.size()>0 and abs(_calculate_polygon_area(t[0]) - _calculate_polygon_area(a)) < 0.01:
			edges.append(p_i)
		p_i += 1
	return edges

# 过滤掉小数点后面有数字的点
func _filter_points(polygon_a: PackedVector2Array) -> PackedVector2Array:
	var filtered_points = []
	for point in polygon_a:
		if point.x == round(point.x) and point.y == round(point.y):
			filtered_points.append(point)
	return filtered_points

# 计算多边形的面积
func _calculate_polygon_area(polygon_a: PackedVector2Array) -> float:
	var area: float = 0.0
	var n: int = polygon_a.size()
	for i in range(n):
		var j: int = (i + 1) % n
		area += polygon_a[i].x * polygon_a[j].y
		area -= polygon_a[i].y * polygon_a[j].x
	return abs(area) / 2.0
