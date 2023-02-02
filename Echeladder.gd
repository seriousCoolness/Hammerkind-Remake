extends Control

var rung_res = preload("res://Rung.tscn")
var recent_rung_res = preload("res://Echeladder_RecentRung.tscn")
var bonus_res = preload("res://Echeladder_BonusTag.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func add_rung(name):
	var rung = rung_res.instance()
	$Background/Ladder/HBoxContainer/MarginContainer/VBoxContainer.add_child(rung)
	rung.set_rung_name(name)
	rung.name = name
	pass

func add_recent_rung(name, bg_color, txt_color):
	while $Background/RecentRungs/VBoxContainer.get_child_count() > 2:
		$Background/RecentRungs/VBoxContainer.get_child(0).queue_free()
	if $Background/RecentRungs/VBoxContainer.get_child_count() < 2:
		var recent_rung = recent_rung_res.instance()
		recent_rung.set_rung_name(name)
		recent_rung.set_rung_color(bg_color, txt_color)
		$Background/RecentRungs/VBoxContainer.add_child(recent_rung)
		pass
	

func add_rung_bonus(name, gel_viscosity, cache_limit, bg_color, txt_color):
	var gel_bonus = $Background/StatBonuses/VBoxContainer/GelViscosity/TextContainer/HBoxContainer
	var cache_bonus = $Background/StatBonuses/VBoxContainer/CacheLimit/TextContainer/HBoxContainer
	while gel_bonus.get_child_count() > 2:
		gel_bonus.get_child(0).queue_free()
	if gel_bonus.get_child_count() < 2:
		var bonus_tag = bonus_res.instance()
		bonus_tag.set_rung_bonus(name,gel_viscosity)
		bonus_tag.set_rung_color(bg_color, txt_color)
		gel_bonus.add_child(bonus_tag)
		
	
	while cache_bonus.get_child_count() > 2:
		cache_bonus.get_child(0).queue_free()
	if cache_bonus.get_child_count() < 2:
		var bonus_tag = bonus_res.instance()
		bonus_tag.set_rung_bonus(name,cache_limit)
		bonus_tag.set_rung_color(bg_color, txt_color)
		cache_bonus.add_child(bonus_tag)
		

func get_rung(name):
	
	return $Background/Ladder/HBoxContainer/MarginContainer/VBoxContainer.get_node(name)
	

func climb_to_rung(player):
	
	var rungnum = $Background/Ladder/HBoxContainer/MarginContainer/VBoxContainer.get_child_count()-1
	
	
	while rungnum >= 0:
		
		if $Background/Ladder/HBoxContainer/MarginContainer/VBoxContainer.get_child_count() - player.echeladder_rung <= rungnum:
			
			$Background/Ladder/HBoxContainer/MarginContainer/VBoxContainer.get_child(rungnum).climbed = true
			
		
		rungnum-=1
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
