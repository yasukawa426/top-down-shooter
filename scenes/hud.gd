extends CanvasLayer

# start button pressed, time to start game
signal start_game

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
	
	$GameOverControl/ColorRect/GameOverLabel.text = "SURVIVED " + str(score) + " SECONDS"
	$GameOverControl.show()
	

func _on_message_timer_timeout() -> void:
	$MessageLabel.hide()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	$GameplayControl.show()
	$MenuControl.hide()
	$GameOverControl.hide()
	start_game.emit()

func update_score(value: int) -> void:
	$GameplayControl/TimeLabel.text = str(value)
