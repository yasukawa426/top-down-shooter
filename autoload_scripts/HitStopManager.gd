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

## Pauses the game for a X duration to create a hit stop effect.
func hit_stop(duration: Duration):
	var time: float = _get_duration(duration)

	Engine.time_scale = 0
	await get_tree().create_timer(time, true, false, true).timeout
	Engine.time_scale = 1
func slow_mo(seconds: int):	
	Engine.time_scale = 0.4
		
	await get_tree().create_timer(seconds, true, false, true).timeout
	Engine.time_scale = 1
