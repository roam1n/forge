extends Node2D

@onready var state_machine: StateMachine = $StateMachine

enum State {
	#SelectRequest,
	Unmet,
	Met,
	ChunkFocus,
	ChunkSuspendedActive,
	CheckRequest,
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

signal check_request

var focus_chunk: Node2D
var _dot_position: Vector2


func _ready() -> void:
	_generate_chunks()
	
func get_next_state(state: State) -> State:
	if not focus_chunk:
		state = State.CheckRequest
	match state:
		State.ChunkFocus:
			if focus_chunk.is_adsorbed:
				state = State.ChunkSuspendedActive
		State.ChunkSuspendedActive:
			if (get_global_mouse_position() - focus_chunk.position).length() >= 12.0:
				state = State.ChunkFocus
	return state

func transition_state(from: State, to: State) -> void:
	match to:
		State.ChunkFocus:
			focus_chunk.is_adsorbed = false
		State.CheckRequest:
			check_request.emit()

func tick_physics(state: State) -> void:
	match state:
		State.ChunkFocus:
			focus_chunk.position = get_global_mouse_position()

func _on_dot_matrix_active_dot(dot_position: Vector2, _dot_type: String) -> void:
	# 被吸附到点的块，会被禁止行动
	if focus_chunk:
		focus_chunk.is_adsorbed = true
		focus_chunk.position = dot_position

func _on_chunk_be_focused(chunk: Area2D) -> void:
	focus_chunk = chunk
	state_machine.state = State.ChunkFocus

func _on_chunk_unfocused(chunk: Area2D) -> void:
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
