extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var gate_number = 1
var last_player

signal gate_triggered(number, player)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if abs(get_parent().get_parent().get_node("Player").position.y - position.y) > 800 or abs(get_parent().get_parent().get_node("Player").position.x - position.x) > 1200:
		visible = false
	else:
		visible = true
		if $Gate_Delay.time_left >= 5 and last_player.grav == 0:
			
			last_player.velocity.x += ((200 * last_player.position.distance_to(position)) * cos(last_player.get_angle_to(position))) * delta
			last_player.velocity.y += ((200 * last_player.position.distance_to(position)) * sin(last_player.get_angle_to(position))) * delta
			last_player.velocity /= 1.1
		if $Gate_Delay.time_left < 5 and last_player != null and last_player.grav == 0:
			last_player.grav = 2400
			last_player.invulnerable = false
		
	pass

func _on_Gate_body_entered(body):
	
	if body.name == "Player":
			
			if $Gate_Delay.is_stopped():
				$Gate_Delay.start(6.5)
				last_player = body
				if get_parent().get_parent().highest_gate < gate_number:
					
					last_player.grav = 0
					last_player.velocity *= 0
					last_player.invulnerable = true
					
				emit_signal("gate_triggered", gate_number, body)
		
	
	pass # Replace with function body.



func _on_Gate_gate_triggered(number, player):
	pass # Replace with function body.
