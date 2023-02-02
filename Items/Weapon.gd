extends "res://Items/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var sprite_offset : Vector2
export var damage : float = 1.0
export var speed : float = 1.0
export var weapon_type : String = "Blunt"
export var kind_abstrata : String = "Hammer"
export var stat_effects : Dictionary


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	
	get_node("Sprite").offset = sprite_offset
	
	pass

func make_weapon_sprite(weapon_sprite):
	
	weapon_sprite.texture = self.texture
	weapon_sprite.centered = false
	weapon_sprite.offset = self.sprite_offset
	
	return weapon_sprite
