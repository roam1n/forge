class_name StateMachine
extends Node

var state: int = -1:
	set(v):
		owner.transition_state(state, v)
		state = v

func _ready() -> void:
	await owner.ready
	state = 0

func _physics_process(_delta: float) -> void:
	var next := owner.get_next_state(state) as int
	if next != state:
		state = next

	if owner.has_method("tick_physics"):
		owner.tick_physics(state)
