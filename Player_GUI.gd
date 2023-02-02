extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var echeladder_res = preload("res://Echeladder.tscn")
var grist_cache_res = preload("res://CacheGui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Global.is_world_ready == true:
		
		handle_gamegui()
		
	
	pass

func handle_gamegui():
	
	var viewport = get_node("/root")
	var height = viewport.get_visible_rect().size.y
	var width = viewport.get_visible_rect().size.x
	
	if get_node_or_null("Cache") != null:
		
		if get_node("Cache").rect_position.y > 0:
			
			get_node("Cache").rect_position.y = lerp(get_node("Cache").rect_position.y, (height/2) - (get_node("Cache").rect_size.y/2), 0.5)
			
		
		var cache_gui = get_node("Cache/ColorRect/MarginContainer/HBoxContainer")
		
		if not cache_gui.get_children().empty():
			var column = 1
			while column <= 3:
				var row = 0
				while row < 9:
					
					var current = cache_gui.get_node("Column"+String(column)).get_children()
					current[row].get_node("Background/Number").text = String(Global.local_player.grists[current[row].name])
					
					row += 1
				
				column += 1
			
		
		if Input.is_action_just_pressed("ui_grist"):
			
			get_node("Cache").queue_free()
			
		
	else:
		
		if Input.is_action_just_pressed("ui_grist"):
			
			switch_menu("grist")
			
		
	if get_node_or_null("Echeladder") != null:
		
		
		var echeladder_x = (width/2) - (get_node("Echeladder").rect_size.x/2)
		
		if get_node("Echeladder").rect_position.x != echeladder_x:
			
			get_node("Echeladder").rect_position.x = lerp(get_node("Echeladder").rect_position.x, (width/2) - (get_node("Echeladder").rect_size.x/2), 0.5)
			
		
		get_node("Echeladder").climb_to_rung(Global.local_player)
		
		if Input.is_action_just_pressed("ui_echeladder"):
			
			get_node("Echeladder").queue_free()
			
		
	else:
		
		if Input.is_action_just_pressed("ui_echeladder"):
			
			switch_menu("echeladder")
			
		
	
	if get_node_or_null("Cache") != null or get_node_or_null("Echeladder") != null:
		Global.in_menu = true
	else:
		Global.in_menu = false
	
	pass

func switch_menu(menu_type):
	
	var viewport = get_node("/root")
	var height = viewport.get_visible_rect().size.y
	var width = viewport.get_visible_rect().size.x
	
	if menu_type.to_lower() == "echeladder":
		
		if Global.in_menu:
			
			get_node("Cache").queue_free()
			
		
		var echeladder = echeladder_res.instance()
		echeladder.rect_position.x = width
		
		var rungnum = 0
		for rung_name in Global.local_player.echeladder_names:
			
			echeladder.add_rung(rung_name)
			if rungnum < Global.local_player.echeladder_bgcolors.size():
				print(rung_name)
				echeladder.get_rung(rung_name).set_rung_color(Global.local_player.echeladder_bgcolors[rungnum], Global.local_player.echeladder_txtcolors[rungnum])
			if Global.local_player.echeladder_bgcolors.size() - rungnum <= Global.local_player.echeladder_rung:
				echeladder.get_rung(rung_name).climbed = true
				echeladder.add_recent_rung(rung_name, Global.local_player.echeladder_bgcolors[rungnum], Global.local_player.echeladder_txtcolors[rungnum])
				echeladder.add_rung_bonus(rung_name, int(1 * (Global.local_player.echeladder_rung * 0.5)), Global.local_player.cache_limit_rewards[rungnum], Global.local_player.echeladder_bgcolors[rungnum], Global.local_player.echeladder_txtcolors[rungnum])
			rungnum += 1
			
		
		add_child(echeladder)
		
	if menu_type.to_lower() == "grist":
		
		if Global.in_menu:
			
			get_node("Echeladder").queue_free()
			
		
		var grist_cache = grist_cache_res.instance()
		grist_cache.rect_position.y = height
		add_child(grist_cache)
		
	
	pass
