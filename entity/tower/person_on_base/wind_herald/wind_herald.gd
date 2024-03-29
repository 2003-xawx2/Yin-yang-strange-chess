extends basic_human

@onready var wind := preload("res://entity/tower/person_on_base/wind_herald/wind_bullet.tscn")
@onready var hurricane := preload("res://entity/tower/person_on_base/wind_herald/hurricane.tscn")
@onready var ball_audio: random_audio = $audio/Ball
@onready var hurricane_audio: random_audio = $audio/Hurricane


func small_attack()->void:
	ball_audio.play_random()
	update_direction()
	recoil()
	var bullet:=wind.instantiate()
	get_parent().get_parent().add_child(bullet)
	bullet.global_position = bullet_position
	bullet.init(direction)


func hurt_attack()->void:
	hurricane_audio.play_random()
	update_direction()
	recoil(20)
	var bullet:=hurricane.instantiate()
	get_parent().get_parent().add_child(bullet)
	bullet.global_position = bullet_position
	bullet.init(direction)


func update_enemies_attack()->void:
	enemies = detect_area.get_overlapping_bodies()
	if return_target() == null:
		animation_player.play("idle")
	else:
		animation_player.play("attack")

