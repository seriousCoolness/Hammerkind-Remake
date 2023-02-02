extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_scene_ready = false
var has_loaded = false

var player
var world

export var house_folder_name = "Johns_House"
var house_directory

export var origin = Vector2(0,0)
export var max_house_width = 2000
var current_house_height

var base_tilemap
var chunks_list
var chunk_res = preload("res://House_Chunk.tscn")

var chunk_loading_queue = []
var chunk_loading_mutex
var chunk_loading_thread
var chunk_unloading_queue = []
var chunk_unloading_mutex
var chunk_unloading_thread

const max_platform_build_width = 7

const chunk_width = 16
const chunk_height = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	
	player = get_node_or_null("/root/World/Player")
	world = get_node_or_null("/root/World")
	
	base_tilemap = get_node_or_null("/root/World/Chunks/Basetilemap")
	chunks_list = get_node_or_null("/root/World/Chunks")
	
	house_directory = "user://"+Global.save_directory+"/"+house_folder_name
	
	pass # Replace with function body.


func handle_house_building():
	
	var viewport = get_node("/root")
	var _height = viewport.get_visible_rect().size.y
	var _width = viewport.get_visible_rect().size.x
	
	var rand_type = randf()
	
	if is_scene_ready == true:
#	if rand_type <= 0.0:
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
#			var platform_position = base_tilemap.world_to_map(Vector2(rand_x, rand_y))
#			build_room(platform_position.x, platform_position.y, platform_position.x + rand_size_x, platform_position.y + rand_size_y, 0)
#
#			player.grists["Build"] -= get_build_cost(rand_size_x, rand_size_y, "room")
#
#
#
#	else:
#
		
		if get_maximum_platform_width(player.grists["Build"]) > 0:
			var rand_platform_width = (randi() % max_platform_build_width)+1
			var rand_x = (randf() * _width) - (_width/2) + player.get_node("Camera2D").get_camera_screen_center().x - (rand_platform_width/2)
			var rand_y = (randf() * -192)
			
			if get_build_cost(rand_platform_width, 0, "platform") > player.grists["Build"]:
				rand_platform_width = (randi() % get_maximum_platform_width(player.grists["Build"]))+1
			
			var platform_position = Vector2(origin.x + rand_x, player.position.y + rand_y)
			build_platform(base_tilemap.world_to_map(platform_position).x, base_tilemap.world_to_map(platform_position).y, rand_platform_width, 1)
			
			player.grists["Build"] -= get_build_cost(rand_platform_width, 0, "platform")
			
		
	
	pass

func handle_chunk_loading():
	
	var player_cell = base_tilemap.world_to_map(player.position)
	var chunks_to_cell_ratio = Global.render_radius
	
	var chunk_iterate_x = chunks_to_cell_ratio * -16
	while chunk_iterate_x != chunks_to_cell_ratio * 16:
		var chunk_iterate_y = chunks_to_cell_ratio * -16
		while chunk_iterate_y != chunks_to_cell_ratio * 16:
			var chunk_point = Vector2(int(player_cell.x + chunk_iterate_x)/16, int(player_cell.y + chunk_iterate_y)/16)
			
			if base_tilemap.map_to_world(Vector2(chunk_point.x * 16, chunk_point.y * 16)).distance_to(player.position) <= (592 * Global.render_radius)+ (592/2):
				
				load_tilemap_chunk(chunk_point)
				
			chunk_iterate_y += 16
		chunk_iterate_x += 16
		
	#chunk_loading_mutex.lock()
	#chunk_loading_queue.
	#chunk_loading_mutex.unlock()
	pass

func handle_chunk_unloading(userdata):
	
	for chunk_node in chunks_list.get_children():
		var chunk_coords = chunk_node.chunk_coords
		if chunk_node.name != "Basetilemap" and chunk_node.position.distance_to(Global.local_player.position) > 562.5 * Global.render_radius:
			chunk_unloading_mutex.lock()
			chunk_unloading_queue.append(chunk_coords)
			chunk_unloading_mutex.unlock()
		
	
	pass

