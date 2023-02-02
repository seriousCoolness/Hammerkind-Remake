extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var text_color
var background_color
# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Background.color = background_color
	$VBoxContainer/Background/Rung.add_color_override("font_color",text_color)
	pass # Replace with function body.

func set_rung_color(bg_color, txt_color):
	background_color = bg_color
	text_color = txt_color
	pass

func set_rung_name(name):
	
	$VBoxContainer/Background/Rung.text = name + "!"
	self.name = name
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
