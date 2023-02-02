extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	
	update_weapon()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_weapon():
	
	if Global.local_player != null and Global.local_player.weapon_item != null:
		
		$Card/KindLabel.text = Global.local_player.weapon_item.kind_abstrata + "kind"
		$Card/StrifeItem.texture = Global.local_player.weapon_item.texture
		
	if Global.local_player != null and Global.local_player.weapon_item == null:
		
		$Card/KindLabel.text = ""
		$Card/StrifeItem.texture = null
		
	pass
