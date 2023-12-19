extends GPUParticles2D


func _on_timer_timeout():
	emitting = false
	queue_free()
