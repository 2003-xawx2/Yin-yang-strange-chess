extends AudioStreamPlayer



func _on_finished() -> void:
	await get_tree().create_timer(17).timeout
	play()
