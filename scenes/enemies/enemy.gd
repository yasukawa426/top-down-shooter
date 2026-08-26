extends CharacterBody2D


@export var SPEED = 200
var player:Node2D




func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	
	else:
		look_at(player.position)
		
		if (player.position.x - position.x) > 0:
			velocity.x = 1
		else:
			velocity.x = -1
		
		if (player.position.y - position.y) > 0:
			velocity.y = 1
		else:
			velocity.y = -1
			
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
			
		move_and_slide()
		
		
	
