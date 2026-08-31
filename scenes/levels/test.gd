extends Node2D

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Test Level ready, adding player")
	var player: PackedScene = load("res://scenes/player/player.tscn")
	var player_node: CharacterBody2D = player.instantiate()
	player_node.position = $PlayerSpawnMarker2D.position
	
	add_child(player_node)
	
	print("Player Added!")

func _on_mob_timer_timeout() -> void:
	var mob: CharacterBody2D = mob_scene.instantiate()
	var mob_spawn_location = $MobPath2D/MobSpawnPathFollow2D
	#get a random location along the path and set it to the mob
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	
	add_child(mob)
