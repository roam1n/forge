extends Node2D

var target_scene = preload("res://Scenes/TestRoom/target.tscn")
var player_scene = preload("res://Scenes/TestRoom/player.tscn")

func _ready() -> void:
	#### Following to be set from Store Front ####
	var request_resource_path = "res://dataTables/request/request_00"+str(3)+".tres"  #randi_range(0,3)
	Global.current_request = load(request_resource_path)
	##############################################

	#### Following to be set from Foundry Room ####
	Global.current_weapon_damage = 10
	Global.current_weapon_range = 50
	Global.current_weapon_fire_rate = 0.2
	###############################################
	generate_targets()

func generate_targets():
	var player = player_scene.instantiate()
	add_child(player)
	player.position = $TileMap.map_to_local(Vector2i(1,1))
	var target = target_scene.instantiate()
	add_child(target)
	target.connect("requirement_reached", Callable(self, "_on_requirement_reached"))
	target.position = $TileMap.map_to_local(Vector2(6,5))
	if Global.current_request.min_damage != 0:
		target.max_health = Global.current_request.min_damage
	else:
		target.max_health = Global.current_weapon_damage * 5
	## 如果要求伤害且不要求施法间隔，人偶需要一击必杀，如果没达到，人偶回复全部血量
	if Global.current_request.min_damage > 0 && Global.current_request.rate == 0:
		target.one_time_kill = true
	## 如果要求施法间隔，人偶逐渐回复血量
	if Global.current_request.rate > 0:
		target.regain_health = true
		target.regain_health_rate = Global.current_weapon_damage * 2
	## 如果要求距离，人偶周围圆形区域不可行走，需要在区域外击杀人偶
	if Global.current_request.range > 0:
		target.shoot_range = Global.current_request.range

func _on_requirement_reached():
	get_tree().paused = true
	$GUI.visible = true

func random_on_circle(radius : int) -> Vector2:
	var angle = randi_range(0, 360)
	var pos = Vector2(0.5,0.5).rotated(deg_to_rad(angle))*radius
	return pos



func _on_store_front_button_pressed():
	var store_front_scene = load("res://Scenes/storeFront/storeFront.tscn")
	get_tree().paused = false
	get_tree().change_scene_to_packed(store_front_scene)

func _on_foundary_room_button_pressed():
	var foundry_scene = load("res://Scenes/foundryRoom.tscn")
	get_tree().change_scene_to_packed(foundry_scene)
