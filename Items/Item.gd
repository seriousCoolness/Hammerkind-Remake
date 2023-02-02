extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var display_name : String = "Perfectly Generic Object"
export var texture : Texture
export var custom_renderer : bool = false
export var size : Vector2 = Vector2(27.6,27.6)
export var captchalogue_code : String = "00000000"
export var grist_cost : Dictionary
export var properties : Dictionary
var components : String
# Called when the node enters the scene tree for the first time.
func _ready():
	init_texture()
	init_collision()
	
	pass # Replace with function body.

func init_texture():
	
	if custom_renderer == false:
		var sprite = Sprite.new()
		sprite.name = "Sprite"
		sprite.texture = texture
		sprite.scale = Vector2(0.65, 0.65)
		add_child(sprite)
	
	pass

func init_collision():
	
	if get_node_or_null("CollisionShape2D") != null:
		
		if get_node("CollisionShape2D").shape is RectangleShape2D:
			size = get_node("CollisionShape2D").shape.extents
		if get_node("CollisionShape2D").shape is CapsuleShape2D:
			size = Vector2(get_node("CollisionShape2D").shape.radius * 2, get_node("CollisionShape2D").shape.height)
		
	
	pass

func can_player_captchalogue(player):
	
	
	
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y > 10000:
		self.queue_free()
	pass
