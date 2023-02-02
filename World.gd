extends Node2D

var enemy_res = preload("res://Enemy.tscn")

var player

var highest_gate
var spawnpoint = Vector2()


var mouse
# Called when the node enters the scene tree for the first time.
func _ready():
	
	player = $Player
	spawnpoint = $Player.position
	
	highest_gate = 0
	mouse = true
	
	#unload_tilemap_chunk(1,1)
	#load_tilemap_chunk(1,1)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	player = $Player
	
	if Global.in_menu == false:
		#handle_house_building()
		
		if Input.is_mouse_button_pressed(3) and mouse:
			mouse = false
			var enemy = enemy_res.instance()
			enemy.position = get_global_mouse_position()
			
			$Enemies.add_child(enemy)
			
		if not Input.is_mouse_button_pressed(3) and not Input.is_mouse_button_pressed(2):
			
			mouse = true
			
		
	
	pass

#func handle_house_building():
#
#	var viewport = get_node("/root")
#	var height = viewport.get_visible_rect().size.y
#	var width = viewport.get_visible_rect().size.x
#
#	var rand_type = randf()
#
#
#	if rand_type <= 0.4:
#
#		if get_maximum_room_size(player.grists["Build"]) != 0:
#			var rand_x = (randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x
#			var rand_y = (int((randf() * - 192) + player.get_node("Camera2D").get_camera_screen_center().y)/5)*5
#			var rand_size_x = (randi() % 8)+1
#			var rand_size_y = 5
#
#			while rand_x > player.position.x - 64 and rand_x < player.position.x + 64:
#				rand_x = (randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x
#			while rand_y > player.position.y - 128 and rand_y < player.position.y + 64:
#				rand_y = (int((randf() * - 192) + player.get_node("Camera2D").get_camera_screen_center().y)/5)*5
#
#			if get_build_cost(rand_size_x, rand_size_y, "room") > player.grists["Build"]:
#				rand_size_x = (randi() % get_maximum_room_size(player.grists["Build"]))+1
#
#			if rand_x < player.position.x:
#				rand_x -= rand_size_x*64
#
#
#			var platform_position = $TileMap.world_to_map(Vector2(rand_x, rand_y))
#			build_room(platform_position.x, platform_position.y, platform_position.x + rand_size_x, platform_position.y + rand_size_y, 0)
#
#			player.grists["Build"] -= get_build_cost(rand_size_x, rand_size_y, "room")
#
#
#
#	else:
#
#		if get_maximum_platform_width(player.grists["Build"]) != 0:
#			var rand_platform_width = (randi() % 7)+1
#			var rand_x = (randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x - (rand_platform_width/2)
#			var rand_y = (randf() * -192)
#
#			if get_build_cost(rand_platform_width, 0, "platform") > player.grists["Build"]:
#				rand_platform_width = (randi() % get_maximum_platform_width(player.grists["Build"]))+1
#
#			var platform_position = Vector2(spawnpoint.x + rand_x, player.position.y + rand_y)
#			build_platform($TileMap.world_to_map(platform_position).x, $TileMap.world_to_map(platform_position).y, rand_platform_width, 1)
#
#			player.grists["Build"] -= get_build_cost(rand_platform_width, 0, "platform")
#
#
#
#	pass



func _on_Underling_Spawner_timeout():
	
	var viewport = get_node("/root")
	var height = viewport.get_visible_rect().size.y
	var width = viewport.get_visible_rect().size.x
	
	var enemy = enemy_res.instance()
	enemy.health_vial = 10 * (highest_gate + 1)
	
	var top_or_bottom = randf()
	if top_or_bottom < 0.5:
		enemy.position = Vector2((randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x, (height/2) + player.get_node("Camera2D").get_camera_screen_center().y)
		enemy.init_enemy("Shale", "Tar", ((randf() * (0.5 + highest_gate)) + (1.0 + highest_gate)), Vector2((randf() * 200) - 100, -1200))
	else:
		enemy.position = Vector2((randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x, player.get_node("Camera2D").get_camera_screen_center().y - (height/2))
		enemy.init_enemy("Shale", "Tar", ((randf() * (0.5 + highest_gate)) + (1.0 + highest_gate)), Vector2((randf() * 200) - 100, 0))
	
	$Enemies.add_child(enemy)
	
	$"Underling Spawner".start((randi() % 6) + 3)
	
	pass # Replace with function body.


func _on_House_Builder():
	
	if player.grists["Build"] >= 5:
		$House_Builder.handle_house_building()
		print("Platform built")
	
	$House_Builder.start((randi() % 5)+3)
	pass


func _on_Gate_gate_triggered(number, player):
	if number > highest_gate:
		
		highest_gate = number
		$CanvasLayer/Control/Gate_Text.gate_reached(number)
		
	
	player.health_vial = player.max_health_vial
	
	pass # Replace with function body.

func get_world_mouse_position():
	return get_global_mouse_position()

