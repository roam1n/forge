extends Node

var current_request: Request
var current_weapon_damage: int
var current_weapon_range: int
var current_weapon_fire_rate: float
var current_weapon_pattern_size: int = 0


func _ready() -> void:
	# TODO 铸造室 临时的委托
	current_request = preload("res://dataTables/request/request_000.tres")
	current_weapon_damage = current_request.mold.damage
	current_weapon_fire_rate = current_request.mold.rate
	current_weapon_range = current_request.mold.range
