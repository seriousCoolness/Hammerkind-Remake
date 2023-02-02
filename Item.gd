extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var display_name : String = "Perfectly Generic Object"
export var texture : Texture
export var Size : Vector2 = Vector2(27.6,27.6)
export var captchalogue_code : String = "00000000"
export var grist_cost : Dictionary
export var properties : Dictionary
var components : String
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = texture
	$CollisionShape2D.shape.extents = Size
	pass # Replace with function body.

func can_player_captchalogue(player):
	
	
	return false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