func get_tilemap_chunk(cell_x, cell_y):
	#var chunk_name = (String(int(cell_x)/16)+","+String(int(cell_y)/16))
	var chunk_coords = Vector2(int(cell_x)/16,int(cell_y)/16)
	var chunk_name = String(chunk_coords.x)+","+String(chunk_coords.y)
	
	if chunks_list.get_node_or_null(chunk_name) == null:
		
		var chunk = chunk_res.instance()
		chunk.name = chunk_name
		chunk.house_builder = self
		chunk.player_owner = player
		chunk.chunk_coords = chunk_coords
		chunk.position = base_tilemap.map_to_world(Vector2(chunk_coords.x * 16,chunk_coords.y * 16))
		chunk.add_to_group("Chunks")
		print("Created chunk "+String(chunk_name))
		chunks_list.add_child(chunk)
		save_tilemap_chunk_by_node(chunk)
		
	
	return chunk_coords

func get_enemies_within_tilemap_chunk(chunk_coords):
	
	var enemies = Array()
	for enemy in $Enemies.get_children():
		
		if enemy.position.x >= base_tilemap.map_to_world(chunk_coords*16).x and enemy.position.y <= base_tilemap.map_to_world(chunk_coords*16).y and enemy.position.x < base_tilemap.map_to_world(Vector2((chunk_coords.x+1)*16,(chunk_coords.y+1)*16)).x and enemy.position.y > base_tilemap.map_to_world(Vector2((chunk_coords.x+1)*16,(chunk_coords.y+1)*16)).y:
			
			enemies.append(enemy)
			
		
	
	return enemies

func save_tilemap_chunk(cell_x, cell_y):
	
	var chunk_coords = Vector2(int(cell_x)/chunk_width,int(cell_y)/chunk_height)
	var chunk_name = String(chunk_coords.x)+","+String(chunk_coords.y)
	
	if chunks_list.get_node_or_null(chunk_name) != null:
		
		var dir = Directory.new()
		
		if not dir.dir_exists(house_directory):
			dir.make_dir_recursive(house_directory)
		
		var save_game = File.new()
		save_game.open(house_directory+"/"+chunk_name+".save", File.WRITE)
		
		var tiles = Array()
		
		for cell in chunks_list.get_node_or_null(chunk_name).get_used_cells():
			
			tiles.append(Vector3(int(cell.x)%16,int(cell.y)%16,chunks_list.get_node_or_null(chunk_name).get_cell(cell.x,cell.y)))
			
		
		#var enemies = Array()
		#get_enemies_within_tilemap_chunk(chunk_coords)
		
		var chunk_data = {
			"filename" : chunks_list.get_node(chunk_name).get_filename(),
			"chunk_x" : chunk_coords.x,
			"chunk_y" : chunk_coords.y,
			"cells" : tiles,
			"house" : self.get_path(),
			"player" : player.name
		}
		
		save_game.store_line(to_json(chunk_data))
		print("Saved chunk "+chunk_name)
		
	pass

func save_tilemap_chunk_by_node(chunk_node):
	
	var chunk_name = String(chunk_node.chunk_coords.x) + "," + String(chunk_node.chunk_coords.y)
	
	var dir = Directory.new()
	
	if not dir.dir_exists(house_directory):
		dir.make_dir_recursive(house_directory)
	
	var save_game = File.new()
	save_game.open(house_directory+"/"+chunk_name+".save", File.WRITE)
	
	var tiles = Array()
	
	for cell in chunk_node.get_used_cells():
		
		tiles.append(Vector3(int(cell.x)%16,int(cell.y)%16,chunk_node.get_cell(cell.x,cell.y)))
		
	
	#var enemies = Array()
	#get_enemies_within_tilemap_chunk(chunk_coords)
	var chunk_coords = chunk_node.chunk_coords
	var chunk_data = {
		"filename" : chunk_node.get_filename(),
		"chunk_x" : chunk_coords.x,
		"chunk_y" : chunk_coords.y,
		"cells" : tiles,
		"house" : self.get_path(),
		"player" : player.name
	}
	
	save_game.store_line(to_json(chunk_data))
	print("Saved chunk "+ chunk_node.name + " ["+String(chunk_node.chunk_coords.x)+","+String(chunk_node.chunk_coords.y)+"]")
	
	pass

