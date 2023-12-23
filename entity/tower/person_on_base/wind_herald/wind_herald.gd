extends basic_human

@onready var wind := preload("res://entity/tower/person_on_base/wind_herald/wind_bullet.tscn")
@onready var hurricane := preload("res://entity/tower/person_on_base/wind_herald/hurricane.tscn")


func small_attack()->void:
	update_direction()
	recoil()
	var bullet:=wind.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = bullet_position
	bullet.init(direction)


func hurt_attack()->void:
	update_direction()
	recoil(20)
	var bullet:=hurricane.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = bullet_position
	bullet.init(direction)


func update_enemies_attack()->void:
	enemies = detect_area.get_overlapping_bodies()
	if return_target() == null:
		$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play("attack")
