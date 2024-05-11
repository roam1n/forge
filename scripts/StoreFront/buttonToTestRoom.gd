extends TextureButton

var testRoomScene = load("res://Scenes/TestRoom/test_room.tscn")
func _on_pressed():
	get_tree().change_scene_to_packed(testRoomScene)
