extends KinematicBody2D

var grist_res = preload("res://Grist.tscn")

var player

export var health_vial = 20
export var damage = 2

export var echeladder_reward = 5

export var grist_multi = 1.0
export var grist_primary = "Shale"
export var grist_secondary = "Tar"

var velocity = Vector2()
var facing
var speed
var decel
var fric
var jump
var grav

var on_ground
var attacked
var is_active

var target_groups = Array()
var aggressors_register = Dictionary()
var current_target = Array()

export var aggro_range = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Global.is_world_ready == true:
		player = Global.local_player
	
	grist_multi = 2.0
	grist_primary = player.grists.keys()[(randi() % (player.grists.keys().size()-10)+1)]
	grist_secondary = player.grists.keys()[(randi() % (player.grists.keys().size()-10)+1)]
	
	facing = 1
	
	speed = 200
	decel = 3600
	fric = 1200
	jump = 800
	grav = 1800
	
	target_groups.append("Players")
	
	on_ground = false
	is_active = false
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(0, false)
	velocity.x = 0
	pass # Replace with function body.

func init_enemy(primary, secondary, value_mult, start_vel):
	
	grist_primary = primary
	grist_secondary = secondary
	grist_multi = value_mult
	
	is_active = false
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(0, false)
	velocity.x = start_vel.x
	velocity.y = start_vel.y
	pass

func _physics_process(delta):
	
	if Global.is_world_ready == true:
		
		if not is_active and velocity.y >= 0:
			
			is_active = true
			
		
		if is_active and not get_collision_layer_bit(2):
			set_collision_layer_bit(2, true)
			set_collision_mask_bit(0, true)
			if test_move(transform, velocity):
				
				set_collision_layer_bit(2, false)
				set_collision_mask_bit(0, false)
				
				
			
		
		if is_on_floor():
			
			velocity.y = 0
			
		else:
			
			velocity.y += grav * delta
			
		
		if is_on_ceiling():
			
			velocity.y = 0
			
		
		if is_active:
			
			handle_ai(player.position, delta)
			
		
		if sign(velocity.x) == -1:
			
			$Sprite.flip_h = false
			
		if sign(velocity.x) == 1:
			
			$Sprite.flip_h = true
			
		
		move_and_slide(velocity, Vector2(0,-1))
		
		if is_active and not get_collision_layer_bit(2):
			set_collision_layer_bit(2, true)
			set_collision_mask_bit(0, true)
			if test_move(transform, velocity):
				
				set_collision_layer_bit(2, false)
				set_collision_mask_bit(0, false)
				
				
			
		
	
	pass

func _process(delta):
	
	if Global.is_world_ready == true:
		
		if health_vial <= 0:
			
			handle_die()
			
		
		
		for area in $Area2D.get_overlapping_areas():
			
			if area.get_groups()[0] == "Weapons":
				
				$Timer.stop()
				velocity.x = sign(position.x - player.position.x) * player.get_weapon_knockback()
				
				if $Hit_sfx_timer.is_stopped() == true:
					
					MusicPlayer.play_damage_sfx("Imp", self)
					$Hit_sfx_timer.start(0.5)
					
				
				health_vial -= player.get_total_damage()
				
			
		
	
	pass

func handle_ai(player_position, delta):
	
	if max(player_position.x, position.x) - min(position.x, player_position.x) <= aggro_range and max(player_position.y, position.y) - min(position.y, player_position.y) <= aggro_range/3 and randf() <= (1/Performance.get_monitor(Performance.TIME_FPS)) and $Timer.is_stopped():
		
		$Timer.start(1)
		
		var rand_facing = randi() % 3
		if rand_facing == 2:
			facing = sign(player_position.x - position.x)
		if rand_facing == 0:
			facing = facing * -1
		
	if not $Timer.is_stopped() and is_on_floor(): 
		
		velocity.x = facing * speed
		
	
	if $Timer.is_stopped():
		
		if is_on_floor():
			if abs(velocity.x) - sign(velocity.x) * (fric * delta) < 0:
				velocity.x = 0
			else:
				velocity.x -= sign(velocity.x) * (fric * delta)
			
		
	
	if on_ground:
		
		var rand_vertical = randf()
		if player.position.y < position.y and rand_vertical >= 0.33:
			velocity.y = -jump
			on_ground = false
		if player.position.y < position.y and rand_vertical < 0.33:
			position.y += 1.1
			on_ground = false
		
		if player.position.y > position.y and rand_vertical >= 0.33:
			position.y += 1.1
			on_ground = false
		if player.position.y > position.y and rand_vertical < 0.33:
			velocity.y = -jump
			on_ground = false
		
	
	pass

func handle_die():
	
	handle_xp()
	
	var num_pickups = (randi() % (4 * int(grist_multi * 1.1)))
	var starting_number = num_pickups
	while num_pickups >= 0:
		
		var grist_pickup = grist_res.instance()
		
		var rand_grist_type = (randi() % 6)
		
		var grist_type_name
		var grist_value
		if rand_grist_type >= 0 and rand_grist_type < 3:
			grist_type_name = "Build"
			grist_value = (randi() % int(grist_multi * 5)) + 1
			
		if rand_grist_type >= 3 and rand_grist_type < 5:
			grist_type_name = grist_primary
			grist_value = (randi() % int(grist_multi * 4)) + 1
			
		if rand_grist_type == 5:
			grist_type_name = grist_secondary
			grist_value = (randi() % int(grist_multi * 3)) + 1
			
		if num_pickups == starting_number:
			grist_type_name = "Build"
			grist_value = (randi() % int(grist_multi * 3)) + 3
			
		
		var angle = randf() * PI
		grist_pickup.position = self.position
		
		var grist_force = Vector2()
		grist_force.x = (cos(angle) * 400)
		grist_force.y = -(sin(angle) * 1200)
		grist_pickup.set_axis_velocity(grist_force)
		
		grist_pickup.init_grist(grist_type_name, grist_value)
		get_parent().add_child(grist_pickup)
		
		num_pickups -= 1
		
	
	var rand_vitality_gel = randi() % 8
	
	if rand_vitality_gel >= 2 and rand_vitality_gel <= 3:
		
		var health_pickup = grist_res.instance()
		
		var angle = randf() * PI
		health_pickup.position = self.position
		var grist_force = Vector2()
		grist_force.x = (cos(angle) * 400)
		grist_force.y = -(sin(angle) * 1200)
		health_pickup.set_axis_velocity(grist_force)
		
		health_pickup.init_grist("Health", 2)
		get_parent().add_child(health_pickup)
		
	if rand_vitality_gel == 4:
		
		var health_pickup = grist_res.instance()
		
		var angle = randf() * PI
		health_pickup.position = self.position
		var grist_force = Vector2()
		grist_force.x = (cos(angle) * 400)
		grist_force.y = -(sin(angle) * 1200)
		health_pickup.set_axis_velocity(grist_force)
		
		health_pickup.init_grist("Health", 5)
		get_parent().add_child(health_pickup)
		
	
	queue_free()
	
	pass

func handle_xp():
	
	
	player.add_echeladder_progress(echeladder_reward)
	
	pass

func _on_body_entered(body):
	
	for group in body.get_groups():
		for target in target_groups:
			
			if group == target:
				
				body.damage_player(damage, 2, position)
				
			
		
	
	pass # Replace with function body.


func _on_Timer_timeout():
	
	if is_on_floor():
		
		on_ground = true
		
	
	pass # Replace with function body.
