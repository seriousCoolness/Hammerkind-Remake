extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vial_rect

# Called when the node enters the scene tree for the first time.
func _ready():
	vial_rect = $Background/Vial_Outline.rect_size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Global.local_player != null:
		
		$Background/Vial_Outline.rect_position.x = lerp($Background/Vial_Outline.rect_position.x, 0 + (vial_rect.x * ((Global.local_player.max_health_vial - Global.local_player.health_vial) / Global.local_player.max_health_vial)), 0.4)
		$Background/Inside_Border/Vial_Inside.rect_position.x = lerp($Background/Inside_Border/Vial_Inside.rect_position.x, 0 + (vial_rect.x * ((Global.local_player.max_health_vial - Global.local_player.health_vial) / Global.local_player.max_health_vial)), 0.4)
		
	
	pass
