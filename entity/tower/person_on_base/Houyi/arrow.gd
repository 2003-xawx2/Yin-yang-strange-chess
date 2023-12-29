extends basic_bullet

var if_hit:bool = false

func init(_direcction:Vector2)->void:
	super(_direcction)
	animation_player.play("fly")


func _physics_process(delta: float) -> void:
	if !if_hit:
		basic_process(delta)
	else:
		basic_process(delta/3)


func _on_hurt_box_hurt() -> void:
	if_hit = true
	animation_player.play("hit")
