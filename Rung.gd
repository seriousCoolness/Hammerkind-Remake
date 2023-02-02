extends ColorRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var climbed
var text_color
var background_color
func _ready():
	color = Color(0,0,0)
	climbed = false
	
	pass

func set_rung_color(bg_color, txt_color):
	background_color = bg_color
	text_color = txt_color
	pass

func set_rung_name(n):
	$RungName.text = n
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not climbed:
		color = Color(0,0,0)
		$RungName.add_color_override("font_color",Color(255,255,255))
	if climbed:
		
		if background_color != null:
			color = background_color
			$RungName.add_color_override("font_color",text_color)
	pass
