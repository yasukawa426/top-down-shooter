extends CharacterBody2D

## Base speed all enemies will be based on
@export var BASE_SPEED: int = 200
## Base damage all enemies will be based on
@export var BASE_DAMAGE: int = 1
## Base HP 
@export var BASE_HP: int = 1
#rn its slighty lower than the player
## Enemy max speed after scaling.
@export var _MAX_SPEED: int = 500
## Enemy minimum damage after scaling.
@export var _MINIMUM_DAMAGE: int = 1
## Enemy minimum HP after scaling.
@export var _MINIMUM_HP: int = 1


var scaled_speed: float
var scaled_damage: float
var current_hp: float
var player: Node2D

func _ready() -> void:
	var rand_scale := randf_range(0.6, 1.4)
	scale = Vector2(rand_scale, rand_scale)
	
	#the smaller the faster and the bigger the stronger, we use power so it is even more noticiable
	set_speed(BASE_SPEED / pow(rand_scale, 1.5))
	set_damage(BASE_DAMAGE * pow(rand_scale, 3))
	set_hp(BASE_HP * pow(rand_scale, 3))
	
	
	if OS.is_debug_build():
		$DebugSpeedLabel.visible = true
		$DebugSpeedLabel.text = "speed: " + str(int(scaled_speed))
		$DebugDamageLabel.visible = true
		$DebugDamageLabel.text = "damage: " + str(int(scaled_damage))
		$DebugHpLabel.visible = true
		$DebugHpLabel.text = "hp: " + str(int(current_hp))

## Rotates the enemy to look at the player and moves it towards the player
func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	if player == null:
		player = get_tree().get_first_node_in_group("player")
	
	else:
		look_at(player.position)

		#gets the direction it should move to
		velocity = (player.position - position).normalized()

		#apply speed to the direction
		if velocity.length() > 0:
			velocity = velocity * scaled_speed
			
		#kachaw
		move_and_slide()
		
		
## Got hit by a bullet -> gets damage and delete bullet -> if hp <= 0 dies
func _on_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free()

	current_hp -= player.damage

	if current_hp <= 0:
		_die()

## Removes the enemy from the scene
func _die() -> void:
	queue_free()

## Update the enemy speed respecting its max speed
func set_speed(speed: float) -> void:
	if speed > _MAX_SPEED:
		speed = _MAX_SPEED
		
	scaled_speed = speed

## Update the enemy damage respecting its minimum damage	
func set_damage(damage: float) -> void:
	if damage < _MINIMUM_DAMAGE:
		damage = _MINIMUM_DAMAGE
	
	scaled_damage = damage

## Update the enemy hp respecting its minimum hp
func set_hp(hp: float) -> void:
	if hp < _MINIMUM_HP:
		hp = _MINIMUM_HP

	current_hp = hp
