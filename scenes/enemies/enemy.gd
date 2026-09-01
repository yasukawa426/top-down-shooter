extends CharacterBody2D

## Base speed all enemies will be based on
@export var BASE_SPEED = 200
## Base damage all enemies will be based on
@export var BASE_DAMAGE: int = 1
#rn its slighty lower than the player
## Enemy max speed after scaling.
@export var _MAX_SPEED = 500
## Enemy minimum damage after scaling.
@export var _MINIMUM_DAMAGE = 1



var SPEED: float
var DAMAGE: float
var player:Node2D


func _ready() -> void:
	var rand_scale := randf_range(0.6, 1.4)
	scale = Vector2(rand_scale, rand_scale)
	
	#the smaller the faster and the bigger the stronger, we use power so it is even more noticiable
	set_speed(BASE_SPEED / pow(rand_scale, 1.5))
	set_damage(BASE_DAMAGE * pow(rand_scale, 3))
	
	
	if OS.is_debug_build():
		$DebugSpeedLabel.visible = true
		$DebugSpeedLabel.text = "speed: " + str(int(SPEED))
		$DebugDamageLabel.visible = true
		$DebugDamageLabel.text = "damage: " + str(int(DAMAGE))

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
	
func set_damage(damage: int) -> void:
	if damage < _MINIMUM_DAMAGE:
		damage = _MINIMUM_DAMAGE
	
	DAMAGE = damage
