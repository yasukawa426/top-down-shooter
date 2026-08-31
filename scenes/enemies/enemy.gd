extends CharacterBody2D


@export var SPEED = 200
#enemy max speed, rn its slighty lower than the player
const _MAX_SPEED = 500
var player:Node2D


func _ready() -> void:
	var rand_scale := randf_range(0.6, 1.4)
	scale = Vector2(rand_scale, rand_scale)
	
	#the smaller the faster, we use power so it is even more noticiable
	set_speed(SPEED / pow(rand_scale, 1.5))
	
	if OS.is_debug_build():
		$DebugSpeedLabel.visible = true
		$DebugSpeedLabel.text = str(int(SPEED))

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

#updated the enemy speed respecting its max speed
func set_speed(speed: float) -> void:
	if speed > _MAX_SPEED:
		speed = _MAX_SPEED
		
	SPEED = speed 
	
