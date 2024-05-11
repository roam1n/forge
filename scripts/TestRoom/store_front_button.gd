extends TextureButton

var storeFrontScene = load("res://Scenes/storeFront/storeFront.tscn")
func _on_pressed():
	get_tree().change_scene_to_packed(storeFrontScene)
