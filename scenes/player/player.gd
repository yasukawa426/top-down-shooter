extends CharacterBody2D
signal died
signal damaged

## Player movement speed
@export var SPEED: float = 600.0
## Player bullet movement speed
@export var BULLET_SPEED: float = 2000.0
## Player initial max hp
@export var INITIAL_MAX_HP: int = 5
## Player bullet INITIAL_DAMAGE
@export var INITIAL_DAMAGE: int = 2

## Player current damage, can be modified by upgrades
var current_damage: int = INITIAL_DAMAGE
## Player current max hp, can be modified by upgrades
var max_hp: int = INITIAL_MAX_HP
## Player current hp, can be modified by heals and damage.
var current_hp: int = INITIAL_MAX_HP
var dead: bool = true

@onready var camera2d: Camera2D = $Camera2D
@onready var bullet: PackedScene = preload("res://scenes/player/bullet.tscn")
@onready var INITIAL_SPRITE_LOCAL_POSITION: Vector2 = $Visual.position

func _ready() -> void:
	dead = true

func _process(_delta: float) -> void:
	#rotate towards the mouse
	look_at(get_global_mouse_position())
	

func _physics_process(_delta: float) -> void:
	#TODO: overhaul player movement to use acceleration and friction
	velocity = Vector2.ZERO
	if not dead:
		_handle_user_input()

	
	if velocity.length() > 0 and not dead:
		if $FootstepTimer.is_stopped():
			$FootstepTimer.start()
		velocity = velocity.normalized() * SPEED
	else:
		$FootstepTimer.stop()
		pass
		
	#move_and_slide already uses delta
	#velocity = velocity * delta
	move_and_slide()


func _handle_user_input() -> void:
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	
		
	if Input.is_action_pressed("shoot") and $ShootCooldownTimer.is_stopped():
		_shoot()
	
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

#spawn a bullet moving towards the marker - player direction
func _spawn_bullet() -> void:
	var new_bullet: RigidBody2D = bullet.instantiate()
	
	new_bullet.global_position = $BulletMarker2D.global_position
	
	new_bullet.linear_velocity = ($BulletMarker2D.global_position - global_position).normalized() * BULLET_SPEED
	
	new_bullet.hit_something.connect(_play_bullet_sound)
	add_sibling(new_bullet)

func _on_area_2d_body_entered(body: Node2D) -> void:
	#if the body being detected is the player, just ignore it. It shouldn't, tho, because I set the collision mask to only detect enemies, but just in case
	if body.get_instance_id() == self.get_instance_id():
		print("Hit themselves")
		return
	
	if body.is_in_group("mobs"):
		damage_player(body.scaled_damage)
	

func damage_player(enemy_damage: int) -> void:
	print("took " + str(enemy_damage) + " damage")
	current_hp -= enemy_damage
	
	damaged.emit()

	if current_hp <= 0:
		_die()
	else:
		$HurtAudioStreamPlayer.play()
		# apply the blink shade to player only
		var tween: Tween = $Visual/PlayerSprite.create_tween()
		tween.tween_method(Utils.set_shader_blink_intensity.bind($Visual/PlayerSprite), 1.0, 0.0, 0.3)
		# apply the blink shader smoothly to all children of Visual node
		#for sprites in $Visual.get_children():
			#var tween: Tween = sprites.create_tween()
			#tween.tween_method(Utils.set_shader_blink_intensity.bind(sprites), 1.0, 0.0, 0.3)
			
		
func _die() -> void:
	dead = true
	#got hit, hide and emit signal
	$DeathAudioStreamPlayer.play()
	hide()
	died.emit()
	#disables collision for area2d as to not trigger multiple times after finished collision processing
	$Area2D/CollisionShape2D.set_deferred("disabled", true)

func reset() -> void:
	max_hp = INITIAL_MAX_HP
	current_hp = INITIAL_MAX_HP
	
	show()
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	
func get_player_stats() -> Dictionary:
	return {
		"max_hp": max_hp,
		"current_hp": current_hp,
		"speed": SPEED,
		"bullet_speed": BULLET_SPEED,
		"current_damage": current_damage,
	}

func _shoot() -> void:
	_spawn_bullet()
	_wiggle_player()
	$FireAudioStreamPlayer.play()
	$ShootCooldownTimer.start()
	var tween: Tween = $Visual/GunSprite.create_tween()
	tween.tween_method(Utils.set_shader_blink_intensity.bind($Visual/GunSprite), 0.8, 0.0, $ShootCooldownTimer.time_left)
	

## Shakes the player when firing gun, strengh is based on bullet damage. Visual Only
func _wiggle_player():
	const BASE_RECOIL: float = 20
	const DAMAGE_INFLUENCE: float = 0.3
	
	var sprites: Node2D = $Visual
	# direction the sprites will move to after shooting
	var recoil_direction: Vector2 = -sprites.transform.x.normalized()
	# position before recoil
	var current_position: Vector2 = sprites.position
	
	var recoil_strengh: float = (current_damage * DAMAGE_INFLUENCE) * BASE_RECOIL
	var recoil_position: Vector2 = current_position + (recoil_direction * recoil_strengh)
	
	
	# tween animates smoothly property changes overtimes. as in, move to the left in 0.5 second. Calling multiple property changes queues them.
	var tween: Tween = create_tween()
	# apply recoil
	tween.tween_property(sprites, "position", recoil_position, 0.05)
	# go back 
	tween.tween_property(sprites, "position", INITIAL_SPRITE_LOCAL_POSITION, 0.08)

	# add real knockback. this need friction and stuff tho.
	# velocity += recoil_direction * recoil_strengh

func _play_bullet_sound() ->void:
	var sound_player: AudioStreamPlayer = $BulletAudioStreamPlayer
	sound_player.play()


func _on_shoot_cooldown_timer_timeout() -> void:
	#$ReloadAudioStreamPlayer.speed
	$ReloadAudioStreamPlayer.play(0.33)


func _on_footstep_timer_timeout() -> void:
	$FootstepAudioStreamPlayer.play()
