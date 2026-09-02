extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	get_tree().create_timer(self.lifetime - 0.1).timeout.connect(func(): speed_scale = 0)

func _disable() -> void:
	self.set_process(false)
