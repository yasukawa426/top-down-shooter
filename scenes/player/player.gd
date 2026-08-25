extends CharacterBody2D


const SPEED : float = 300.0
const JUMP_VELOCITY: float = -400.0
@onready var camera2d: Camera2D = $Camera2D



func _physics_process(delta: float) -> void:
	# Add the gravity.
	# if not is_on_floor():
	# 	velocity += get_gravity() * delta

	# # Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	velocity = Vector2.ZERO
	

	if Input.is_action_pressed("move_left"):
		velocity.x += -SPEED 

	if Input.is_action_pressed("move_right"):
		velocity.x += SPEED
	
	if Input.is_action_pressed("move_up"):
		velocity.y += -SPEED

	if Input.is_action_pressed("move_down"):
		velocity.y += SPEED
	
	
	
	#mouse wheel only gets detected by "action_just_realeased" method
	if camera2d.zoom.x < 1:
		if Input.is_action_pressed("zoom_in"):
				camera2d.zoom.x += 0.02
				camera2d.zoom.y += 0.02
		
		elif Input.is_action_just_released("zoom_in"):
				camera2d.zoom.x += 0.04
				camera2d.zoom.y += 0.04

	if camera2d.zoom.x > 0.5:
		if Input.is_action_pressed("zoom_out"):
				camera2d.zoom.x -= 0.02
				camera2d.zoom.y -= 0.02
		
		elif Input.is_action_just_released("zoom_out"):
				camera2d.zoom.x -= 0.04
				camera2d.zoom.y -= 0.04

	


func _on_area_2d_body_entered(body: Node2D) -> void:
	#if the body being detected is the player, just ignore it. It shouldn't, tho, because I set the collision mask to only detect enemies, but just in case
	if body.get_instance_id() == self.get_instance_id():
		print("Hit themselves")
		return
		
	#got hit, hide and emit signal
	hide()
	hit.emit()
	#disables collision for area2d as to not trigger multiple times after finished collision processing
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
