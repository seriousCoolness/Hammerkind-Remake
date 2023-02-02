extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var house_builder
var player_owner
export var chunk_coords = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.name != String(chunk_coords.x)+","+String(chunk_coords.y):
		print("Chunk "+name+" is invalid. Unloading without saving.")
		queue_free()
	
	if self.position.distance_to(player_owner.position) > (592 * Global.render_radius) + (592/2):
		print("Unloaded chunk " + name)
		print(self.position.distance_to(player_owner.position))
		print(self.position)
		house_builder.unload_tilemap_chunk(chunk_coords)
	pass
