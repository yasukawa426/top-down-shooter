extends Node2D

var score:int = 0

var game_started: bool = false
var test_level: PackedScene = preload("res://scenes/levels/test.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true


func _start_game() -> void:
	#reset level
	var levels = $Levels.get_children()
	for node in levels:
		node.queue_free()
	
	var level_instance = test_level.instantiate()
	$Levels.add_child(level_instance)
	level_instance.player_died.connect(_on_player_died)
	
	
	#reset score
	_set_score(0)
	$ScoreTimer.start()
	
	#reset player
	$Player.reset()
	
	#unpause game
	get_tree().paused = false


func _on_hud_start_game() -> void:
	_start_game()


func _on_player_died() -> void:
	get_tree().paused = true
	$HUD.show_game_over(score)


func _on_score_timer_timeout() -> void:
	_set_score(score + 1)


func _set_score(value: int) -> void:
	score = value
	$HUD.update_score(value)


func _on_player_damaged() -> void:
	var data :Dictionary = $Player.get_player_stats()
	$HUD.update_health(data.current_hp, data.max_hp)


func _on_hud_end_game() -> void:
	#TODO: save data before quiting?
	get_tree().quit()
