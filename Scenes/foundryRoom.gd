extends Node2D

const CHUNK = preload("res://Elements/dotMatrix/chunk.tscn")
const CHUNKS_DATA = [
	"res://dataTables/chunks/blaze.tres",
	"res://dataTables/chunks/life.tres",
	"res://dataTables/chunks/resonance.tres",
	"res://dataTables/chunks/starlight.tres",
	"res://dataTables/chunks/storm.tres",
	"res://dataTables/chunks/tidal.tres",
]

var _is_focusing_chunk: bool = false
var focus_chunk: Node2D

func _ready() -> void:
	_is_focusing_chunk = true
	var x = 288
	var y = 16
	for i in range(0, 15):
		_generate_chunk(Vector2(i%3*32+x, floor(i/3)*32+y), randi_range(0,i%6), Vector2(randi_range(1,2),randi_range(1,2)))
	_generate_chunk(Vector2(288, 16+32*5), 4, Vector2(0,1))
	_generate_chunk(Vector2(288+32, 16+32*5), 2, Vector2(0,-3))
	_generate_chunk(Vector2(288+64, 16+32*5), 5, Vector2(1,-1))

func _physics_process(_delta: float) -> void:
	if focus_chunk:
		if _is_focusing_chunk or (get_global_mouse_position() - focus_chunk.position).length() >= 25.0:
			_is_focusing_chunk = true
			focus_chunk.position = get_global_mouse_position()

func _on_dot_matrix_active_dot(dot_position: Vector2, _dot_type: String) -> void:
	if focus_chunk:
		_is_focusing_chunk = false
		focus_chunk.position = dot_position

func _on_chunk_be_focused(chunk: Area2D) -> void:
	focus_chunk = chunk

func _on_chunk_unfocused(chunk: Area2D) -> void:
	if focus_chunk and focus_chunk.get_instance_id() == chunk.get_instance_id():
		focus_chunk = null

func _generate_chunk(curr_position: Vector2, num = null, center = null) -> void:
	var chunk := CHUNK.instantiate()
	if not num:
		num = randi_range(0, CHUNKS_DATA.size()-1)
	chunk.data = load(CHUNKS_DATA[num])
	chunk.position = curr_position
	chunk.focus_chunk.connect(_on_chunk_be_focused)
	chunk.unfocus_chunk.connect(_on_chunk_unfocused)
	add_child(chunk)
	chunk.owner = self
	if center:
		chunk.generate_patters_data(center)
