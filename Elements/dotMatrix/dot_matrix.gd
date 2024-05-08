extends Node2D


const SOLID_DOT:PackedScene = preload("res://Elements/dotMatrix/solid_dot.tscn")

@export var curr_mold: Mold

# 当鼠标移到点的区域范围内，返回这个点的位置信息
signal active_dot(dot_position:Vector2)

const DISTANCE:float = 30.01

func _ready() -> void:
	generate_dot_matrix(curr_mold.solid_dots)

func generate_dot_matrix(solids:PackedVector2Array) -> void:
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
