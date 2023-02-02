extends RigidBody2D

#First Column
var grist_Build_res = preload("res://Sprites/Pickups/Build_Grist.png")
var grist_Shale_res = preload("res://Sprites/Pickups/Shale_Grist.png")
var grist_Chalk_res = preload("res://Sprites/Pickups/Chalk_Grist.png")
var grist_Amber_res = preload("res://Sprites/Pickups/Amber_Grist.png")
var grist_Uranium_res = preload("res://Sprites/Pickups/Uranium_Grist.png")
var grist_Blood_res = preload("res://Sprites/Pickups/Blood_Grist.png")
var grist_Caulk_res = preload("res://Sprites/Pickups/Caulk_Grist.png")
var grist_Rust_res = preload("res://Sprites/Pickups/Rust_Grist.png")
var grist_Sulfur_res = preload("res://Sprites/Pickups/Sulfur_Grist.png")
#Second Column
var grist_Copper_res = preload("res://Sprites/Pickups/Copper_Grist.png")
var grist_Garnet_res = preload("res://Sprites/Pickups/Garnet_Grist.png")
var grist_Marble_res = preload("res://Sprites/Pickups/Marble_Grist.png")
var grist_Frosting_res = preload("res://Sprites/Pickups/Frosting_Grist.png")
var grist_Aluminum_res = preload("res://Sprites/Pickups/Aluminum_Grist.png")
var grist_Sandstone_res = preload("res://Sprites/Pickups/Sandstone_Grist.png")
var grist_Tar_res = preload("res://Sprites/Pickups/Tar_Grist.png")
var grist_Malachite_res = preload("res://Sprites/Pickups/Malachite_Grist.png")
var grist_Jet_res = preload("res://Sprites/Pickups/Jet_Grist.png")
#Third Column
var grist_Amethyst_res = preload("res://Sprites/Pickups/Amethyst_Grist.png")
var grist_Obsidian_res = preload("res://Sprites/Pickups/Obsidian_Grist.png")
var grist_Emerald_res = preload("res://Sprites/Pickups/Emerald_Grist.png")
var grist_Mercury_res = preload("res://Sprites/Pickups/Mercury_Grist.png")
var grist_Redstone_res = preload("res://Sprites/Pickups/Redstone_Grist.png")
var grist_Candy_res = preload("res://Sprites/Pickups/Candy_Grist.png")
var grist_Sapphire_res = preload("res://Sprites/Pickups/Sapphire_Grist.png")
var grist_Gold_res = preload("res://Sprites/Pickups/Gold_Grist.png")
var grist_Zillium_res = preload("res://Sprites/Pickups/Zillium_Grist.png")
#Fourth Column
var grist_Sugar_res = preload("res://Sprites/Pickups/Sugar_Grist.png")
var grist_Cobalt_res = preload("res://Sprites/Pickups/Cobalt_Grist.png")
var grist_Opal_res = preload("res://Sprites/Pickups/Opal_Grist.tres")
var grist_Iodine_res = preload("res://Sprites/Pickups/Iodine_Grist.png")
var grist_Radium_res = preload("res://Sprites/Pickups/Radium_Grist.tres")
var grist_Diamond_res = preload("res://Sprites/Pickups/Diamond_Grist.png")
var grist_Spectrum_res = preload("res://Sprites/Pickups/Spectrum_Grist.tres")
var grist_Quartz_res = preload("res://Sprites/Pickups/Quartz_Grist.png")
var grist_Artifact_res = preload("res://Sprites/Pickups/Artifact_Grist.png")

#Non-grist pickups
var vitality_Gel_res = preload("res://Sprites/Pickups/Health_Cube.png")



var grist_value
var grist_type

# Called when the node enters the scene tree for the first time.
func init_grist(type, value):
	
	grist_type = type
	grist_value = value
	
	$Sprite.texture = get_resource(type)
	
	var grist_scale
	#if grist_type == "Build":
	grist_scale = 0.42 + (grist_value * 0.03)
	
	$Sprite.scale.x *= grist_scale
	$Sprite.scale.y *= grist_scale
	
	$CollisionShape2D.shape.extents.x = (22.764 * grist_scale) + 0.1
	$Area2D/CollisionShape2D.shape.extents.x = (22.764 * grist_scale) + 0.1
	$CollisionShape2D.shape.extents.y = (22.764 * grist_scale) + 0.1
	$Area2D/CollisionShape2D.shape.extents.y = (22.764 * grist_scale) + 0.1
	
	$Sprite.scale.x *= grist_scale
	$Sprite.scale.y *= grist_scale
	
	pass

func get_resource(type):
	
	if type != "Health":
		return self.get("grist_"+type+"_res")
	else:
		return self.get("vitality_Gel_res")
	

func _on_body_entered(body):
	
	if body.name == "Player" and $Collection_Delay.is_stopped() and grist_type != "Health":
		
		body.add_grist(grist_type, grist_value)
		MusicPlayer.play_pickup_sfx("Grist", self)
		queue_free()
		
	if body.name == "Player" and $Collection_Delay.is_stopped() and grist_type == "Health":
		
		body.health_vial += grist_value
		MusicPlayer.play_pickup_sfx("Gel", self)
		queue_free()
		
	
	pass # Replace with function body.
