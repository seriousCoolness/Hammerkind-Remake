extends "res://Items/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var item_texture : Texture

func _ready():
	init_texture()
	.init_collision()
	pass

func init_texture():
	
	if item_texture != null:
		$"ViewportContainer/Card Renderer/Spatial/Item_Inside".texture = item_texture
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
