extends Node2D

@onready var state_machine: StateMachine = $StateMachine
@onready var select_request: Control = %SelectRequest
@onready var foundry_progress: Control = %FoundryProgress
@onready var submit_button: Button = %Submit

enum State {
	SelectRequest,
	Unmet,
	Met,
	ChunkFocus,
	ChunkSuspendedActive,
	CheckRequest,
	Submit
}

const CHUNK = preload("res://Elements/dotMatrix/chunk.tscn")
const CHUNKS_DATA = {
	"blaze": "res://dataTables/chunks/blaze.tres",
	"life": "res://dataTables/chunks/life.tres",
	"resonance": "res://dataTables/chunks/resonance.tres",
	"starlight": "res://dataTables/chunks/starlight.tres",
	"storm": "res://dataTables/chunks/storm.tres",
	"tidal": "res://dataTables/chunks/tidal.tres",
}

signal check_request

var focus_chunk: Node2D
var focus_mold: Mold
var current_foundry_data


func _ready() -> void:
	_generate_chunks()
	select_request.button.button_down.connect(_selected_request)

func get_next_state(state: State) -> State:
	match state:
		State.ChunkFocus:
			if not focus_chunk:
				state = State.CheckRequest
			elif focus_chunk.is_adsorbed:
				state = State.ChunkSuspendedActive
		State.ChunkSuspendedActive:
			if not focus_chunk:
				state = State.CheckRequest
			elif (get_global_mouse_position() - focus_chunk.position).length() >= 12.0:
				state = State.ChunkFocus
		State.CheckRequest:
			if _is_request_met():
				state = State.Met
			else:
				state = State.Unmet
	return state

func transition_state(from: State, to: State) -> void:
	if from == State.SelectRequest:
		select_request.hide()
	match to:
		State.SelectRequest:
			select_request.show()
		State.ChunkFocus:
			focus_chunk.is_adsorbed = false
		State.CheckRequest:
			select_request.hide()
			check_request.emit()
		State.Unmet:
			submit_button.hide()
			foundry_progress.show()
		State.Met:
			submit_button.show()
			save_data()

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

func _on_chunk_unfocused(_chunk: Area2D) -> void:
	focus_chunk = null

func _generate_chunks() -> void:
	var x = 288
	var y = 16
	var i = 0
	while i < 15:
		_generate_chunk(Vector2(i%3*32+x, floor(i/3)*32+y), null, Vector3(randi_range(1,2),randi_range(1,2),0))
		i = i+1
	if Global.current_request and Global.current_request.mold:
		var special_chunks = Global.current_request.mold.chunks
		focus_mold = Global.current_request.mold
		for chunk in special_chunks:
			_generate_chunk(Vector2(i%3*32+x, floor(i/3)*32+y), chunk.name, chunk.key)
			i = i+1

func _generate_chunk(curr_position: Vector2, chunk_name = null, key = null) -> void:
	var chunk := CHUNK.instantiate()
	if not chunk_name:
		chunk_name = CHUNKS_DATA.keys()[randi_range(0, CHUNKS_DATA.size()-1)]
	chunk.data = load(CHUNKS_DATA[chunk_name])
	chunk.position = curr_position
	chunk.focus_chunk.connect(_on_chunk_be_focused)
	chunk.unfocus_chunk.connect(_on_chunk_unfocused)
	add_child(chunk)
	chunk.owner = self
	if key:
		chunk.generate_patters_data(key)

func _on_back_button_down() -> void:
	get_tree().change_scene_to_packed(preload("res://Scenes/storeFront/storeFront.tscn"))

func _selected_request() -> void:
	state_machine.state = State.CheckRequest

func _is_request_met() -> bool:
	var rate: float = focus_mold.rate
	var area_range: int = focus_mold.area_range
	var damage: int = focus_mold.damage
	var pattern_size: int = 0
	for node in get_tree().get_nodes_in_group("chunk"):
		if not node._is_overlap and node.is_adsorbed:
			area_range += node.data.area_range
			damage += node.data.damage
			if rate + 0.1 > node.data.rate: #施法间隔最低0.1
				rate -= node.data.rate
			else:
				rate = 0.1
			if node.is_in_group("patternStart") and node._pattern_scope.visible:
				pattern_size += 1
	current_foundry_data = {
		"rate": rate,
		"area_range": area_range,
		"damage": damage,
		"pattern_size": pattern_size
	}
	foundry_progress.update_labels(current_foundry_data)
	return (Global.current_request.rate >= rate and Global.current_request.area_range <= area_range and 
		Global.current_request.min_damage <= damage and Global.current_request.pattern_size <= pattern_size)

func save_data() -> void:
	Global.current_weapon_damage = current_foundry_data.damage
	Global.current_weapon_range = current_foundry_data.area_range
	Global.current_weapon_fire_rate = current_foundry_data.rate
	Global.current_weapon_pattern_size = current_foundry_data.pattern_size

func _on_submit_button_down() -> void:
	save_data()
	get_tree().change_scene_to_packed(preload("res://Scenes/TestRoom/test_room.tscn"))
