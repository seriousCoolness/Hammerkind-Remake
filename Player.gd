extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player_gui_res = preload("res://Player_GUI.tscn")
var player_gui


var max_health_vial : float
var health_vial : float
var mangrit_vial : float
var gel_viscocity

var echeladder_rung
var echeladder_names = Array()
var echeladder_bgcolors = Array()
var echeladder_txtcolors = Array()
var cache_limit_rewards = Array()
var echeladder_progress

var grists = Dictionary()
var cache_limit: int

var strife_specibus = Array()
var weapon_item_res = preload("res://Items/Weapons/Claw_Hammer.tscn")
var weapon_item
var weapon_hitbox
var weapon_sprite

var velocity = Vector2()
var previous_safe_position = Vector2()
var starting_accel
var airaccel
var airdecel
var decel
var topspeed
var bounce
var fric
var jump
var grav
var on_ground
var invulnerable
var is_attacking
var blunt_sliding
var flipped

# Called when the node enters the scene tree for the first time.
func _ready():
	
	gel_viscocity = 0
	max_health_vial = 10 + (gel_viscocity * 2)
	health_vial = max_health_vial
	mangrit_vial = 5
	
	init_echeladder()
	init_grist()
	
	strife_specibus.append("Hammer")
	set_weapon("res://Items/Weapons/Claw_Hammer.tscn")
	
	velocity = Vector2(0,0)
	starting_accel = 2500
	decel = 6000
	airaccel = 300
	airdecel = 180
	topspeed = 55000
	bounce = 0.3
	fric = 1700
	jump = 51000
	grav = 2400
	on_ground = false
	invulnerable = false
	is_attacking = false
	blunt_sliding = false
	flipped = false
	
	pass # Replace with function body.

func init_echeladder():
	
	echeladder_rung = 1
	echeladder_progress = 0
	
	echeladder_names.append("LODESTAR YOUTH")
	echeladder_bgcolors.append(Color(49.0/255.0,36.0/255.0,172.0/255.0))
	echeladder_txtcolors.append(Color(23.0/255.0,150.0/255.0,208.0/255.0))
	cache_limit_rewards.append(500)
	echeladder_names.append("RUMPUS BUSTER")
	echeladder_bgcolors.append(Color(161.0/255.0,68.0/255.0,0.0/255.0))
	echeladder_txtcolors.append(Color(201.0/255.0,52.0/255.0,75.0/255.0))
	cache_limit_rewards.append(500)
	echeladder_names.append("BOY-SKYLARK")
	echeladder_bgcolors.append(Color(61.0/255.0,1,23.0/255.0))
	echeladder_txtcolors.append(Color(0.0,151.0/255.0,11.0/255.0))
	cache_limit_rewards.append(850)
	echeladder_names.append("GADABOUT PIPSQUEAK")
	echeladder_bgcolors.append(Color(228.0/255.0,255.0/255.0,0))
	echeladder_txtcolors.append(Color(108.0/255.0,154.0/255.0,0))
	cache_limit_rewards.append(350)
	echeladder_names.append("MOPPET OF DESTINY")
	echeladder_bgcolors.append(Color(216.0/255.0,133.0/255.0,217.0/255.0))
	echeladder_txtcolors.append(Color(108.0/255.0,0,1))
	cache_limit_rewards.append(350)
	echeladder_names.append("KNEEHIGH PILGRIM")
	echeladder_bgcolors.append(Color(241.0/255.0,43.0/255.0,38.0/255.0))
	echeladder_txtcolors.append(Color(1,1,1))
	cache_limit_rewards.append(220)
	echeladder_names.append("COOL BUCKAROO")
	echeladder_bgcolors.append(Color(177.0/255.0,255.0/255.0,255.0/255.0))
	echeladder_txtcolors.append(Color(89.0/255.0,89.0/255.0,89.0/255.0))
	cache_limit_rewards.append(220)
	echeladder_names.append("BRAVESPROUT")
	echeladder_bgcolors.append(Color(223.0/255.0,187.0/255.0,108.0/255.0))
	echeladder_txtcolors.append(Color(255.0/255.0,0,0))
	cache_limit_rewards.append(160)
	echeladder_names.append("NIPPER CADET")
	echeladder_bgcolors.append(Color(52.0/255.0,90.0/255.0,255.0/255.0))
	echeladder_txtcolors.append(Color(0,255.0/255.0,240.0/255.0))
	cache_limit_rewards.append(80)
	echeladder_names.append("PESKY URCHIN")
	echeladder_bgcolors.append(Color(168.0/255.0,255.0/255.0,168.0/255.0))
	echeladder_txtcolors.append(Color(255.0/255.0,184.0/255.0,174.0/255.0))
	cache_limit_rewards.append(40)
	echeladder_names.append("CHAMP-FRY")
	echeladder_bgcolors.append(Color(255.0/255.0,174.0/255.0,0))
	echeladder_txtcolors.append(Color(248.0/255.0,0,0))
	cache_limit_rewards.append(30)
	echeladder_names.append("ANKLEBITER")
	echeladder_bgcolors.append(Color(161.0/255.0,32.0/255.0,172.0/255.0))
	echeladder_txtcolors.append(Color(138.0/255.0,255.0/255.0,51.0/255.0))
	cache_limit_rewards.append(30)
	echeladder_names.append("FIDGETY BOPPER")
	echeladder_bgcolors.append(Color(36.0/255.0,217.0/255.0,215.0/255.0))
	echeladder_txtcolors.append(Color(0,142.0/255.0,160.0/255.0))
	cache_limit_rewards.append(20)
	echeladder_names.append("PLUCKY TOT")
	echeladder_bgcolors.append(Color(255.0/255.0,43.0/255.0,143.0/255.0))
	echeladder_txtcolors.append(Color(0,0,0))
	cache_limit_rewards.append(20)
	echeladder_names.append("JUVESQUIRT")
	echeladder_bgcolors.append(Color(253.0/255.0,255.0/255.0,43.0/255.0))
	echeladder_txtcolors.append(Color(255.0/255.0,148.0/255.0,43.0/255.0))
	cache_limit_rewards.append(10)
	echeladder_names.append("GREENTYKE")
	echeladder_bgcolors.append(Color(79.0/255.0,212.0/255.0,0))
	echeladder_txtcolors.append(Color(253.0/255.0,255.0/255.0,43.0/255.0))
	cache_limit_rewards.append(0)
	pass

