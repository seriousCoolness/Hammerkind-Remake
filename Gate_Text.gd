extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not $Gate_Text_Timer.is_stopped():
		
		if fmod($Gate_Text_Timer.time_left, 0.1) >= 0.05:
			
			visible = false
			
		if fmod($Gate_Text_Timer.time_left, 0.1) < 0.05:
			
			visible = true
			
		
	if $Gate_Text_Timer.is_stopped():
		visible = false
	pass

func gate_reached(number):
	
	text = "GATE " + String(number) + " REACHED"
	visible = true
	$Gate_Text_Timer.start(1)
	pass
