extends RigidBody2D


#hit a wall. dies
func _on_body_entered(body: Node) -> void:
	queue_free()
