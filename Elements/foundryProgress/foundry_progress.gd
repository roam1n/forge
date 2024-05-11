extends Control

@onready var request_list: VBoxContainer = %RequestList

const REQUEST_ITEM = preload("res://Elements/foundryProgress/request_item.tscn")

var damage_item: VBoxContainer = REQUEST_ITEM.instantiate()
var rate_item: VBoxContainer = REQUEST_ITEM.instantiate()
var range_item: VBoxContainer = REQUEST_ITEM.instantiate()
var pattern_size_item: VBoxContainer = REQUEST_ITEM.instantiate()


func _ready() -> void:
	request_list.add_child(damage_item)
	request_list.add_child(rate_item)
	request_list.add_child(range_item)
	request_list.add_child(pattern_size_item)

func update_labels(curr) -> void:
	if Global.current_request:
		var req: Request = Global.current_request
		damage_item.update("魔法伤害", float(curr.damage), ">=", float(req.min_damage))
		rate_item.update("施法间隔", float(curr.rate), "<=", float(req.rate))
		range_item.update("施法范围", float(curr.range), ">=", float(req.range))
		pattern_size_item.update("魔纹数量", float(curr.pattern_size), ">=", float(req.pattern_size))
