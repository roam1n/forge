extends Node2D

enum State {
	SelectRequest,
	Unmet,
	Met,
	Submit
}

const CHUNK = preload("res://Elements/dotMatrix/chunk.tscn")
const CHUNKS_DATA = [
	"res://dataTables/chunks/blaze.tres",
	"res://dataTables/chunks/life.tres",
	"res://dataTables/chunks/resonance.tres",
	"res://dataTables/chunks/starlight.tres",
	"res://dataTables/chunks/storm.tres",
	"res://dataTables/chunks/tidal.tres",
]

var _is_chunk_action: bool = false
var focus_chunk: Node2D
var state: State = State.SelectRequest


func _ready() -> void:
	_is_chunk_action = true
	_generate_chunks()

func _physics_process(_delta: float) -> void:
	# 检测鼠标左键是否依旧按下（如果取消了，信号传递需要一点反应时间，可能focus_chunk还有值）
	if focus_chunk and Input.is_action_pressed("mouse_left"):
		# 块在距离鼠标超过16后，会从禁止装变成活跃的
		if _is_chunk_action or (get_global_mouse_position() - focus_chunk.position).length() >= 12.0:
			_is_chunk_action = true
			focus_chunk.position = get_global_mouse_position()

func _on_dot_matrix_active_dot(dot_position: Vector2, _dot_type: String) -> void:
	# 被吸附到点的块，会被禁止行动
	if focus_chunk:
		_is_chunk_action = false
		focus_chunk.position = dot_position

func _on_chunk_be_focused(chunk: Area2D) -> void:
	_is_chunk_action = true
	focus_chunk = chunk

func _on_chunk_unfocused(chunk: Area2D) -> void:
	#if focus_chunk and focus_chunk.get_instance_id() == chunk.get_instance_id():
	focus_chunk = null

func _generate_chunks() -> void:
	var x = 288
	var y = 16
	for i in range(0, 15):
		_generate_chunk(Vector2(i%3*32+x, floor(i/3)*32+y), randi_range(0,i%6), Vector3(randi_range(1,2),randi_range(1,2),0))
	_generate_chunk(Vector2(288, 16+32*5), 4, Vector3(0,1,0))
	_generate_chunk(Vector2(288+32, 16+32*5), 2, Vector3(0,-3,0))
	_generate_chunk(Vector2(288+64, 16+32*5), 5, Vector3(1,-1,0.5*PI))

func _generate_chunk(curr_position: Vector2, num = null, key = null) -> void:
	var chunk := CHUNK.instantiate()
	if not num:
		num = randi_range(0, CHUNKS_DATA.size()-1)
	chunk.data = load(CHUNKS_DATA[num])
	chunk.position = curr_position
	chunk.focus_chunk.connect(_on_chunk_be_focused)
	chunk.unfocus_chunk.connect(_on_chunk_unfocused)
	add_child(chunk)
	chunk.owner = self
	if key:
		chunk.generate_patters_data(key)
