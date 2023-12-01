extends GPUParticles2D



func _on_timer_timeout():
	emitting = false
	await get_tree().create_timer(.4).timeout
	queue_free()
