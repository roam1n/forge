extends Node2D

var target_scene = preload("res://Scenes/TestRoom/target.tscn")
var player_scene = preload("res://Scenes/TestRoom/player.tscn")

func _ready() -> void:
	#### Following to be set from Store Front ####
	var request_resource_path = "res://dataTables/request/request_00"+str(0)+".tres"  #randi_range(0,3)
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
	if Global.current_request.range > 0:
		pass
		#player.position = $TileMap.map_to_local(Vector2i(6,5))
		#for i in 10:
			#var target_pos=Vector2(6,5) + random_on_circle(Global.current_request.range)
			#var target = target_scene.instantiate()
			#add_child(target)
			#print(target_pos)
			#target.position = $TileMap.map_to_local(target_pos)

	else:
		player.position = $TileMap.map_to_local(Vector2i(1,1))
		var target = target_scene.instantiate()
		add_child(target)
		target.position = $TileMap.map_to_local(Vector2(6,5))

func random_on_circle(radius : int) -> Vector2:
	var angle = randi_range(0, 360)
	var pos = Vector2(0.5,0.5).rotated(deg_to_rad(angle))*radius
	return pos
