extends Node

var world = null
var local_player = null
var save_directory = "save_1"

var is_world_ready = false
var in_menu = false
var render_radius : int = 2



func _ready():
	
	var root = get_tree().get_root()
	world = root.get_child(root.get_child_count() - 1)
	
	pass



func _process(delta):
	
	if world != null:
		if world.get_node_or_null("Player") != null:
			
			local_player = world.get_node("Player")
			is_world_ready = true
			
		
		else:
			
			local_player = null
			is_world_ready = false
			
		
	
	pass



func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)
	pass



func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	world.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)
	
	# Instance the new scene.
	world = s.instance()
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(world)
	
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(world)
	pass



func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	
	return files