func unload_tilemap_chunk(chunk):
	
	var chunk_coords = chunk
	var chunk_name = String(chunk_coords.x)+","+String(chunk_coords.y)
	
	if chunks_list.get_node_or_null(chunk_name) == null:
		pass
	
	if chunks_list.get_node_or_null(chunk_name).name == chunk_name:
		
		var dir = Directory.new()
		
		if not dir.dir_exists(house_directory):
			dir.make_dir_recursive(house_directory)
		
		var save_game = File.new()
		save_game.open(house_directory+"/"+chunk_name+".save", File.WRITE)
		
		var tiles = Array()
		
		for cell in chunks_list.get_node_or_null(chunk_name).get_used_cells():
			
			tiles.append(Vector3(int(cell.x)%16,int(cell.y)%16,chunks_list.get_node_or_null(chunk_name).get_cell(cell.x,cell.y)))
			
		
		#var enemies = Array()
		#get_enemies_within_tilemap_chunk(chunk_coords)
		
		var chunk_data = {
			"filename" : chunks_list.get_node(chunk_name).get_filename(),
			"chunk_x" : chunk_coords.x,
			"chunk_y" : chunk_coords.y,
			"cells" : tiles,
			"house" : self.get_path(),
			"player" : player.name
		}
		
		save_game.store_line(to_json(chunk_data))
		
	
	chunks_list.get_node(chunk_name).queue_free()
	print("Saved and unloaded chunk "+chunk_name)
	pass

func load_tilemap_chunk_from_cells(cell_x,cell_y):
	
	var chunk_coords = Vector2(int(cell_x)/16,int(cell_y)/16)
	var chunk_name = String(chunk_coords.x)+","+String(chunk_coords.y)
	
	var save_game = File.new()
	if save_game.file_exists(house_directory+"/"+chunk_name+".save") and chunks_list.get_node_or_null(chunk_name) == null:
		
		
		save_game.open(house_directory+"/"+chunk_name+".save", File.READ)
		
		var node_data = parse_json(save_game.get_line())
		var new_chunk = load(node_data["filename"]).instance()
		
		chunks_list.add_child(new_chunk)
		var chunk_x = node_data["chunk_x"]
		var chunk_y = node_data["chunk_y"]
		new_chunk.chunk_coords = Vector2(chunk_x,chunk_y)
		new_chunk.player_owner = world.get_node(node_data["player"])
		new_chunk.house_builder = world.get_node(node_data["house"])
		new_chunk.name = String(chunk_x)+","+String(chunk_y)
		new_chunk.position = base_tilemap.map_to_world(Vector2(chunk_x * 16,chunk_y * 16))
		
		
		for string in node_data["cells"]:
			
			var cell = string_to_vector3(string)
			
			new_chunk.set_cell(cell[0], cell[1], cell[2])
			
		
		print("Loaded chunk "+chunk_name)
		
	save_game.close()
	
	pass

func load_tilemap_chunk(chunk):
	
	var chunk_coords = Vector2(chunk.x,chunk.y)
	var chunk_name = String(chunk_coords.x)+","+String(chunk_coords.y)
	
	if chunks_list.get_node_or_null(chunk_name) != null:
		#print("Chunk "+String(chunk_name)+" already loaded.")
		pass
	else:
		var save_game = File.new()
		if save_game.file_exists(house_directory+"/"+chunk_name+".save") and chunks_list.get_node_or_null(chunk_name) == null:
			
			
			save_game.open(house_directory+"/"+chunk_name+".save", File.READ)
			
			var node_data = parse_json(save_game.get_line())
			if node_data == null or not node_data.has("filename") or not ResourceLoader.exists(node_data["filename"]):
				pass
			var new_chunk = load(node_data["filename"]).instance()
			
			chunks_list.add_child(new_chunk)
			var chunk_x = node_data["chunk_x"]
			var chunk_y = node_data["chunk_y"]
			new_chunk.chunk_coords = Vector2(chunk_x,chunk_y)
			new_chunk.player_owner = world.get_node(node_data["player"])
			new_chunk.house_builder = world.get_node(node_data["house"])
			new_chunk.name = String(chunk_x)+","+String(chunk_y)
			new_chunk.position = base_tilemap.map_to_world(Vector2(chunk_x * 16,chunk_y * 16))
			
			for string in node_data["cells"]:
				
				var cell = string_to_vector3(string)
				
				new_chunk.set_cell(cell[0], cell[1], cell[2])
				
			
			print("Loaded chunk "+chunk_name)
			
		save_game.close()
	
	pass

func string_to_vector3(string):
	
	return string.lstrip("(").rstrip(")").split_floats(", ")

func string_to_vector2(string):
	string = string.insert(0,"Vector2(").insert(string.length(),")")
	string = string.insert(string.find(',')+1,' ')
	print(str2var(string))
	return str2var(string)

