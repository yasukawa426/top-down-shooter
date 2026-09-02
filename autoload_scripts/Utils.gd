extends Node

func set_shader_blink_intensity(value: float, affected_node: Node2D) -> void:
	#print("chanded intensity to : " + str(value))
	affected_node.material.set_shader_parameter("blink_intensity", value)
