extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
var show_detailed

func _ready():
	
	show_detailed = false
	if name != "Radium" and name != "Spectrum" and name != "Opal":
		$Background/Icon.texture = load("res://Sprites/Pickups/" + name + "_Grist.png")
	else:
		$Background/Icon.texture = load("res://Sprites/Pickups/" + name + "_Grist.tres")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.local_player != null:
		
		if Global.local_player.cache_limit < 1000 or show_detailed == true:
			$Background/Number.text = String(Global.local_player.grists[name])+' / '+String(Global.local_player.cache_limit)
		else:
			$Background/Number.text = String(Global.local_player.grists[name])
		$Background/TextureProgress.value = (float(Global.local_player.grists[name])/float(Global.local_player.cache_limit)) * 100.0
		
	
	pass


func _on_Build_mouse_entered():
	show_detailed = true
	pass # Replace with function body.


func _on_Build_mouse_exited():
	show_detailed = false
	pass # Replace with function body.
