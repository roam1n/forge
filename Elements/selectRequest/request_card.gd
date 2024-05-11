extends VBoxContainer

@onready var number: Label = %Number
#@onready var type: Label = %Type
@onready var rate: Label = %Rate
@onready var damage: Label = %Damage
@onready var area_range: Label = %AreaRange

@export var request: Request

func _ready() -> void:
	update_number_label(request.resource_path.get_file())
	update_rate_label(str(request.rate))
	update_damage_label(str(request.min_damage))
	update_area_range_label(str(request.range))

func update_number_label(text:String) -> void:
	number.text = "委托编号： " + text.split(".")[0].split("_")[1]

#func update_type_label(text) -> void:
	#pass

func update_rate_label(text:String) -> void:
	rate.text = "施法间隔： 小于" + text

func update_damage_label(text:String) -> void:
	damage.text = "魔法伤害： 大于" + text

func update_area_range_label(text:String) -> void:
	area_range.text = "施法范围： 大于" + text