func init_grist():
	
	cache_limit = 20
	#Column 1
	grists = {"Build": 20,
			  "Shale": 0,
			  "Chalk": 0,
			  "Amber": 0,
			  "Uranium": 0,
			  "Blood": 0,
			  "Caulk": 0,
			  "Rust": 0,
			  "Sulfur": 0,
	#Column Two
			  "Copper": 0,
			  "Garnet": 0,
			  "Marble": 0,
			  "Frosting": 0,
			  "Aluminum": 0,
			  "Sandstone": 0,
			  "Tar": 0,
			  "Malachite": 0,
			  "Jet": 0,
	#Column Three
			  "Amethyst": 0,
			  "Obsidian": 0,
			  "Emerald": 0,
			  "Mercury": 0,
			  "Redstone": 0,
			  "Candy": 0,
			  "Sapphire": 0,
			  "Gold": 0,
			  "Zillium": 0,
	#Column Four
			  "Sugar": 0,
			  "Cobalt": 0,
			  "Opal": 0,
			  "Iodine": 0,
			  "Radium": 0,
			  "Diamond": 0,
			  "Spectrum": 0,
			  "Quartz": 0,
			  "Artifact": 0
	}
	
	pass

func _process(delta):
	
	if Global.is_world_ready and Global.world.get_node_or_null("CanvasLayer") == null:
		
		player_gui = player_gui_res.instance()
		Global.world.add_child(player_gui)
		
	
	handle_echeladder()
	
	if Input.is_action_just_pressed("game_strifebar_1"):
		set_weapon("res://Items/Weapons/Claw_Hammer.tscn")
	
	if Input.is_action_just_pressed("game_strifebar_2"):
		set_weapon("res://Items/Weapons/Pogo_Hammer.tscn")
	
	if Input.is_action_just_pressed("game_strifebar_0"):
		set_weapon("None")
	
	if Input.is_key_pressed(KEY_END):
		add_echeladder_progress(50)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if flipped == true:
		
		$Body.scale.x = -0.65
		weapon_hitbox.scale.x = -1
		
	if flipped == false:
		
		$Body.scale.x = 0.65
		weapon_hitbox.scale.x = 1
		
	
	if health_vial > max_health_vial:
		
		health_vial = max_health_vial
		
	
	if health_vial <= 0:
		
		handle_die()
		
	
	if position.y >= 1024 or velocity.y >= 2500.0:
		
		var fall_position = position
		velocity = Vector2(0,0)
		position = previous_safe_position
		damage_player(4, 1, position)
		
	
	var accel = starting_accel
	accel -= abs(velocity.x) / 25
	
	handle_collisions(delta)
	
	if $BodyAnimations.assigned_animation != "blunt_attack":
		if Input.is_action_pressed("ui_right") and velocity.x >= 0:
			
			if on_ground: 
				velocity.x += accel * delta
			else:
				velocity.x += airaccel * delta
		if Input.is_action_pressed("ui_right") and velocity.x <= 0:
			
			if on_ground: 
				velocity.x += decel * delta
			else:
				velocity.x += airdecel * delta
		if Input.is_action_pressed("ui_left") and velocity.x <= 0:
			
			if on_ground: 
				velocity.x -= accel * delta
			else:
				velocity.x -= airaccel * delta
		if Input.is_action_pressed("ui_left") and velocity.x >= 0:
			
			if on_ground: 
				velocity.x -= decel * delta
			else:
				velocity.x -= airdecel * delta
			
		
	
	if (not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") and on_ground) or ($BodyAnimations.assigned_animation == "blunt_attack" and on_ground):
		
		if abs(velocity.x) - (fric * delta) < 0:
			velocity.x = 0
		else:
			velocity.x -= sign(velocity.x) * (fric * delta)
		
	
	if abs(velocity.x) > topspeed * delta:
		velocity.x = sign(velocity.x) * (topspeed * delta)
	
	
	if on_ground:
		
		previous_safe_position.x = position.x - (sign(velocity.x) * 56)
		previous_safe_position.y = position.y
		if Input.is_action_pressed("game_jump") and not is_attacking:
			velocity.y -= jump * delta
		if Input.is_action_pressed("ui_down") and velocity.y == 0:
			position.y += 0.3
		
	
	if Input.is_action_pressed("ui_up") and $Camera2D.offset.y > -200:
		
		$Camera2D.offset.y = lerp($Camera2D.offset.y, -200, 0.05)
		
	if not Input.is_action_pressed("ui_up"):
		
		$Camera2D.offset.y = lerp($Camera2D.offset.y, 0, 0.1)
		
	
	move_and_slide(velocity, Vector2(0,-1))
	
	handle_animation()
	
	if $BodyAnimations.assigned_animation == "blunt_attack":
		
		is_attacking = true
		
	else:
		
		is_attacking = false
		
	
	pass


func add_grist(type, amount):
	
	grists[type] += amount
	
	if grists[type] < 0:
		
		grists[type] = 0
		
	
	if grists[type] > cache_limit:
		
		grists[type] = cache_limit
		
	
	pass 

func add_echeladder_progress(amount):
	
	echeladder_progress += amount
	
	pass

func get_rung_progress(rung):
	
	return (5 * (rung-1) * rung-1)
	

func handle_echeladder():
	
	while echeladder_progress >= get_rung_progress(echeladder_rung+1):
		print("Echeladder Rung " +String(echeladder_rung)+" progress: " + String(get_rung_progress(echeladder_rung+1)))
		echeladder_rung += 1
		gel_viscocity += 1 * (echeladder_rung * 0.5)
		max_health_vial += (gel_viscocity * 2)
		health_vial = max_health_vial
		
		if echeladder_rung-1 < cache_limit_rewards.size():
			cache_limit += cache_limit_rewards[-(echeladder_rung)]
		
		
	
	pass

func handle_animation():
	
	var type = get_weapon_type()
	
	if type == "Blunt":
		handle_blunt_animations()
	else:
		handle_empty_animations()
	
	pass
func handle_empty_animations():
	
	if is_on_floor():
		
		$BodyAnimations.playback_speed = abs(velocity.x) * 0.005
		
	
	if $ArmAnimations.assigned_animation == "empty_attack":
		
		$ArmAnimations.playback_speed = 2.5
		
	
	if invulnerable and $Timer.time_left >= 0.5:
		if fmod($Timer.time_left, 0.1) >= 0.05:
			
			$Body.visible = false
			
		if fmod($Timer.time_left, 0.1) < 0.05:
			
			$Body.visible = true
			
		
	
	if $ArmAnimations.current_animation != "empty_attack":
		$ArmAnimations.play("hide_arms")
		weapon_hitbox.set_collision_layer_bit(11, false)
		weapon_hitbox.set_collision_layer_bit(12, false)
	
	if Input.is_action_just_pressed("game_attack"):
		
		if $ArmAnimations.current_animation != "empty_attack":
			
			$ArmAnimations.play("empty_attack")
			weapon_hitbox.set_collision_layer_bit(11, true)
			weapon_hitbox.set_collision_layer_bit(12, true)
			
		
	
	
	
	if Input.is_action_pressed("ui_right") and velocity.x >= 0:
		
		if is_on_floor():
			flipped = false
			$BodyAnimations.play("run")
			
		
	if Input.is_action_pressed("ui_left") and velocity.x < 0:
		
		if is_on_floor():
			flipped = true
			$BodyAnimations.play("run")
			
		
	if Input.is_action_pressed("ui_right") and velocity.x <= 0:
		
		if is_on_floor():
			flipped = false
			$BodyAnimations.play("slide")
			
		
	if Input.is_action_pressed("ui_left") and velocity.x > 0:
		
		if is_on_floor():
			flipped = true
			$BodyAnimations.play("slide")
			
		
	
	if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		
		if velocity.x == 0:
			
			$BodyAnimations.play("idle")
			
		else:
			
			$BodyAnimations.play("slide")
			
		
	
	
	if (not on_ground and not is_on_floor()) or (not on_ground and not is_on_floor() and Input.is_action_pressed("ui_down")):
		
		$BodyAnimations.play("jump")
		
	
	pass



func handle_blunt_animations():
	
	if is_on_floor():
		
		$BodyAnimations.playback_speed = abs(velocity.x) * 0.005
		
	if $BodyAnimations.assigned_animation == "blunt_attack":
		
		$BodyAnimations.playback_speed = 2.5
		$ArmAnimations.playback_speed = 2.4 + (weapon_item.speed / 10.0)
		
	
	
	if invulnerable and $Timer.time_left >= 0.5:
		if fmod($Timer.time_left, 0.1) >= 0.05:
			
			$Body.visible = false
			
		if fmod($Timer.time_left, 0.1) < 0.05:
			
			$Body.visible = true
			
		
	
	if Input.is_action_pressed("game_attack") and $BodyAnimations.assigned_animation != "blunt_attack":
		
		$BodyAnimations.play("blunt_attack")
		$ArmAnimations.play("blunt_attack")
		$HeadAnimations.play("angry")
		blunt_sliding = false
		weapon_hitbox.set_collision_layer_bit(11, true)
		weapon_hitbox.set_collision_layer_bit(12, true)
		
	
	
	if not $BodyAnimations.assigned_animation == "blunt_attack" or (blunt_sliding and not Input.is_action_pressed("game_attack")):
		if Input.is_action_pressed("ui_right") and velocity.x >= 0:
			
			if is_on_floor():
				flipped = false
				$BodyAnimations.play("run")
				$ArmAnimations.play("hide_arms")
				$HeadAnimations.play("neutral")
				
			
		if Input.is_action_pressed("ui_left") and velocity.x < 0:
			
			if is_on_floor():
				flipped = true
				$BodyAnimations.play("run")
				$ArmAnimations.play("hide_arms")
				$HeadAnimations.play("neutral")
				
			
		if Input.is_action_pressed("ui_right") and velocity.x <= 0:
			
			if is_on_floor():
				flipped = false
				$BodyAnimations.play("slide")
				$ArmAnimations.play("hide_arms")
				$HeadAnimations.play("neutral")
				
			
		if Input.is_action_pressed("ui_left") and velocity.x > 0:
			
			if is_on_floor():
				flipped = true
				$BodyAnimations.play("slide")
				$ArmAnimations.play("hide_arms")
				
			
		
		if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			
			if velocity.x == 0:
				
				$BodyAnimations.play("idle")
				$ArmAnimations.play("hide_arms")
				$HeadAnimations.play("neutral")
				
			else:
				
				$BodyAnimations.play("slide")
				$ArmAnimations.play("hide_arms")
				
			
			weapon_hitbox.set_collision_layer_bit(11, false)
			weapon_hitbox.set_collision_layer_bit(12, false)
			
		
	
	if (not on_ground and not is_on_floor() and not Input.is_action_pressed("game_attack")) or (not on_ground and not is_on_floor() and Input.is_action_pressed("ui_down")):
		
		$BodyAnimations.play("jump")
		$ArmAnimations.play("hide_arms")
		
	
	pass



func handle_collisions(var delta):
	on_ground = false
	
	for i in range(0, get_slide_count()):
		var collision = get_slide_collision(i)
		
		if collision.collider.get_collision_layer_bit(0):
			
			if is_on_floor():
				
				on_ground = true
				
			
			if is_on_wall() and not velocity.x == 0:
				
				velocity.x = 0
				
			
			if is_on_ceiling() and not velocity.y == 0:
				
				velocity.y = 0
				
			
		
		#if collision.collider.get_collision_layer_bit(1):
		#	
		#	
		#	
		#if collision.collider.get_collision_layer_bit(12): #Underling hit-box (NOT collision-box)
		#	
		#	if not invulnerable:
		#		
		#		velocity.x = sign(velocity.x) * -500
		#		velocity.y = 0
		#		health_vial -= collision.collider.get_owner().damage
		#		invulnerable = true
		#		$Timer.start(1)
		#		
		#	
		
	
	if on_ground:
		velocity.y = 0
	else:
		velocity.y += grav * delta
	
	pass



func _on_Timer_timeout():
	
	invulnerable = false
	$Body.visible = true
	pass # Replace with function body.



func damage_player(damage, time, enemy_pos):
	
	if not invulnerable:
		
		if enemy_pos != position:
			velocity.x = sign(position.x - enemy_pos.x) * 500
		else:
			velocity.x = 0
		velocity.y = 0
		health_vial -= damage
		invulnerable = true
		$Timer.start(time)
		MusicPlayer.play_damage_sfx("Blunt", self)
		
	
	pass



func handle_die():
	
	Global.goto_scene(Global.world.get_filename())
	
	pass


#so that the game knows that john has finished swinging his hammer.
func _on_Body_animation_finished(anim_name):
	
	if get_weapon_type() == "Blunt":
		blunt_sliding = true
		if on_ground and abs(velocity.x) < 20 and not Input.is_action_pressed("game_attack") and anim_name == "blunt_attack":
			
			$BodyAnimations.play("idle")
			blunt_sliding = false
			weapon_hitbox.set_collision_layer_bit(11, false)
			weapon_hitbox.set_collision_layer_bit(12, false)
			
		
	
	pass # Replace with function body.



func set_weapon(resource_path):
	
	if resource_path != "None" and ResourceLoader.exists(resource_path):
		
		weapon_item_res = load(resource_path)
		weapon_item = weapon_item_res.instance()
		weapon_hitbox = get_node("Hammer")
		weapon_sprite = get_node("Body/WeaponSprite")
		weapon_sprite = weapon_item.make_weapon_sprite(weapon_sprite)
		
	if resource_path == "None":
		
		weapon_item_res = null
		weapon_item = null
		weapon_hitbox = get_node("Hammer")
		weapon_sprite = get_node("Body/WeaponSprite")
		weapon_sprite.texture = null
		
	
	pass



#get the string weapon_type from weapon_item. if the weapon doesn't exist, return "None"
func get_weapon_type():
	
	if weapon_item == null:
		return "Empty"
	else:
		return weapon_item.weapon_type
	


#Get total damage from echeladder bonuses, equipment bonuses, misc buffs, and weapon base-damage.
func get_total_damage():
	
	var total_damage = 0
	
	if weapon_item != null:
		total_damage += weapon_item.damage
	else:
		total_damage += 0
	
	return total_damage


#get enemy knockback for weapons
func get_weapon_knockback():
	
	var total_knockback = 0
	
	if weapon_item != null:
		total_knockback += ((velocity.length() / 10.0) + (weapon_item.speed * 10)) * weapon_item.mass
	else:
		total_knockback += (velocity.length() / 10.0) + 250.0
	
	return total_knockback

