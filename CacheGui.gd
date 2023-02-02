extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Global.local_player != null:
		$ColorRect.get_node("Cache Limit Number").text = String(Global.local_player.cache_limit)
	
	pass