#old non-chunk based house building.
#func OLD_handle_house_building():
#
#	var viewport = get_node("/root")
#	var _height = viewport.get_visible_rect().size.y
#	var width = viewport.get_visible_rect().size.x
#
#	#Gather what kinds of buildings are possible given the player's build grist.
#	var possible_builds = Array()
#
#	if get_maximum_platform_width(player.grists["Build"]) > 0:
#		possible_builds.append("platform")
#		possible_builds.append("platform")
#		possible_builds.append("platform")
#	if get_maximum_room_size(player.grists["Build"]) > 0:
#		possible_builds.append("room")
#	if get_maximum_wall_size(player.grists["Build"]) > 4:
#		possible_builds.append("wall")
#	if get_maximum_floor_size(player.grists["Build"]) > 3:
#		possible_builds.append("floor")
#		possible_builds.append("floor")
#
#	var rand_selection = 0
#	if possible_builds.size() != 0:
#		rand_selection = randi() % possible_builds.size()
#
#	if possible_builds[rand_selection] == "platform":
#
#		var rand_platform_width = (randi() % int(min(7,get_maximum_platform_width(player.grists["Build"]))-4))+5
#		var rand_x = (randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x - (rand_platform_width/2)
#		var rand_y = (randf() * -192)
#
#		var platform_position = Vector2(spawnpoint.x + rand_x, player.position.y + rand_y)
#		build_platform($TileMap.world_to_map(platform_position).x, $TileMap.world_to_map(platform_position).y, rand_platform_width, 1)
#
#		player.add_grist("Build",-get_build_cost(rand_platform_width, 0, "platform"))
#
#	if possible_builds[rand_selection] == "room":
#
#
#		print_debug("player.position.y = ",player.position.y)
#		print_debug("house_base_height = ",house_base_height)
#		print_debug("int(player.position.y - house_base_height /5) *5 = ",int((player.position.y - house_base_height)/5)*5)
#		var rand_x = (randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x
#		var rand_y = house_base_height
#		while abs(rand_y) < abs(player.position.y - house_base_height):
#			rand_y += sign(player.position.y - house_base_height) * 5
#		rand_y += ((randi() %2)-1)*5
#
#		var rand_size_x = (randf() * min(8,get_maximum_room_size(player.grists["Build"])))+1
#		var rand_size_y = 3
#
#		while rand_x > player.position.x - 500 and rand_x < player.position.x + 500:
#			rand_x = (randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x
#
#		if rand_x < player.position.x:
#			rand_x -= rand_size_x*2*38-27
#
#		var platform_position = $TileMap.world_to_map(Vector2(rand_x, rand_y))
#		build_room(platform_position.x, platform_position.y, platform_position.x + (rand_size_x*2), platform_position.y + (rand_size_y*2), 0)
#
#		player.add_grist("Build",-get_build_cost(rand_size_x, rand_size_y, "room"))
#
#	if possible_builds[rand_selection] == "wall":
#
#		var rand_x = (randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x
#		var rand_y = house_base_height
#		while abs(rand_y) < abs(player.position.y - house_base_height):
#			rand_y += sign(player.position.y - house_base_height) * 5
#		rand_y += ((randi() %2)-1)*5
#
#		var rand_size_x = 1
#		var rand_size_y = (randi() % int(min(5,get_maximum_wall_size(player.grists["Build"]))))+1
#
#		while rand_x > player.position.x - 500 and rand_x < player.position.x + 500:
#			rand_x = (randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x
#
#		if rand_x < player.position.x:
#			rand_x -= rand_size_x*2*38-27
#
#		var platform_position = $TileMap.world_to_map(Vector2(rand_x, rand_y))
#		build_room(platform_position.x, platform_position.y, platform_position.x + (rand_size_x*2), platform_position.y + (rand_size_y*2), 0)
#
#		player.add_grist("Build",-get_build_cost(1, rand_size_y, "wall"))
#
#	if possible_builds[rand_selection] == "floor":
#
#
#		var rand_x = (randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x
#		var rand_y = house_base_height + 56
#		while abs(rand_y) < abs(player.position.y - house_base_height):
#			rand_y += sign(player.position.y - house_base_height) * 5
#		rand_y += ((randi() %2)-1)*5
#
#		var rand_size_x = (randi() % int(min(2,get_maximum_floor_size(player.grists["Build"]))-1))+2
#		var rand_size_y = 1
#
#		while rand_x > player.position.x - 500 and rand_x < player.position.x + 500:
#			rand_x = (randf() * width) - (width/2) + player.get_node("Camera2D").get_camera_screen_center().x
#
#		if rand_x < player.position.x:
#			rand_x -= rand_size_x*2*38-27
#
#		var platform_position = $TileMap.world_to_map(Vector2(rand_x, rand_y))
#		build_room(platform_position.x, platform_position.y, platform_position.x + (rand_size_x*2), platform_position.y + (rand_size_y*2), 0)
#
#		player.add_grist("Build",-get_build_cost(rand_size_x, 1, "floor"))
#
#
#	pass

