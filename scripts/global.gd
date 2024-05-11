extends Node

var current_request: Request
var current_weapon_damage: int
var current_weapon_range: int
var current_weapon_fire_rate: float
var current_foundry_data


func _ready() -> void:
	# TODO 铸造室 临时的委托
	current_request = preload("res://dataTables/request/request_000.tres")
