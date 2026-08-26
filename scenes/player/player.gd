extends CharacterBody2D
signal hit

@export var SPEED: float = 600.0
const JUMP_VELOCITY: float = -400.0
@onready var camera2d: Camera2D = $Camera2D
@onready var bullet = preload("res://scenes/player/bullet.tscn")


func _physics_process(delta: float) -> void:
	#rotate towards the mouse
	look_at(get_global_mouse_position())
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	velocity = Vector2.ZERO
	
	_handle_user_input()

	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
	else:
		pass
		
	# move_and_slide already uses delta
	#velocity = velocity * delta
	move_and_slide()


func _handle_user_input() -> void:
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	
		
	if Input.is_action_pressed("shoot"):
		var new_bullet: Area2D = bullet.instantiate()
		new_bullet.position = $BulletMarker2D.global_position
		#new_bullet.y = $Bullet/MeshInstance2D.y
		#add_child(new_bullet)
		add_sibling(new_bullet)
	
	if Input.is_action_just_released("reset"):
		var bullets: Array[Node] = get_tree().get_nodes_in_group("bullets")
		for projectile in bullets:
			projectile.queue_free()
	
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
