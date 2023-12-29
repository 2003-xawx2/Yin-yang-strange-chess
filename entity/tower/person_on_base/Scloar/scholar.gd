extends basic_human

@onready var link := preload("res://entity/tower/person_on_base/Scloar/link.tscn")
@onready var graphic := $Graphic


func _ready() -> void:
	super._ready()
	animation_player.play("idle")


func small_attack()->void:
	target = return_target()
	if target == null:
		return
	update_direction()
	recoil()
	for i in range(3):
		var bullet: = link.instantiate()
		get_parent().get_parent().add_child(bullet)
		bullet.global_position = bullet_position
		bullet.init(direction.rotated(randf_range(-PI/6,PI/6)))


func update_enemies_attack()->void:
	enemies = detect_area.get_overlapping_bodies()
	if return_target() == null:
		animation_player.play("RESET")
		animation_player.play("idle")
	else:
		animation_player.play("attack")



func adjust_direction(_direction:Vector2)->void:
	if _direction.dot(Vector2.RIGHT)>0.1:
		graphic.scale.x = 1
		bullet_position = global_position + bullet_offset
	elif _direction.dot(Vector2.RIGHT)<-0.1:
		graphic.scale.x = -1
		bullet_position = global_position + Vector2( -bullet_offset.x,bullet_offset.y)
	if _direction.dot(Vector2.UP)>0.1:
		sprite.texture = back_sprite
	elif _direction.dot(Vector2.UP)<-0.1:
		sprite.texture = front_sprite
