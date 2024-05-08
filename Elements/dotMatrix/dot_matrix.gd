extends Node2D


const SOLID_DOT:PackedScene = preload("res://Elements/dotMatrix/solid_dot.tscn")

@export var curr_mold: Mold

# 当鼠标移到点的区域范围内，返回这个点的位置信息
signal active_dot(dot_position:Vector2, dot_type:String)

const DISTANCE:float = 16.0

func _ready() -> void:
	generate_dot_matrix(curr_mold.core_dots, "core")
	generate_dot_matrix(curr_mold.texture_dots, "texture")
	generate_dot_matrix(curr_mold.output_dots, "output")

func generate_dot_matrix(solids:PackedVector2Array, dot_type:String) -> void:
	for solid in solids:
		var node:Node2D = SOLID_DOT.instantiate()
		add_child(node)
		node.owner = self
		# 绘制45度倾斜点阵
		if floori(solid.y) % 2 == 1:
			node.position.x = solid.x * DISTANCE + DISTANCE / 2.0
			node.position.y = solid.y * DISTANCE
		else:
			node.position = solid * DISTANCE
		# 设置点的类型
		node.dot_type = dot_type
		# 设置node的检测区域
		var collision:CollisionShape2D = node.get_node("CollisionShape2D")
		collision.shape.size = Vector2(DISTANCE, DISTANCE)
