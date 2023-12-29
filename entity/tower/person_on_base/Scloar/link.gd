extends basic_bullet


func init(_direcction:Vector2)->void:
	super(_direcction)
	animation_player.play("attack")


func _physics_process(delta: float) -> void:
	basic_process(delta)


func _on_hurt_box_hurt() -> void:
	queue_free()
