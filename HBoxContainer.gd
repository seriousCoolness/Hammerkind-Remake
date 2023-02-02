extends HBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_VScrollBar_scrolling():
	
	$MarginContainer.rect_position.y = -$VScrollBar.value
	
	pass # Replace with function body.
