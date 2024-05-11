extends TextureButton
var foundryScene = load("res://Scenes/foundryRoom.tscn")

func _on_pressed():
	get_tree().change_scene_to_packed(foundryScene)
