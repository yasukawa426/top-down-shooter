extends Node

enum Duration{
	TINY,
	SHORT,
	MEDIUM,
	LONG,
}

func _get_duration(duration: Duration) -> float:
	var time: float 
	
	match duration:
		Duration.TINY:
			time = 0.05
		Duration.SHORT:
			time = 0.15
		Duration.MEDIUM:
			time = 0.25
		Duration.LONG:
			time = 0.5
	
	return time

## Pauses the game for a X duration to create a hit stop effect and then goes back to previous time scale. Only runs if no time effect is happening.
func hit_stop(duration: Duration):
	if Engine.time_scale != 1:
		return
	
	var time: float = _get_duration(duration)
	
	Engine.time_scale = 0
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1

## Slows down time by 60% for X seconds.
func slow_mo(seconds: float):	
	Engine.time_scale = 0.4
		
	await get_tree().create_timer(seconds, true, false, true).timeout
	Engine.time_scale = 1
