extends CanvasLayer

# start button pressed, time to start game
signal start_game
signal end_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameplayControl.hide()
	$GameOverControl.hide()

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over(score: int) -> void:
	$GameplayControl.hide()
	
	$GameOverControl/ColorRect/GameOverLabel.text = "DIED IN " + _score_to_time(score)
	$GameOverControl.show()
	

func _on_message_timer_timeout() -> void:
	$MessageLabel.hide()


func _on_exit_button_pressed() -> void:
	end_game.emit()


func _on_start_button_pressed() -> void:
	$GameplayControl.show()
	$MenuControl.hide()
	$GameOverControl.hide()
	
	#TODO: get player data in a better way
	var player_data = get_node("../Player").get_player_stats()
	
	$GameplayControl/HealthProgressBar.max_value = player_data.max_hp
	$GameplayControl/HealthProgressBar.value = player_data.max_hp
	
	start_game.emit()

func update_score(value: int) -> void:
	$GameplayControl/TimeLabel.text = _score_to_time(value)

func _score_to_time(value: int) -> String:
	var minutes := int (value / 60)
	var seconds := int(value) % 60
	
	return "%02d:%02d" % [minutes, seconds]

func update_health(value, max_hp):
	$GameplayControl/HealthProgressBar.max_value = max_hp
	$GameplayControl/HealthProgressBar.value = value
