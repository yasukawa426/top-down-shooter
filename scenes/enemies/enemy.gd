extends CharacterBody2D


@export var SPEED = 200
var player:Node2D




func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	
	else:
		look_at(player.position)

		#gets the direction it should move to
		velocity = (player.position - position).normalized()

		#apply speed to the direction
		if velocity.length() > 0:
			velocity = velocity * SPEED
			
		#kachaw
		move_and_slide()
		
		
	

#got hit by a bullet -> dies and delete bullet
func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
	body.queue_free()
