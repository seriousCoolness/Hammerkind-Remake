extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()

const ACCELERATION = 30
const AIRACCELERATION = 3
const AIRDECELERATION = 7
const DECELERATION = 40
const JUMP = 525

var friction
var bounceFactor
var gravity
var topspeed

var hasJumped = bool()

func _ready():
	friction = 30
	bounceFactor = 0.3
	gravity = 30
	topspeed = 600
	
	hasJumped = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if abs(velocity.x) <= topspeed and not Input.is_action_pressed("game_attack"):
		
		if Input.is_action_pressed("ui_right") and velocity.x >= 0:
			if is_on_floor():
				velocity.x += ACCELERATION
			else:
				velocity.x += AIRACCELERATION
			
		if Input.is_action_pressed("ui_left") and velocity.x <= 0:
			if is_on_floor():
				velocity.x -= ACCELERATION
			else:
				velocity.x -= AIRACCELERATION
			
		if Input.is_action_pressed("ui_right") and velocity.x <= 0:
			if is_on_floor():
				velocity.x += DECELERATION
			else:
				velocity.x += AIRDECELERATION
			
		if Input.is_action_pressed("ui_left") and velocity.x >= 0:
			if is_on_floor():
				velocity.x -= DECELERATION
			else:
				velocity.x -= AIRDECELERATION
			
		
	
	if abs(velocity.x) > topspeed:
		
		velocity.x = sign(velocity.x) * topspeed
		
	
	if is_on_floor():
		
		velocity.y = 0
		hasJumped = false
		
		if Input.is_action_pressed("game_jump"):
			
			velocity.y = -JUMP
			hasJumped = true
			
		
		if $Sprite.animation == "run_attack":
			
			$Sprite.speed_scale = 5
			
		else:
			
			$Sprite.speed_scale = abs(velocity.x) * 0.015
			
		
		if (not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left")) or $Sprite.animation == "run_attack":
			
			if abs(velocity.x) - friction >= 0:
				velocity.x -= sign(velocity.x) * friction
			else:
				velocity.x = 0
			
		
	
	if is_on_wall():
		print("collided with wall")
		if not((velocity.x * -1) * bounceFactor >= 0 and sign(velocity.x) == 1) and not((velocity.x * -1) * bounceFactor <= 0 and sign(velocity.x) == -1):
			print("wall bounced player")
			velocity.x = ((velocity.x * -1) * bounceFactor)
		else:
			print("wall stopped player")
			velocity.x = 0
		
	
	if abs(velocity.x) <= 1:
		velocity.x = 0
	
	if not is_on_floor():
		
		velocity.y += gravity
		
	
	move_and_slide(velocity, Vector2(0, -1))
	
	
	
	
	
	
	
	pass


func _on_Sprite_animation_finished():
		
		
		pass # Replace with function body.
