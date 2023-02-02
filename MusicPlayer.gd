extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var temp_player_res = preload("res://KnockbackSound.tscn")

var sfx_blunt1_res = preload("res://Sounds/SFX/sfx_blunt.wav")
var sfx_blunt2_res = preload("res://Sounds/SFX/sfx_blunt2.wav")
var sfx_hit1_res = preload("res://Sounds/SFX/sfx_hit.wav")
var sfx_hit2_res = preload("res://Sounds/SFX/sfx_hit2.wav")

var sfx_gelpickup_res = preload("res://Sounds/SFX/sfx_gelpickup.wav")
var sfx_gristpickup_res = preload("res://Sounds/SFX/sfx_gristpickup.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func stop_track():
	$MusicTrack.stop()

func play_track():
	$MusicTrack.play(0.0)

func pause_track():
	$MusicTrack.stream_paused = true

func resume_track():
	$MusicTrack.stream_paused = false

func switch_track(res_path):
	
	var track = load(res_path)
	$MusicTrack.stop()
	$MusicTrack.stream = track
	$MusicTrack.play(0.0)
	

func get_track():
	return $MusicTrack.stream

func play_damage_sfx(type, source):
	
	var audioplayer = temp_player_res.instance()
	
	if(type == "Imp"):
		var rand_sfx = (randi() % 2)
		if (rand_sfx == 1):
			audioplayer.stream = sfx_blunt1_res
		else:
			audioplayer.stream = sfx_blunt2_res
		
	if(type == "Blunt"):
		
		var rand_sfx = (randi() % 2)
		if (rand_sfx == 1):
			audioplayer.stream = sfx_hit1_res
		else:
			audioplayer.stream = sfx_hit2_res
		
	
	source.add_child(audioplayer)
	audioplayer.play(0.0)
	pass

func play_pickup_sfx(type, source):
	
	var audioplayer = temp_player_res.instance()
	
	if(type == "Gel"):
		audioplayer.stream = sfx_gelpickup_res
	if(type == "Grist"):
		audioplayer.stream = sfx_gristpickup_res
	
	Global.world.add_child(audioplayer)
	audioplayer.position = source.position
	audioplayer.play(0.0)
	pass
