extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	
	if $Sprite3D.rotation_degrees.y >=360:
		$Sprite3D.rotation_degrees.y = 0
	$Sprite3D.rotation_degrees.y += 15 * delta
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
