extends basic_bullet


var enemy_tracked:Node2D


func init(_direcction:Vector2)->void:
	super.init(_direcction)
	animation_player.play("attack")


func _physics_process(delta: float) -> void:
	if enemy_tracked == null:
		return
	
	global_position = global_position.lerp(enemy_tracked.global_position,1-exp(-delta*8))
