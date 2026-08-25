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

	move_and_slide()
