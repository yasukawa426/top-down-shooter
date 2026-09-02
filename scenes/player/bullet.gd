extends RigidBody2D
signal hit_something

#hit a something. dies
func _on_body_entered(body: Node) -> void:
	hit_something.emit()
	queue_free()
