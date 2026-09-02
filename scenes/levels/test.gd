extends Node2D

@export var mob_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("Test Level ready, adding player")
	#var player: PackedScene = load("res://scenes/player/player.tscn")
	#var player_node: CharacterBody2D = player.instantiate()
	
	var player_node = get_tree().get_first_node_in_group("player")
	player_node.position = $PlayerSpawnMarker2D.position
	player_node.dead = false
	
	#add_child(player_node)
	
	print("Player Teleported!")
	

func _on_mob_timer_timeout() -> void:
	var mob: CharacterBody2D = mob_scene.instantiate()
	var mob_spawn_location = $MobPath2D/MobSpawnPathFollow2D
	#get a random location along the path and set it to the mob
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	mob.died.connect(_play_death_sound)
	add_child(mob)

func _play_death_sound():
	$EnemyDeathAudioStreamPlayer.play()