func build_platform(var cell_x, var cell_y, var width, var type):
	
	var iterate_cell = cell_x - (width)
	
	while iterate_cell <= cell_x + (width):
		var chunk_coords = get_tilemap_chunk(iterate_cell,cell_y)
		chunks_list.get_node(String(chunk_coords.x)+","+String(chunk_coords.y)).set_cell(int(iterate_cell)%16, int(cell_y)%16, -1)
		chunks_list.get_node(String(chunk_coords.x)+","+String(chunk_coords.y)).set_cell(int(iterate_cell)%16, int(cell_y)%16, type)
		
		iterate_cell += 1
	
	pass

func build_room(var cell_x1, var cell_y1, var cell_x2, var cell_y2, var type):
	
	var iterate_cellx = cell_x1
	while iterate_cellx < cell_x2:
		var iterate_celly = cell_y1
		while iterate_celly < cell_y2:
			var chunk_coords = get_tilemap_chunk(iterate_cellx,iterate_celly)
			chunks_list.get_node(String(chunk_coords.x)+","+String(chunk_coords.y)).set_cell(iterate_cellx, iterate_celly, -1)
			chunks_list.get_node(String(chunk_coords.x)+","+String(chunk_coords.y)).set_cell(iterate_cellx, iterate_celly, type)
			
			iterate_celly += 1
		iterate_cellx += 1
	
	pass

func get_build_cost(var size_x, var size_y, var type):
	
	if type == "platform":
		return int(size_x/2.0)*3
	if type == "room":
		return int(size_x*5)/2
	if type == "stairs":
		return int(pow(size_y, 1.5)) + size_x
	if type == "wall":
		return size_y+1
	if type == "floor":
		return size_x+1
	

#inverse of function "get_build_cost" when type == "platform"
func get_maximum_platform_width(var build_grist):
	
	if int((build_grist/3)*2)-1 < 0:
		
		return 0
		
	else:
		
		return int((build_grist/3)*2)-1
		
	

#inverse of function "get_build_cost" when type == "room" and assuming room is square.
func get_maximum_room_size(var build_grist):
	if int((build_grist*2)/5)-1 <= 0:
		
		return 0
		
	else:
		
		return int((build_grist*2)/5)-1
		
	

func get_maximum_wall_size(var build_grist):
	
	if build_grist-3 <= 0:
		
		return 0
		
	else:
		
		return build_grist-3
		
	
	pass

func get_maximum_floor_size(var build_grist):
	
	if build_grist-3 <= 0:
		
		return 0
		
	else:
		
		return build_grist-3
		
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_scene_ready == true:
		
		handle_chunk_loading()
		
		if Global.in_menu == false:
			
			var chunk_coords = get_tilemap_chunk(base_tilemap.world_to_map(world.get_world_mouse_position()).x,base_tilemap.world_to_map(world.get_world_mouse_position()).y)
			
			if Input.is_mouse_button_pressed(2) and player.grists["Build"] >= get_build_cost(3, 0, "platform") and world.mouse:
				
				build_platform(base_tilemap.world_to_map(Vector2(world.get_world_mouse_position().x,world.get_world_mouse_position().y)).x, base_tilemap.world_to_map(world.get_world_mouse_position()).y, 3, 1)
				player.grists["Build"] -= get_build_cost(3, 0, "platform")
				world.mouse = false
				
			
		
	
	pass


func _on_World_ready():
	player = get_node_or_null("/root/World/Player")
	world = get_node_or_null("/root/World")
	
	base_tilemap = get_node_or_null("/root/World/Chunks/Basetilemap")
	chunks_list = get_node_or_null("/root/World/Chunks")
	
	is_scene_ready = true
	pass # Replace with function body.

func _exit_tree():
	
	for node in chunks_list.get_children():
		
		if node.name != "Basetilemap":
			
			save_tilemap_chunk_by_node(node)
			
		
	
