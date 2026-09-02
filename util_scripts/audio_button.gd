extends Button
class_name AudioButton

@export var sound: AudioStreamWAV
var audio_player = null

func _init():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	connect("pressed", audio_player.play,)    

func _ready() -> void:
	audio_player.stream = sound

func set_sound(p_value):
	sound = p_value
	if audio_player:
		audio_player.stream = sound
