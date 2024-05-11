extends VBoxContainer


@onready var key_label: Label = $Key
@onready var value_label: Label = $Value


func update(key:String, value:float, cond_str:String, target:float) -> void:
	key_label.text = "- " + key + ": "
	var is_met: bool = (value == target)
	match cond_str:
		"<=":
			is_met = (value <= target)
		">=":
			is_met = (value >= target)
	if is_met:
		value_label.add_theme_color_override("font_color", Color(0.376, 0.69, 0.412))
	else:
		value_label.add_theme_color_override("font_color", Color(0.8, 0.6, 0.6))
	value_label.text = str(value) + "( " + cond_str + str(target) + " )"
